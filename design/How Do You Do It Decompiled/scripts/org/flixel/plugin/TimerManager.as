package org.flixel.plugin
{
   import org.flixel.FlxBasic;
   import org.flixel.FlxTimer;
   
   public class TimerManager extends FlxBasic
   {
       
      protected var _timers:Array;
      
      public function TimerManager()
      {
         super();
         _timers = [];
         visible = false;
      }
      
      override public function destroy() : void
      {
         clear();
         _timers = null;
      }
      
      override public function update() : void
      {
         var _loc1_:* = null;
         var _loc2_:int = _timers.length - 1;
         while(_loc2_ >= 0)
         {
            _loc2_--;
            _loc1_ = _timers[_loc2_] as FlxTimer;
            if(_loc1_ != null && !_loc1_.paused && !_loc1_.finished && _loc1_.time > 0)
            {
               _loc1_.update();
            }
         }
      }
      
      public function add(param1:FlxTimer) : void
      {
         _timers.push(param1);
      }
      
      public function remove(param1:FlxTimer) : void
      {
         var _loc2_:int = _timers.indexOf(param1);
         if(_loc2_ >= 0)
         {
            _timers.splice(_loc2_,1);
         }
      }
      
      public function clear() : void
      {
         var _loc1_:* = null;
         var _loc2_:int = _timers.length - 1;
         while(_loc2_ >= 0)
         {
            _loc2_--;
            _loc1_ = _timers[_loc2_] as FlxTimer;
            if(_loc1_ != null)
            {
               _loc1_.destroy();
            }
         }
         _timers.length = 0;
      }
   }
}
