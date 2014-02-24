package
{
    import org.flixel.*;

    public class Player extends FlxSprite{
        [Embed(source="../assets/girl.png")] private var ImgPlayer:Class;

        private var runSpeed:int = 2;
        public var grabbing:Boolean = false;
        private var _jumppower:int = 290;
        private var jumping:Boolean = false;
        private var running:Boolean = false;
        public var holding:Boolean = false;
        public var counter:int = 0;
        private var slippery:Boolean = false;
        private var grabDown:Boolean = false;
        public var no_control:Boolean = false;
        public var fallen:Boolean = false;
        public var isMoving:Boolean = false;
        public var runFast:Boolean = false;
        public var dropping:Boolean = false;
        public var dir:String = "";
        public var moveleft:Boolean = false;
        public var moveright:Boolean = false;

        public function Player(x:int,y:int):void{
            super(x,y);
            loadGraphic(ImgPlayer, true, true, 31, 94, true);

            drag.x = runSpeed*8;
        }

        override public function update():void{
            super.update();
            borderCollide();

            if(moveleft){
                this.facing = LEFT;
                this.x--;
            }
            if(moveright){
                this.facing = RIGHT;
                this.x++;
            }

            acceleration.x = 0;

        }

        public function runLeft():void{
            facing = LEFT;
            x -= runSpeed;
        }

        public function runRight():void{
            facing = RIGHT;
            x += runSpeed;
        }

        public function decelerate():void{
            if (counter < 5) {;
                drag.x += 200;
                if (!this.fallen){
                    isMoving = true;
                }
                counter++;
            } else if (counter == 5) {
                if (!this.fallen){
                    isMoving = false;
                }
                counter = 0;
            }
        }

        public function borderCollide():void{
            if(x >= FlxG.width - width)
                x = FlxG.width - width;
            if(this.x <= 0)
                this.x = 0;
            if(this.y >= FlxG.height - height)
                this.y = FlxG.height - height;
            if(this.y <= 0)
                this.y = 0;
        }
    }
}