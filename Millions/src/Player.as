package{
    import org.flixel.*;

    public class Player extends FlxSprite{
        [Embed(source = '../assets/girl_sprite.png')] public static var sprite:Class;

        public var runSpeed:Number = 1;
        public var offRoad_runSpeed:Number = .05;
        public var _scale:FlxPoint = new FlxPoint(1,1);
        public var _scaleFlipX:Number = 1;
        public var _scaleFlipY:Number = 1;
        public var pos:FlxPoint;
        public var accelerate:FlxPoint;
        public var velo:FlxPoint;
        public var maxSpeed:Number = 1;
        public var offRoad_maxSpeed:Number = .05;
        public var onRoad:Boolean = true;

        public function Player(x:Number, y:Number):void{
            super(x,y);

            pos = new FlxPoint(this.x,this.y);
            accelerate = new FlxPoint(0,0);
            velo = new FlxPoint(0,0);

            loadGraphic(sprite, true, true, 15, 28, true);
            width = 8;
            height = 8;
            offset.y = 21;

            addAnimation("run", [1,2], 14, true);
            addAnimation("standing", [0]);
            addAnimation("runBack", [4,5], 14, true);
            addAnimation("standingBack", [3]);

            this.scale = _scale;
        }


        override public function update():void{
            super.update();

            if(onRoad){
                onRoadMovement();
            } else if(!onRoad){
                offRoadMovement();
            }
        }

        public function onRoadMovement():void{
            if(velo.x > 0){
                velo.x -= .01;
            } else if(velo.x < 0){
                velo.x += .01;
            }

            if(velo.y > 0){
                velo.y -= .01;
            } else if(velo.y < 0){
                velo.y += .01;
            }

            if(accelerate.x > 0){
                accelerate.x -= .005;
            } else if(accelerate.x < 0){
                accelerate.x += .005;
            }

            if(accelerate.y > 0){
                accelerate.y -= .005;
            } else if(accelerate.y < 0){
                accelerate.y += .005;
            }

            velo.x += accelerate.x;
            velo.y += accelerate.y;
            pos.x += velo.x;
            pos.y += velo.y;

            if(Math.abs(velo.x) >= maxSpeed){
                velo.x = (velo.x/Math.abs(velo.x))*maxSpeed;
            }
            if(Math.abs(velo.y) >= maxSpeed){
                velo.y = (velo.y/Math.abs(velo.y))*maxSpeed;
            }

            this.x = pos.x;
            this.y = pos.y;

            if(FlxG.keys.LEFT) {
                accelerate.x = runSpeed*-1;
                this.scale.x = _scaleFlipX;
                this.scale.y = _scaleFlipY;
                play("run");
            } else if(FlxG.keys.RIGHT){
                accelerate.x = runSpeed;
                this.scale.x = -_scaleFlipX;
                this.scale.y = _scaleFlipY;
                play("run");
            } else if(FlxG.keys.UP){
                accelerate.y = runSpeed*-1;
                play("runBack");
            } else if(FlxG.keys.DOWN){
                accelerate.y = runSpeed;
                play("run");
            } else if(FlxG.keys.justPressed("UP")){
                play("standingBack");
            } else if (FlxG.keys.justPressed("DOWN")){
                play("standing");
            } else {
                play("standing");
            }
        }

        public function offRoadMovement():void{
            if(velo.x > 0){
                velo.x -= .05;
            } else if(velo.x < 0){
                velo.x += .05;
            }

            if(velo.y > 0){
                velo.y -= .05;
            } else if(velo.y < 0){
                velo.y += .05;
            }

            if(accelerate.x > 0){
                accelerate.x -= .005;
            } else if(accelerate.x < 0){
                accelerate.x += .005;
            }

            if(accelerate.y > 0){
                accelerate.y -= .005;
            } else if(accelerate.y < 0){
                accelerate.y += .005;
            }

            velo.x += accelerate.x;
            velo.y += accelerate.y;
            pos.x += velo.x;
            pos.y += velo.y;

            if(Math.abs(velo.x) >= maxSpeed){
                velo.x = (velo.x/Math.abs(velo.x))*offRoad_maxSpeed;
            }
            if(Math.abs(velo.y) >= maxSpeed){
                velo.y = (velo.y/Math.abs(velo.y))*offRoad_maxSpeed;
            }

            this.x = pos.x;
            this.y = pos.y;

            if(FlxG.keys.LEFT) {
                accelerate.x = offRoad_runSpeed*-1;
                this.scale.x = _scaleFlipX;
                this.scale.y = _scaleFlipY;
                play("run");
            } else if(FlxG.keys.RIGHT){
                accelerate.x = offRoad_runSpeed;
                this.scale.x = -_scaleFlipX;
                this.scale.y = _scaleFlipY;
                play("run");
            } else if(FlxG.keys.UP){
                accelerate.y = offRoad_runSpeed*-1;
                play("runBack");
            } else if(FlxG.keys.DOWN){
                accelerate.y = offRoad_runSpeed;
                play("run");
            } else if(FlxG.keys.justPressed("UP")){
                play("standingBack");
            } else if (FlxG.keys.justPressed("DOWN")){
                play("standing");
            } else {
                play("standing");
            }
        }
    }
}

