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
        [Embed(source="../assets/swimming.png")] private var Swimmer:Class;
        [Embed(source="../assets/bg.png")] private var Bg:Class;
        [Embed(source="../assets/wave.png")] private var Wave:Class;

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

        public var swim_pos:b2Vec2;
        public var wave_pos:b2Vec2;
        public var wave_width:Number = 150;

        public var m_mouseJoint:b2MouseJoint;
        public var w_mouseJoint:b2MouseJoint;

        public static const PHYS_SCALE:Number = 30;

        public var swimmerCollision:SwimmerContactListener;

        public var ridingwave:Boolean = false;

        public var swim_sprite:FlxSprite;
        public var bg_sprite:FlxSprite;
        public var wave_sprite:FlxSprite;

        public var distance:FlxText;

        public var speed:Number;
        public var waves_caught:Number;

        public function PlayState(new_speed:Number = .2, waves:Number = 0){
            speed = new_speed;
            waves_caught = waves;

        }

        override public function create():void
        {
            debugText = new FlxText(10, 30, FlxG.width, "");
            add(debugText);

            //FlxG.bgColor = 0xff783629;
            setupWorld();

            bg_sprite = new FlxSprite(0,0);
            bg_sprite.loadGraphic(Bg,false,false,532,432);
            FlxG.state.add(bg_sprite);

            distance = new FlxText(30,30,100,(100/PHYS_SCALE).toString() + " more feet to catch a wave!");
            FlxG.state.add(distance);

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
            swimBodyDef.position.Set((FlxG.width*2)/PHYS_SCALE, 400/PHYS_SCALE);
            swimBody = m_world.CreateBody(swimBodyDef);
            circleShape = new b2CircleShape(.3);
            swimFixtureDef = new b2FixtureDef();
            swimFixtureDef.shape = circleShape;
            swimBody.SetUserData("swimmer");
            swimFixtureDef.isSensor = true;
            swimFixture = swimBody.CreateFixture(swimFixtureDef);
            swimFixtureDef.isSensor = false;

            swim_pos = swimBody.GetPosition();

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

            wave_sprite = new FlxSprite(waveBody.GetPosition().x,waveBody.GetPosition().y);
            wave_sprite.loadGraphic(Wave,false,true,229,196);
            FlxG.state.add(wave_sprite);

            swim_sprite = new FlxSprite(swim_pos.x,swim_pos.y);
            swim_sprite.loadGraphic(Swimmer, true, true, 192/6, 32, true);
            swim_sprite.addAnimation("left", [0, 1, 2], 12, true);
            swim_sprite.addAnimation("right", [3, 4, 5], 12, true);
            swim_sprite.play("left");
            FlxG.state.add(swim_sprite);

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

            //swim
            var md:b2MouseJointDef = new b2MouseJointDef();
            md.bodyA = groundBody;
            md.bodyB = swimBody;
            md.target.Set(swimBody.GetPosition().x, swimBody.GetPosition().y);
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
            //m_world.DrawDebugData();

            swim_pos = swimBody.GetPosition();
            wave_pos = waveBody.GetPosition();

            swim_sprite.x = (swim_pos.x * m_physScale / 2) - swim_sprite.width/2;
            swim_sprite.y = (swim_pos.y * m_physScale / 2) - swim_sprite.height/2;
            swim_sprite.angle = swimBody.GetAngle() * (180 / Math.PI);

            wave_sprite.x = (wave_pos.x * m_physScale / 2) - wave_sprite.width/2;
            wave_sprite.y = (wave_pos.y * m_physScale / 2) - wave_sprite.height/2;
            wave_sprite.angle = waveBody.GetAngle() * (180 / Math.PI);

            if(!ridingwave){
                if(swim_pos.x > 100/PHYS_SCALE){
                    distance.text = Math.abs(Math.round((100/PHYS_SCALE - swim_pos.x))).toString() + " more feet to catch a wave!";
                    if(FlxG.keys.SPACE){
                        m_mouseJoint.SetTarget(new b2Vec2(swim_pos.x,swim_pos.y+speed));
                    } else {
                        m_mouseJoint.SetTarget(new b2Vec2(swim_pos.x-.1,swim_pos.y-.2));
                    }
                } else {
                    ridingwave = true;
                    swim_sprite.play("right");
                    distance.text = "Let's go!";
                }
            }

            debugText.text = swim_pos.x.toString();

            if(ridingwave) {
                swimBody.SetUserData("swimmer_win");
                m_mouseJoint.SetTarget(new b2Vec2(swim_pos.x+.4,swim_pos.y-.06));
                if(swim_pos.x > 16){
                    FlxG.switchState(new TextState("Ride the wave using SPACE, but don't fall off!",new BoogieState(speed,waves_caught), 2));
                }
            }

            //setup with m_mousejoin
            if(swim_pos.x > (FlxG.width*2.1)/PHYS_SCALE){
                if(!ridingwave){
                    FlxG.switchState(new TextState("You got crushed!\nYou caught " + waves_caught.toString() + " waves!", new MenuState(), 1));
                }
            }
            if(swim_pos.x < 0){
                swimBody.SetPosition(new b2Vec2(0,swim_pos.y));
            }
            if(swim_pos.y > 500/PHYS_SCALE){
                swimBody.SetPosition(new b2Vec2(swim_pos.x,500/PHYS_SCALE));
            }
            if(swim_pos.y < 0){
                swimBody.SetPosition(new b2Vec2(swim_pos.x,0));
            }

            if(wave_pos.x > (640+wave_width)/PHYS_SCALE){
                waveBody.SetPosition(new b2Vec2(-wave_width/PHYS_SCALE, FlxG.height/PHYS_SCALE));
            }

            wave_pos.x += speed;
            w_mouseJoint.SetTarget(new b2Vec2(wave_pos.x,FlxG.height/PHYS_SCALE));
        }

        private function setupWorld():void{
            var gravity:b2Vec2 = new b2Vec2(0,9.8);
            m_world = new b2World(gravity,true);
            swimmerCollision = new SwimmerContactListener(waves_caught);
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
