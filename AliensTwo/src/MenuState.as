package{
    import org.flixel.*;

    public class MenuState extends FlxState{
        [Embed(source="../assets/table.png")] private var TableImg:Class;
        [Embed(source="../assets/basket.png")] private var BasketImg:Class;
        [Embed(source="../assets/bg.png")] private var BgImg:Class;
        [Embed(source="../assets/tree.png")] private var TreeImg:Class;
        [Embed(source="../assets/nana.png")] private var NanaImg:Class;
        [Embed(source="../assets/tablestuff.png")] private var TableStuffImg:Class;
        [Embed(source="../assets/mom.png")] private var MomImg:Class;
        [Embed(source="../assets/aunt1.png")] private var Aunt1Img:Class;
        [Embed(source="../assets/aunt2.png")] private var Aunt2Img:Class;
        [Embed(source="../assets/fullbulb1.png")] private var FullBulb1:Class;
        [Embed(source="../assets/fullbulb2.png")] private var FullBulb2:Class;
        [Embed(source="../assets/fullbulb3.png")] private var FullBulb3:Class;
        [Embed(source="../assets/clock.mp3")] private var ClockSound:Class;
        public var table_stuff:FlxSprite;
        public var tree:FlxSprite;
        public var bulbText:FlxText;
        public var timeText:FlxText;
        public var momText:FlxText;
        public var familyText:FlxText;

        public var table:FlxSprite;
        public var player:Player;
        public var potpourri:FlxGroup;
        public var full_bulbs:FlxGroup;
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
        public var nanapt:FlxPoint = new FlxPoint(260,100);
        public var mom:FlxSprite;
        public var mompt:FlxPoint = new FlxPoint(50,50);
        public var aunt1:FlxSprite;
        public var aunt1pt:FlxPoint = new FlxPoint(200,50);
        public var aunt2:FlxSprite;
        public var aunt2pt:FlxPoint = new FlxPoint(250,50);

        override public function create():void{
            FlxG.mouse.hide();

            bg = new FlxSprite(0,0);
            bg.loadGraphic(BgImg,false,false,320,240);
            add(bg);

            tree = new FlxSprite(100,10);
            tree.loadGraphic(TreeImg,false,false,120,143);
            add(tree);

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

            for(var i:Number = 0; i < p_num; i++){
                var p:Potpourri = new Potpourri(table);
                add(p);
            }

            var t1:FlxText;
            t1 = new FlxText(20,140,FlxG.width/2,"Walk to the box to grab a bulb. Click and drag potpourri to stuff the bulb.");
            add(t1);

            var t2:FlxText;
            t2 = new FlxText(20,220,FlxG.width,"Click to play.");
            add(t2);
        }

        override public function update():void{
            super.update();

            FlxG.collide();

            if(FlxG.mouse.pressed()){
                FlxG.switchState(new TextState("Honey, take this potpourri and stuff the empty Christmas bulbs.", "nope"));
            }
        }

    }
}
