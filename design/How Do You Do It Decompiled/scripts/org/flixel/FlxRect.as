package org.flixel
{
   import flash.geom.Rectangle;
   
   public class FlxRect
   {
       
      public var x:Number;
      
      public var y:Number;
      
      public var width:Number;
      
      public var height:Number;
      
      public function FlxRect(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0)
      {
         super();
         x = param1;
         y = param2;
         width = param3;
         height = param4;
      }
      
      public function get left() : Number
      {
         return x;
      }
      
      public function get right() : Number
      {
         return x + width;
      }
      
      public function get top() : Number
      {
         return y;
      }
      
      public function get bottom() : Number
      {
         return y + height;
      }
      
      public function make(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0) : FlxRect
      {
         x = param1;
         y = param2;
         width = param3;
         height = param4;
         return this;
      }
      
      public function copyFrom(param1:FlxRect) : FlxRect
      {
         x = param1.x;
         y = param1.y;
         width = param1.width;
         height = param1.height;
         return this;
      }
      
      public function copyTo(param1:FlxRect) : FlxRect
      {
         param1.x = x;
         param1.y = y;
         param1.width = width;
         param1.height = height;
         return param1;
      }
      
      public function copyFromFlash(param1:Rectangle) : FlxRect
      {
         x = param1.x;
         y = param1.y;
         width = param1.width;
         height = param1.height;
         return this;
      }
      
      public function copyToFlash(param1:Rectangle) : Rectangle
      {
         param1.x = x;
         param1.y = y;
         param1.width = width;
         param1.height = height;
         return param1;
      }
      
      public function overlaps(param1:FlxRect) : Boolean
      {
         return param1.x + param1.width > x && param1.x < x + width && param1.y + param1.height > y && param1.y < y + height;
      }
   }
}
