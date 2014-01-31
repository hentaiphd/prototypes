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

    public class BoogieState extends FlxState
    {
        public var m_physScale:Number = 30;
        public var m_world:b2World;

        public var body:FlxSprite;

        public var debugText:FlxText;

        public var swimmer:FlxSprite;
        public var swimBody:b2Body;
        public var swimBodyDef:b2BodyDef;
        public var circleShape:b2CircleShape;
        public var swimFixtureDef:b2FixtureDef;
        public var swimFixture:b2Fixture;

        public var wave1BodyDef:b2BodyDef;
        public var wave1Shape:b2PolygonShape;
        public var wave1Body:b2Body;
        public var wave1FixtureDef:b2FixtureDef;
        public var wave1Fixture:b2Fixture;

        public var wave2BodyDef:b2BodyDef;
        public var wave2Shape:b2PolygonShape;
        public var wave2Body:b2Body;
        public var wave2FixtureDef:b2FixtureDef;
        public var wave2Fixture:b2Fixture;

        public var swim_pos:b2Vec2;
        public var wave1_pos:b2Vec2;
        public var wave2_pos:b2Vec2;
        public var wave_width:Number = 150;

        public var m_mouseJoint:b2MouseJoint;
        public var w1_mouseJoint:b2MouseJoint;
        public var w2_mouseJoint:b2MouseJoint;

        public static const PHYS_SCALE:Number = 30;

        public var swimmerCollision:SwimmerContactListener;

        override public function create():void
        {
            debugText = new FlxText(10, 30, FlxG.width, "boogie");
            add(debugText);

            //FlxG.bgColor = 0xff783629;
            setupWorld();

            swimBodyDef = new b2BodyDef();
            swimBodyDef.type = b2Body.b2_dynamicBody;
            swimBodyDef.position.Set((FlxG.width/2)/PHYS_SCALE, (FlxG.height/2)/PHYS_SCALE);
            swimBody = m_world.CreateBody(swimBodyDef);
            circleShape = new b2CircleShape(.3);
            swimFixtureDef = new b2FixtureDef();
            swimFixtureDef.shape = circleShape;
            swimBody.SetUserData("swimmer");
            swimFixtureDef.isSensor = true;
            swimFixture = swimBody.CreateFixture(swimFixtureDef);
            swimFixtureDef.isSensor = false;

            wave1BodyDef = new b2BodyDef();
            wave1BodyDef.type = b2Body.b2_dynamicBody;
            wave1BodyDef.position.Set(50/PHYS_SCALE, FlxG.height/PHYS_SCALE);
            wave1Body = m_world.CreateBody(wave1BodyDef);
            wave1Shape = new b2PolygonShape();
            wave1Shape.SetAsBox(wave_width/PHYS_SCALE, (FlxG.height/2)/PHYS_SCALE);
            wave1FixtureDef = new b2FixtureDef();
            wave1FixtureDef.shape = wave1Shape;
            wave1Body.SetUserData("wave");
            wave1FixtureDef.isSensor = true;
            wave1Body.CreateFixture(wave1FixtureDef);
            wave1FixtureDef.isSensor = false;

            wave2BodyDef = new b2BodyDef();
            wave2BodyDef.type = b2Body.b2_dynamicBody;
            wave2BodyDef.position.Set(50/PHYS_SCALE, FlxG.height/PHYS_SCALE);
            wave2Body = m_world.CreateBody(wave2BodyDef);
            wave2Shape = new b2PolygonShape();
            wave2Shape.SetAsBox(wave_width/PHYS_SCALE, (FlxG.height/2)/PHYS_SCALE);
            wave2FixtureDef = new b2FixtureDef();
            wave2FixtureDef.shape = wave2Shape;
            wave2Body.SetUserData("wave");
            wave2FixtureDef.isSensor = true;
            wave2Body.CreateFixture(wave2FixtureDef);
            wave2FixtureDef.isSensor = false;

            //swim
            var md:b2MouseJointDef = new b2MouseJointDef();
            md.bodyA = wave1Body;
            md.bodyB = swimBody;
            md.target.Set(swimBody.GetPosition().x, swimBody.GetPosition().y);
            md.collideConnected = true;
            md.maxForce = 30;
            m_mouseJoint = m_world.CreateJoint(md) as b2MouseJoint;

            //wave1
            var mw:b2MouseJointDef = new b2MouseJointDef();
            mw.bodyA = swimBody;
            mw.bodyB = wave1Body;
            mw.target.Set(wave1Body.GetPosition().x, wave1Body.GetPosition().y);
            mw.collideConnected = true;
            mw.maxForce = 30;
            w1_mouseJoint = m_world.CreateJoint(mw) as b2MouseJoint;

            //wave2
            var mw2:b2MouseJointDef = new b2MouseJointDef();
            mw2.bodyA = swimBody;
            mw2.bodyB = wave2Body;
            mw2.target.Set(wave2Body.GetPosition().x, wave2Body.GetPosition().y);
            mw2.collideConnected = true;
            mw2.maxForce = 30;
            w2_mouseJoint = m_world.CreateJoint(mw2) as b2MouseJoint;

        }

        override public function update():void
        {
            super.update();

            m_world.Step(1.0/30.0, 10, 10);
            m_world.DrawDebugData();

            swim_pos = swimBody.GetPosition();
            wave1_pos = wave1Body.GetPosition();
            wave2_pos = wave2Body.GetPosition();

            if(FlxG.mouse.pressed()){
                var waveMultiplier:Number = 10;
                var waveStretcher:Number = 5;
                var i:Number = 1;
                var sinPosY:Number = Math.sin(i / waveStretcher) * waveMultiplier;
                var blah:b2Vec2 = new b2Vec2((FlxG.width/2)/PHYS_SCALE, (FlxG.height/2)/PHYS_SCALE);
                m_mouseJoint.SetTarget(new b2Vec2(swim_pos.x+(sinPosY/PHYS_SCALE),swim_pos.y+1));
                i++;
            } else {
                m_mouseJoint.SetTarget(blah);
            }
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