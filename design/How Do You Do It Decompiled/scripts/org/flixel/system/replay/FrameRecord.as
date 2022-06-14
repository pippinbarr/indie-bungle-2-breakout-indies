package org.flixel.system.replay
{
   public class FrameRecord
   {
       
      public var frame:int;
      
      public var keys:Array;
      
      public var mouse:org.flixel.system.replay.MouseRecord;
      
      public function FrameRecord()
      {
         super();
         frame = 0;
         keys = null;
         mouse = null;
      }
      
      public function create(param1:Number, param2:Array = null, param3:org.flixel.system.replay.MouseRecord = null) : FrameRecord
      {
         frame = param1;
         keys = param2;
         mouse = param3;
         return this;
      }
      
      public function destroy() : void
      {
         keys = null;
         mouse = null;
      }
      
      public function save() : String
      {
         var _loc4_:* = null;
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         var _loc1_:String = frame + "k";
         if(keys != null)
         {
            _loc2_ = 0;
            _loc3_ = keys.length;
            while(_loc2_ < _loc3_)
            {
               if(_loc2_ > 0)
               {
                  _loc1_ = _loc1_ + ",";
               }
               _loc4_ = keys[_loc2_++];
               _loc1_ = _loc1_ + (_loc4_.code + ":" + _loc4_.value);
            }
         }
         _loc1_ = _loc1_ + "m";
         if(mouse != null)
         {
            _loc1_ = _loc1_ + (mouse.x + "," + mouse.y + "," + mouse.button + "," + mouse.wheel);
         }
         return _loc1_;
      }
      
      public function load(param1:String) : FrameRecord
      {
         var _loc5_:* = 0;
         var _loc7_:* = 0;
         var _loc6_:* = null;
         var _loc4_:Array = param1.split("k");
         frame = _loc4_[0] as String;
         _loc4_ = (_loc4_[1] as String).split("m");
         var _loc2_:String = _loc4_[0];
         var _loc3_:String = _loc4_[1];
         if(_loc2_.length > 0)
         {
            _loc4_ = _loc2_.split(",");
            _loc5_ = 0;
            _loc7_ = _loc4_.length;
            while(_loc5_ < _loc7_)
            {
               _loc6_ = (_loc4_[_loc5_++] as String).split(":");
               if(_loc6_.length == 2)
               {
                  if(keys == null)
                  {
                     keys = [];
                  }
                  keys.push({
                     "code":_loc6_[0] as String,
                     "value":_loc6_[1] as String
                  });
               }
            }
         }
         if(_loc3_.length > 0)
         {
            _loc4_ = _loc3_.split(",");
            if(_loc4_.length >= 4)
            {
               mouse = new org.flixel.system.replay.MouseRecord(_loc4_[0] as String,_loc4_[1] as String,_loc4_[2] as String,_loc4_[3] as String);
            }
         }
         return this;
      }
   }
}
