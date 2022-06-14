package org.flixel.plugin
{
   import org.flixel.FlxBasic;
   import org.flixel.FlxG;
   import org.flixel.FlxCamera;
   import org.flixel.FlxPath;
   
   public class DebugPathDisplay extends FlxBasic
   {
       
      protected var _paths:Array;
      
      public function DebugPathDisplay()
      {
         super();
         _paths = [];
         active = false;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         clear();
         _paths = null;
      }
      
      override public function draw() : void
      {
         if(!FlxG.visualDebug || ignoreDrawDebug)
         {
            return;
         }
         if(cameras == null)
         {
            cameras = FlxG.cameras;
         }
         var _loc1_:uint = 0;
         var _loc2_:uint = cameras.length;
         while(_loc1_ < _loc2_)
         {
            drawDebug(cameras[_loc1_++]);
         }
      }
      
      override public function drawDebug(param1:FlxCamera = null) : void
      {
         var _loc2_:* = null;
         if(param1 == null)
         {
            var param1:FlxCamera = FlxG.camera;
         }
         var _loc3_:int = _paths.length - 1;
         while(_loc3_ >= 0)
         {
            _loc3_--;
            _loc2_ = _paths[_loc3_] as FlxPath;
            if(_loc2_ != null && !_loc2_.ignoreDrawDebug)
            {
               _loc2_.drawDebug(param1);
            }
         }
      }
      
      public function add(param1:FlxPath) : void
      {
         _paths.push(param1);
      }
      
      public function remove(param1:FlxPath) : void
      {
         var _loc2_:int = _paths.indexOf(param1);
         if(_loc2_ >= 0)
         {
            _paths.splice(_loc2_,1);
         }
      }
      
      public function clear() : void
      {
         var _loc1_:* = null;
         var _loc2_:int = _paths.length - 1;
         while(_loc2_ >= 0)
         {
            _loc2_--;
            _loc1_ = _paths[_loc2_] as FlxPath;
            if(_loc1_ != null)
            {
               _loc1_.destroy();
            }
         }
         _paths.length = 0;
      }
   }
}
