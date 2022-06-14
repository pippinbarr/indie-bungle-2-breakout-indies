package org.flixel.system
{
   import org.flixel.system.replay.FrameRecord;
   import org.flixel.FlxG;
   import org.flixel.system.replay.MouseRecord;
   
   public class FlxReplay
   {
       
      public var seed:Number;
      
      public var frame:int;
      
      public var frameCount:int;
      
      public var finished:Boolean;
      
      protected var _frames:Array;
      
      protected var _capacity:int;
      
      protected var _marker:int;
      
      public function FlxReplay()
      {
         super();
         seed = 0;
         frame = 0;
         frameCount = 0;
         finished = false;
         _frames = null;
         _capacity = 0;
         _marker = 0;
      }
      
      public function destroy() : void
      {
         if(_frames == null)
         {
            return;
         }
         var _loc1_:int = frameCount - 1;
         while(_loc1_ >= 0)
         {
            _loc1_--;
            (_frames[_loc1_] as FrameRecord).destroy();
         }
         _frames = null;
      }
      
      public function create(param1:Number) : void
      {
         destroy();
         init();
         seed = param1;
         rewind();
      }
      
      public function load(param1:String) : void
      {
         var _loc2_:* = null;
         init();
         var _loc4_:Array = param1.split("\n");
         seed = _loc4_[0];
         var _loc3_:uint = 1;
         var _loc5_:uint = _loc4_.length;
         while(_loc3_ < _loc5_)
         {
            _loc2_ = _loc4_[_loc3_++] as String;
            if(_loc2_.length > 3)
            {
               frameCount = §§dup(frameCount) + 1;
               _frames[frameCount] = new FrameRecord().load(_loc2_);
               if(frameCount >= _capacity)
               {
                  _capacity = §§dup()._capacity * 2;
                  _frames.length = _capacity;
               }
            }
         }
         rewind();
      }
      
      protected function init() : void
      {
         _capacity = 100;
         _frames = new Array(_capacity);
         frameCount = 0;
      }
      
      public function save() : String
      {
         if(frameCount <= 0)
         {
            return null;
         }
         var _loc1_:String = seed + "\n";
         var _loc2_:uint = 0;
         while(_loc2_ < frameCount)
         {
            _loc1_ = _loc1_ + (_frames[_loc2_++].save() + "\n");
         }
         return _loc1_;
      }
      
      public function recordFrame() : void
      {
         var _loc2_:Array = FlxG.keys.record();
         var _loc1_:MouseRecord = FlxG.mouse.record();
         if(_loc2_ == null && _loc1_ == null)
         {
            frame = frame + 1;
            return;
         }
         frameCount = §§dup(frameCount) + 1;
         frame = §§dup(frame) + 1;
         _frames[frameCount] = new FrameRecord().create(frame,_loc2_,_loc1_);
         if(frameCount >= _capacity)
         {
            _capacity = §§dup()._capacity * 2;
            _frames.length = _capacity;
         }
      }
      
      public function playNextFrame() : void
      {
         FlxG.resetInput();
         if(_marker >= frameCount)
         {
            finished = true;
            return;
         }
         frame = §§dup(frame) + 1;
         if((_frames[_marker] as FrameRecord).frame != frame)
         {
            return;
         }
         _marker = §§dup(_marker) + 1;
         var _loc1_:FrameRecord = _frames[_marker];
         if(_loc1_.keys != null)
         {
            FlxG.keys.playback(_loc1_.keys);
         }
         if(_loc1_.mouse != null)
         {
            FlxG.mouse.playback(_loc1_.mouse);
         }
      }
      
      public function rewind() : void
      {
         _marker = 0;
         frame = 0;
         finished = false;
      }
   }
}
