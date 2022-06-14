package org.flixel.system.input
{
   public class Input
   {
       
      var _lookup:Object;
      
      var _map:Array;
      
      const _total:uint = 256;
      
      public function Input()
      {
         super();
         _lookup = {};
         _map = new Array(256);
      }
      
      public function update() : void
      {
         var _loc2_:* = null;
         var _loc1_:uint = 0;
         while(_loc1_ < 256)
         {
            _loc2_ = _map[_loc1_++];
            if(_loc2_ != null)
            {
               if(_loc2_.last == -1 && _loc2_.current == -1)
               {
                  _loc2_.current = 0;
               }
               else if(_loc2_.last == 2 && _loc2_.current == 2)
               {
                  _loc2_.current = 1;
               }
               _loc2_.last = _loc2_.current;
            }
         }
      }
      
      public function reset() : void
      {
         var _loc2_:* = null;
         var _loc1_:uint = 0;
         while(_loc1_ < 256)
         {
            _loc2_ = _map[_loc1_++];
            if(_loc2_ != null)
            {
               this[_loc2_.name] = false;
               _loc2_.current = 0;
               _loc2_.last = 0;
            }
         }
      }
      
      public function pressed(param1:String) : Boolean
      {
         return this[param1];
      }
      
      public function justPressed(param1:String) : Boolean
      {
         return _map[_lookup[param1]].current == 2;
      }
      
      public function justReleased(param1:String) : Boolean
      {
         return _map[_lookup[param1]].current == -1;
      }
      
      public function record() : Array
      {
         var _loc3_:* = null;
         var _loc1_:Array = null;
         var _loc2_:uint = 0;
         while(_loc2_ < 256)
         {
            _loc3_ = _map[_loc2_++];
            if(!(_loc3_ == null || _loc3_.current == 0))
            {
               if(_loc1_ == null)
               {
                  _loc1_ = [];
               }
               _loc1_.push({
                  "code":_loc2_ - 1,
                  "value":_loc3_.current
               });
            }
         }
         return _loc1_;
      }
      
      public function playback(param1:Array) : void
      {
         var _loc5_:* = null;
         var _loc2_:* = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = param1.length;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = param1[_loc3_++];
            _loc2_ = _map[_loc5_.code];
            _loc2_.current = _loc5_.value;
            if(_loc5_.value > 0)
            {
               this[_loc2_.name] = true;
            }
         }
      }
      
      public function getKeyCode(param1:String) : int
      {
         return _lookup[param1];
      }
      
      public function any() : Boolean
      {
         var _loc2_:* = null;
         var _loc1_:uint = 0;
         while(_loc1_ < 256)
         {
            _loc2_ = _map[_loc1_++];
            if(_loc2_ != null && _loc2_.current > 0)
            {
               return true;
            }
         }
         return false;
      }
      
      protected function addKey(param1:String, param2:uint) : void
      {
         _lookup[param1] = param2;
         _map[param2] = {
            "name":param1,
            "current":0,
            "last":0
         };
      }
      
      public function destroy() : void
      {
         _lookup = null;
         _map = null;
      }
   }
}
