package org.flixel.system.input
{
   import org.flixel.FlxPoint;
   import flash.display.Sprite;
   import flash.display.Bitmap;
   import org.flixel.FlxG;
   import org.flixel.FlxCamera;
   import flash.events.MouseEvent;
   import org.flixel.system.replay.MouseRecord;
   
   public class Mouse extends FlxPoint
   {
       
      protected var ImgDefaultCursor:Class;
      
      public var wheel:int;
      
      public var screenX:int;
      
      public var screenY:int;
      
      protected var _current:int;
      
      protected var _last:int;
      
      protected var _cursorContainer:Sprite;
      
      protected var _cursor:Bitmap;
      
      protected var _lastX:int;
      
      protected var _lastY:int;
      
      protected var _lastWheel:int;
      
      protected var _point:FlxPoint;
      
      protected var _globalScreenPosition:FlxPoint;
      
      public function Mouse(param1:Sprite)
      {
         ImgDefaultCursor = §cursor_png$fcaf4f1295d989b4a3fca581f1e5d1ba-547219204§;
         super();
         _cursorContainer = param1;
         screenX = 0;
         _lastX = 0;
         screenY = 0;
         _lastY = 0;
         wheel = 0;
         _lastWheel = 0;
         _current = 0;
         _last = 0;
         _cursor = null;
         _point = new FlxPoint();
         _globalScreenPosition = new FlxPoint();
      }
      
      public function destroy() : void
      {
         _cursorContainer = null;
         _cursor = null;
         _point = null;
         _globalScreenPosition = null;
      }
      
      public function show(param1:Class = null, param2:Number = 1, param3:int = 0, param4:int = 0) : void
      {
         _cursorContainer.visible = true;
         if(param1 != null)
         {
            load(param1,param2,param3,param4);
         }
         else if(_cursor == null)
         {
            load();
         }
      }
      
      public function hide() : void
      {
         _cursorContainer.visible = false;
      }
      
      public function get visible() : Boolean
      {
         return _cursorContainer.visible;
      }
      
      public function load(param1:Class = null, param2:Number = 1, param3:int = 0, param4:int = 0) : void
      {
         if(_cursor != null)
         {
            _cursorContainer.removeChild(_cursor);
         }
         if(param1 == null)
         {
            var param1:Class = ImgDefaultCursor;
         }
         _cursor = new param1();
         _cursor.x = param3;
         _cursor.y = param4;
         _cursor.scaleX = param2;
         _cursor.scaleY = param2;
         _cursorContainer.addChild(_cursor);
      }
      
      public function unload() : void
      {
         if(_cursor != null)
         {
            if(_cursorContainer.visible)
            {
               load();
            }
            else
            {
               _cursorContainer.removeChild(_cursor);
               _cursor = null;
            }
         }
      }
      
      public function update(param1:int, param2:int) : void
      {
         _globalScreenPosition.x = param1;
         _globalScreenPosition.y = param2;
         updateCursor();
         if(_last == -1 && _current == -1)
         {
            _current = 0;
         }
         else if(_last == 2 && _current == 2)
         {
            _current = 1;
         }
         _last = _current;
      }
      
      protected function updateCursor() : void
      {
         _cursorContainer.x = _globalScreenPosition.x;
         _cursorContainer.y = _globalScreenPosition.y;
         var _loc1_:FlxCamera = FlxG.camera;
         screenX = (_globalScreenPosition.x - _loc1_.x) / _loc1_.zoom;
         screenY = (_globalScreenPosition.y - _loc1_.y) / _loc1_.zoom;
         x = screenX + _loc1_.scroll.x;
         y = screenY + _loc1_.scroll.y;
      }
      
      public function getWorldPosition(param1:FlxCamera = null, param2:FlxPoint = null) : FlxPoint
      {
         if(param1 == null)
         {
            var param1:FlxCamera = FlxG.camera;
         }
         if(param2 == null)
         {
            var param2:FlxPoint = new FlxPoint();
         }
         getScreenPosition(param1,_point);
         param2.x = _point.x + param1.scroll.x;
         param2.y = _point.y + param1.scroll.y;
         return param2;
      }
      
      public function getScreenPosition(param1:FlxCamera = null, param2:FlxPoint = null) : FlxPoint
      {
         if(param1 == null)
         {
            var param1:FlxCamera = FlxG.camera;
         }
         if(param2 == null)
         {
            var param2:FlxPoint = new FlxPoint();
         }
         param2.x = (_globalScreenPosition.x - param1.x) / param1.zoom;
         param2.y = (_globalScreenPosition.y - param1.y) / param1.zoom;
         return param2;
      }
      
      public function reset() : void
      {
         _current = 0;
         _last = 0;
      }
      
      public function pressed() : Boolean
      {
         return _current > 0;
      }
      
      public function justPressed() : Boolean
      {
         return _current == 2;
      }
      
      public function justReleased() : Boolean
      {
         return _current == -1;
      }
      
      public function handleMouseDown(param1:MouseEvent) : void
      {
         if(_current > 0)
         {
            _current = 1;
         }
         else
         {
            _current = 2;
         }
      }
      
      public function handleMouseUp(param1:MouseEvent) : void
      {
         if(_current > 0)
         {
            _current = -1;
         }
         else
         {
            _current = 0;
         }
      }
      
      public function handleMouseWheel(param1:MouseEvent) : void
      {
         wheel = param1.delta;
      }
      
      public function record() : MouseRecord
      {
         if(_lastX == _globalScreenPosition.x && _lastY == _globalScreenPosition.y && _current == 0 && _lastWheel == wheel)
         {
            return null;
         }
         _lastX = _globalScreenPosition.x;
         _lastY = _globalScreenPosition.y;
         _lastWheel = wheel;
         return new MouseRecord(_lastX,_lastY,_current,_lastWheel);
      }
      
      public function playback(param1:MouseRecord) : void
      {
         _current = param1.button;
         wheel = param1.wheel;
         _globalScreenPosition.x = param1.x;
         _globalScreenPosition.y = param1.y;
         updateCursor();
      }
   }
}
