package org.flixel.system
{
   public class FlxAnim
   {
       
      public var name:String;
      
      public var delay:Number;
      
      public var frames:Array;
      
      public var looped:Boolean;
      
      public function FlxAnim(param1:String, param2:Array, param3:Number = 0, param4:Boolean = true)
      {
         super();
         name = param1;
         delay = 0;
         if(param3 > 0)
         {
            delay = 1 / param3;
         }
         frames = param2;
         looped = param4;
      }
      
      public function destroy() : void
      {
         frames = null;
      }
   }
}
