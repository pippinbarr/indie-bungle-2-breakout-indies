package org.flixel
{
   import org.flixel.plugin.TimerManager;
   
   public class FlxTimer
   {
       
      public var time:Number;
      
      public var loops:uint;
      
      public var paused:Boolean;
      
      public var finished:Boolean;
      
      protected var _callback:Function;
      
      protected var _timeCounter:Number;
      
      protected var _loopsCounter:uint;
      
      public function FlxTimer()
      {
         super();
         time = 0;
         loops = 0;
         _callback = null;
         _timeCounter = 0;
         _loopsCounter = 0;
         paused = false;
         finished = false;
      }
      
      public static function get manager() : TimerManager
      {
         return FlxG.getPlugin(TimerManager) as TimerManager;
      }
      
      public function destroy() : void
      {
         stop();
         _callback = null;
      }
      
      public function update() : void
      {
         _timeCounter = §§dup()._timeCounter + FlxG.elapsed;
         while(_timeCounter >= time && !paused && !finished)
         {
            _timeCounter = §§dup()._timeCounter - time;
            _loopsCounter = _loopsCounter + 1;
            if(loops > 0 && _loopsCounter >= loops)
            {
               stop();
            }
            if(_callback != null)
            {
               _callback(this);
            }
         }
      }
      
      public function start(param1:Number = 1, param2:uint = 1, param3:Function = null) : FlxTimer
      {
         var _loc4_:TimerManager = manager;
         if(_loc4_ != null)
         {
            _loc4_.add(this);
         }
         if(paused)
         {
            paused = false;
            return this;
         }
         paused = false;
         finished = false;
         time = param1;
         loops = param2;
         _callback = param3;
         _timeCounter = 0;
         _loopsCounter = 0;
         return this;
      }
      
      public function stop() : void
      {
         finished = true;
         var _loc1_:TimerManager = manager;
         if(_loc1_ != null)
         {
            _loc1_.remove(this);
         }
      }
      
      public function get timeLeft() : Number
      {
         return time - _timeCounter;
      }
      
      public function get loopsLeft() : int
      {
         return loops - _loopsCounter;
      }
      
      public function get progress() : Number
      {
         if(time > 0)
         {
            return _timeCounter / time;
         }
         return 0;
      }
   }
}
