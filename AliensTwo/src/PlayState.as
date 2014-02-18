package
{
    import org.flixel.*;

    public class PlayState extends FlxState
    {
        public var debugText:FlxText;

        public var table:FlxSprite;
        public var table_x:Number = 150;
        public var table_y:Number = 190;
        public var player:Player;
        public var potpourri:FlxGroup;
        public var bulbs:FlxGroup;
        public var carrying_p:Boolean = false;
        public var carrying_b:Boolean = false;
        public var stuffing:Number = 0;
        public var bulbs_stuffed:Number = 0;
        public var stuff_lock:Boolean = false;

        public var mouse:FlxSprite;

        override public function create():void
        {
            FlxG.bgColor = 0xff458A00;

            table = new FlxSprite(table_x,table_y);
            table.makeGraphic(100,10);
            table.immovable = true;
            add(table);

            player = new Player(100,FlxG.height-50);
            player.scale.x = 2;
            player.scale.y = 2;
            add(player);

            potpourri = new FlxGroup();
            bulbs = new FlxGroup();

            for(var i:Number = 0; i < 30; i++){
                var p:Potpourri = new Potpourri(table);
                add(p);
                potpourri.add(p);
            }

            var b:Bulb = new Bulb(table);
            add(b);
            bulbs.add(b);

            mouse = new FlxSprite(FlxG.mouse.x,FlxG.mouse.y);
            mouse.makeGraphic(5,5);
            add(mouse);

            debugText = new FlxText(10,10,100,"");
            add(debugText);

        }

        override public function update():void
        {
            super.update();
            mouse.x = FlxG.mouse.x;
            mouse.y = FlxG.mouse.y;

            FlxG.overlap(potpourri,bulbs,fillBulb);
            FlxG.collide(potpourri,table);
            FlxG.collide(bulbs,table);
            FlxG.collide(player,table);

            stuff_lock = false;

            if(FlxG.mouse.pressed()){
                if(carrying_p == false){
                    FlxG.overlap(potpourri,mouse,carryPotpourri);
                }
                if(carrying_b == false){
                    FlxG.overlap(bulbs,mouse,carryBulbs);
                }
            }

            if(FlxG.mouse.pressed() == false){
                carrying_p = false;
                carrying_b = false;
            }

            debugText.text = "Stuffing: " + stuffing.toString() + " Bulbs stuffed: " + bulbs_stuffed.toString();
        }

        public function fillBulb(p:FlxSprite,b:FlxSprite):void{
            p.kill();
            if(!stuff_lock){
                stuff_lock = true;
                if(stuffing < 5){
                    stuffing++;
                } else {
                    bulbs_stuffed++;
                }
            }
        }

        public function carryPotpourri(p:Potpourri,m:FlxSprite):void{
            p.carry();
            carrying_p = true;
        }

        public function carryBulbs(b:Bulb,m:FlxSprite):void{
            b.carry();
            carrying_b = true;
        }
    }
}
