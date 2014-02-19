package
{
    import org.flixel.*;

    public class PlayState extends FlxState
    {
        [Embed(source="../assets/table.png")] private var TableImg:Class;
        [Embed(source="../assets/basket.png")] private var BasketImg:Class;
        [Embed(source="../assets/tree.png")] private var TreeImg:Class;
        public var bulbText:FlxText;
        public var timeText:FlxText;

        public var table:FlxSprite;
        public var player:Player;
        public var potpourri:FlxGroup;
        public var carrying_p:Boolean = false;
        public var carrying_b:Boolean = false;
        public var stuffing:Number = 0;
        public var bulbs_stuffed:Number = 0;
        public var stuff_lock:Boolean = false;
        public var p_num:Number = 10;

        public var basket:FlxSprite;
        public var mouse:FlxSprite;
        public var bulb:Bulb = null;
        public var tree:FlxSprite;

        public var frames:Number = 0;
        public var timeFrame:Number = 0;

        override public function create():void
        {
            FlxG.bgColor = 0xff458A00;

            tree = new FlxSprite(100,70);
            tree.loadGraphic(TreeImg,false,false,87,86);
            tree.scale.x = 2;
            tree.scale.y = 2;
            add(tree);

            table = new FlxSprite(170,150);
            table.loadGraphic(TableImg,false,false,138,66);
            //table.scale.x = .5;
            //table.scale.y = .5;
            table.immovable = true;
            add(table);

            basket = new FlxSprite(-5,140);
            basket.loadGraphic(BasketImg,false,false,114,116);
            //basket.scale.x = .5;
            //basket.scale.y = .5;
            add(basket);

            player = new Player(120,FlxG.height-50);
            player.scale.x = 2;
            player.scale.y = 2;
            add(player);

            potpourri = new FlxGroup();

            for(var i:Number = 0; i < p_num; i++){
                var p:Potpourri = new Potpourri(table);
                add(p);
                potpourri.add(p);
            }

            mouse = new FlxSprite(FlxG.mouse.x,FlxG.mouse.y);
            mouse.makeGraphic(5,5);
            add(mouse);

            bulbText = new FlxText(10,10,FlxG.width,"");
            add(bulbText);
            timeText = new FlxText(10,20,FlxG.width,"");
            add(timeText);

        }

        override public function update():void
        {
            super.update();

            frames++;
            if(frames%50 == 0){
                timeFrame++;
            }

            if(timeFrame == 200){
                FlxG.switchState(new TextState("They broke all of your bulbs...",new MenuState()));
            }

            mouse.x = FlxG.mouse.x;
            mouse.y = FlxG.mouse.y;

            if(potpourri.length == 0){
                for(var i:Number = 0; i < p_num; i++){
                    var p:Potpourri = new Potpourri(table);
                    add(p);
                    potpourri.add(p);
                }
            }

            FlxG.collide(potpourri,table);
            FlxG.collide(potpourri,potpourri);
            FlxG.overlap(player,table);

            if(bulb != null){
                FlxG.overlap(bulb,table,bulbOnTable);
                FlxG.overlap(potpourri,bulb,fillBulb);
            }

            stuff_lock = false;

            if(FlxG.mouse.pressed()){
                FlxG.overlap(basket,player,grabBulb);

                if(carrying_p == false){
                    FlxG.overlap(potpourri,mouse,carryPotpourri);
                }
            }

            if(FlxG.mouse.pressed() == false){
                carrying_p = false;
            }

            bulbText.text = "Bulbs stuffed: " + bulbs_stuffed.toString();
            timeText.text = "Time: " + timeFrame.toString();

            if(bulb != null){
                if(bulb.held){
                    bulb.carrying(player.x,player.y);
                }
            }
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
                    bulb.kill();
                    bulb = null;
                }
            }
        }

        public function bulbOnTable(b:Bulb,t:FlxSprite):void{
            if(!b.held){
               b.carrying(t.x+10,t.y-10);
            }
        }

        public function grabBulb(b:FlxSprite,p:Player):void{
            if(bulb == null){
                bulb = new Bulb(b,p.x,p.y);
                add(bulb);
            }
        }

        public function carryPotpourri(p:Potpourri,m:FlxSprite):void{
            p.carry();
            carrying_p = true;
        }
    }
}
