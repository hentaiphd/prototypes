package{
    import org.flixel.*;

    public class Obstacle extends FlxSprite{
        [Embed(source = '../assets/hamster.gif')] public static var sprite:Class;

        public var runSpeed:Number = 2;
        public var _level:FlxTilemap;
        public var _bounds:FlxPoint;
        public var _frames:Number = 0;
        public var y_pos:Number;

        public function Obstacle(x:Number, y:Number, level:FlxTilemap):void{
            super(x,y);
            loadGraphic(sprite, false, false, 21, 25);
            this.scale.x = .5;
            this.scale.y = .5;
            this.width = 10;
            this.height = 10;

            y_pos = y;

            _level = level;
            _bounds = new FlxPoint(_level.getBounds().left, _level.getBounds().right);
        }

        override public function update():void{
            super.update();
            _frames++;

            if(this.x < _bounds.x){
                runSpeed *= -1;
            } else if(this.x > _bounds.y) {
                runSpeed *= -1;
            }

            this.x += runSpeed;
            this.y = y_pos + Math.sin(_frames*.7)*5;

        }
    }
}