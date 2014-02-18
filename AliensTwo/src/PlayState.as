package
{
    import org.flixel.*;

    public class PlayState extends FlxState
    {
        public var debugText:FlxText;

        public var table:FlxSprite;
        public var table_x:Number = 150;
        public var table_y:Number = 180;
        public var player:Player;
        public var potpourri:FlxGroup;

        override public function create():void
        {
            FlxG.mouse.show();
            FlxG.bgColor = 0xff458A00;

            table = new FlxSprite(table_x,table_y);
            table.makeGraphic(100,10);
            table.immovable = true;
            table.solid = true;
            add(table);

            player = new Player(100,100);
            player.scale.x = 2;
            player.scale.y = 2;
            add(player);

            potpourri = new FlxGroup();

            for(var i:Number = 0; i < 20; i++){
                var rand:Number = (Math.random()*table.width)+table_x;
                var p:Potpourri = new Potpourri(table);
                add(p);
                potpourri.add(p);
            }

            debugText = new FlxText(10,10,100,"");
            add(debugText);

        }

        override public function update():void
        {
            super.update();
            player.update()
            FlxG.collide();
            FlxG.collide(potpourri,table,collisionCallback);
            borderCollide(table);
            borderCollide(player);

            for(var i:Number = 0; i < potpourri.length; i++){
                borderCollide(potpourri.members[i]);
            }

        }

        public function collisionCallback(p:FlxGroup,t:FlxSprite):void{
            for(var i:Number = 0; i < p.length; i++){
                p.members[i].velocity = 0;
            }
            debugText.text = "collide";
        }

        //*2 because of player sprite scaling
        public function borderCollide(_this:FlxSprite):void{
            if(_this.x >= FlxG.width - _this.width*2)
                _this.x = FlxG.width - _this.width*2;
            if(_this.x <= 0)
                _this.x = 0;
            if(_this.y >= FlxG.height - _this.height*2)
                _this.y = FlxG.height - _this.height*2;
            if(_this.y <= 0)
                _this.y = 0;
        }
    }
}
