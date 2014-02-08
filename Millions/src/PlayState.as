package{
    import flash.utils.ByteArray;

    import org.flixel.*;
    import org.flixel.system.FlxTile;

    public class PlayState extends FlxState {
        [Embed(source="../assets/mapCSV_Group1_Map1.csv", mimeType = "application/octet-stream")] private var Map:Class;
        [Embed(source="../assets/tiles1.png")] private var ImgTiles:Class;
        protected var _level:FlxTilemap;
        protected var _player:Player;
        protected var zoomcam:ZoomCamera;
        protected var _timer:Number;
        public var debugText:FlxText;

        protected var _gameStateActive:Boolean;
        protected var _pregameActive:Boolean = true;

        protected var _goalSprite:FlxSprite;



        override public function create():void{

            FlxG.bgColor = 0xFFccfbff;
            //FlxG.mouse.show();

            _timer = 0;

            _level = new FlxTilemap();
            _level.loadMap(new Map,ImgTiles,8,8,FlxTilemap.OFF);
            _level.follow();
            add(_level);

            _level.setTileProperties(1,FlxObject.NONE,onRoad);
            _level.setTileProperties(6,FlxObject.NONE,offRoading,null,100);
            _level.setTileProperties(5,FlxObject.ANY);
            _level.setTileProperties(46,FlxObject.NONE,goalReached);

            _player = new Player(35, _level.height-30);
            add(_player);

            FlxG.worldBounds = new FlxRect(0, 0, _level.width, _level.height);

            zoomcam = new ZoomCamera(0, 0, 640, 480);
            FlxG.resetCameras(zoomcam);
            zoomcam.target = _level;
            zoomcam.targetZoom = 1.2;

            startGame();

            debugText = new FlxText(_player.x,_player.y,100,"");
            add(debugText);
        }

        public function startGame():void{
            _gameStateActive = true;
            zoomcam.target = _player;
            zoomcam.targetZoom = 3;
        }

        override public function update():void{
            //debugText.text = _level.getTile(_player.x,_player.y).toString();
            _timer += FlxG.elapsed;
            super.update();
            FlxG.collide(_player, _level);

        }

        public function onRoad(tile:uint,obj:Player):void{
            obj.onRoad = true;
        }

        public function offRoading(tile:uint,obj:Player):void{
            obj.onRoad = false;
        }

        public function goalReached():void{

        }

        public function displacement(_object1:FlxSprite, _object2:FlxSprite):Number{
            var dx:Number = Math.abs(_object1.x - _object2.x);
            var dy:Number = Math.abs(_object1.y - _object2.y);
            return Math.sqrt(dx*dx + dy*dy);
        }
    }
}
