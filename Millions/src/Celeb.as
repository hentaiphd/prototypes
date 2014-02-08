package{
    import org.flixel.*;

    public class Celeb extends FlxSprite{
        [Embed(source = '../assets/mom_sprite.png')] public static var sprite:Class;
        private var xAnchor:int;
        private var yAnchor:int;
        private var textLock:Boolean = false;
        private var _curTarget:FlxPoint;
        private var _level:FlxTilemap;
        private var _lastFoundTime:Number = 0;
        private var _runSpeed:Number;
        private var originPoint:FlxPoint;

        public var _hasHitTarget:Boolean;
        public var _shouldFindNewTarget:Boolean;
        public var _distracted:Boolean;
        public var _distractedTime:Number;
        public var _reply:FlxText;

        public var _timer:Number;

        public static var maxSpeed:Number = 80;
        public static var minSpeed:Number = 70;

        public var _scale:FlxPoint = new FlxPoint(1,1);
        public var _scaleFlipX:Number = 1;
        public var _scaleFlipY:Number = 1;

        public var _patrolPoints:Array;
        public var patrolPointCounter:Number = 0;;

        public var lastFramVel:FlxPoint = new FlxPoint();

        public var pos:FlxPoint;
        public var chatting:Boolean = false;
        public var words:FlxText;
        public var chat_flag:Boolean = false;

        public var celeb_name:String;
        public var relationship_counter:Number = 0;
        //add a personality type so that the player can end up choosing the names
        //of celeb and also specify how they want their personality to be
        //types: shy, paranoid, hyper, diva

        public function Celeb(x:Number, y:Number, _level:FlxTilemap, n:String):void{
            super(x,y);

            celeb_name = n;

            this._level = _level;
            this._runSpeed = Math.random() * (maxSpeed-minSpeed) + minSpeed;
            this.originPoint = new FlxPoint(x, y);
            this._patrolPoints = new Array();

            loadGraphic(sprite, true, true, 15, 33, true);
            width = 1;
            height = 1;
            offset.y = 16;

            _shouldFindNewTarget = true;

            addAnimation("run", [1,2], 7, true);
            addAnimation("standing", [0]);
            addAnimation("runBack", [4,5], 7, true);
            addAnimation("standingBack", [3]);

            pos = new FlxPoint(this.x,this.y);

            words = new FlxText(this.x,this.y,100,"chatttttt");
        }

        override public function update():void{
            super.update();

            pos.x = this.x;
            pos.y = this.y;

            if(velocity.x > 0){
                //right
                play("run");
                this.scale.x = -_scaleFlipX;
                this.scale.y = _scaleFlipY;
            } else if(velocity.x < 0){
                //left
                play("run");
                this.scale.x = _scaleFlipX;
                this.scale.y = _scaleFlipY;
            } else if(velocity.y > 0){
                //down
                play("run");
            } else if(velocity.y < 0){
                //up
                play("runBack");
            } else if(velocity.x == 0){
                if(velocity.y == 0){
                    if(lastFramVel.y > 0){
                        play("standing");
                    } else {
                        play("standingBack");
                    }
                }
            }

            _timer += FlxG.elapsed;

            if(!_curTarget || this.isInRange(this._curTarget)){
                stopFollowing();
                _shouldFindNewTarget = true;
            }

            if(_shouldFindNewTarget){
                setTarget(getNextPatrolPoint(), -50);
            }

            lastFramVel = new FlxPoint(velocity.x, velocity.y);

            if(chatting){
                if(!chat_flag){
                    FlxG.state.add(words);
                    chat_flag = true;
                }
                words.x = this.x;
                words.y = this.y;
            }
        }

        public function checkDist(sprite:FlxPoint):Boolean{
            var speak:Boolean;
            var dist:Number = FlxU.getDistance(this.pos, sprite);
            speak = dist < 20;
            return speak;
        }

        public function chat():void{
            words.text = "chattttt";
            chatting = true;
        }

        public function chatFlagsOff():void{
            chatting = false;
            chat_flag = false;
            words.text = "";
        }

        public function getNextPatrolPoint():FlxPoint{
            return new FlxPoint(Math.random()*50*8, Math.random()*50*8);
        }

        public function searchFor(_object:Player, _time:Number):void{
            var found:Boolean = _level.ray(new FlxPoint(x, y),
                                           new FlxPoint(_object.x, _object.y));
            if(found){
                _lastFoundTime = _timer;
            }
            var maxDisp:Number = 100;

            if(_object.snackGrabbed != null){
                if(((_timer - _lastFoundTime < .5) ||
                 found && displacement(_object) < maxDisp)){
                    if(_object){
                        _distracted = false;
                        _shouldFindNewTarget = false;
                        setTarget(new FlxPoint(_object.x, _object.y), 10);
                    }
                }
            }
        }

        public function displacement(_object:FlxSprite):Number{
            var dx:Number = Math.abs(_object.x - this.x);
            var dy:Number = Math.abs(_object.y - this.y);
            return Math.sqrt(dx*dx + dy*dy);
        }

        public function isInRange(_point:FlxPoint):Boolean{
            if(Math.abs(_point.x - this.x) < 20 &&
               Math.abs(_point.y - this.y) < 20){
                return true;
            }
            return false;
        }

        public function stopFollowing():void{
            this.stopFollowingPath(true);
            this.velocity.x = this.velocity.y = 0;
            this._curTarget = null;
            this._distracted = false;
        }

        public function setTarget(_point:FlxPoint, speedup:Number = 0):void{
            this._curTarget = _point;

            var path:FlxPath = this._level.findPath(
                new FlxPoint(x + width/2, y + height/2), _point);
            if(path){
                _shouldFindNewTarget = false;
                this.followPath(path, _runSpeed+speedup);
            }
        }

        public function moveToPoint(_point:FlxPoint, _level:FlxTilemap):void{
            var path:FlxPath = _level.findPath(new FlxPoint(x + width/2, y + height/2), _point);
            this.followPath(path);
        }
    }
}
