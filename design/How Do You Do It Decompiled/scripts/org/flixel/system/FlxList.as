package org.flixel.system
{
   import org.flixel.FlxObject;
   
   public class FlxList
   {
       
      public var object:FlxObject;
      
      public var next:org.flixel.system.FlxList;
      
      public function FlxList()
      {
         super();
         object = null;
         next = null;
      }
      
      public function destroy() : void
      {
         object = null;
         if(next != null)
         {
            next.destroy();
         }
         next = null;
      }
   }
}
