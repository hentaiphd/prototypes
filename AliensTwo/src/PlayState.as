package
{
    import org.flixel.*;

    public class PlayState extends FlxState
    {
        [Embed(source="../assets/table.png")] private var TableImg:Class;
        [Embed(source="../assets/basket.png")] private var BasketImg:Class;
        public var debugText:FlxText;

        public var table:FlxSprite;
        public var player:Player;
        public var potpourri:FlxGroup;
        public var bulbs:FlxGroup;
        public var carrying_p:Boolean = false;
        public var carrying_b:Boolean = false;
        public var stuffing:Number = 0;
        public var bulbs_stuffed:Number = 0;
        public var stuff_lock:Boolean = false;
        public var p_num:Number = 10;

        public var basket:FlxSprite;
        public var mouse:FlxSprite;

        override public function create():void
        {
            FlxG.bgColor = 0xff458A00;

            table = new FlxSprite(170,150);
            table.loadGraphic(TableImg,false,false,138,90);
            //table.scale.x = 3;
            //table.scale.y = 3;
            table.immovable = true;
            add(table);

            basket = new FlxSprite(50,170);
            basket.loadGraphic(BasketImg,false,false,57,58);
            //basket.scale.x = 2;
            //basket.scale.y = 2;
            //basket.immovable = true;
            add(basket);

            player = new Player(120,FlxG.height-50);
            player.scale.x = 2;
            player.scale.y = 2;
            add(player);

            potpourri = new FlxGroup();
            bulbs = new FlxGroup();

            for(var i:Number = 0; i < p_num; i++){
                var p:Potpourri = new Potpourri(table);
                add(p);
                potpourri.add(p);
            }

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

            if(potpourri.length == 0){
                for(var i:Number = 0; i < p_num; i++){
                    var p:Potpourri = new Potpourri(table);
                    add(p);
                    potpourri.add(p);
                }
            }

            FlxG.overlap(potpourri,bulbs,fillBulb);
            FlxG.collide(potpourri,table);
            FlxG.collide(potpourri,potpourri);
            FlxG.collide(bulbs,bulbs);
            FlxG.collide(bulbs,table);
            FlxG.overlap(player,table);
            FlxG.overlap(basket,player,grabBulb);

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

            debugText.text = "Bulbs stuffed: " + bulbs_stuffed.toString();
        }

        public function fillBulb(p:FlxSprite,b:Bulb):void{
            p.kill();
            potpourri.remove(p,true);
            if(!stuff_lock){
                stuff_lock = true;
                if(b.stuffing < 5){
                    b.stuffing++;
                } else {
                    bulbs_stuffed++;
                    b.kill();
                    bulbs.remove(b,true);
                }
            }
        }

        public function grabBulb(basket:FlxSprite,player:Player):void{
            if(FlxG.mouse.pressed()){
                var b:Bulb = new Bulb(basket,player.x,player.y);
                add(b);
                bulbs.add(b);
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
