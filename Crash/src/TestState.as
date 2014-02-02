package
{
    import org.flixel.*;

    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.Joints.*;
    import Box2D.Collision.Shapes.b2PolygonShape;
    import flash.display.*;

    public class TestState extends FlxState
    {
        public var m_physScale:Number = 30;
        public var m_world:b2World;

        override public function create():void
        {

            var gravity:b2Vec2 = new b2Vec2(0,9.8);
            m_world = new b2World(gravity,true);
            m_world.SetContactListener(new SwimmerContactListener());

            var dbgDraw:b2DebugDraw = new b2DebugDraw();
            var dbgSprite:Sprite = new Sprite();
            FlxG.stage.addChild(dbgSprite);
            dbgDraw.SetSprite(dbgSprite);
            dbgDraw.SetDrawScale(30.0);
            dbgDraw.SetFillAlpha(0.3);
            dbgDraw.SetLineThickness(1.0);
            dbgDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
            m_world.SetDebugDraw(dbgDraw);

            var bd:b2BodyDef = new b2BodyDef();
            bd.type = b2Body.b2_dynamicBody;
            bd.position.Set(100 / m_physScale, 0 / m_physScale);
            var ball:b2Body = m_world.CreateBody(bd);
            var shape:b2CircleShape = new b2CircleShape(1);
            var fd:b2FixtureDef = new b2FixtureDef();
            fd.shape = shape;
            ball.CreateFixture(fd);

            bd.type = b2Body.b2_staticBody;
            bd.position.Set(100 / m_physScale, 100 / m_physScale);
            var ball2:b2Body = m_world.CreateBody(bd);
            ball2.CreateFixture(fd);
        }

        override public function update():void
        {
            m_world.Step(1.0/30.0, 10, 10);
            m_world.DrawDebugData();
        }
    }
}