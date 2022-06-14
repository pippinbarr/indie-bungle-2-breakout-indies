package org.flixel.system.debug
{
   import flash.display.Sprite;
   import flash.display.Bitmap;
   import org.flixel.FlxG;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class Vis extends Sprite
   {
       
      protected var ImgBounds:Class;
      
      protected var _bounds:Bitmap;
      
      protected var _overBounds:Boolean;
      
      protected var _pressingBounds:Boolean;
      
      public function Vis()
      {
         ImgBounds = bounds_png$e32f2f468f54aa0ef0e361032212b1191938653458;
         super();
         var _loc1_:uint = 7;
         _bounds = new ImgBounds();
         addChild(_bounds);
         unpress();
         checkOver();
         updateGUI();
         addEventListener("enterFrame",init);
      }
      
      public function destroy() : void
      {
         removeChild(_bounds);
         _bounds = null;
         parent.removeEventListener("mouseMove",onMouseMove);
         parent.removeEventListener("mouseDown",onMouseDown);
         parent.removeEventListener("mouseUp",onMouseUp);
      }
      
      public function onBounds() : void
      {
         FlxG.visualDebug = !FlxG.visualDebug;
      }
      
      protected function init(param1:Event = null) : void
      {
         if(root == null)
         {
            return;
         }
         removeEventListener("enterFrame",init);
         parent.addEventListener("mouseMove",onMouseMove);
         parent.addEventListener("mouseDown",onMouseDown);
         parent.addEventListener("mouseUp",onMouseUp);
      }
      
      protected function onMouseMove(param1:MouseEvent = null) : void
      {
         if(!checkOver())
         {
            unpress();
         }
         updateGUI();
      }
      
      protected function onMouseDown(param1:MouseEvent = null) : void
      {
         unpress();
         if(_overBounds)
         {
            _pressingBounds = true;
         }
      }
      
      protected function onMouseUp(param1:MouseEvent = null) : void
      {
         if(_overBounds && _pressingBounds)
         {
            onBounds();
         }
         unpress();
         checkOver();
         updateGUI();
      }
      
      protected function checkOver() : Boolean
      {
         _overBounds = false;
         if(mouseX < 0 || mouseX > width || mouseY < 0 || mouseY > height)
         {
            return false;
         }
         if(mouseX > _bounds.x || mouseX < _bounds.x + _bounds.width)
         {
            _overBounds = true;
         }
         return true;
      }
      
      protected function unpress() : void
      {
         _pressingBounds = false;
      }
      
      protected function updateGUI() : void
      {
         if(FlxG.visualDebug)
         {
            if(_overBounds && _bounds.alpha != 1)
            {
               _bounds.alpha = 1;
            }
            else if(!_overBounds && _bounds.alpha != 0.9)
            {
               _bounds.alpha = 0.9;
            }
         }
         else if(_overBounds && _bounds.alpha != 0.6)
         {
            _bounds.alpha = 0.6;
         }
         else if(!_overBounds && _bounds.alpha != 0.5)
         {
            _bounds.alpha = 0.5;
         }
      }
   }
}
