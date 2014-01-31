package
{
    import org.flixel.*;

    import flash.display.*;
    import flash.events.*;
    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Dynamics.Joints.*;
    import Box2D.Dynamics.Contacts.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import flash.display.Sprite;

    public class PlayState extends FlxState
    {
        public var m_physScale:Number = 30;
        public var m_world:b2World;

        public var body:FlxSprite;

        public var debugText:FlxText;

        public var swimmer:FlxSprite;
        public var wheelBody:b2Body;
        public var wheelBodyDef:b2BodyDef;
        public var circleShape:b2CircleShape;
        public var wheelFixtureDef:b2FixtureDef;
        public var wheelFixture:b2Fixture;
        public var groundBodyDef:b2BodyDef;
        public var groundBody:b2Body;
        public var groundShape:b2PolygonShape;
        public var groundFixtureDef:b2FixtureDef;
        public var groundFixture:b2Fixture;

        public var waveBodyDef:b2BodyDef;
        public var waveShape:b2PolygonShape;
        public var waveBody:b2Body;
        public var waveFixtureDef:b2FixtureDef;
        public var waveFixture:b2Fixture;

        public var goalBodyDef:b2BodyDef;
        public var goalShape:b2PolygonShape;
        public var goalBody:b2Body;
        public var goalFixtureDef:b2FixtureDef;
        public var goalFixture:b2Fixture;

        public var wheel_pos:b2Vec2;
        public var wave_pos:b2Vec2;
        public var wave_width:Number = 150;

        public var m_mouseJoint:b2MouseJoint;
        public var w_mouseJoint:b2MouseJoint;

        public static const PHYS_SCALE:Number = 30;

        public var swimmerCollision:SwimmerContactListener;

        public var ridingwave:Boolean = false;


        override public function create():void
        {
            debugText = new FlxText(10, 30, FlxG.width, "");
            add(debugText);

            //FlxG.bgColor = 0xff783629;
            setupWorld();

            groundBodyDef = new b2BodyDef();
            groundBodyDef.position.Set(100/PHYS_SCALE, (FlxG.height*2.5)/PHYS_SCALE);
            groundBody = m_world.CreateBody(groundBodyDef);
            groundShape = new b2PolygonShape();
            groundShape.SetAsBox((FlxG.width*2)/PHYS_SCALE, (FlxG.height/2)/PHYS_SCALE);
            groundFixtureDef = new b2FixtureDef();
            groundFixtureDef.shape = groundShape;
            groundBody.SetUserData("floor");
            groundFixtureDef.isSensor = true;
            groundFixture = groundBody.CreateFixture(groundFixtureDef);
            groundFixtureDef.isSensor = false;

            wheelBodyDef = new b2BodyDef();
            wheelBodyDef.type = b2Body.b2_dynamicBody;
            wheelBodyDef.position.Set(800/PHYS_SCALE, 400/PHYS_SCALE);
            wheelBody = m_world.CreateBody(wheelBodyDef);
            circleShape = new b2CircleShape(.3);
            wheelFixtureDef = new b2FixtureDef();
            wheelFixtureDef.shape = circleShape;
            wheelBody.SetUserData("swimmer");
            wheelFixtureDef.isSensor = true;
            wheelFixture = wheelBody.CreateFixture(wheelFixtureDef);
            wheelFixtureDef.isSensor = false;

            waveBodyDef = new b2BodyDef();
            waveBodyDef.type = b2Body.b2_dynamicBody;
            waveBodyDef.position.Set(50/PHYS_SCALE, FlxG.height/PHYS_SCALE);
            waveBody = m_world.CreateBody(waveBodyDef);
            waveShape = new b2PolygonShape();
            waveShape.SetAsBox(wave_width/PHYS_SCALE, (FlxG.height/2)/PHYS_SCALE);
            waveFixtureDef = new b2FixtureDef();
            waveFixtureDef.shape = waveShape;
            waveBody.SetUserData("wave");
            waveFixtureDef.isSensor = true;
            waveBody.CreateFixture(waveFixtureDef);
            waveFixtureDef.isSensor = false;

            goalBodyDef = new b2BodyDef();
            goalBodyDef.position.Set(640/PHYS_SCALE, FlxG.height/PHYS_SCALE);
            goalBody = m_world.CreateBody(goalBodyDef);
            goalShape = new b2PolygonShape();
            goalShape.SetAsBox(10/PHYS_SCALE, FlxG.height/PHYS_SCALE);
            goalFixtureDef = new b2FixtureDef();
            goalFixtureDef.shape = goalShape;
            goalBody.SetUserData("goal");
            goalFixtureDef.isSensor = true;
            goalBody.CreateFixture(goalFixtureDef);
            goalFixtureDef.isSensor = false;

            //wheel
            var md:b2MouseJointDef = new b2MouseJointDef();
            md.bodyA = groundBody;
            md.bodyB = wheelBody;
            md.target.Set(wheelBody.GetPosition().x, wheelBody.GetPosition().y);
            md.collideConnected = true;
            md.maxForce = 30;
            m_mouseJoint = m_world.CreateJoint(md) as b2MouseJoint;

            //wave
            var mw:b2MouseJointDef = new b2MouseJointDef();
            mw.bodyA = groundBody;
            mw.bodyB = waveBody;
            mw.target.Set(waveBody.GetPosition().x, waveBody.GetPosition().y);
            mw.collideConnected = true;
            mw.maxForce = 30;
            w_mouseJoint = m_world.CreateJoint(mw) as b2MouseJoint;

        }

        override public function update():void
        {
            super.update();

            m_world.Step(1.0/30.0, 10, 10);
            m_world.DrawDebugData();

            wheel_pos = wheelBody.GetPosition();
            wave_pos = waveBody.GetPosition();

            if(wheel_pos.x < 100/PHYS_SCALE){
                ridingwave = true;
            }

            debugText.text = waveBody.GetUserData().toString();

            //setup with m_mousejoin
            if(wheel_pos.x > 640/PHYS_SCALE){
                wheelBody.SetPosition(new b2Vec2((640/PHYS_SCALE)-100/PHYS_SCALE,wheel_pos.y));
            }
            if(wheel_pos.x < 0){
                wheelBody.SetPosition(new b2Vec2(0,wheel_pos.y));
            }
            if(wheel_pos.y > 500/PHYS_SCALE){
                wheelBody.SetPosition(new b2Vec2(wheel_pos.x,500/PHYS_SCALE));
            }
            if(wheel_pos.y < 0){
                wheelBody.SetPosition(new b2Vec2(wheel_pos.x,0));
            }

            if(FlxG.mouse.pressed()){
                m_mouseJoint.SetTarget(new b2Vec2(wheel_pos.x,wheel_pos.y+1));
            } else {
                m_mouseJoint.SetTarget(new b2Vec2(wheel_pos.x-.1,wheel_pos.y-.1));
            }

            if(wave_pos.x > (640+wave_width)/PHYS_SCALE){
                waveBody.SetPosition(new b2Vec2(-wave_width/PHYS_SCALE, FlxG.height/PHYS_SCALE));
            }

            wave_pos.x += .2;
            w_mouseJoint.SetTarget(new b2Vec2(wave_pos.x,FlxG.height/PHYS_SCALE));
        }

        private function setupWorld():void{
            var gravity:b2Vec2 = new b2Vec2(0,9.8);
            m_world = new b2World(gravity,true);
            swimmerCollision = new SwimmerContactListener();
            m_world.SetContactListener(swimmerCollision);

            var dbgDraw:b2DebugDraw = new b2DebugDraw();
            var dbgSprite:Sprite = new Sprite();
            FlxG.stage.addChild(dbgSprite);
            dbgDraw.SetSprite(dbgSprite);
            dbgDraw.SetDrawScale(30.0);
            dbgDraw.SetFillAlpha(0.3);
            dbgDraw.SetLineThickness(1.0);
            dbgDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
            m_world.SetDebugDraw(dbgDraw);
        }
    }
}
