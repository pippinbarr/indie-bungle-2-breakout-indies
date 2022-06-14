package org.flixel
{
   import flash.display.BitmapData;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.geom.Point;
   import flash.geom.ColorTransform;
   
   public class FlxCamera extends FlxBasic
   {
      
      public static const STYLE_LOCKON:uint = 0;
      
      public static const STYLE_PLATFORMER:uint = 1;
      
      public static const STYLE_TOPDOWN:uint = 2;
      
      public static const STYLE_TOPDOWN_TIGHT:uint = 3;
      
      public static const SHAKE_BOTH_AXES:uint = 0;
      
      public static const SHAKE_HORIZONTAL_ONLY:uint = 1;
      
      public static const SHAKE_VERTICAL_ONLY:uint = 2;
      
      public static var defaultZoom:Number;
       
      public var x:Number;
      
      public var y:Number;
      
      public var width:uint;
      
      public var height:uint;
      
      public var target:org.flixel.FlxObject;
      
      public var deadzone:org.flixel.FlxRect;
      
      public var bounds:org.flixel.FlxRect;
      
      public var scroll:org.flixel.FlxPoint;
      
      public var buffer:BitmapData;
      
      public var bgColor:uint;
      
      public var screen:org.flixel.FlxSprite;
      
      protected var _zoom:Number;
      
      protected var _point:org.flixel.FlxPoint;
      
      protected var _color:uint;
      
      protected var _flashBitmap:Bitmap;
      
      var _flashSprite:Sprite;
      
      var _flashOffsetX:Number;
      
      var _flashOffsetY:Number;
      
      protected var _flashRect:Rectangle;
      
      protected var _flashPoint:Point;
      
      protected var _fxFlashColor:uint;
      
      protected var _fxFlashDuration:Number;
      
      protected var _fxFlashComplete:Function;
      
      protected var _fxFlashAlpha:Number;
      
      protected var _fxFadeColor:uint;
      
      protected var _fxFadeDuration:Number;
      
      protected var _fxFadeComplete:Function;
      
      protected var _fxFadeAlpha:Number;
      
      protected var _fxShakeIntensity:Number;
      
      protected var _fxShakeDuration:Number;
      
      protected var _fxShakeComplete:Function;
      
      protected var _fxShakeOffset:org.flixel.FlxPoint;
      
      protected var _fxShakeDirection:uint;
      
      protected var _fill:BitmapData;
      
      public function FlxCamera(param1:int, param2:int, param3:int, param4:int, param5:Number = 0)
      {
         super();
         x = param1;
         y = param2;
         width = param3;
         height = param4;
         target = null;
         deadzone = null;
         scroll = new org.flixel.FlxPoint();
         _point = new org.flixel.FlxPoint();
         bounds = null;
         screen = new org.flixel.FlxSprite();
         screen.makeGraphic(width,height,0,true);
         screen.setOriginToCorner();
         buffer = screen.pixels;
         bgColor = FlxG.bgColor;
         _color = 16777215;
         _flashBitmap = new Bitmap(buffer);
         _flashBitmap.x = -width * 0.5;
         _flashBitmap.y = -height * 0.5;
         _flashSprite = new Sprite();
         zoom = param5;
         _flashOffsetX = width * 0.5 * zoom;
         _flashOffsetY = height * 0.5 * zoom;
         _flashSprite.x = x + _flashOffsetX;
         _flashSprite.y = y + _flashOffsetY;
         _flashSprite.addChild(_flashBitmap);
         _flashRect = new Rectangle(0,0,width,height);
         _flashPoint = new Point();
         _fxFlashColor = 0;
         _fxFlashDuration = 0;
         _fxFlashComplete = null;
         _fxFlashAlpha = 0;
         _fxFadeColor = 0;
         _fxFadeDuration = 0;
         _fxFadeComplete = null;
         _fxFadeAlpha = 0;
         _fxShakeIntensity = 0;
         _fxShakeDuration = 0;
         _fxShakeComplete = null;
         _fxShakeOffset = new org.flixel.FlxPoint();
         _fxShakeDirection = 0;
         _fill = new BitmapData(width,height,true,0);
      }
      
      override public function destroy() : void
      {
         screen.destroy();
         screen = null;
         target = null;
         scroll = null;
         deadzone = null;
         bounds = null;
         buffer = null;
         _flashBitmap = null;
         _flashRect = null;
         _flashPoint = null;
         _fxFlashComplete = null;
         _fxFadeComplete = null;
         _fxShakeComplete = null;
         _fxShakeOffset = null;
         _fill = null;
      }
      
      override public function update() : void
      {
         var _loc1_:* = NaN;
         var _loc3_:* = NaN;
         var _loc2_:* = NaN;
         if(target != null)
         {
            if(deadzone == null)
            {
               focusOn(target.getMidpoint(_point));
            }
            else
            {
               _loc3_ = target.x + (target.x > 0?1.0E-7:-1.0E-7);
               _loc2_ = target.y + (target.y > 0?1.0E-7:-1.0E-7);
               _loc1_ = _loc3_ - deadzone.x;
               if(scroll.x > _loc1_)
               {
                  scroll.x = _loc1_;
               }
               _loc1_ = _loc3_ + target.width - deadzone.x - deadzone.width;
               if(scroll.x < _loc1_)
               {
                  scroll.x = _loc1_;
               }
               _loc1_ = _loc2_ - deadzone.y;
               if(scroll.y > _loc1_)
               {
                  scroll.y = _loc1_;
               }
               _loc1_ = _loc2_ + target.height - deadzone.y - deadzone.height;
               if(scroll.y < _loc1_)
               {
                  scroll.y = _loc1_;
               }
            }
         }
         if(bounds != null)
         {
            if(scroll.x < bounds.left)
            {
               scroll.x = bounds.left;
            }
            if(scroll.x > bounds.right - width)
            {
               scroll.x = bounds.right - width;
            }
            if(scroll.y < bounds.top)
            {
               scroll.y = bounds.top;
            }
            if(scroll.y > bounds.bottom - height)
            {
               scroll.y = bounds.bottom - height;
            }
         }
         if(_fxFlashAlpha > 0)
         {
            _fxFlashAlpha = §§dup()._fxFlashAlpha - FlxG.elapsed / _fxFlashDuration;
            if(_fxFlashAlpha <= 0 && _fxFlashComplete != null)
            {
               _fxFlashComplete();
            }
         }
         if(_fxFadeAlpha > 0 && _fxFadeAlpha < 1)
         {
            _fxFadeAlpha = §§dup()._fxFadeAlpha + FlxG.elapsed / _fxFadeDuration;
            if(_fxFadeAlpha >= 1)
            {
               _fxFadeAlpha = 1;
               if(_fxFadeComplete != null)
               {
                  _fxFadeComplete();
               }
            }
         }
         if(_fxShakeDuration > 0)
         {
            _fxShakeDuration = §§dup()._fxShakeDuration - FlxG.elapsed;
            if(_fxShakeDuration <= 0)
            {
               _fxShakeOffset.make();
               if(_fxShakeComplete != null)
               {
                  _fxShakeComplete();
               }
            }
            else
            {
               if(_fxShakeDirection == 0 || _fxShakeDirection == 1)
               {
                  _fxShakeOffset.x = (FlxG.random() * _fxShakeIntensity * width * 2 - _fxShakeIntensity * width) * _zoom;
               }
               if(_fxShakeDirection == 0 || _fxShakeDirection == 2)
               {
                  _fxShakeOffset.y = (FlxG.random() * _fxShakeIntensity * height * 2 - _fxShakeIntensity * height) * _zoom;
               }
            }
         }
      }
      
      public function follow(param1:org.flixel.FlxObject, param2:uint = 0) : void
      {
         var _loc3_:* = NaN;
         var _loc4_:* = NaN;
         var _loc5_:* = NaN;
         target = param1;
         switch(param2)
         {
            case 1:
               _loc4_ = width / 8;
               _loc5_ = height / 3;
               deadzone = new org.flixel.FlxRect((width - _loc4_) / 2,(height - _loc5_) / 2 - _loc5_ * 0.25,_loc4_,_loc5_);
               break;
            case 2:
               _loc3_ = FlxU.max(width,height) / 4;
               deadzone = new org.flixel.FlxRect((width - _loc3_) / 2,(height - _loc3_) / 2,_loc3_,_loc3_);
               break;
            case 3:
               _loc3_ = FlxU.max(width,height) / 8;
               deadzone = new org.flixel.FlxRect((width - _loc3_) / 2,(height - _loc3_) / 2,_loc3_,_loc3_);
               break;
            default:
               deadzone = null;
         }
      }
      
      public function focusOn(param1:org.flixel.FlxPoint) : void
      {
         param1.x = param1.x + (param1.x > 0?1.0E-7:-1.0E-7);
         param1.y = param1.y + (param1.y > 0?1.0E-7:-1.0E-7);
         scroll.make(param1.x - width * 0.5,param1.y - height * 0.5);
      }
      
      public function setBounds(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Boolean = false) : void
      {
         if(bounds == null)
         {
            bounds = new org.flixel.FlxRect();
         }
         bounds.make(param1,param2,param3,param4);
         if(param5)
         {
            FlxG.worldBounds.copyFrom(bounds);
         }
         update();
      }
      
      public function flash(param1:uint = 4294967295, param2:Number = 1, param3:Function = null, param4:Boolean = false) : void
      {
         if(!param4 && _fxFlashAlpha > 0)
         {
            return;
         }
         _fxFlashColor = param1;
         if(param2 <= 0)
         {
            var param2:Number = Number.MIN_VALUE;
         }
         _fxFlashDuration = param2;
         _fxFlashComplete = param3;
         _fxFlashAlpha = 1;
      }
      
      public function fade(param1:uint = 4278190080, param2:Number = 1, param3:Function = null, param4:Boolean = false) : void
      {
         if(!param4 && _fxFadeAlpha > 0)
         {
            return;
         }
         _fxFadeColor = param1;
         if(param2 <= 0)
         {
            var param2:Number = Number.MIN_VALUE;
         }
         _fxFadeDuration = param2;
         _fxFadeComplete = param3;
         _fxFadeAlpha = Number.MIN_VALUE;
      }
      
      public function shake(param1:Number = 0.05, param2:Number = 0.5, param3:Function = null, param4:Boolean = true, param5:uint = 0) : void
      {
         if(!param4 && (_fxShakeOffset.x != 0 || _fxShakeOffset.y != 0))
         {
            return;
         }
         _fxShakeIntensity = param1;
         _fxShakeDuration = param2;
         _fxShakeComplete = param3;
         _fxShakeDirection = param5;
         _fxShakeOffset.make();
      }
      
      public function stopFX() : void
      {
         _fxFlashAlpha = 0;
         _fxFadeAlpha = 0;
         _fxShakeDuration = 0;
         _flashSprite.x = x + width * 0.5;
         _flashSprite.y = y + height * 0.5;
      }
      
      public function copyFrom(param1:FlxCamera) : FlxCamera
      {
         if(param1.bounds == null)
         {
            bounds = null;
         }
         else
         {
            if(bounds == null)
            {
               bounds = new org.flixel.FlxRect();
            }
            bounds.copyFrom(param1.bounds);
         }
         target = param1.target;
         if(target != null)
         {
            if(param1.deadzone == null)
            {
               deadzone = null;
            }
            else
            {
               if(deadzone == null)
               {
                  deadzone = new org.flixel.FlxRect();
               }
               deadzone.copyFrom(param1.deadzone);
            }
         }
         return this;
      }
      
      public function get zoom() : Number
      {
         return _zoom;
      }
      
      public function set zoom(param1:Number) : void
      {
         if(param1 == 0)
         {
            _zoom = defaultZoom;
         }
         else
         {
            _zoom = param1;
         }
         setScale(_zoom,_zoom);
      }
      
      public function get alpha() : Number
      {
         return _flashBitmap.alpha;
      }
      
      public function set alpha(param1:Number) : void
      {
         _flashBitmap.alpha = param1;
      }
      
      public function get angle() : Number
      {
         return _flashSprite.rotation;
      }
      
      public function set angle(param1:Number) : void
      {
         _flashSprite.rotation = param1;
      }
      
      public function get color() : uint
      {
         return _color;
      }
      
      public function set color(param1:uint) : void
      {
         _color = param1;
         var _loc2_:ColorTransform = _flashBitmap.transform.colorTransform;
         _loc2_.redMultiplier = (_color >> 16) * 0.00392;
         _loc2_.greenMultiplier = (_color >> 8 & 255) * 0.00392;
         _loc2_.blueMultiplier = (_color & 255) * 0.00392;
         _flashBitmap.transform.colorTransform = _loc2_;
      }
      
      public function get antialiasing() : Boolean
      {
         return _flashBitmap.smoothing;
      }
      
      public function set antialiasing(param1:Boolean) : void
      {
         _flashBitmap.smoothing = param1;
      }
      
      public function getScale() : org.flixel.FlxPoint
      {
         return _point.make(_flashSprite.scaleX,_flashSprite.scaleY);
      }
      
      public function setScale(param1:Number, param2:Number) : void
      {
         _flashSprite.scaleX = param1;
         _flashSprite.scaleY = param2;
      }
      
      public function getContainerSprite() : Sprite
      {
         return _flashSprite;
      }
      
      public function fill(param1:uint, param2:Boolean = true) : void
      {
         _fill.fillRect(_flashRect,param1);
         buffer.copyPixels(_fill,_flashRect,_flashPoint,null,null,param2);
      }
      
      function drawFX() : void
      {
         var _loc1_:* = NaN;
         if(_fxFlashAlpha > 0)
         {
            _loc1_ = _fxFlashColor >> 24;
            fill(((_loc1_ <= 0?255:_loc1_) * _fxFlashAlpha << 24) + (_fxFlashColor & 16777215));
         }
         if(_fxFadeAlpha > 0)
         {
            _loc1_ = _fxFadeColor >> 24;
            fill(((_loc1_ <= 0?255:_loc1_) * _fxFadeAlpha << 24) + (_fxFadeColor & 16777215));
         }
         if(_fxShakeOffset.x != 0 || _fxShakeOffset.y != 0)
         {
            _flashSprite.x = x + _flashOffsetX + _fxShakeOffset.x;
            _flashSprite.y = y + _flashOffsetY + _fxShakeOffset.y;
         }
      }
   }
}
