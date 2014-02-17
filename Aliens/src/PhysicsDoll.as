package
{
    import org.flixel.*;

    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.Joints.*;

    public class PhysicsDoll
    {
        public var m_world:b2World;
        public var m_physScale:Number = 30
        public var midriff:b2Body;
        public var torso3:b2Body
        public var spriteType:Number;

        public var headSprite:FlxSprite;
        public var chestSprite:FlxSprite;
        public var hipsSprite:FlxSprite;
        public var armLSprite:FlxSprite;
        public var armRSprite:FlxSprite;
        public var legLSprite:FlxSprite;
        public var legRSprite:FlxSprite;
        public var footLSprite:FlxSprite;
        public var footRSprite:FlxSprite;

        public var groundBodyDef:b2BodyDef;
        public var groundBody:b2Body;
        public var groundShape:b2PolygonShape;
        public var groundFixtureDef:b2FixtureDef;
        public var groundFixture:b2Fixture;

        public var head:b2Body;
        public var torso1:b2Body;
        public var upperArmL1:b2Body;
        public var upperArmR1:b2Body;
        public var upperArmL2:b2Body;
        public var upperArmR2:b2Body;
        public var l_hand:b2Body;
        public var r_hand:b2Body;
        public var upperLegL:b2Body;
        public var upperLegR:b2Body;
        public var lowerLegL:b2Body;
        public var lowerLegR:b2Body;

        private const LEGSPACING:Number = 18;

        public static const ATYPE:int = 0;  // lady
        public static const BTYPE:int = 1;  // dude

        private const LEGAMASK:uint = 0x0002;
        private const LEGACAT:uint  = 0x0002;
        private const LEGBMASK:uint = 0x0004;
        private const LEGBCAT:uint  = 0x0004;
        private const TORSOMASK:uint  = 0xFFFF;
        private const TORSOCAT:uint  = 0x0010;
        private const ARMMASK:uint  = 0xFFFF;
        private const ARMCAT:uint  = 0x0020;
        private const FOOTMASK:uint = 0xFFEF;
        private const FOOTCAT:uint  = 0x0008;

        public static const COL_HEAD:String = "HEAD";
        public static const COL_L_HAND:String = "L_HAND";
        public static const COL_R_HAND:String = "R_HAND";
        public static const COL_GROIN:String = "GROIN";

        public var m_mouseJoint:b2MouseJoint;
        public var PHYS_SCALE:Number = 30;

        public function create(_world:b2World, start:FlxPoint,
                               spriteType:int = ATYPE):void
        {
            m_world = _world;
            this.spriteType = spriteType;

            var circ:b2CircleShape;
            var box:b2PolygonShape;
            var bd:b2BodyDef = new b2BodyDef();
            var jd:b2RevoluteJointDef = new b2RevoluteJointDef();
            var fixtureDef:b2FixtureDef = new b2FixtureDef();
            var startX:Number = start.x;
            var startY:Number = start.y;

            // BODIES
            // Set these to dynamic bodies
            bd.type = b2Body.b2_dynamicBody;

            // Head
            circ = new b2CircleShape( 50 / m_physScale );
            fixtureDef.shape = circ;
            fixtureDef.density = 1.0;
            fixtureDef.friction = 0.4;
            fixtureDef.restitution = 0.3;
            var headY:Number = 40;
            bd.position.Set(startX / m_physScale, (startY - headY) / m_physScale);
            bd.type = b2Body.b2_staticBody;
            head = m_world.CreateBody(bd);
            bd.type = b2Body.b2_dynamicBody;
            fixtureDef.isSensor = true;
            fixtureDef.userData = COL_HEAD;
            head.CreateFixture(fixtureDef);
            fixtureDef.isSensor = false;

            // Torso1
            box = new b2PolygonShape();
            box.SetAsBox(50 / m_physScale, 50 / m_physScale);
            fixtureDef.shape = box;
            //fixtureDef.density = 1.0;
            //fixtureDef.friction = 0.4;
            //fixtureDef.restitution = 0.1;
            bd.position.Set(startX / m_physScale, (startY + 50) / m_physScale);
            bd.type = b2Body.b2_staticBody;
            torso1 = m_world.CreateBody(bd);
            bd.type = b2Body.b2_dynamicBody;
            torso1.CreateFixture(fixtureDef);
            /* Torso2
            box = new b2PolygonShape();
            box.SetAsBox(50 / m_physScale, 50 / m_physScale);
            fixtureDef.shape = box;
            bd.position.Set(startX / m_physScale, (startY + 100) / m_physScale);
            bd.fixedRotation = true;
            var torso2:b2Body = m_world.CreateBody(bd);
            torso2.CreateFixture(fixtureDef);
            bd.fixedRotation = false;*/
            midriff = torso1;

            // UpperArm
            fixtureDef.density = 1.0;
            fixtureDef.friction = 0.4;
            fixtureDef.restitution = 0.1;
            // L1
            box = new b2PolygonShape();
            box.SetAsBox(30 / m_physScale, 10 / m_physScale);
            fixtureDef.shape = box;
            var armSpace:Number = 90;
            var armHeight:Number = 10;
            bd.position.Set((startX - armSpace) / m_physScale, (startY + armHeight) / m_physScale);
            upperArmL1 = m_world.CreateBody(bd);
            upperArmL1.CreateFixture(fixtureDef);
            //L2
            box = new b2PolygonShape();
            box.SetAsBox(30 / m_physScale, 10 / m_physScale);
            fixtureDef.shape = box;
            bd.position.Set((startX - 100) / m_physScale, (startY + armHeight) / m_physScale);
            upperArmL2 = m_world.CreateBody(bd);
            upperArmL2.CreateFixture(fixtureDef);
            // L Hand
            box = new b2PolygonShape();
            box.SetAsBox(10 / m_physScale, 10 / m_physScale);
            fixtureDef.shape = box;
            bd.position.Set((startX - 130) / m_physScale, (startY + armHeight) / m_physScale);
            l_hand = m_world.CreateBody(bd);
            fixtureDef.isSensor = true;
            fixtureDef.userData = COL_L_HAND;
            l_hand.CreateFixture(fixtureDef);
            fixtureDef.isSensor = false;
            bd.fixedRotation = false;
            // R1
            box = new b2PolygonShape();
            box.SetAsBox(30 / m_physScale, 10 / m_physScale);
            fixtureDef.shape = box;
            bd.position.Set((startX + armSpace) / m_physScale, (startY + armHeight) / m_physScale);
            upperArmR1 = m_world.CreateBody(bd);
            upperArmR1.CreateFixture(fixtureDef);
            // R2
            box = new b2PolygonShape();
            box.SetAsBox(30 / m_physScale, 10 / m_physScale);
            fixtureDef.shape = box;
            bd.position.Set((startX + 120) / m_physScale, (startY + armHeight) / m_physScale);
            upperArmR2 = m_world.CreateBody(bd);
            upperArmR2.CreateFixture(fixtureDef);
            // R Hand
            box = new b2PolygonShape();
            box.SetAsBox(10 / m_physScale, 10 / m_physScale);
            fixtureDef.shape = box;
            bd.position.Set((startX + 150) / m_physScale, (startY + armHeight) / m_physScale);
            r_hand = m_world.CreateBody(bd);
            fixtureDef.isSensor = true;
            fixtureDef.userData = COL_R_HAND;
            r_hand.CreateFixture(fixtureDef);
            fixtureDef.isSensor = false;
            bd.fixedRotation = false;

            // JOINTS
            jd.enableLimit = true;

            // Head to shoulders
            jd.lowerAngle = -10 / (180/Math.PI);
            jd.upperAngle = 10 / (180/Math.PI);
            jd.Initialize(torso1, head, new b2Vec2(startX / m_physScale, (startY - 3) / m_physScale));
            m_world.CreateJoint(jd);

            // Upper arm to shoulders
            // L
            var shoulderJointSpace:Number = 32;
            jd.lowerAngle = -85 / (180/Math.PI);
            jd.upperAngle = 10 / (180/Math.PI);
            jd.Initialize(torso1, upperArmL1, new b2Vec2((startX - 50) / m_physScale, (startY + 10) / m_physScale));
            m_world.CreateJoint(jd);
            //L1 to L2
            jd.lowerAngle = -85 / (180/Math.PI);
            jd.upperAngle = 10 / (180/Math.PI);
            jd.Initialize(upperArmL1, upperArmL2, new b2Vec2((startX - 90) / m_physScale, (startY + 10) / m_physScale));
            m_world.CreateJoint(jd);
            // L Hand to L Arm
            jd.lowerAngle = -125 / (180/Math.PI);
            jd.upperAngle = 125 / (180/Math.PI);
            jd.Initialize(upperArmL2, l_hand, new b2Vec2((startX-150) / m_physScale, (startY+armHeight) / m_physScale));
            m_world.CreateJoint(jd);
            // R
            jd.lowerAngle = -10 / (180/Math.PI);
            jd.upperAngle = 85 / (180/Math.PI);
            jd.Initialize(torso1, upperArmR1, new b2Vec2((startX + 50) / m_physScale, (startY + 10) / m_physScale));
            m_world.CreateJoint(jd);
            // R1 to R2
            jd.lowerAngle = -10 / (180/Math.PI);
            jd.upperAngle = 85 / (180/Math.PI);
            jd.Initialize(upperArmR1, upperArmR2, new b2Vec2((startX + 90) / m_physScale, (startY + 10) / m_physScale));
            m_world.CreateJoint(jd);
            // R Hand to R Arm
            jd.lowerAngle = -125 / (180/Math.PI);
            jd.upperAngle = 125 / (180/Math.PI);
            jd.Initialize(upperArmR2, r_hand, new b2Vec2((startX+150) / m_physScale, (startY+armHeight) / m_physScale));
            m_world.CreateJoint(jd);

            /* Shoulders/stomach
            jd.lowerAngle = -15 / (180/Math.PI);
            jd.upperAngle = 15 / (180/Math.PI);
            jd.Initialize(torso1, torso2, new b2Vec2(startX / m_physScale, (startY + 65) / m_physScale));
            m_world.CreateJoint(jd);*/

            //table
            groundBodyDef = new b2BodyDef();
            groundBodyDef.position.Set(100/PHYS_SCALE, (FlxG.height*2.5)/PHYS_SCALE);
            groundBody = m_world.CreateBody(groundBodyDef);
            groundShape = new b2PolygonShape();
            groundShape.SetAsBox((FlxG.width*2)/PHYS_SCALE, (FlxG.height/2)/PHYS_SCALE);
            groundFixtureDef = new b2FixtureDef();
            groundFixtureDef.shape = groundShape;
            groundBody.SetUserData("table");
            groundFixtureDef.isSensor = true;
            groundFixture = groundBody.CreateFixture(groundFixtureDef);
            groundFixtureDef.isSensor = false;

            setupSprites();

            var md:b2MouseJointDef = new b2MouseJointDef();
            md.bodyA = groundBody;
            md.bodyB = l_hand;
            md.target.Set(l_hand.GetPosition().x, l_hand.GetPosition().y);
            md.collideConnected = true;
            md.maxForce = 30;
            m_mouseJoint = m_world.CreateJoint(md) as b2MouseJoint;
        }

        public function update():void
        {
            headSprite.x = (head.GetPosition().x * m_physScale / 2) - headSprite.width/2;
            headSprite.y = (head.GetPosition().y * m_physScale / 2) - headSprite.height/2;
            headSprite.angle = torso1.GetAngle() * (180 / Math.PI);

            chestSprite.x = (torso1.GetPosition().x * m_physScale / 2) - chestSprite.width/2;
            chestSprite.y = (torso1.GetPosition().y * m_physScale / 2) - chestSprite.height/2;
            chestSprite.angle = torso1.GetAngle() * (180 / Math.PI) ;

            hipsSprite.x = (midriff.GetPosition().x * m_physScale / 2) - hipsSprite.width/2;
            hipsSprite.y = (midriff.GetPosition().y * m_physScale / 2) - hipsSprite.height/2;
            hipsSprite.angle = midriff.GetAngle() * (180 / Math.PI) ;

            armLSprite.x = (upperArmR1.GetPosition().x * m_physScale / 2) - armLSprite.width/2;
            if (spriteType == ATYPE) {
                armLSprite.y = (upperArmR1.GetPosition().y * m_physScale / 2) - armLSprite.height/2 - 3;
            } else if (spriteType == BTYPE) {
                armLSprite.y = (upperArmR1.GetPosition().y * m_physScale / 2) - armLSprite.height/2;
            }
            armLSprite.angle = upperArmR1.GetAngle() * (180 / Math.PI) ;

            armRSprite.x = (upperArmL1.GetPosition().x * m_physScale / 2) - armRSprite.width/2;
            armRSprite.y = (upperArmL1.GetPosition().y * m_physScale / 2) - armRSprite.height/2;
            armRSprite.angle = upperArmL1.GetAngle() * (180 / Math.PI) ;

            legRSprite.x = (upperLegL.GetPosition().x * m_physScale / 2) - legRSprite.width/2;
            legRSprite.y = (upperLegL.GetPosition().y * m_physScale / 2) - legRSprite.height/2;
            legRSprite.angle = upperLegL.GetAngle() * (180 / Math.PI) ;

            legLSprite.x = (upperLegR.GetPosition().x * m_physScale / 2) - legLSprite.width/2;
            legLSprite.y = (upperLegR.GetPosition().y * m_physScale / 2) - legLSprite.height/2;
            legLSprite.angle = upperLegR.GetAngle() * (180 / Math.PI) ;

            footLSprite.x = (lowerLegR.GetPosition().x * m_physScale / 2) - footLSprite.width/2;
            footLSprite.y = (lowerLegR.GetPosition().y * m_physScale / 2) - footLSprite.height/2;
            footLSprite.angle = lowerLegR.GetAngle() * (180 / Math.PI) ;

            footRSprite.x = (lowerLegL.GetPosition().x * m_physScale / 2) - footRSprite.width/2;
            footRSprite.y = (lowerLegL.GetPosition().y * m_physScale / 2) - footRSprite.height/2;
            footRSprite.angle = lowerLegL.GetAngle() * (180 / Math.PI) ;

            var mousepoint:FlxPoint = new FlxPoint(FlxG.mouse.x/PHYS_SCALE,FlxG.mouse.y/PHYS_SCALE);
            var handLpoint:FlxPoint = new FlxPoint(l_hand.GetPosition().x,l_hand.GetPosition().y);

            if(FlxU.getDistance(mousepoint,handLpoint) < 20/PHYS_SCALE){
                if(FlxG.mouse.pressed()){
                    m_mouseJoint.SetTarget(new b2Vec2(mousepoint.x,mousepoint.y));
                }
            }
        }

        public function setupSprites():void
        {/*
            headSprite = new FlxSprite(0, 0);
            chestSprite = new FlxSprite(0, 0);
            hipsSprite = new FlxSprite(0, 0);
            armLSprite = new FlxSprite(0, 0);
            armRSprite = new FlxSprite(0, 0);
            legLSprite = new FlxSprite(0, 0);
            legRSprite = new FlxSprite(0, 0);
            footLSprite = new FlxSprite(0, 0);
            footRSprite = new FlxSprite(0, 0);*/
            if (spriteType == ATYPE) {

            } else if (spriteType == BTYPE) {

            }
            FlxG.state.add(armLSprite);
            FlxG.state.add(armRSprite);
            FlxG.state.add(hipsSprite);
            FlxG.state.add(legLSprite);
            FlxG.state.add(legRSprite);
            FlxG.state.add(footLSprite);
            FlxG.state.add(footRSprite);
            FlxG.state.add(chestSprite);
            FlxG.state.add(headSprite);
        }
    }
}
