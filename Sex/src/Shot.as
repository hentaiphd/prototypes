package{
    import org.flixel.*;

    public class Shot extends FlxSprite{
        public var shouldMove:Boolean = true;
        public var walking:Boolean = true;
        public var walkDistance:Number = 0;
        public var walkTarget:DHPoint;
        public var walkDirection:DHPoint = null;
        public var walkSpeed:Number = 2;
        public var _health:Number = 50;
        public var pos:FlxPoint = new FlxPoint(0, 0);

        public function Shot(x:Number, y:Number):void{
            super(x,y);
            this.makeGraphic(5,5,0xffffffff);
        }


        override public function update():void{
            super.update();
        }


        public function followEnemy(_player:Enemy):void{

            pos.x = this.x;
            pos.y = this.y;

            if(this.x != _player.x){
                if(this.y != _player.y){
                    this.walkTarget = new DHPoint(FlxG.mouse.x, FlxG.mouse.y);
                    this.walking = true;
                    this.walkDistance = new DHPoint(_player.x-pos.x, _player.y-pos.y)._length();
                    this.walkDirection = new DHPoint(_player.x-pos.x, _player.y-pos.y).normalized();
                }
            }

            if (new DHPoint(_player.x, _player.y)._length() < 3) {
                this.walking = false;
            }

            if(this.shouldMove && this.walking) {
                walk(_player);
            }
        }

        public function collideFn():void
        {
            this.walking = false;
        }

        public function walk(_player:Enemy):void{
            this.walkDirection = new DHPoint(_player.x-pos.x, _player.y-pos.y).normalized();
            var walkX:Number = this.walkDirection.x * this.walkSpeed;
            var walkY:Number = this.walkDirection.y * this.walkSpeed;
            this.x += walkX;
            this.y += walkY;
        }
    }
}