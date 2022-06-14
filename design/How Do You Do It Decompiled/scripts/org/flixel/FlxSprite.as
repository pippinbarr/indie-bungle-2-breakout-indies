package org.flixel
{
   import flash.display.BitmapData;
   import org.flixel.system.FlxAnim;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.display.Graphics;
   
   public class FlxSprite extends FlxObject
   {
       
      protected var ImgDefault:Class;
      
      public var origin:org.flixel.FlxPoint;
      
      public var offset:org.flixel.FlxPoint;
      
      public var scale:org.flixel.FlxPoint;
      
      public var blend:String;
      
      public var antialiasing:Boolean;
      
      public var finished:Boolean;
      
      public var frameWidth:uint;
      
      public var frameHeight:uint;
      
      public var frames:uint;
      
      public var framePixels:BitmapData;
      
      public var dirty:Boolean;
      
      protected var _animations:Array;
      
      protected var _flipped:uint;
      
      protected var _curAnim:FlxAnim;
      
      protected var _curFrame:uint;
      
      protected var _curIndex:uint;
      
      protected var _frameTimer:Number;
      
      protected var _callback:Function;
      
      protected var _facing:uint;
      
      protected var _alpha:Number;
      
      protected var _color:uint;
      
      protected var _bakedRotation:Number;
      
      protected var _pixels:BitmapData;
      
      protected var _flashPoint:Point;
      
      protected var _flashRect:Rectangle;
      
      protected var _flashRect2:Rectangle;
      
      protected var _flashPointZero:Point;
      
      protected var _colorTransform:ColorTransform;
      
      protected var _matrix:Matrix;
      
      public function FlxSprite(param1:Number = 0, param2:Number = 0, param3:Class = null)
      {
         ImgDefault = §default_png$d45c40316df1f1b623b379a878bce47b-2108836623§;
         super(param1,param2);
         health = 1;
         _flashPoint = new Point();
         _flashRect = new Rectangle();
         _flashRect2 = new Rectangle();
         _flashPointZero = new Point();
         offset = new org.flixel.FlxPoint();
         origin = new org.flixel.FlxPoint();
         scale = new org.flixel.FlxPoint(1,1);
         _alpha = 1;
         _color = 16777215;
         blend = null;
         antialiasing = false;
         cameras = null;
         finished = false;
         _facing = 16;
         _animations = [];
         _flipped = 0;
         _curAnim = null;
         _curFrame = 0;
         _curIndex = 0;
         _frameTimer = 0;
         _matrix = new Matrix();
         _callback = null;
         if(param3 == null)
         {
            var param3:Class = ImgDefault;
         }
         loadGraphic(param3);
      }
      
      override public function destroy() : void
      {
         var _loc1_:* = null;
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         if(_animations != null)
         {
            _loc2_ = 0;
            _loc3_ = _animations.length;
            while(_loc2_ < _loc3_)
            {
               _loc1_ = _animations[_loc2_++];
               if(_loc1_ != null)
               {
                  _loc1_.destroy();
               }
            }
            _animations = null;
         }
         _flashPoint = null;
         _flashRect = null;
         _flashRect2 = null;
         _flashPointZero = null;
         offset = null;
         origin = null;
         scale = null;
         _curAnim = null;
         _matrix = null;
         _callback = null;
         framePixels = null;
      }
      
      public function loadGraphic(param1:Class, param2:Boolean = false, param3:Boolean = false, param4:uint = 0, param5:uint = 0, param6:Boolean = false) : FlxSprite
      {
         _bakedRotation = 0;
         _pixels = FlxG.addBitmap(param1,param3,param6);
         if(param3)
         {
            _flipped = _pixels.width >> 1;
         }
         else
         {
            _flipped = 0;
         }
         if(param4 == 0)
         {
            if(param2)
            {
               var param4:uint = _pixels.height;
            }
            else if(_flipped > 0)
            {
               param4 = _pixels.width * 0.5;
            }
            else
            {
               param4 = _pixels.width;
            }
         }
         frameWidth = §§dup(param4);
         width = param4;
         if(param5 == 0)
         {
            if(param2)
            {
               var param5:uint = width;
            }
            else
            {
               param5 = _pixels.height;
            }
         }
         frameHeight = §§dup(param5);
         height = param5;
         resetHelpers();
         return this;
      }
      
      public function loadRotatedGraphic(param1:Class, param2:uint = 16, param3:int = -1, param4:Boolean = false, param5:Boolean = false) : FlxSprite
      {
         var _loc22_:* = null;
         var _loc9_:* = 0;
         var _loc11_:* = 0;
         var _loc17_:* = 0;
         var _loc19_:* = 0;
         var _loc12_:* = 0;
         var _loc7_:* = NaN;
         var _loc20_:* = 0;
         var _loc18_:* = 0;
         var _loc13_:* = 0;
         var _loc14_:* = 0;
         var _loc15_:uint = Math.sqrt(param2);
         var _loc6_:BitmapData = FlxG.addBitmap(param1);
         if(param3 >= 0)
         {
            _loc22_ = _loc6_;
            _loc6_ = new BitmapData(_loc22_.height,_loc22_.height);
            _loc9_ = param3 * _loc6_.width;
            _loc11_ = 0;
            _loc17_ = _loc22_.width;
            if(_loc9_ >= _loc17_)
            {
               _loc11_ = _loc9_ / _loc17_ * _loc6_.height;
               _loc9_ = _loc9_ % _loc17_;
            }
            _flashRect.x = _loc9_;
            _flashRect.y = _loc11_;
            _flashRect.width = _loc6_.width;
            _flashRect.height = _loc6_.height;
            _loc6_.copyPixels(_loc22_,_flashRect,_flashPointZero);
         }
         var _loc8_:uint = _loc6_.width;
         if(_loc6_.height > _loc8_)
         {
            _loc8_ = _loc6_.height;
         }
         if(param5)
         {
            _loc8_ = _loc8_ * 1.5;
         }
         var _loc10_:uint = FlxU.ceil(param2 / _loc15_);
         width = _loc8_ * _loc10_;
         height = _loc8_ * _loc15_;
         var _loc21_:String = param1 + ":" + param3 + ":" + width + "x" + height;
         var _loc16_:Boolean = FlxG.checkBitmapCache(_loc21_);
         _pixels = FlxG.createBitmap(width,height,0,true,_loc21_);
         frameWidth = §§dup(_pixels.width);
         width = _pixels.width;
         frameHeight = §§dup(_pixels.height);
         height = _pixels.height;
         _bakedRotation = 360 / param2;
         if(!_loc16_)
         {
            _loc19_ = 0;
            _loc7_ = 0.0;
            _loc20_ = _loc6_.width * 0.5;
            _loc18_ = _loc6_.height * 0.5;
            _loc13_ = _loc8_ * 0.5;
            _loc14_ = _loc8_ * 0.5;
            while(_loc19_ < _loc15_)
            {
               _loc12_ = 0;
               while(_loc12_ < _loc10_)
               {
                  _matrix.identity();
                  _matrix.translate(-_loc20_,-_loc18_);
                  _matrix.rotate(_loc7_ * 0.017453293);
                  _matrix.translate(_loc8_ * _loc12_ + _loc13_,_loc14_);
                  _loc7_ = _loc7_ + _bakedRotation;
                  _pixels.draw(_loc6_,_matrix,null,null,null,param4);
                  _loc12_++;
               }
               _loc14_ = _loc14_ + _loc8_;
               _loc19_++;
            }
         }
         height = §§dup(_loc8_);
         width = §§dup(_loc8_);
         frameHeight = §§dup(_loc8_);
         frameWidth = _loc8_;
         resetHelpers();
         if(param5)
         {
            width = _loc6_.width;
            height = _loc6_.height;
            centerOffsets();
         }
         return this;
      }
      
      public function makeGraphic(param1:uint, param2:uint, param3:uint = 4294967295, param4:Boolean = false, param5:String = null) : FlxSprite
      {
         _bakedRotation = 0;
         _pixels = FlxG.createBitmap(param1,param2,param3,param4,param5);
         frameWidth = §§dup(_pixels.width);
         width = _pixels.width;
         frameHeight = §§dup(_pixels.height);
         height = _pixels.height;
         resetHelpers();
         return this;
      }
      
      protected function resetHelpers() : void
      {
         _flashRect.x = 0;
         _flashRect.y = 0;
         _flashRect.width = frameWidth;
         _flashRect.height = frameHeight;
         _flashRect2.x = 0;
         _flashRect2.y = 0;
         _flashRect2.width = _pixels.width;
         _flashRect2.height = _pixels.height;
         if(framePixels == null || framePixels.width != width || framePixels.height != height)
         {
            framePixels = new BitmapData(width,height);
         }
         origin.make(frameWidth * 0.5,frameHeight * 0.5);
         framePixels.copyPixels(_pixels,_flashRect,_flashPointZero);
         frames = _flashRect2.width / _flashRect.width * _flashRect2.height / _flashRect.height;
         if(_colorTransform != null)
         {
            framePixels.colorTransform(_flashRect,_colorTransform);
         }
         _curIndex = 0;
      }
      
      override public function postUpdate() : void
      {
         super.postUpdate();
         updateAnimation();
      }
      
      override public function draw() : void
      {
         var _loc2_:* = null;
         if(_flickerTimer != 0)
         {
            _flicker = !_flicker;
            if(_flicker)
            {
               return;
            }
         }
         if(dirty)
         {
            calcFrame();
         }
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
               _point.x = x - _loc2_.scroll.x * scrollFactor.x - offset.x;
               _point.y = y - _loc2_.scroll.y * scrollFactor.y - offset.y;
               _point.x = _point.x + (_point.x > 0?1.0E-7:-1.0E-7);
               _point.y = _point.y + (_point.y > 0?1.0E-7:-1.0E-7);
               if((angle == 0 || _bakedRotation > 0) && scale.x == 1 && scale.y == 1 && blend == null)
               {
                  _flashPoint.x = _point.x;
                  _flashPoint.y = _point.y;
                  _loc2_.buffer.copyPixels(framePixels,_flashRect,_flashPoint,null,null,true);
               }
               else
               {
                  _matrix.identity();
                  _matrix.translate(-origin.x,-origin.y);
                  _matrix.scale(scale.x,scale.y);
                  if(angle != 0 && _bakedRotation <= 0)
                  {
                     _matrix.rotate(angle * 0.017453293);
                  }
                  _matrix.translate(_point.x + origin.x,_point.y + origin.y);
                  _loc2_.buffer.draw(framePixels,_matrix,null,blend,null,antialiasing);
               }
               _VISIBLECOUNT = _VISIBLECOUNT + 1;
               if(FlxG.visualDebug && !ignoreDrawDebug)
               {
                  drawDebug(_loc2_);
               }
            }
         }
      }
      
      public function stamp(param1:FlxSprite, param2:int = 0, param3:int = 0) : void
      {
         param1.drawFrame();
         var _loc4_:BitmapData = param1.framePixels;
         if((param1.angle == 0 || param1._bakedRotation > 0) && param1.scale.x == 1 && param1.scale.y == 1 && param1.blend == null)
         {
            _flashPoint.x = param2;
            _flashPoint.y = param3;
            _flashRect2.width = _loc4_.width;
            _flashRect2.height = _loc4_.height;
            _pixels.copyPixels(_loc4_,_flashRect2,_flashPoint,null,null,true);
            _flashRect2.width = _pixels.width;
            _flashRect2.height = _pixels.height;
            calcFrame();
            return;
         }
         _matrix.identity();
         _matrix.translate(-param1.origin.x,-param1.origin.y);
         _matrix.scale(param1.scale.x,param1.scale.y);
         if(param1.angle != 0)
         {
            _matrix.rotate(param1.angle * 0.017453293);
         }
         _matrix.translate(param2 + param1.origin.x,param3 + param1.origin.y);
         _pixels.draw(_loc4_,_matrix,null,param1.blend,null,param1.antialiasing);
         calcFrame();
      }
      
      public function drawLine(param1:Number, param2:Number, param3:Number, param4:Number, param5:uint, param6:uint = 1) : void
      {
         var _loc7_:Graphics = FlxG.flashGfx;
         _loc7_.clear();
         _loc7_.moveTo(param1,param2);
         var _loc8_:Number = (param5 >> 24 & 255) / 255;
         if(_loc8_ <= 0)
         {
            _loc8_ = 1.0;
         }
         _loc7_.lineStyle(param6,param5,_loc8_);
         _loc7_.lineTo(param3,param4);
         _pixels.draw(FlxG.flashGfxSprite);
         dirty = true;
      }
      
      public function fill(param1:uint) : void
      {
         _pixels.fillRect(_flashRect2,param1);
         if(_pixels != framePixels)
         {
            dirty = true;
         }
      }
      
      protected function updateAnimation() : void
      {
         var _loc2_:* = 0;
         var _loc1_:* = 0;
         if(_bakedRotation > 0)
         {
            _loc2_ = _curIndex;
            _loc1_ = angle % 360;
            if(_loc1_ < 0)
            {
               _loc1_ = _loc1_ + 360;
            }
            _curIndex = _loc1_ / _bakedRotation + 0.5;
            if(_loc2_ != _curIndex)
            {
               dirty = true;
            }
         }
         else if(_curAnim != null && _curAnim.delay > 0 && (_curAnim.looped || !finished))
         {
            _frameTimer = §§dup()._frameTimer + FlxG.elapsed;
            while(_frameTimer > _curAnim.delay)
            {
               _frameTimer = _frameTimer - _curAnim.delay;
               if(_curFrame == _curAnim.frames.length - 1)
               {
                  if(_curAnim.looped)
                  {
                     _curFrame = 0;
                  }
                  finished = true;
               }
               else
               {
                  _curFrame = _curFrame + 1;
               }
               _curIndex = _curAnim.frames[_curFrame];
               dirty = true;
            }
         }
         if(dirty)
         {
            calcFrame();
         }
      }
      
      public function drawFrame(param1:Boolean = false) : void
      {
         if(param1 || dirty)
         {
            calcFrame();
         }
      }
      
      public function addAnimation(param1:String, param2:Array, param3:Number = 0, param4:Boolean = true) : void
      {
         _animations.push(new FlxAnim(param1,param2,param3,param4));
      }
      
      public function addAnimationCallback(param1:Function) : void
      {
         _callback = param1;
      }
      
      public function play(param1:String, param2:Boolean = false) : void
      {
         if(!param2 && _curAnim != null && param1 == _curAnim.name && (_curAnim.looped || !finished))
         {
            return;
         }
         _curFrame = 0;
         _curIndex = 0;
         _frameTimer = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = _animations.length;
         while(_loc3_ < _loc4_)
         {
            if(_animations[_loc3_].name == param1)
            {
               _curAnim = _animations[_loc3_];
               if(_curAnim.delay <= 0)
               {
                  finished = true;
               }
               else
               {
                  finished = false;
               }
               _curIndex = _curAnim.frames[_curFrame];
               dirty = true;
               return;
            }
            _loc3_++;
         }
         FlxG.log("WARNING: No animation called \"" + param1 + "\"");
      }
      
      public function randomFrame() : void
      {
         _curAnim = null;
         _curIndex = FlxG.random() * _pixels.width / frameWidth;
         dirty = true;
      }
      
      public function setOriginToCorner() : void
      {
         var _loc1_:* = 0;
         origin.y = _loc1_;
         origin.x = _loc1_;
      }
      
      public function centerOffsets(param1:Boolean = false) : void
      {
         offset.x = (frameWidth - width) * 0.5;
         offset.y = (frameHeight - height) * 0.5;
         if(param1)
         {
            x = §§dup().x + offset.x;
            y = §§dup().y + offset.y;
         }
      }
      
      public function replaceColor(param1:uint, param2:uint, param3:Boolean = false) : Array
      {
         var _loc5_:* = 0;
         var _loc6_:Array = null;
         if(param3)
         {
            _loc6_ = [];
         }
         var _loc7_:uint = 0;
         var _loc8_:uint = _pixels.height;
         var _loc4_:uint = _pixels.width;
         while(_loc7_ < _loc8_)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               if(_pixels.getPixel32(_loc5_,_loc7_) == param1)
               {
                  _pixels.setPixel32(_loc5_,_loc7_,param2);
                  if(param3)
                  {
                     _loc6_.push(new org.flixel.FlxPoint(_loc5_,_loc7_));
                  }
                  dirty = true;
               }
               _loc5_++;
            }
            _loc7_++;
         }
         return _loc6_;
      }
      
      public function get pixels() : BitmapData
      {
         return _pixels;
      }
      
      public function set pixels(param1:BitmapData) : void
      {
         _pixels = param1;
         frameWidth = §§dup(_pixels.width);
         width = _pixels.width;
         frameHeight = §§dup(_pixels.height);
         height = _pixels.height;
         resetHelpers();
      }
      
      public function get facing() : uint
      {
         return _facing;
      }
      
      public function set facing(param1:uint) : void
      {
         if(_facing != param1)
         {
            dirty = true;
         }
         _facing = param1;
      }
      
      public function get alpha() : Number
      {
         return _alpha;
      }
      
      public function set alpha(param1:Number) : void
      {
         if(param1 > 1)
         {
            var param1:* = 1.0;
         }
         if(param1 < 0)
         {
            param1 = 0.0;
         }
         if(param1 == _alpha)
         {
            return;
         }
         _alpha = param1;
         if(_alpha != 1 || _color != 16777215)
         {
            _colorTransform = new ColorTransform((_color >> 16) * 0.00392,(_color >> 8 & 255) * 0.00392,(_color & 255) * 0.00392,_alpha);
         }
         else
         {
            _colorTransform = null;
         }
         dirty = true;
      }
      
      public function get color() : uint
      {
         return _color;
      }
      
      public function set color(param1:uint) : void
      {
         var param1:uint = param1 & 16777215;
         if(_color == param1)
         {
            return;
         }
         _color = param1;
         if(_alpha != 1 || _color != 16777215)
         {
            _colorTransform = new ColorTransform((_color >> 16) * 0.00392,(_color >> 8 & 255) * 0.00392,(_color & 255) * 0.00392,_alpha);
         }
         else
         {
            _colorTransform = null;
         }
         dirty = true;
      }
      
      public function get frame() : uint
      {
         return _curIndex;
      }
      
      public function set frame(param1:uint) : void
      {
         _curAnim = null;
         _curIndex = param1;
         dirty = true;
      }
      
      override public function onScreen(param1:FlxCamera = null) : Boolean
      {
         if(param1 == null)
         {
            var param1:FlxCamera = FlxG.camera;
         }
         getScreenXY(_point,param1);
         _point.x = _point.x - offset.x;
         _point.y = _point.y - offset.y;
         if((angle == 0 || _bakedRotation > 0) && scale.x == 1 && scale.y == 1)
         {
            return _point.x + frameWidth > 0 && _point.x < param1.width && _point.y + frameHeight > 0 && _point.y < param1.height;
         }
         var _loc5_:Number = frameWidth / 2;
         var _loc4_:Number = frameHeight / 2;
         var _loc2_:Number = scale.x > 0?scale.x:-scale.x;
         var _loc3_:Number = scale.y > 0?scale.y:-scale.y;
         var _loc6_:Number = Math.sqrt(_loc5_ * _loc5_ + _loc4_ * _loc4_) * (_loc2_ >= _loc3_?_loc2_:_loc3_);
         _point.x = _point.x + _loc5_;
         _point.y = _point.y + _loc4_;
         return _point.x + _loc6_ > 0 && _point.x - _loc6_ < param1.width && _point.y + _loc6_ > 0 && _point.y - _loc6_ < param1.height;
      }
      
      public function pixelsOverlapPoint(param1:org.flixel.FlxPoint, param2:uint = 255, param3:FlxCamera = null) : Boolean
      {
         if(param3 == null)
         {
            var param3:FlxCamera = FlxG.camera;
         }
         getScreenXY(_point,param3);
         _point.x = _point.x - offset.x;
         _point.y = _point.y - offset.y;
         _flashPoint.x = param1.x - param3.scroll.x - _point.x;
         _flashPoint.y = param1.y - param3.scroll.y - _point.y;
         return framePixels.hitTest(_flashPointZero,param2,_flashPoint);
      }
      
      protected function calcFrame() : void
      {
         var _loc3_:uint = _curIndex * frameWidth;
         var _loc2_:uint = 0;
         var _loc1_:uint = _flipped?_flipped:_pixels.width;
         if(_loc3_ >= _loc1_)
         {
            _loc2_ = _loc3_ / _loc1_ * frameHeight;
            _loc3_ = _loc3_ % _loc1_;
         }
         if(_flipped && _facing == 1)
         {
            _loc3_ = (_flipped << 1) - _loc3_ - frameWidth;
         }
         _flashRect.x = _loc3_;
         _flashRect.y = _loc2_;
         framePixels.copyPixels(_pixels,_flashRect,_flashPointZero);
         var _loc4_:* = 0;
         _flashRect.y = _loc4_;
         _flashRect.x = _loc4_;
         if(_colorTransform != null)
         {
            framePixels.colorTransform(_flashRect,_colorTransform);
         }
         if(_callback != null)
         {
            _callback(_curAnim != null?_curAnim.name:null,_curFrame,_curIndex);
         }
         dirty = false;
      }
   }
}
