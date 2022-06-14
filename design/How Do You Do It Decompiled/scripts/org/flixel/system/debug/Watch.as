package org.flixel.system.debug
{
   import org.flixel.system.FlxWindow;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   
   public class Watch extends FlxWindow
   {
      
      protected static const MAX_LOG_LINES:uint = 1024;
      
      protected static const LINE_HEIGHT:uint = 15;
       
      public var editing:Boolean;
      
      protected var _names:Sprite;
      
      protected var _values:Sprite;
      
      protected var _watching:Array;
      
      public function Watch(param1:String, param2:Number, param3:Number, param4:Boolean = true, param5:Rectangle = null, param6:uint = 2139062143, param7:uint = 2130706432)
      {
         super(param1,param2,param3,param4,param5,param6,param7);
         _names = new Sprite();
         _names.x = 2;
         _names.y = 15;
         addChild(_names);
         _values = new Sprite();
         _values.x = 2;
         _values.y = 15;
         addChild(_values);
         _watching = [];
         editing = false;
         removeAll();
      }
      
      override public function destroy() : void
      {
         removeChild(_names);
         _names = null;
         removeChild(_values);
         _values = null;
         var _loc1_:* = 0;
         var _loc2_:uint = _watching.length;
         while(_loc1_ < _loc2_)
         {
            _loc1_++;
            (_watching[_loc1_] as WatchEntry).destroy();
         }
         _watching = null;
         super.destroy();
      }
      
      public function add(param1:Object, param2:String, param3:String = null) : void
      {
         var _loc4_:* = null;
         var _loc5_:* = 0;
         var _loc6_:uint = _watching.length;
         while(_loc5_ < _loc6_)
         {
            _loc5_++;
            _loc4_ = _watching[_loc5_] as WatchEntry;
            if(_loc4_.object == param1 && _loc4_.field == param2)
            {
               return;
            }
         }
         _loc4_ = new WatchEntry(_watching.length * 15,_width / 2,_width / 2 - 10,param1,param2,param3);
         _names.addChild(_loc4_.nameDisplay);
         _values.addChild(_loc4_.valueDisplay);
         _watching.push(_loc4_);
      }
      
      public function remove(param1:Object, param2:String = null) : void
      {
         var _loc3_:* = null;
         var _loc4_:int = _watching.length - 1;
         while(_loc4_ >= 0)
         {
            _loc3_ = _watching[_loc4_];
            if(_loc3_.object == param1 && (param2 == null || _loc3_.field == param2))
            {
               _watching.splice(_loc4_,1);
               _names.removeChild(_loc3_.nameDisplay);
               _values.removeChild(_loc3_.valueDisplay);
               _loc3_.destroy();
            }
            _loc4_--;
         }
         _loc3_ = null;
         _loc4_ = 0;
         var _loc5_:uint = _watching.length;
         while(_loc4_ < _loc5_)
         {
            (_watching[_loc4_] as WatchEntry).setY(_loc4_ * 15);
            _loc4_++;
         }
      }
      
      public function removeAll() : void
      {
         var _loc1_:* = null;
         var _loc2_:* = 0;
         var _loc3_:uint = _watching.length;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = _watching.pop();
            _names.removeChild(_loc1_.nameDisplay);
            _values.removeChild(_loc1_.valueDisplay);
            _loc1_.destroy();
            _loc2_++;
         }
         _watching.length = 0;
      }
      
      public function update() : void
      {
         editing = false;
         var _loc1_:uint = 0;
         var _loc2_:uint = _watching.length;
         while(_loc1_ < _loc2_)
         {
            if(!(_watching[_loc1_++] as WatchEntry).updateValue())
            {
               editing = true;
            }
         }
      }
      
      public function submit() : void
      {
         var _loc2_:* = null;
         var _loc1_:uint = 0;
         var _loc3_:uint = _watching.length;
         while(_loc1_ < _loc3_)
         {
            _loc2_ = _watching[_loc1_++] as WatchEntry;
            if(_loc2_.editing)
            {
               _loc2_.submit();
            }
         }
         editing = false;
      }
      
      override protected function updateSize() : void
      {
         if(_height < _watching.length * 15 + 17)
         {
            _height = _watching.length * 15 + 17;
         }
         super.updateSize();
         _values.x = _width / 2 + 2;
         var _loc1_:* = 0;
         var _loc2_:uint = _watching.length;
         while(_loc1_ < _loc2_)
         {
            _loc1_++;
            (_watching[_loc1_] as WatchEntry).updateWidth(_width / 2,_width / 2 - 10);
         }
      }
   }
}
