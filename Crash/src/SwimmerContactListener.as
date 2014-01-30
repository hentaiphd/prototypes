package
{
    import Box2D.Dynamics.Contacts.b2Contact;
    import Box2D.Dynamics.b2ContactListener;
    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.Joints.*;
    import org.flixel.*;

    public class SwimmerContactListener extends b2ContactListener
    {

        override public function BeginContact(contact:b2Contact):void
        {
            var fixtureA:b2Fixture = contact.GetFixtureA();
            var fixtureB:b2Fixture = contact.GetFixtureB();
            var bodyA:b2Body = fixtureA.GetBody();
            var bodyB:b2Body = fixtureB.GetBody();
            var bA_userdata:String = fixtureA.GetUserData().toString();
            var bB_userdata:String = fixtureB.GetUserData().toString();

            //bodyA.ApplyForce(new b2Vec2(0,200), new b2Vec2(0,0));
            //bodyB.ApplyForce(new b2Vec2(0,200), new b2Vec2(0,0));
        }

        override public function EndContact(contact:b2Contact):void
        {

        }
    }
}