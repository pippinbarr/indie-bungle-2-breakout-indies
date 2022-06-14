package org.flixel.system
{
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import org.flixel.FlxCamera;
   import flash.geom.Point;
   import org.flixel.FlxG;
   import org.flixel.FlxU;
   
   public class FlxTilemapBuffer
   {
       
      public var x:Number;
      
      public var y:Number;
      
      public var width:Number;
      
      public var height:Number;
      
      public var dirty:Boolean;
      
      public var rows:uint;
      
      public var columns:uint;
      
      protected var _pixels:BitmapData;
      
      protected var _flashRect:Rectangle;
      
      public function FlxTilemapBuffer(param1:Number, param2:Number, param3:uint, param4:uint, param5:FlxCamera = null)
      {
         super();
         if(param5 == null)
         {
            var param5:FlxCamera = FlxG.camera;
         }
         columns = FlxU.ceil(param5.width / param1) + 1;
         if(columns > param3)
         {
            columns = param3;
         }
         rows = FlxU.ceil(param5.height / param2) + 1;
         if(rows > param4)
         {
            rows = param4;
         }
         _pixels = new BitmapData(columns * param1,rows * param2,true,0);
         width = _pixels.width;
         height = _pixels.height;
         _flashRect = new Rectangle(0,0,width,height);
         dirty = true;
      }
      
      public function destroy() : void
      {
         _pixels = null;
      }
      
      public function fill(param1:uint = 0) : void
      {
         _pixels.fillRect(_flashRect,param1);
      }
      
      public function get pixels() : BitmapData
      {
         return _pixels;
      }
      
      public function draw(param1:FlxCamera, param2:Point) : void
      {
         param1.buffer.copyPixels(_pixels,_flashRect,param2,null,null,true);
      }
   }
}
