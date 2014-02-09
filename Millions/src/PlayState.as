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
        public var debugText:FlxText;

        protected var _gameStateActive:Boolean;
        protected var _pregameActive:Boolean = true;
        protected var _goalText:FlxText;
        protected var _goalSprite:FlxSprite;

        protected var goal:Boolean = false;

        public var timeFrame:Number = 0;
        public var timer:Number = 0;
        public var fell:Number = 0;

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

            _player = new Player(35, _level.height-30);
            add(_player);

            _goalText = new FlxText(250,270,100,"Booty Call!");

            _goalSprite = new FlxSprite(_goalText.x+15,_goalText.y-10);
            _goalSprite.loadGraphic(ImgStar, true, true, 23, 26, true);
            _goalSprite.addAnimation("blink", [0,1], 14, true);
            //_goalSprite.scale.x = .3;
            //_goalSprite.scale.y = .3;
            add(_goalSprite);
            _goalSprite.play("blink");

            add(_goalText);

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
            zoomcam.targetZoom = 5;
        }

        override public function update():void{
            timeFrame++;
            if(timeFrame%50 == 0){
                timer++;
            }

            //debugText.x = _player.x;
            //debugText.y = _player.y;
            //debugText.text = goal.toString();
            _timer += FlxG.elapsed;
            super.update();
            FlxG.collide(_player, _level);

            if(FlxG.collide(_player,_goalSprite)){
                goal = true;
            }

            if(goal == true){
                if(timer > 60){
                    if(fell > 10){
                        FlxG.switchState(new TextState("You made it in " + timer.toString() + " minutes.\nBut you took so long, so they're not that into it...\nYou also fell " + fell + " times, so you're kinda beat up... but that's... sorta sexy???", new MenuState()));
                    } else {
                        FlxG.switchState(new TextState("You made it in " + timer.toString() + " minutes.\nAnd you only fell " + fell + " times! You kept it cool!", new MenuState()));
                    }
                } else{
                    if(fell > 10){
                        FlxG.switchState(new TextState("Booty call success! You made it in " + timer.toString() + " minutes.\nBut, you fell " + fell + " times, so you're kinda beat up... but that's... sorta sexy???", new MenuState()));
                    } else {
                        FlxG.switchState(new TextState("Booty call success! You made it in " + timer.toString() + " minutes.\nAnd you only fell " + fell + " times! You kept it cool!", new MenuState()));
                    }
                }
            }

        }

        public function onRoad(tile:uint,obj:Player):void{
            obj.onRoad = true;
        }

        public function offRoading(tile:uint,obj:Player):void{
            obj.onRoad = false;
            fell++;
        }

        public function displacement(_object1:FlxSprite, _object2:FlxSprite):Number{
            var dx:Number = Math.abs(_object1.x - _object2.x);
            var dy:Number = Math.abs(_object1.y - _object2.y);
            return Math.sqrt(dx*dx + dy*dy);
        }
    }
}
