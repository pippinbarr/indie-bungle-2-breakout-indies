package org.flixel
{
   import flash.net.SharedObject;
   import flash.events.NetStatusEvent;
   
   public class FlxSave
   {
      
      protected static var SUCCESS:uint = 0;
      
      protected static var PENDING:uint = 1;
      
      protected static var ERROR:uint = 2;
       
      public var data:Object;
      
      public var name:String;
      
      protected var _sharedObject:SharedObject;
      
      protected var _onComplete:Function;
      
      protected var _closeRequested:Boolean;
      
      public function FlxSave()
      {
         super();
         destroy();
      }
      
      public function destroy() : void
      {
         _sharedObject = null;
         name = null;
         data = null;
         _onComplete = null;
         _closeRequested = false;
      }
      
      public function bind(param1:String) : Boolean
      {
         destroy();
         name = param1;
         try
         {
            _sharedObject = SharedObject.getLocal(name);
         }
         catch(e:Error)
         {
            FlxG.log("ERROR: There was a problem binding to\nthe shared object data from FlxSave.");
            destroy();
            var _loc3_:* = false;
            return _loc3_;
         }
         data = _sharedObject.data;
         return true;
      }
      
      public function close(param1:uint = 0, param2:Function = null) : Boolean
      {
         _closeRequested = true;
         return flush(param1,param2);
      }
      
      public function flush(param1:uint = 0, param2:Function = null) : Boolean
      {
         if(!checkBinding())
         {
            return false;
         }
         _onComplete = param2;
         var _loc3_:String = null;
         try
         {
            _loc3_ = _sharedObject.flush(param1);
         }
         catch(e:Error)
         {
            var _loc5_:* = onDone(ERROR);
            return _loc5_;
         }
         if(_loc3_ == "pending")
         {
            _sharedObject.addEventListener("netStatus",onFlushStatus);
         }
         return onDone(_loc3_ == "flushed"?SUCCESS:PENDING);
      }
      
      public function erase() : Boolean
      {
         if(!checkBinding())
         {
            return false;
         }
         _sharedObject.clear();
         return true;
      }
      
      protected function onFlushStatus(param1:NetStatusEvent) : void
      {
         _sharedObject.removeEventListener("netStatus",onFlushStatus);
         onDone(param1.info.code == "SharedObject.Flush.Success"?SUCCESS:ERROR);
      }
      
      protected function onDone(param1:uint) : Boolean
      {
         var _loc2_:* = param1;
         if(PENDING !== _loc2_)
         {
            if(ERROR === _loc2_)
            {
               FlxG.log("ERROR: There was a problem flushing\nthe shared object data from FlxSave.");
            }
         }
         else
         {
            FlxG.log("FLIXEL: FlxSave is requesting extra storage space.");
         }
         if(_onComplete != null)
         {
            _onComplete(param1 == SUCCESS);
         }
         if(_closeRequested)
         {
            destroy();
         }
         return param1 == SUCCESS;
      }
      
      protected function checkBinding() : Boolean
      {
         if(_sharedObject == null)
         {
            FlxG.log("FLIXEL: You must call FlxSave.bind()\nbefore you can read or write data.");
            return false;
         }
         return true;
      }
   }
}
