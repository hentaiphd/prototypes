package
{
    import org.flixel.*;

    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.Joints.*;

    import flash.display.*;

    public class PlayState extends TimedState
    {
        public var m_physScale:Number = 30
        public var m_world:b2World;
        public var m_mouseJoint:b2MouseJoint;
        public var dollLGrabber:DollGrabber;
        public var dollRGrabber:DollGrabber;
        public var dollL:PhysicsDoll;
        public var dollR:PhysicsDoll;
        public var dollController:DollController;
        public var dollCollision:DollContactListener;
        static public var mouseXWorldPhys:Number;
        static public var mouseYWorldPhys:Number;
        static public var mouseXWorld:Number;
        static public var mouseYWorld:Number;

        public var bubble_width:Number = FlxG.width/2;
        public var body:FlxSprite;
        public var lArm:Arm;
        public var rArm:Arm;

        public var debugText:FlxText;

        override public function create():void
        {
            FlxG.mouse.show();

            setupWorld();

            var startY:Number = 200;
            var startX:Number = 170;

            var worldAABB:b2AABB = new b2AABB();
            worldAABB.lowerBound.Set(0, 220 / m_physScale);
            worldAABB.upperBound.Set(640 / m_physScale, 480 / m_physScale);

            var position:FlxPoint = new FlxPoint(startX, startY);
            dollL = new PhysicsDoll();
            dollL.create(m_world, position, PhysicsDoll.ATYPE);

            //setup collision listener
            dollCollision = new DollContactListener();
            m_world.SetContactListener(dollCollision);

            debugText = new FlxText(100, 30, FlxG.width, "hello");
            add(debugText);
            debugText.color = 0xf9d0b4;
        }

        override public function update():void
        {
            super.update();

            UpdateMouseWorld()

            m_world.Step(1.0/30.0, 10, 10);
            m_world.DrawDebugData();

            dollL.update();

            var mousepoint:FlxPoint = new FlxPoint(FlxG.mouse.x/dollL.PHYS_SCALE,FlxG.mouse.y/dollL.PHYS_SCALE);
            var handLpoint:FlxPoint = new FlxPoint(dollL.l_hand.GetPosition().x,dollL.l_hand.GetPosition().y);

            debugText.text = "FlxU.getDistance(mousepoint,handLpoint).toString()";
        }

        override public function endCallback():void
        {
            FlxG.switchState(new MenuState());
        }

        public function UpdateMouseWorld():void{
            mouseXWorldPhys = (FlxG.mouse.screenX)/m_physScale;
            mouseYWorldPhys = (FlxG.mouse.screenY)/m_physScale;
            mouseXWorld = (FlxG.mouse.screenX);
            mouseYWorld = (FlxG.mouse.screenY);
        }

        private function setupWorld():void{
            var gravity:b2Vec2 = new b2Vec2(0,9.8);
            m_world = new b2World(gravity,true);

            var dbgDraw:b2DebugDraw = new b2DebugDraw();
            var dbgSprite:Sprite = new Sprite();
            FlxG.stage.addChild(dbgSprite);
            dbgDraw.SetSprite(dbgSprite);
            dbgDraw.SetDrawScale(30.0);
            dbgDraw.SetFillAlpha(0.3);
            dbgDraw.SetLineThickness(1.0);
            dbgDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
            m_world.SetDebugDraw(dbgDraw);

            // Create border of boxes
            var wall:b2PolygonShape= new b2PolygonShape();
            var wallBd:b2BodyDef = new b2BodyDef();
            var wallB:b2Body;

            // Left
            wallBd.position.Set( -95 / m_physScale, 480 / m_physScale / 2);
            wall.SetAsBox(100/m_physScale, 480/m_physScale/2);
            //wallB = m_world.CreateBody(wallBd);
            //wallB.CreateFixture2(wall);
            // Right
            wallBd.position.Set((640 + 95) / m_physScale, 480 / m_physScale / 2);
            //wallB = m_world.CreateBody(wallBd);
            //wallB.CreateFixture2(wall);
            // Top
            wallBd.position.Set(640 / m_physScale / 2, -95 / m_physScale);
            wall.SetAsBox(680/m_physScale/2, 100/m_physScale);
            //wallB = m_world.CreateBody(wallBd);
            //wallB.CreateFixture2(wall);
            // Bottom
            wallBd.position.Set(640 / m_physScale / 2, (480 + 95) / m_physScale);
            //wallB = m_world.CreateBody(wallBd);
            //wallB.CreateFixture2(wall);
        }
    }
}
