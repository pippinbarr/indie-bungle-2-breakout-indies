package org.flixel
{
   import flash.display.Graphics;
   
   public class FlxObject extends FlxBasic
   {
      
      public static const LEFT:uint = 1;
      
      public static const RIGHT:uint = 16;
      
      public static const UP:uint = 256;
      
      public static const DOWN:uint = 4096;
      
      public static const NONE:uint = 0;
      
      public static const CEILING:uint = 256;
      
      public static const FLOOR:uint = 4096;
      
      public static const WALL:uint = 17;
      
      public static const ANY:uint = 4369;
      
      public static const OVERLAP_BIAS:Number = 4;
      
      public static const PATH_FORWARD:uint = 0;
      
      public static const PATH_BACKWARD:uint = 1;
      
      public static const PATH_LOOP_FORWARD:uint = 16;
      
      public static const PATH_LOOP_BACKWARD:uint = 256;
      
      public static const PATH_YOYO:uint = 4096;
      
      public static const PATH_HORIZONTAL_ONLY:uint = 65536;
      
      public static const PATH_VERTICAL_ONLY:uint = 1048576;
      
      protected static const _pZero:org.flixel.FlxPoint = new org.flixel.FlxPoint();
       
      public var x:Number;
      
      public var y:Number;
      
      public var width:Number;
      
      public var height:Number;
      
      public var immovable:Boolean;
      
      public var velocity:org.flixel.FlxPoint;
      
      public var mass:Number;
      
      public var elasticity:Number;
      
      public var acceleration:org.flixel.FlxPoint;
      
      public var drag:org.flixel.FlxPoint;
      
      public var maxVelocity:org.flixel.FlxPoint;
      
      public var angle:Number;
      
      public var angularVelocity:Number;
      
      public var angularAcceleration:Number;
      
      public var angularDrag:Number;
      
      public var maxAngular:Number;
      
      public var scrollFactor:org.flixel.FlxPoint;
      
      protected var _flicker:Boolean;
      
      protected var _flickerTimer:Number;
      
      public var health:Number;
      
      protected var _point:org.flixel.FlxPoint;
      
      protected var _rect:org.flixel.FlxRect;
      
      public var moves:Boolean;
      
      public var touching:uint;
      
      public var wasTouching:uint;
      
      public var allowCollisions:uint;
      
      public var last:org.flixel.FlxPoint;
      
      public var path:org.flixel.FlxPath;
      
      public var pathSpeed:Number;
      
      public var pathAngle:Number;
      
      protected var _pathNodeIndex:int;
      
      protected var _pathMode:uint;
      
      protected var _pathInc:int;
      
      protected var _pathRotate:Boolean;
      
      public function FlxObject(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0)
      {
         super();
         x = param1;
         y = param2;
         last = new org.flixel.FlxPoint(x,y);
         width = param3;
         height = param4;
         mass = 1;
         elasticity = 0;
         immovable = false;
         moves = true;
         touching = 0;
         wasTouching = 0;
         allowCollisions = 4369;
         velocity = new org.flixel.FlxPoint();
         acceleration = new org.flixel.FlxPoint();
         drag = new org.flixel.FlxPoint();
         maxVelocity = new org.flixel.FlxPoint(10000,10000);
         angle = 0;
         angularVelocity = 0;
         angularAcceleration = 0;
         angularDrag = 0;
         maxAngular = 10000;
         scrollFactor = new org.flixel.FlxPoint(1,1);
         _flicker = false;
         _flickerTimer = 0;
         _point = new org.flixel.FlxPoint();
         _rect = new org.flixel.FlxRect();
         path = null;
         pathSpeed = 0;
         pathAngle = 0;
      }
      
      public static function separate(param1:FlxObject, param2:FlxObject) : Boolean
      {
         var _loc3_:Boolean = separateX(param1,param2);
         var _loc4_:Boolean = separateY(param1,param2);
         return _loc3_ || _loc4_;
      }
      
      public static function separateX(param1:FlxObject, param2:FlxObject) : Boolean
      {
         var _loc9_:* = NaN;
         var _loc6_:* = NaN;
         var _loc11_:* = null;
         var _loc4_:* = null;
         var _loc8_:* = NaN;
         var _loc14_:* = NaN;
         var _loc12_:* = NaN;
         var _loc17_:* = NaN;
         var _loc15_:* = NaN;
         var _loc3_:* = NaN;
         var _loc10_:Boolean = param1.immovable;
         var _loc5_:Boolean = param2.immovable;
         if(_loc10_ && _loc5_)
         {
            return false;
         }
         if(param1 is FlxTilemap)
         {
            return (param1 as FlxTilemap).overlapsWithCallback(param2,separateX);
         }
         if(param2 is FlxTilemap)
         {
            return (param2 as FlxTilemap).overlapsWithCallback(param1,separateX,true);
         }
         var _loc13_:* = 0.0;
         var _loc16_:Number = param1.x - param1.last.x;
         var _loc7_:Number = param2.x - param2.last.x;
         if(_loc16_ != _loc7_)
         {
            _loc9_ = _loc16_ > 0?_loc16_:-_loc16_;
            _loc6_ = _loc7_ > 0?_loc7_:-_loc7_;
            _loc11_ = new org.flixel.FlxRect(param1.x - (_loc16_ > 0?_loc16_:0.0),param1.last.y,param1.width + (_loc16_ > 0?_loc16_:-_loc16_),param1.height);
            _loc4_ = new org.flixel.FlxRect(param2.x - (_loc7_ > 0?_loc7_:0.0),param2.last.y,param2.width + (_loc7_ > 0?_loc7_:-_loc7_),param2.height);
            if(_loc11_.x + _loc11_.width > _loc4_.x && _loc11_.x < _loc4_.x + _loc4_.width && _loc11_.y + _loc11_.height > _loc4_.y && _loc11_.y < _loc4_.y + _loc4_.height)
            {
               _loc8_ = _loc9_ + _loc6_ + 4;
               if(_loc16_ > _loc7_)
               {
                  _loc13_ = param1.x + param1.width - param2.x;
                  if(_loc13_ > _loc8_ || !(param1.allowCollisions & 16) || !(param2.allowCollisions & 1))
                  {
                     _loc13_ = 0.0;
                  }
                  else
                  {
                     param1.touching = param1.touching | 16;
                     param2.touching = param2.touching | 1;
                  }
               }
               else if(_loc16_ < _loc7_)
               {
                  _loc13_ = param1.x - param2.width - param2.x;
                  if(-_loc13_ > _loc8_ || !(param1.allowCollisions & 1) || !(param2.allowCollisions & 16))
                  {
                     _loc13_ = 0.0;
                  }
                  else
                  {
                     param1.touching = param1.touching | 1;
                     param2.touching = param2.touching | 16;
                  }
               }
            }
         }
         if(_loc13_ != 0)
         {
            _loc14_ = param1.velocity.x;
            _loc12_ = param2.velocity.x;
            if(!_loc10_ && !_loc5_)
            {
               _loc13_ = _loc13_ * 0.5;
               param1.x = param1.x - _loc13_;
               param2.x = param2.x + _loc13_;
               _loc17_ = Math.sqrt(_loc12_ * _loc12_ * param2.mass / param1.mass) * (_loc12_ > 0?1:-1.0);
               _loc15_ = Math.sqrt(_loc14_ * _loc14_ * param1.mass / param2.mass) * (_loc14_ > 0?1:-1.0);
               _loc3_ = (_loc17_ + _loc15_) * 0.5;
               _loc17_ = _loc17_ - _loc3_;
               _loc15_ = _loc15_ - _loc3_;
               param1.velocity.x = _loc3_ + _loc17_ * param1.elasticity;
               param2.velocity.x = _loc3_ + _loc15_ * param2.elasticity;
            }
            else if(!_loc10_)
            {
               param1.x = param1.x - _loc13_;
               param1.velocity.x = _loc12_ - _loc14_ * param1.elasticity;
            }
            else if(!_loc5_)
            {
               param2.x = param2.x + _loc13_;
               param2.velocity.x = _loc14_ - _loc12_ * param2.elasticity;
            }
            return true;
         }
         return false;
      }
      
      public static function separateY(param1:FlxObject, param2:FlxObject) : Boolean
      {
         var _loc9_:* = NaN;
         var _loc6_:* = NaN;
         var _loc11_:* = null;
         var _loc4_:* = null;
         var _loc8_:* = NaN;
         var _loc14_:* = NaN;
         var _loc12_:* = NaN;
         var _loc17_:* = NaN;
         var _loc15_:* = NaN;
         var _loc3_:* = NaN;
         var _loc10_:Boolean = param1.immovable;
         var _loc5_:Boolean = param2.immovable;
         if(_loc10_ && _loc5_)
         {
            return false;
         }
         if(param1 is FlxTilemap)
         {
            return (param1 as FlxTilemap).overlapsWithCallback(param2,separateY);
         }
         if(param2 is FlxTilemap)
         {
            return (param2 as FlxTilemap).overlapsWithCallback(param1,separateY,true);
         }
         var _loc13_:* = 0.0;
         var _loc16_:Number = param1.y - param1.last.y;
         var _loc7_:Number = param2.y - param2.last.y;
         if(_loc16_ != _loc7_)
         {
            _loc9_ = _loc16_ > 0?_loc16_:-_loc16_;
            _loc6_ = _loc7_ > 0?_loc7_:-_loc7_;
            _loc11_ = new org.flixel.FlxRect(param1.x,param1.y - (_loc16_ > 0?_loc16_:0.0),param1.width,param1.height + _loc9_);
            _loc4_ = new org.flixel.FlxRect(param2.x,param2.y - (_loc7_ > 0?_loc7_:0.0),param2.width,param2.height + _loc6_);
            if(_loc11_.x + _loc11_.width > _loc4_.x && _loc11_.x < _loc4_.x + _loc4_.width && _loc11_.y + _loc11_.height > _loc4_.y && _loc11_.y < _loc4_.y + _loc4_.height)
            {
               _loc8_ = _loc9_ + _loc6_ + 4;
               if(_loc16_ > _loc7_)
               {
                  _loc13_ = param1.y + param1.height - param2.y;
                  if(_loc13_ > _loc8_ || !(param1.allowCollisions & 4096) || !(param2.allowCollisions & 256))
                  {
                     _loc13_ = 0.0;
                  }
                  else
                  {
                     param1.touching = param1.touching | 4096;
                     param2.touching = param2.touching | 256;
                  }
               }
               else if(_loc16_ < _loc7_)
               {
                  _loc13_ = param1.y - param2.height - param2.y;
                  if(-_loc13_ > _loc8_ || !(param1.allowCollisions & 256) || !(param2.allowCollisions & 4096))
                  {
                     _loc13_ = 0.0;
                  }
                  else
                  {
                     param1.touching = param1.touching | 256;
                     param2.touching = param2.touching | 4096;
                  }
               }
            }
         }
         if(_loc13_ != 0)
         {
            _loc14_ = param1.velocity.y;
            _loc12_ = param2.velocity.y;
            if(!_loc10_ && !_loc5_)
            {
               _loc13_ = _loc13_ * 0.5;
               param1.y = param1.y - _loc13_;
               param2.y = param2.y + _loc13_;
               _loc17_ = Math.sqrt(_loc12_ * _loc12_ * param2.mass / param1.mass) * (_loc12_ > 0?1:-1.0);
               _loc15_ = Math.sqrt(_loc14_ * _loc14_ * param1.mass / param2.mass) * (_loc14_ > 0?1:-1.0);
               _loc3_ = (_loc17_ + _loc15_) * 0.5;
               _loc17_ = _loc17_ - _loc3_;
               _loc15_ = _loc15_ - _loc3_;
               param1.velocity.y = _loc3_ + _loc17_ * param1.elasticity;
               param2.velocity.y = _loc3_ + _loc15_ * param2.elasticity;
            }
            else if(!_loc10_)
            {
               param1.y = param1.y - _loc13_;
               param1.velocity.y = _loc12_ - _loc14_ * param1.elasticity;
               if(param2.active && param2.moves && _loc16_ > _loc7_)
               {
                  param1.x = param1.x + (param2.x - param2.last.x);
               }
            }
            else if(!_loc5_)
            {
               param2.y = param2.y + _loc13_;
               param2.velocity.y = _loc14_ - _loc12_ * param2.elasticity;
               if(param1.active && param1.moves && _loc16_ < _loc7_)
               {
                  param2.x = param2.x + (param1.x - param1.last.x);
               }
            }
            return true;
         }
         return false;
      }
      
      override public function destroy() : void
      {
         velocity = null;
         acceleration = null;
         drag = null;
         maxVelocity = null;
         scrollFactor = null;
         _point = null;
         _rect = null;
         last = null;
         cameras = null;
         if(path != null)
         {
            path.destroy();
         }
         path = null;
      }
      
      override public function preUpdate() : void
      {
         _ACTIVECOUNT = _ACTIVECOUNT + 1;
         if(_flickerTimer != 0)
         {
            if(_flickerTimer > 0)
            {
               _flickerTimer = _flickerTimer - FlxG.elapsed;
               if(_flickerTimer <= 0)
               {
                  _flickerTimer = 0;
                  _flicker = false;
               }
            }
         }
         last.x = x;
         last.y = y;
         if(path != null && pathSpeed != 0 && path.nodes[_pathNodeIndex] != null)
         {
            updatePathMotion();
         }
      }
      
      override public function postUpdate() : void
      {
         if(moves)
         {
            updateMotion();
         }
         wasTouching = touching;
         touching = 0;
      }
      
      protected function updateMotion() : void
      {
         var _loc2_:* = NaN;
         var _loc1_:* = NaN;
         _loc1_ = (FlxU.computeVelocity(angularVelocity,angularAcceleration,angularDrag,maxAngular) - angularVelocity) / 2;
         angularVelocity = §§dup().angularVelocity + _loc1_;
         angle = §§dup().angle + angularVelocity * FlxG.elapsed;
         angularVelocity = §§dup().angularVelocity + _loc1_;
         _loc1_ = (FlxU.computeVelocity(velocity.x,acceleration.x,drag.x,maxVelocity.x) - velocity.x) / 2;
         velocity.x = velocity.x + _loc1_;
         _loc2_ = velocity.x * FlxG.elapsed;
         velocity.x = velocity.x + _loc1_;
         x = §§dup().x + _loc2_;
         _loc1_ = (FlxU.computeVelocity(velocity.y,acceleration.y,drag.y,maxVelocity.y) - velocity.y) / 2;
         velocity.y = velocity.y + _loc1_;
         _loc2_ = velocity.y * FlxG.elapsed;
         velocity.y = velocity.y + _loc1_;
         y = §§dup().y + _loc2_;
      }
      
      override public function draw() : void
      {
         var _loc2_:* = null;
         if(cameras == null)
         {
            cameras = FlxG.cameras;
         }
         var _loc1_:uint = 0;
         var _loc3_:uint = cameras.length;
         while(_loc1_ < _loc3_)
         {
            _loc2_ = cameras[_loc1_++];
            if(onScreen(_loc2_))
            {
               _VISIBLECOUNT = _VISIBLECOUNT + 1;
               if(FlxG.visualDebug && !ignoreDrawDebug)
               {
                  drawDebug(_loc2_);
               }
            }
         }
      }
      
      override public function drawDebug(param1:FlxCamera = null) : void
      {
         var _loc3_:* = 0;
         if(param1 == null)
         {
            var param1:FlxCamera = FlxG.camera;
         }
         var _loc5_:Number = x - param1.scroll.x * scrollFactor.x;
         var _loc4_:Number = y - param1.scroll.y * scrollFactor.y;
         _loc5_ = _loc5_ + (_loc5_ > 0?1.0E-7:-1.0E-7);
         _loc4_ = _loc4_ + (_loc4_ > 0?1.0E-7:-1.0E-7);
         var _loc2_:int = width != width?width:width - 1;
         var _loc7_:int = height != height?height:height - 1;
         var _loc6_:Graphics = FlxG.flashGfx;
         _loc6_.clear();
         _loc6_.moveTo(_loc5_,_loc4_);
         if(allowCollisions)
         {
            if(allowCollisions != 4369)
            {
               _loc3_ = 4293926655;
            }
            if(immovable)
            {
               _loc3_ = 4278252069;
            }
            else
            {
               _loc3_ = 4294901778;
            }
         }
         else
         {
            _loc3_ = 4278227177;
         }
         _loc6_.lineStyle(1,_loc3_,0.5);
         _loc6_.lineTo(_loc5_ + _loc2_,_loc4_);
         _loc6_.lineTo(_loc5_ + _loc2_,_loc4_ + _loc7_);
         _loc6_.lineTo(_loc5_,_loc4_ + _loc7_);
         _loc6_.lineTo(_loc5_,_loc4_);
         param1.buffer.draw(FlxG.flashGfxSprite);
      }
      
      public function followPath(param1:org.flixel.FlxPath, param2:Number = 100, param3:uint = 0, param4:Boolean = false) : void
      {
         if(param1.nodes.length <= 0)
         {
            FlxG.log("WARNING: Paths need at least one node in them to be followed.");
            return;
         }
         path = param1;
         pathSpeed = FlxU.abs(param2);
         _pathMode = param3;
         _pathRotate = param4;
         if(_pathMode == 1 || _pathMode == 256)
         {
            _pathNodeIndex = path.nodes.length - 1;
            _pathInc = -1;
         }
         else
         {
            _pathNodeIndex = 0;
            _pathInc = 1;
         }
      }
      
      public function stopFollowingPath(param1:Boolean = false) : void
      {
         pathSpeed = 0;
         if(param1 && path != null)
         {
            path.destroy();
            path = null;
         }
      }
      
      protected function advancePath(param1:Boolean = true) : org.flixel.FlxPoint
      {
         var _loc2_:* = null;
         if(param1)
         {
            _loc2_ = path.nodes[_pathNodeIndex];
            if(_loc2_ != null)
            {
               if((_pathMode & 1048576) == 0)
               {
                  x = _loc2_.x - width * 0.5;
               }
               if((_pathMode & 65536) == 0)
               {
                  y = _loc2_.y - height * 0.5;
               }
            }
         }
         _pathNodeIndex = §§dup()._pathNodeIndex + _pathInc;
         if((_pathMode & 1) > 0)
         {
            if(_pathNodeIndex < 0)
            {
               _pathNodeIndex = 0;
               pathSpeed = 0;
            }
         }
         else if((_pathMode & 16) > 0)
         {
            if(_pathNodeIndex >= path.nodes.length)
            {
               _pathNodeIndex = 0;
            }
         }
         else if((_pathMode & 256) > 0)
         {
            if(_pathNodeIndex < 0)
            {
               _pathNodeIndex = path.nodes.length - 1;
               if(_pathNodeIndex < 0)
               {
                  _pathNodeIndex = 0;
               }
            }
         }
         else if((_pathMode & 4096) > 0)
         {
            if(_pathInc > 0)
            {
               if(_pathNodeIndex >= path.nodes.length)
               {
                  _pathNodeIndex = path.nodes.length - 2;
                  if(_pathNodeIndex < 0)
                  {
                     _pathNodeIndex = 0;
                  }
                  _pathInc = -_pathInc;
               }
            }
            else if(_pathNodeIndex < 0)
            {
               _pathNodeIndex = 1;
               if(_pathNodeIndex >= path.nodes.length)
               {
                  _pathNodeIndex = path.nodes.length - 1;
               }
               if(_pathNodeIndex < 0)
               {
                  _pathNodeIndex = 0;
               }
               _pathInc = -_pathInc;
            }
         }
         else if(_pathNodeIndex >= path.nodes.length)
         {
            _pathNodeIndex = path.nodes.length - 1;
            pathSpeed = 0;
         }
         return path.nodes[_pathNodeIndex];
      }
      
      protected function updatePathMotion() : void
      {
         _point.x = x + width * 0.5;
         _point.y = y + height * 0.5;
         var _loc2_:org.flixel.FlxPoint = path.nodes[_pathNodeIndex];
         var _loc3_:Number = _loc2_.x - _point.x;
         var _loc4_:Number = _loc2_.y - _point.y;
         var _loc1_:* = (_pathMode & 65536) > 0;
         var _loc5_:* = (_pathMode & 1048576) > 0;
         if(_loc1_)
         {
            if((_loc3_ > 0?_loc3_:-_loc3_) < pathSpeed * FlxG.elapsed)
            {
               _loc2_ = advancePath();
            }
         }
         else if(_loc5_)
         {
            if((_loc4_ > 0?_loc4_:-_loc4_) < pathSpeed * FlxG.elapsed)
            {
               _loc2_ = advancePath();
            }
         }
         else if(Math.sqrt(_loc3_ * _loc3_ + _loc4_ * _loc4_) < pathSpeed * FlxG.elapsed)
         {
            _loc2_ = advancePath();
         }
         if(pathSpeed != 0)
         {
            _point.x = x + width * 0.5;
            _point.y = y + height * 0.5;
            if(_loc1_ || _point.y == _loc2_.y)
            {
               velocity.x = _point.x < _loc2_.x?pathSpeed:-pathSpeed;
               if(velocity.x < 0)
               {
                  pathAngle = -90;
               }
               else
               {
                  pathAngle = 90;
               }
               if(!_loc1_)
               {
                  velocity.y = 0;
               }
            }
            else if(_loc5_ || _point.x == _loc2_.x)
            {
               velocity.y = _point.y < _loc2_.y?pathSpeed:-pathSpeed;
               if(velocity.y < 0)
               {
                  pathAngle = 0;
               }
               else
               {
                  pathAngle = 180;
               }
               if(!_loc5_)
               {
                  velocity.x = 0;
               }
            }
            else
            {
               pathAngle = FlxU.getAngle(_point,_loc2_);
               FlxU.rotatePoint(0,pathSpeed,0,0,pathAngle,velocity);
            }
            if(_pathRotate)
            {
               angularVelocity = 0;
               angularAcceleration = 0;
               angle = pathAngle;
            }
         }
      }
      
      public function overlaps(param1:FlxBasic, param2:Boolean = false, param3:FlxCamera = null) : Boolean
      {
         var _loc7_:* = false;
         var _loc5_:* = 0;
         var _loc4_:* = null;
         if(param1 is FlxGroup)
         {
            _loc7_ = false;
            _loc5_ = 0;
            _loc4_ = (param1 as FlxGroup).members;
            while(_loc5_ < 1)
            {
               if(overlaps(_loc4_[_loc5_++],param2,param3))
               {
                  _loc7_ = true;
               }
            }
            return _loc7_;
         }
         if(param1 is FlxTilemap)
         {
            return (param1 as FlxTilemap).overlaps(this,param2,param3);
         }
         var _loc8_:FlxObject = param1 as FlxObject;
         if(!param2)
         {
            return _loc8_.x + _loc8_.width > x && _loc8_.x < x + width && _loc8_.y + _loc8_.height > y && _loc8_.y < y + height;
         }
         if(param3 == null)
         {
            var param3:FlxCamera = FlxG.camera;
         }
         var _loc6_:org.flixel.FlxPoint = _loc8_.getScreenXY(null,param3);
         getScreenXY(_point,param3);
         return _loc6_.x + _loc8_.width > _point.x && _loc6_.x < _point.x + width && _loc6_.y + _loc8_.height > _point.y && _loc6_.y < _point.y + height;
      }
      
      public function overlapsAt(param1:Number, param2:Number, param3:FlxBasic, param4:Boolean = false, param5:FlxCamera = null) : Boolean
      {
         var _loc10_:* = false;
         var _loc9_:* = null;
         var _loc7_:* = 0;
         var _loc6_:* = null;
         var _loc11_:* = null;
         if(param3 is FlxGroup)
         {
            _loc10_ = false;
            _loc7_ = 0;
            _loc6_ = (param3 as FlxGroup).members;
            while(_loc7_ < 1)
            {
               if(overlapsAt(param1,param2,_loc6_[_loc7_++],param4,param5))
               {
                  _loc10_ = true;
               }
            }
            return _loc10_;
         }
         if(param3 is FlxTilemap)
         {
            _loc11_ = param3 as FlxTilemap;
            return _loc11_.overlapsAt(_loc11_.x - (param1 - x),_loc11_.y - (param2 - y),this,param4,param5);
         }
         var _loc12_:FlxObject = param3 as FlxObject;
         if(!param4)
         {
            return _loc12_.x + _loc12_.width > param1 && _loc12_.x < param1 + width && _loc12_.y + _loc12_.height > param2 && _loc12_.y < param2 + height;
         }
         if(param5 == null)
         {
            var param5:FlxCamera = FlxG.camera;
         }
         var _loc8_:org.flixel.FlxPoint = _loc12_.getScreenXY(null,param5);
         _point.x = param1 - param5.scroll.x * scrollFactor.x;
         _point.y = param2 - param5.scroll.y * scrollFactor.y;
         _point.x = _point.x + (_point.x > 0?1.0E-7:-1.0E-7);
         _point.y = _point.y + (_point.y > 0?1.0E-7:-1.0E-7);
         return _loc8_.x + _loc12_.width > _point.x && _loc8_.x < _point.x + width && _loc8_.y + _loc12_.height > _point.y && _loc8_.y < _point.y + height;
      }
      
      public function overlapsPoint(param1:org.flixel.FlxPoint, param2:Boolean = false, param3:FlxCamera = null) : Boolean
      {
         if(!param2)
         {
            return param1.x > x && param1.x < x + width && param1.y > y && param1.y < y + height;
         }
         if(param3 == null)
         {
            var param3:FlxCamera = FlxG.camera;
         }
         var _loc4_:Number = param1.x - param3.scroll.x;
         var _loc5_:Number = param1.y - param3.scroll.y;
         getScreenXY(_point,param3);
         return _loc4_ > _point.x && _loc4_ < _point.x + width && _loc5_ > _point.y && _loc5_ < _point.y + height;
      }
      
      public function onScreen(param1:FlxCamera = null) : Boolean
      {
         if(param1 == null)
         {
            var param1:FlxCamera = FlxG.camera;
         }
         getScreenXY(_point,param1);
         return _point.x + width > 0 && _point.x < param1.width && _point.y + height > 0 && _point.y < param1.height;
      }
      
      public function getScreenXY(param1:org.flixel.FlxPoint = null, param2:FlxCamera = null) : org.flixel.FlxPoint
      {
         if(param1 == null)
         {
            var param1:org.flixel.FlxPoint = new org.flixel.FlxPoint();
         }
         if(param2 == null)
         {
            var param2:FlxCamera = FlxG.camera;
         }
         param1.x = x - param2.scroll.x * scrollFactor.x;
         param1.y = y - param2.scroll.y * scrollFactor.y;
         param1.x = param1.x + (param1.x > 0?1.0E-7:-1.0E-7);
         param1.y = param1.y + (param1.y > 0?1.0E-7:-1.0E-7);
         return param1;
      }
      
      public function flicker(param1:Number = 1) : void
      {
         _flickerTimer = param1;
         if(_flickerTimer == 0)
         {
            _flicker = false;
         }
      }
      
      public function get flickering() : Boolean
      {
         return _flickerTimer != 0;
      }
      
      public function get solid() : Boolean
      {
         return (allowCollisions & 4369) > 0;
      }
      
      public function set solid(param1:Boolean) : void
      {
         if(param1)
         {
            allowCollisions = 4369;
         }
         else
         {
            allowCollisions = 0;
         }
      }
      
      public function getMidpoint(param1:org.flixel.FlxPoint = null) : org.flixel.FlxPoint
      {
         if(param1 == null)
         {
            var param1:org.flixel.FlxPoint = new org.flixel.FlxPoint();
         }
         param1.x = x + width * 0.5;
         param1.y = y + height * 0.5;
         return param1;
      }
      
      public function reset(param1:Number, param2:Number) : void
      {
         revive();
         touching = 0;
         wasTouching = 0;
         x = param1;
         y = param2;
         last.x = x;
         last.y = y;
         velocity.x = 0;
         velocity.y = 0;
      }
      
      public function isTouching(param1:uint) : Boolean
      {
         return (touching & param1) > 0;
      }
      
      public function justTouched(param1:uint) : Boolean
      {
         return (touching & param1) > 0 && (wasTouching & param1) <= 0;
      }
      
      public function hurt(param1:Number) : void
      {
         health = health - param1;
         if(health <= 0)
         {
            kill();
         }
      }
   }
}
