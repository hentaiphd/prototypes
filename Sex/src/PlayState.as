package{
    import flash.utils.ByteArray;

    import org.flixel.*;
    import org.flixel.system.FlxTile;

    public class PlayState extends FlxState {
        [Embed(source="../assets/mapCSV_Group1_Map1.csv", mimeType = "application/octet-stream")] private var Map:Class;
        [Embed(source="../assets/tiles1.png")] private var ImgTiles:Class;
        [Embed(source="../assets/star.png")] private var ImgStar:Class;
        protected var _level:FlxTilemap;
        protected var _player:Player;
        protected var zoomcam:ZoomCamera;
        protected var _timer:Number;
        public var timeFrame:Number = 0;
        public var timer:Number = 0;
        public var debugText:FlxText;

        public var _chatBox:ChatBox;
        public var _health:Health;

        public var _npc:NPC;

        public function PlayState(){
        }

        override public function create():void{
            FlxG.mouse.show();
            startGame();
            debugText = new FlxText(100,100,100,"");
            add(debugText);
        }

        public function startGame():void{
            FlxG.bgColor = 0xFFccfbff;

            _level = new FlxTilemap();
            _level.loadMap(new Map,ImgTiles,8,8,FlxTilemap.OFF);
            _level.follow();
            add(_level);

            _level.setTileProperties(1,FlxObject.NONE);
            _level.setTileProperties(6,FlxObject.ANY);
            _level.setTileProperties(5,FlxObject.ANY);

            _player = new Player(35, _level.height-30);
            add(_player);

            _npc = new NPC(_player.x+5,_player.y+10);
            add(_npc);

            FlxG.worldBounds = new FlxRect(0, 0, _level.width, _level.height);

            zoomcam = new ZoomCamera(0, 0, 640, 480);
            FlxG.resetCameras(zoomcam);
            zoomcam.target = _player;
            zoomcam.targetZoom = 3;

            _chatBox = new ChatBox(zoomcam.width-100, zoomcam.height-30);
            add(_chatBox);

            _health = new Health(zoomcam.width-50, zoomcam.height-30);
            add(_health);
        }

        override public function update():void{
            super.update();
            _chatBox.x = _player.x-85;
            _chatBox.y = _player.y+90;
            _health.x = _player.x+170;
            _health.y = _player.y+90;

            //debugText.text = zoomcam.height.toString();
            debugText.x = _player.x;
            debugText.y = _player.y;

            timeFrame++;
            _timer += FlxG.elapsed;

            if(timeFrame%50 == 0){
                timer++;
            }

            FlxG.collide(_player, _level);
        }

        //public function moveNPC():void{
        //    if()
        //}
    }
}
