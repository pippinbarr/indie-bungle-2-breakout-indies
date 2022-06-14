package org.flixel
{
   public class FlxGroup extends FlxBasic
   {
      
      public static const ASCENDING:int = -1;
      
      public static const DESCENDING:int = 1;
       
      public var members:Array;
      
      public var length:Number;
      
      protected var _maxSize:uint;
      
      protected var _marker:uint;
      
      protected var _sortIndex:String;
      
      protected var _sortOrder:int;
      
      public function FlxGroup(param1:uint = 0)
      {
         super();
         members = [];
         length = 0;
         _maxSize = param1;
         _marker = 0;
         _sortIndex = null;
      }
      
      override public function destroy() : void
      {
         var _loc2_:* = null;
         var _loc1_:* = 0;
         if(members != null)
         {
            _loc1_ = 0;
            while(_loc1_ < length)
            {
               _loc2_ = members[_loc1_++] as FlxBasic;
               if(_loc2_ != null)
               {
                  _loc2_.destroy();
               }
            }
            members.length = 0;
            members = null;
         }
         _sortIndex = null;
      }
      
      override public function preUpdate() : void
      {
      }
      
      override public function update() : void
      {
         var _loc2_:* = null;
         var _loc1_:uint = 0;
         while(_loc1_ < length)
         {
            _loc2_ = members[_loc1_++] as FlxBasic;
            if(_loc2_ != null && _loc2_.exists && _loc2_.active)
            {
               _loc2_.preUpdate();
               _loc2_.update();
               _loc2_.postUpdate();
            }
         }
      }
      
      override public function draw() : void
      {
         var _loc2_:* = null;
         var _loc1_:uint = 0;
         while(_loc1_ < length)
         {
            _loc2_ = members[_loc1_++] as FlxBasic;
            if(_loc2_ != null && _loc2_.exists && _loc2_.visible)
            {
               _loc2_.draw();
            }
         }
      }
      
      public function get maxSize() : uint
      {
         return _maxSize;
      }
      
      public function set maxSize(param1:uint) : void
      {
         var _loc3_:* = null;
         _maxSize = param1;
         if(_marker >= _maxSize)
         {
            _marker = 0;
         }
         if(_maxSize == 0 || members == null || _maxSize >= members.length)
         {
            return;
         }
         var _loc2_:uint = _maxSize;
         var _loc4_:uint = members.length;
         while(_loc2_ < _loc4_)
         {
            _loc3_ = members[_loc2_++] as FlxBasic;
            if(_loc3_ != null)
            {
               _loc3_.destroy();
            }
         }
         var _loc5_:* = _maxSize;
         members.length = _loc5_;
         length = _loc5_;
      }
      
      public function add(param1:FlxBasic) : FlxBasic
      {
         if(members.indexOf(param1) >= 0)
         {
            return param1;
         }
         var _loc2_:uint = 0;
         var _loc3_:uint = members.length;
         while(_loc2_ < _loc3_)
         {
            if(members[_loc2_] == null)
            {
               members[_loc2_] = param1;
               if(_loc2_ >= length)
               {
                  length = _loc2_ + 1;
               }
               return param1;
            }
            _loc2_++;
         }
         if(_maxSize > 0)
         {
            if(members.length >= _maxSize)
            {
               return param1;
            }
            if(members.length * 2 <= _maxSize)
            {
               members.length = members.length * 2;
            }
            else
            {
               members.length = _maxSize;
            }
         }
         else
         {
            members.length = members.length * 2;
         }
         members[_loc2_] = param1;
         length = _loc2_ + 1;
         return param1;
      }
      
      public function recycle(param1:Class = null) : FlxBasic
      {
         var _loc2_:* = null;
         if(_maxSize > 0)
         {
            if(length < _maxSize)
            {
               if(param1 == null)
               {
                  return null;
               }
               return add(new param1() as FlxBasic);
            }
            _marker = §§dup(_marker) + 1;
            _loc2_ = members[_marker];
            if(_marker >= _maxSize)
            {
               _marker = 0;
            }
            return _loc2_;
         }
         _loc2_ = getFirstAvailable(param1);
         if(_loc2_ != null)
         {
            return _loc2_;
         }
         if(param1 == null)
         {
            return null;
         }
         return add(new param1() as FlxBasic);
      }
      
      public function remove(param1:FlxBasic, param2:Boolean = false) : FlxBasic
      {
         var _loc3_:int = members.indexOf(param1);
         if(_loc3_ < 0 || _loc3_ >= members.length)
         {
            return null;
         }
         if(param2)
         {
            members.splice(_loc3_,1);
            length = length - 1;
         }
         else
         {
            members[_loc3_] = null;
         }
         return param1;
      }
      
      public function replace(param1:FlxBasic, param2:FlxBasic) : FlxBasic
      {
         var _loc3_:int = members.indexOf(param1);
         if(_loc3_ < 0 || _loc3_ >= members.length)
         {
            return null;
         }
         members[_loc3_] = param2;
         return param2;
      }
      
      public function sort(param1:String = "y", param2:int = -1) : void
      {
         _sortIndex = param1;
         _sortOrder = param2;
         members.sort(sortHandler);
      }
      
      public function setAll(param1:String, param2:Object, param3:Boolean = true) : void
      {
         var _loc5_:* = null;
         var _loc4_:uint = 0;
         while(_loc4_ < length)
         {
            _loc5_ = members[_loc4_++] as FlxBasic;
            if(_loc5_ != null)
            {
               if(param3 && _loc5_ is FlxGroup)
               {
                  (_loc5_ as FlxGroup).setAll(param1,param2,param3);
               }
               else
               {
                  _loc5_[param1] = param2;
               }
            }
         }
      }
      
      public function callAll(param1:String, param2:Boolean = true) : void
      {
         var _loc4_:* = null;
         var _loc3_:uint = 0;
         while(_loc3_ < length)
         {
            _loc4_ = members[_loc3_++] as FlxBasic;
            if(_loc4_ != null)
            {
               if(param2 && _loc4_ is FlxGroup)
               {
                  (_loc4_ as FlxGroup).callAll(param1,param2);
               }
               else
               {
                  §§dup(_loc4_)[param1]();
               }
            }
         }
      }
      
      public function getFirstAvailable(param1:Class = null) : FlxBasic
      {
         var _loc3_:* = null;
         var _loc2_:uint = 0;
         while(_loc2_ < length)
         {
            _loc3_ = members[_loc2_++] as FlxBasic;
            if(_loc3_ != null && !_loc3_.exists && (param1 == null || _loc3_ is param1))
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public function getFirstNull() : int
      {
         var _loc2_:* = null;
         var _loc1_:uint = 0;
         var _loc3_:uint = members.length;
         while(_loc1_ < _loc3_)
         {
            if(members[_loc1_] == null)
            {
               return _loc1_;
            }
            _loc1_++;
         }
         return -1;
      }
      
      public function getFirstExtant() : FlxBasic
      {
         var _loc2_:* = null;
         var _loc1_:uint = 0;
         while(_loc1_ < length)
         {
            _loc2_ = members[_loc1_++] as FlxBasic;
            if(_loc2_ != null && _loc2_.exists)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getFirstAlive() : FlxBasic
      {
         var _loc2_:* = null;
         var _loc1_:uint = 0;
         while(_loc1_ < length)
         {
            _loc2_ = members[_loc1_++] as FlxBasic;
            if(_loc2_ != null && _loc2_.exists && _loc2_.alive)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getFirstDead() : FlxBasic
      {
         var _loc2_:* = null;
         var _loc1_:uint = 0;
         while(_loc1_ < length)
         {
            _loc2_ = members[_loc1_++] as FlxBasic;
            if(_loc2_ != null && !_loc2_.alive)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function countLiving() : int
      {
         var _loc3_:* = null;
         var _loc1_:* = -1;
         var _loc2_:uint = 0;
         while(_loc2_ < length)
         {
            _loc3_ = members[_loc2_++] as FlxBasic;
            if(_loc3_ != null)
            {
               if(_loc1_ < 0)
               {
                  _loc1_ = 0;
               }
               if(_loc3_.exists && _loc3_.alive)
               {
                  _loc1_++;
               }
            }
         }
         return _loc1_;
      }
      
      public function countDead() : int
      {
         var _loc3_:* = null;
         var _loc1_:* = -1;
         var _loc2_:uint = 0;
         while(_loc2_ < length)
         {
            _loc3_ = members[_loc2_++] as FlxBasic;
            if(_loc3_ != null)
            {
               if(_loc1_ < 0)
               {
                  _loc1_ = 0;
               }
               if(!_loc3_.alive)
               {
                  _loc1_++;
               }
            }
         }
         return _loc1_;
      }
      
      public function getRandom(param1:uint = 0, param2:uint = 0) : FlxBasic
      {
         if(param2 == 0)
         {
            var param2:uint = length;
         }
         return FlxG.getRandom(members,param1,param2) as FlxBasic;
      }
      
      public function clear() : void
      {
         var _loc1_:* = 0;
         members.length = _loc1_;
         length = _loc1_;
      }
      
      override public function kill() : void
      {
         var _loc2_:* = null;
         var _loc1_:uint = 0;
         while(_loc1_ < length)
         {
            _loc2_ = members[_loc1_++] as FlxBasic;
            if(_loc2_ != null && _loc2_.exists)
            {
               _loc2_.kill();
            }
         }
         super.kill();
      }
      
      protected function sortHandler(param1:FlxBasic, param2:FlxBasic) : int
      {
         if(param1[_sortIndex] < param2[_sortIndex])
         {
            return _sortOrder;
         }
         if(param1[_sortIndex] > param2[_sortIndex])
         {
            return -_sortOrder;
         }
         return 0;
      }
   }
}
