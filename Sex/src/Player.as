package{
    import org.flixel.*;

    public class Player extends FlxSprite{
        [Embed(source = '../assets/boy.png')] public static var sprite_b:Class;
        [Embed(source = '../assets/girl.png')] public static var sprite_g:Class;

        public var runSpeed:Number = .1;
        private var walkDistance:Number = 0;
        private var walkTarget:DHPoint;
        private var walkDirection:DHPoint = null;
        private var walking:Boolean = false;
        private var walkSpeed:Number = 1;
        private var footPos:FlxPoint;
        private var heightDivisor:Number = 2;
        private var debugText:FlxText;

        public var shouldMove:Boolean = true;
        public var pos:FlxPoint;

        public function Player(x:Number, y:Number):void{
            super(x,y);
            loadGraphic(sprite_g, true, true, 14, 16, true);
            //this.offset.y = this.height - this.height/this.heightDivisor;
            //this.height /= this.heightDivisor;
            //this.width /= 2;
            //this.offset.x = this.width/2;
            this.walkTarget = new DHPoint(0, 0);

            addAnimation("run", [2,3], 14, true);
            addAnimation("stand", [0]);
            addAnimation("runBack", [4,5], 14, true);
            addAnimation("standBack", [4]);
        }


        override public function update():void{
            super.update();

            pos = new FlxPoint(this.x, this.y);
            //footPos = new FlxPoint(this.x+this.width/2, this.y+this.height);

            if(this.shouldMove && FlxG.mouse.justPressed()){
                walkTarget = new DHPoint(FlxG.mouse.x, FlxG.mouse.y);
                this.walking = true;
                walkDistance = new DHPoint(walkTarget.x, walkTarget.y)._length();
                walkDirection = new DHPoint(walkTarget.x, walkTarget.y).normalized();
            }

            if(this.shouldMove && walkDirection != null){
                if(Math.abs(walkDirection.y) > Math.abs(walkDirection.x)){
                    if(walkDirection.y < 0){
                        this.facing = UP;
                    } else {
                        this.facing = DOWN;
                    }
                } else {
                    if(walkDirection.x > 0){
                        this.facing = RIGHT;
                    } else {
                        this.facing = LEFT;
                    }
                }
            }

            if (new DHPoint(walkTarget.x, walkTarget.y)._length() < 3) {
                this.walking = false;
            }

            if(this.shouldMove && this.walking) {
                this.walk();
                if(this.facing == LEFT){
                    this.play("run");
                } else if (this.facing == RIGHT){
                    this.play("run");
                } else if(this.facing == UP){
                    this.play("runBack");
                } else if(this.facing == DOWN){
                    this.play("run");
                }
            } else {
                if(this.facing == LEFT){
                    this.play("stand");
                } else if (this.facing == RIGHT){
                    this.play("stand");
                } else if(this.facing == UP){
                    this.play("standBack");
                } else if(this.facing == DOWN){
                    this.play("stand");
                }
            }
        }

        public function collideFn():void
        {
            this.walking = false;
        }

        public function walk():void{
            walkDirection = new DHPoint(walkTarget.x, walkTarget.y).normalized();
            var walkX:Number = this.walkDirection.x * this.walkSpeed;
            var walkY:Number = this.walkDirection.y * this.walkSpeed;
            this.x += walkX;
            this.y += walkY;
        }
    }
}

