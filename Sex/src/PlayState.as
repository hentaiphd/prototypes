package{
    import flash.utils.ByteArray;

    import org.flixel.*;
    import org.flixel.system.FlxTile;
    import org.flixel.plugin.photonstorm.*;
    import flash.geom.Rectangle;

    public class PlayState extends TimedState {
        [Embed(source="../assets/voice1.mp3")] private var Track1:Class;
        [Embed(source="../assets/mapCSV_Group1_Map1.csv", mimeType = "application/octet-stream")] private var Map:Class;
        [Embed(source="../assets/tiles1.png")] private var ImgTiles:Class;
        [Embed(source="../assets/bg.png")] private var ImgBg:Class;
        [Embed(source="../assets/bgunder.png")] private var ImgBgUnder:Class;
        [Embed(source="../assets/visitor1.ttf", fontFamily="visitor1", embedAsCFF="false")] public var Font:String;

        protected var _level:FlxTilemap;
        protected var _player:Player;
        protected var zoomcam:ZoomCamera;
        protected var _timer:Number;

        public var _bg:FlxSprite;
        public var _bgunder:FlxSprite;
        public var timer:Number = 0;
        public var debugText:FlxText;
        public var _npc:NPC;
        public var _chatBox:ChatBox;
        public var chat:FlxText;
        public var counter:Number = 0;
        public var _scroller:FlxScrollZone;
        public var _font:FlxBitmapFont;
        public var rand:Number;
        public var scrolling:Boolean = true;
        public var scrollcounter:Number = 0;
        public var chatlog:Array = new Array("<Panda> the drops going to guil",
            "<Guillen> THANK YOUUU","<Lenore> . . .","<Lenore> Seriously Panda?",
            "<Gothic1> I want it too!!!!!!!!!!1","<guyverguy> lol",
            "<capt44kirk> whyyyyy uuuggghhh",
            "<Lenore> What the fuck, dude.", "we wouldn't even be in this dungeon","if I hadn't let that bullcrap destroy my",
            "most VALUABLE shield.","Guillen obtains PLD ALPHA ARTIFACT ARMOR.",
            "<Lenore> WOW","Lenore has signed off.",
            "<Cib> grats guil","<Guillen> thx cib","<Panda> grats");
        public var _enemy:Enemy;
        public var _healthText:FlxText;
        public var shots:FlxGroup = null;
        public var mouse:FlxSprite;

        override public function create():void{
            FlxG.mouse.show();
            FlxG.play(Track1);
            //_level = new FlxTilemap();
            //_level.loadMap(new Map,ImgTiles,8,8,FlxTilemap.OFF);
            //_level.follow();
            //add(_level);

            //_level.setTileProperties(1,FlxObject.NONE);
            //_level.setTileProperties(6,FlxObject.ANY);
            //_level.setTileProperties(5,FlxObject.ANY);

            shots = new FlxGroup();
            add(shots);

            mouse = new FlxSprite(1,1);
            mouse.makeGraphic(1,1);
            add(mouse);

            _bgunder = new FlxSprite(9,191);
            _bgunder.loadGraphic(ImgBgUnder,false,false,215,43);
            add(_bgunder);

            _chatBox = new ChatBox(5, FlxG.height-55);
            add(_chatBox);

            chat = new FlxText(_chatBox.x+3,_chatBox.y+4,_chatBox.width-20,"");
            chat.color = 0xffffffff;
            chat.size = 8;
            add(chat);

            _bg = new FlxSprite(0,0);
            _bg.loadGraphic(ImgBg,false,false,320,240);
            add(_bg);

            _player = new Player(35, FlxG.height-30);
            add(_player);

            _npc = new NPC(_player.x+5,_player.y+10);
            //add(_npc);

            _enemy = new Enemy(100,100);
            add(_enemy);

            _healthText = new FlxText(10, 10, 100, _player._health.toString());
            add(_healthText);

            //FlxG.worldBounds = new FlxRect(0, 0, _level.width, _level.height);

            //zoomcam = new ZoomCamera(0, 0, 640, 480);
            //FlxG.resetCameras(zoomcam);
            //zoomcam.target = _player;
            //zoomcam.targetZoom = 3;

            debugText = new FlxText(100,100,100,"");
            add(debugText);
        }

        override public function update():void{
            super.update();

            mouse.x = FlxG.mouse.x;
            mouse.y = FlxG.mouse.y;

            _healthText.text = "Health: " + _player._health.toString();
            FlxG.overlap(_player, _enemy, enemyAttack);
            FlxG.overlap(mouse, _enemy, shootEnemy);

            _enemy.followPlayer(_player);
            rand = Math.floor(Math.random()*300)+50;
            timeFrame++;

            _npc.x = _player.x;
            _npc.y = _player.y+10;

            for(var num:Number = 0; num < shots.length; num++){
                shots.members[num].followEnemy(_enemy);
                FlxG.collide(_enemy, shots.members[num], shotEnemy);
            }

            if(FlxG.mouse.justReleased()){
                _player.shooting = false;
            }

            if(scrolling){
                if(timeFrame%rand == 0){
                    timer++;
                    counter++;

                    if(counter < chatlog.length){
                        chat.text += chatlog[counter] + "\n";
                    }

                    if(counter%4 == 0){
                        if(scrollcounter < chatlog.length){
                            chat.y -= (_chatBox.height/4)+4;
                            scrollcounter++;
                        } else {
                            scrolling = false;
                        }
                    }
                }
            }
        }

        public function enemyAttack(p:Player, e:Enemy):void{
            if(timeFrame%5 == 0){
                p._health--;
            }
            FlxG.shake(.001, 1);
        }

        public function shotEnemy(e:Enemy, s:FlxSprite):void{
            e._health--;
            s.kill();
        }

        public function shootEnemy(m:FlxSprite, e:Enemy):void{
            _player.shooting = true;
            if(FlxG.mouse.justPressed()){
                var shot:Shot = new Shot(_player.x, _player.y);
                add(shot);
                shots.add(shot);
            }
        }
    }
}
