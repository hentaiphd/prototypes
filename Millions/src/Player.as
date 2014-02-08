package{
    import org.flixel.*;

    public class Player extends FlxSprite{
        [Embed(source = '../assets/girl_sprite.png')] public static var sprite:Class;

        public var runSpeed:Number = .05;
        public var offRoad_runSpeed:Number = .03;
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
            if(this.velocity.x > 0){
                this.velocity.x -= .01;
            } else if(this.velocity.x < 0){
                this.velocity.x += .01;
            }

            if(this.velocity.y > 0){
                this.velocity.y -= .01;
            } else if(this.velocity.y < 0){
                this.velocity.y += .01;
            }

            if(this.acceleration.x > 0){
                this.acceleration.x -= .005;
            } else if(this.acceleration.x < 0){
                this.acceleration.x += .005;
            }

            if(this.acceleration.y > 0){
                this.acceleration.y -= .005;
            } else if(this.acceleration.y < 0){
                this.acceleration.y += .005;
            }

            this.velocity.x += this.acceleration.x;
            this.velocity.y += this.acceleration.y;
            //pos.x += velo.x;
            //pos.y += velo.y;
            this.x += velocity.x;
            this.y += velocity.y;

            if(Math.abs(this.velocity.x) >= maxSpeed){
                this.velocity.x = (this.velocity.x/Math.abs(this.velocity.x))*maxSpeed;
            }
            if(Math.abs(this.velocity.y) >= maxSpeed){
                this.velocity.y = (this.velocity.y/Math.abs(this.velocity.y))*maxSpeed;
            }

            //this.x = pos.x;
            //this.y = pos.y;

            if(FlxG.keys.LEFT) {
                this.acceleration.x = runSpeed*-1;
                this.scale.x = _scaleFlipX;
                this.scale.y = _scaleFlipY;
                play("run");
            } else if(FlxG.keys.RIGHT){
                this.acceleration.x = runSpeed;
                this.scale.x = -_scaleFlipX;
                this.scale.y = _scaleFlipY;
                play("run");
            } else if(FlxG.keys.UP){
                this.acceleration.y = runSpeed*-1;
                play("runBack");
            } else if(FlxG.keys.DOWN){
                this.acceleration.y = runSpeed;
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
            if(this.velocity.x > 0){
                this.velocity.x -= .008;
            } else if(this.velocity.x < 0){
                this.velocity.x += .008;
            }

            if(this.velocity.y > 0){
                this.velocity.y -= .008;
            } else if(this.velocity.y < 0){
                this.velocity.y += .008;
            }

            if(this.acceleration.x > 0){
                this.acceleration.x -= .005;
            } else if(this.acceleration.x < 0){
                this.acceleration.x += .005;
            }

            if(this.acceleration.y > 0){
                this.acceleration.y -= .005;
            } else if(this.acceleration.y < 0){
                this.acceleration.y += .005;
            }

            this.velocity.x += this.acceleration.x;
            this.velocity.y += this.acceleration.y;
            this.x += velocity.x;
            this.y += velocity.y;

            if(Math.abs(this.velocity.x) >= offRoad_maxSpeed){
                this.velocity.x = (this.velocity.x/Math.abs(this.velocity.x))*offRoad_maxSpeed;
            }
            if(Math.abs(this.velocity.y) >= offRoad_maxSpeed){
                this.velocity.y = (this.velocity.y/Math.abs(this.velocity.y))*offRoad_maxSpeed;
            }

            if(FlxG.keys.LEFT) {
                this.acceleration.x = offRoad_runSpeed*-1;
                this.scale.x = _scaleFlipX;
                this.scale.y = _scaleFlipY;
                play("run");
            } else if(FlxG.keys.RIGHT){
                this.acceleration.x = offRoad_runSpeed;
                this.scale.x = -_scaleFlipX;
                this.scale.y = _scaleFlipY;
                play("run");
            } else if(FlxG.keys.UP){
                this.acceleration.y = offRoad_runSpeed*-1;
                play("runBack");
            } else if(FlxG.keys.DOWN){
                this.acceleration.y = offRoad_runSpeed;
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

