package{
    import org.flixel.*;

    public class NPC extends FlxSprite{
        [Embed(source = '../assets/boy.png')] public static var sprite_b:Class;
        [Embed(source = '../assets/girl.png')] public static var sprite_g:Class;

        public var runSpeed:Number = 1;
        public var offRoad_runSpeed:Number = .04;
        public var _scale:FlxPoint = new FlxPoint(1,1);
        public var _scaleFlipX:Number = 1;
        public var _scaleFlipY:Number = 1;
        public var maxSpeed:Number = 1.5;
        public var offRoad_maxSpeed:Number = .1;
        public var onRoad:Boolean = true;
        public var moveup:Boolean = false;
        public var movedown:Boolean = false;
        public var moveleft:Boolean = false;
        public var moveright:Boolean = false;
        public var standing:Boolean = false;
        public var standingback:Boolean = true;

        public function NPC(x:Number, y:Number):void{
            super(x,y);
            loadGraphic(sprite_b, true, true, 14, 16, true);

            addAnimation("run", [2,3], 14, true);
            addAnimation("standing", [0]);
            addAnimation("runBack", [4,5], 14, true);
            addAnimation("standingBack", [4]);
        }


        override public function update():void{
            super.update();
            onRoadMovement();
        }

        public function onRoadMovement():void{
            if(moveleft) {
                scale.x = -1;
                this.x -= runSpeed;
                this.facing = LEFT;
                play("run");
            } else if(moveright){
                scale.x = -1;
                this.x += runSpeed;
                this.facing = RIGHT;
                play("run");
            } else if(moveup){
                this.y -= runSpeed;
                play("runBack");
            } else if(movedown){
                this.y += runSpeed;
                play("run");
            } else if(standingback){
                play("standingBack");
            } else if (standing){
                play("standing");
            } else {
                play("standing");
            }
        }
    }
}
