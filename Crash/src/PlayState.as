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
        public var waveBody:b2Body;
        public var waveFixtureDef:b2FixtureDef;
        public var waveFixture:b2Fixture;
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

        public var m_mouseJoint:b2MouseJoint;

        public static const PHYS_SCALE:Number = 30;

        public var swimmerCollision:SwimmerContactListener;


        override public function create():void
        {
            debugText = new FlxText(10, 30, FlxG.width, "");
            add(debugText);

            FlxG.bgColor = 0xff783629;
            setupWorld();

            groundBodyDef = new b2BodyDef();
            groundBodyDef.position.Set(100/PHYS_SCALE, (FlxG.height*2.5)/PHYS_SCALE);
            groundBody = m_world.CreateBody(groundBodyDef);
            groundShape = new b2PolygonShape();
            groundShape.SetAsBox((FlxG.width*2)/PHYS_SCALE, (FlxG.height/2)/PHYS_SCALE);
            groundFixtureDef = new b2FixtureDef();
            groundFixtureDef.shape = groundShape;
            groundFixture = groundBody.CreateFixture(groundFixtureDef);

            wheelBodyDef = new b2BodyDef();
            wheelBodyDef.type = b2Body.b2_dynamicBody;
            wheelBodyDef.position.Set(600, 100);
            wheelBody = m_world.CreateBody(wheelBodyDef);
            circleShape = new b2CircleShape(1);
            wheelFixtureDef = new b2FixtureDef();
            var filterData:b2FilterData = new b2FilterData();
            filterData.maskBits = 0xFFFF;
            filterData.categoryBits = 0x0001;
            wheelFixtureDef.filter = filterData;
            wheelFixtureDef.shape = circleShape;
            wheelFixtureDef.userData = "swimmer";
            wheelFixture = wheelBody.CreateFixture(wheelFixtureDef);

            waveBodyDef = new b2BodyDef();
            waveBodyDef.position.Set(50/PHYS_SCALE, FlxG.height/PHYS_SCALE);
            waveBody = m_world.CreateBody(waveBodyDef);
            waveShape = new b2PolygonShape();
            waveShape.SetAsBox(FlxG.width/PHYS_SCALE, (FlxG.height/2)/PHYS_SCALE);
            waveFixtureDef = new b2FixtureDef();
            waveFixtureDef.isSensor = true;
            filterData = new b2FilterData();
            filterData.maskBits = 0xFFFF;
            filterData.categoryBits = 0x001;
            waveFixtureDef.filter = filterData;
            waveFixtureDef.shape = waveShape;
            waveFixtureDef.userData = "swimmer";
            waveBody.CreateFixture(waveFixtureDef);

            var md:b2MouseJointDef = new b2MouseJointDef();
            md.bodyA = groundBody;
            md.bodyB = wheelBody;
            md.target.Set(wheelBody.GetPosition().x, wheelBody.GetPosition().y);
            md.collideConnected = true;
            md.maxForce = 30;
            m_mouseJoint = m_world.CreateJoint(md) as b2MouseJoint;

        }

        override public function update():void
        {
            super.update();

            m_world.Step(1.0/30.0, 10, 10);
            m_world.DrawDebugData();

            var this_pos:b2Vec2 = wheelBody.GetPosition();

            if(this_pos.x > FlxG.width/PHYS_SCALE){
                wheelBody.SetPosition(new b2Vec2(FlxG.width/PHYS_SCALE,this_pos.y));
            }
            if(this_pos.x < 0){
                wheelBody.SetPosition(new b2Vec2(0,this_pos.y));
            }
            if(this_pos.y > 500/PHYS_SCALE){
                wheelBody.SetPosition(new b2Vec2(this_pos.x,500/PHYS_SCALE));
            }
            if(this_pos.y < 0){
                wheelBody.SetPosition(new b2Vec2(this_pos.x,0));
            }

            if(FlxG.mouse.pressed()){
                m_mouseJoint.SetTarget(new b2Vec2(this_pos.x,this_pos.y+1));
            } else {
                m_mouseJoint.SetTarget(new b2Vec2(this_pos.x-.1,this_pos.y-.1));
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
