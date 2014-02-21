package
{
    import org.flixel.*;

    public class PlayState extends FlxState
    {
        [Embed(source="../assets/table.png")] private var TableImg:Class;
        [Embed(source="../assets/basket.png")] private var BasketImg:Class;
        [Embed(source="../assets/bg.png")] private var BgImg:Class;
        [Embed(source="../assets/nana.png")] private var NanaImg:Class;
        [Embed(source="../assets/tablestuff.png")] private var TableStuffImg:Class;
        [Embed(source="../assets/mom.png")] private var MomImg:Class;
        [Embed(source="../assets/aunt1.png")] private var Aunt1Img:Class;
        [Embed(source="../assets/aunt2.png")] private var Aunt2Img:Class;
        [Embed(source="../assets/fullbulb1.png")] private var FullBulb1:Class;
        [Embed(source="../assets/fullbulb2.png")] private var FullBulb2:Class;
        [Embed(source="../assets/fullbulb3.png")] private var FullBulb3:Class;
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
        public var bg:FlxSprite;
        public var nana:FlxSprite;
        public var mom:FlxSprite;
        public var aunt1:FlxSprite;
        public var aunt2:FlxSprite;
        public var table_stuff:FlxSprite;

        public var img_full:Array = [FullBulb1,FullBulb2,FullBulb3];

        public var frames:Number = 0;
        public var timeFrame:Number = 0;

        public var decorate:Boolean = false;

        public var msgText:FlxText;

        override public function create():void
        {
            FlxG.bgColor = 0xff458A00;

            bg = new FlxSprite(0,0);
            bg.loadGraphic(BgImg,false,false,320,240);
            add(bg);

            mom = new FlxSprite(50,50);
            mom.loadGraphic(MomImg,false,false,37,126);
            add(mom);

            aunt1 = new FlxSprite(200,50);
            aunt1.loadGraphic(Aunt1Img,false,true,30,124);
            add(aunt1);

            aunt2 = new FlxSprite(250,50);
            aunt2.loadGraphic(Aunt2Img,false,true,29,124);
            add(aunt2);

            table = new FlxSprite(170,160);
            table.loadGraphic(TableImg,false,false,120,54);
            table.immovable = true;
            //table.frameHeight = 40;
            add(table);

            table_stuff = new FlxSprite(225,145);
            table_stuff.loadGraphic(TableStuffImg,false,false,49,24);
            table_stuff.immovable = true;
            add(table_stuff);

            basket = new FlxSprite(70,185);
            basket.loadGraphic(BasketImg,false,false,42,25);
            add(basket);

            player = new Player(120,120);
            add(player);

            nana = new FlxSprite(30,85);
            nana.loadGraphic(NanaImg,false,false,31,126)
            add(nana);

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
            msgText = new FlxText(0,210,FlxG.width,"");
            //msgText.size = 16;
            msgText.alignment = "center";
            add(msgText);

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

                if(bulb.y > FlxG.height-10){
                    bulb.kill()
                    bulb = null;
                    msgText.text = "Oh no! You broke a bulb!!";
                }
            }

            if(msgText.text != ""){
                if(timeFrame%3 == 0){
                    msgText.text = "";
                }
            }

            if(decorate == true){
                msgText.text = "Click where you'd like to place the bulb on the tree.";
                if(FlxG.mouse.justPressed()){
                    //if(FlxG.overlap(new FlxSprite(FlxG.mouse.x,FlxG.mouse.y),tree)){
                        Decorate(FlxG.mouse.x,FlxG.mouse.y);
                    //}
                    decorate = false;
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
                    decorate = true;
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

        public function Decorate(x:Number,y:Number):void{
            var fbulb:FlxSprite = new FlxSprite(x,y);
            var i_rand:Number = Math.floor(Math.random()*2);
            fbulb.loadGraphic(img_full[i_rand],false,false,10,10);
            add(fbulb);
        }
    }
}
