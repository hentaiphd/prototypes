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

        public var groundBodyDef:b2BodyDef;
        public var groundBody:b2Body;
        public var groundShape:b2PolygonShape;
        public var groundFixtureDef:b2FixtureDef;
        public var groundFixture:b2Fixture;

        public var swim_pos:b2Vec2;
        public var wave1_pos:b2Vec2;
        public var wave2_pos:b2Vec2;
        public var wave_width:Number = 150;

        public var m_mouseJoint:b2MouseJoint;
        public var w1_mouseJoint:b2MouseJoint;
        public var w2_mouseJoint:b2MouseJoint;

        public static const PHYS_SCALE:Number = 30;

        public var swimmerCollision:SwimmerContactListener;
        public var start_x:Number;

        public var s:FlxText = new FlxText(100,100,100,"");
        public var w:FlxText = new FlxText(100,200,100,"");

        public var stamina:Number = 600;
        public var time_sec:Number = 0;
        public var time_frame:Number = 0;

        override public function create():void
        {
            debugText = new FlxText(10, 30, FlxG.width, "boogie");
            add(debugText);

            this.add(s);
            this.add(w);

            FlxG.bgColor = 0xff783629;
            setupWorld();

            start_x = 300/PHYS_SCALE;

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

            swimBodyDef = new b2BodyDef();
            swimBodyDef.type = b2Body.b2_dynamicBody;
            swimBodyDef.position.Set(300/PHYS_SCALE, 100/PHYS_SCALE);
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
            wave1BodyDef.position.Set(100/PHYS_SCALE, 400/PHYS_SCALE);
            wave1Body = m_world.CreateBody(wave1BodyDef);
            wave1Shape = new b2PolygonShape();
            wave1Shape.SetAsBox(wave_width/PHYS_SCALE, (FlxG.height/2)/PHYS_SCALE);
            wave1FixtureDef = new b2FixtureDef();
            wave1FixtureDef.shape = wave1Shape;
            wave1Body.SetUserData("boogie_wave");
            wave1FixtureDef.isSensor = true;
            wave1Body.CreateFixture(wave1FixtureDef);
            wave1FixtureDef.isSensor = false;

            wave2BodyDef = new b2BodyDef();
            wave2BodyDef.type = b2Body.b2_dynamicBody;
            wave2BodyDef.position.Set(550/PHYS_SCALE, 400/PHYS_SCALE);
            wave2Body = m_world.CreateBody(wave2BodyDef);
            wave2Shape = new b2PolygonShape();
            wave2Shape.SetAsBox(wave_width/PHYS_SCALE, (FlxG.height/2)/PHYS_SCALE);
            wave2FixtureDef = new b2FixtureDef();
            wave2FixtureDef.shape = wave2Shape;
            wave2Body.SetUserData("boogie_wave");
            wave2FixtureDef.isSensor = true;
            wave2Body.CreateFixture(wave2FixtureDef);
            wave2FixtureDef.isSensor = false;

            //swim
            var md:b2MouseJointDef = new b2MouseJointDef();
            md.bodyA = groundBody;
            md.bodyB = swimBody;
            md.target.Set(swimBody.GetPosition().x, swimBody.GetPosition().y);
            md.collideConnected = true;
            md.maxForce = 30;
            m_mouseJoint = m_world.CreateJoint(md) as b2MouseJoint;

            //wave1
            var mw:b2MouseJointDef = new b2MouseJointDef();
            mw.bodyA = groundBody;
            mw.bodyB = wave1Body;
            mw.target.Set(wave1Body.GetPosition().x, wave1Body.GetPosition().y);
            mw.collideConnected = true;
            mw.maxForce = 30;
            w1_mouseJoint = m_world.CreateJoint(mw) as b2MouseJoint;

            //wave2
            var mw2:b2MouseJointDef = new b2MouseJointDef();
            mw2.bodyA = groundBody;
            mw2.bodyB = wave2Body;
            mw2.target.Set(wave2Body.GetPosition().x, wave2Body.GetPosition().y);
            mw2.collideConnected = true;
            mw2.maxForce = 30;
            w2_mouseJoint = m_world.CreateJoint(mw2) as b2MouseJoint;

        }

        override public function update():void
        {
            super.update();
            debugText.text = "stamina: " + stamina.toString() + "time_sec: " + time_sec.toString();

            time_frame++;
            if(time_frame%100 == 0){
                time_sec++;
            }

            m_world.Step(1.0/30.0, 10, 10);
            m_world.DrawDebugData();

            wave1_pos = wave1Body.GetPosition();
            wave2_pos = wave2Body.GetPosition();
            swim_pos = swimBody.GetPosition();

            var r:Number = Math.random()*200;
            var r_wave:Number = Math.random()*200;
            var l_wave:Number = Math.random()*200;

            if(time_sec == 10){
                FlxG.switchState(new TextState("WINNING",new MenuState()));
            }

            if(FlxG.keys.SPACE){
                if(stamina > 0){
                    stamina -= 1;
                    m_mouseJoint.SetTarget(new b2Vec2(swim_pos.x,swim_pos.y-.3));
                } else {
                    m_mouseJoint.SetTarget(new b2Vec2(swim_pos.x-1,swim_pos.y+.7));
                }
            } else if(time_sec < 1) {
                m_mouseJoint.SetTarget(new b2Vec2(swim_pos.x-.01,swim_pos.y-.01));
            } else if(swim_pos.x < start_x+(r/PHYS_SCALE)){
                if(stamina > 0){
                    m_mouseJoint.SetTarget(new b2Vec2(swim_pos.x+1,swim_pos.y+.4));
                } else {
                    m_mouseJoint.SetTarget(new b2Vec2(swim_pos.x-1,swim_pos.y+.7));
                }
            } else {
                m_mouseJoint.SetTarget(new b2Vec2(swim_pos.x-1,swim_pos.y+.2));
            }

            if(wave1_pos.y > (300/PHYS_SCALE)+(r_wave/PHYS_SCALE)){
                w1_mouseJoint.SetTarget(new b2Vec2(wave1_pos.x,wave1_pos.y-.1));
            } else {
                w1_mouseJoint.SetTarget(new b2Vec2(wave1_pos.x,wave1_pos.y+.1));
            }

            if(wave2_pos.y > (300/PHYS_SCALE)+(l_wave/PHYS_SCALE)){
                w2_mouseJoint.SetTarget(new b2Vec2(wave2_pos.x,wave2_pos.y-.1));
            } else {
                w2_mouseJoint.SetTarget(new b2Vec2(wave2_pos.x,wave2_pos.y+.1));
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

        public function CalculateBezierPoint(t:Number,p0:Number,p1:Number):b2Vec2
            {
                var u:Number = 1-t;
                var tt:Number = t*t;
                var uu:Number = u*u;
                var uuu:Number = uu * u;
                var ttt:Number = tt * t;

                var p:b2Vec2 = new b2Vec2(uuu * p0,(3 * uu * t * p1)+(uuu * p0)); //first term
                //p += 3 * uu * t * p1; //second term
                //p += 3 * u * tt * p2; //third term
                //p += ttt * p3; //fourth term

                return p;
            }

    }
}