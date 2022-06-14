package org.flixel
{
   public class FlxBasic
   {
      
      static var _ACTIVECOUNT:uint;
      
      static var _VISIBLECOUNT:uint;
       
      public var ID:int;
      
      public var exists:Boolean;
      
      public var active:Boolean;
      
      public var visible:Boolean;
      
      public var alive:Boolean;
      
      public var cameras:Array;
      
      public var ignoreDrawDebug:Boolean;
      
      public function FlxBasic()
      {
         super();
         ID = -1;
         exists = true;
         active = true;
         visible = true;
         alive = true;
         ignoreDrawDebug = false;
      }
      
      public function destroy() : void
      {
      }
      
      public function preUpdate() : void
      {
         _ACTIVECOUNT = _ACTIVECOUNT + 1;
      }
      
      public function update() : void
      {
      }
      
      public function postUpdate() : void
      {
      }
      
      public function draw() : void
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
            _VISIBLECOUNT = _VISIBLECOUNT + 1;
            if(FlxG.visualDebug && !ignoreDrawDebug)
            {
               drawDebug(_loc2_);
            }
         }
      }
      
      public function drawDebug(param1:FlxCamera = null) : void
      {
      }
      
      public function kill() : void
      {
         alive = false;
         exists = false;
      }
      
      public function revive() : void
      {
         alive = true;
         exists = true;
      }
      
      public function toString() : String
      {
         return FlxU.getClassName(this,true);
      }
   }
}
