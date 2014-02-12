package
{
    import org.flixel.*;

    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.Joints.*;

    public class DollController
    {
        public var doll1:DollGrabber;
        public var doll2:DollGrabber;
        public var arm1:Arm;
        public var arm2:Arm;
        public var speed:Number = .055;
        public var speed_up:Number = .5;
        static public var dollTranslateSpeed:Number;
        static public var dollRotateSpeed:Number;
        public var t:FlxText;
        public var rotateMirror:Boolean = false;
        public var isClose:Boolean;

        public var timeFrame:Number = 0;
        public var timeSec:Number = 0;

        public function DollController(doll2:DollGrabber,
                                       arm2:Arm)
        {
            dollRotateSpeed = speed;
            dollTranslateSpeed = speed;
            this.doll2 = doll2;
            this.arm2 = arm2;
            t = new FlxText(100,100,100,"");
            FlxG.state.add(t);
        }

        public function update(timeRemain:Number):Boolean
        {
            timeFrame++;

            if(timeFrame%500 == 0){
                rotateMirror = rotateMirror ? false : true;
            }

            var toss:Boolean = false;
            if (timeRemain < 2) {
                toss = true;
            }

            var ret:Boolean = false;

            //t.text = this.isClose.toString();

            var target2:b2Vec2 = doll2.m_mouseJoint.GetTarget().Copy();
            var angle2:Number = doll2.doll.midriff.GetAngle();
            var left:Boolean = false;
            var right:Boolean = false;
            var up:Boolean = false;
            var down:Boolean = false;
            if (FlxG.keys.D) {
                right = true;
                left = false;
                ret = true;
            } else if (FlxG.keys.A) {
                right = false;
                left = true;
                ret = true;
            }
            if (FlxG.keys.S) {
                up = false;
                down = true;
                ret = true;
            } else if (FlxG.keys.W) {
                up = true;
                down = false;
                ret = true;
            }

            if (FlxG.keys.J) {
                ret = true;
                if (rotateMirror) {

                } else {
                    angle2 -= dollRotateSpeed;
                    arm2.turn(false);
                }
            } else if (FlxG.keys.K) {
                ret = true;
                if (rotateMirror) {
                    angle2 -= dollRotateSpeed;
                    arm2.turn(false);
                }
            } else {
                arm2.stopTurning();
            }

            if (toss) {
                dollTranslateSpeed = 1;
            }

            if (left) {
                target2.x += dollTranslateSpeed;
            }
            if (right) {
                target2.x -= dollTranslateSpeed;
            }
            if (up) {
                target2.y -= dollTranslateSpeed;
            }
            if (down) {
                target2.y += dollTranslateSpeed;
            }

            doll2.SetTransform(target2, angle2, toss);
            return ret;
        }
    }
}
