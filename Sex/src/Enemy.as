package{
    import org.flixel.*;

    public class Enemy extends FlxSprite{
        [Embed(source = '../assets/ghost.png')] public static var hamster:Class;
        public var shouldMove:Boolean = true;
        public var walking:Boolean = true;
        public var walkDistance:Number = 0;
        public var walkTarget:DHPoint;
        public var walkDirection:DHPoint = null;
        public var walkSpeed:Number = .3;
        public var _health:Number = 50;
        public var pos:FlxPoint = new FlxPoint(0, 0);
        public var _healthText:FlxText;

        public function Enemy(x:Number, y:Number):void{
            super(x,y);
            loadGraphic(hamster, true, true, 14, 14, true);
            _healthText = new FlxText(x,y-10,100,_health.toString());
            FlxG.state.add(_healthText);
        }


        override public function update():void{
            super.update();
            _healthText.x = x;
            _healthText.y = y-10;
            _healthText.text = _health.toString();

            if(_health <= 0){
                this.kill();
            }
        }


        public function followPlayer(_player:Player):void{

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

        public function walk(_player:Player):void{
            this.walkDirection = new DHPoint(_player.x-pos.x, _player.y-pos.y).normalized();
            var walkX:Number = this.walkDirection.x * this.walkSpeed;
            var walkY:Number = this.walkDirection.y * this.walkSpeed;
            this.x += walkX;
            this.y += walkY;
        }
    }
}
