package org.flixel.system.debug
{
   import org.flixel.system.FlxWindow;
   import flash.text.TextField;
   import flash.geom.Rectangle;
   import flash.text.TextFormat;
   
   public class Log extends FlxWindow
   {
      
      protected static const MAX_LOG_LINES:uint = 200;
       
      protected var _text:TextField;
      
      protected var _lines:Array;
      
      public function Log(param1:String, param2:Number, param3:Number, param4:Boolean = true, param5:Rectangle = null, param6:uint = 2139062143, param7:uint = 2130706432)
      {
         super(param1,param2,param3,param4,param5,param6,param7);
         _text = new TextField();
         _text.x = 2;
         _text.y = 15;
         _text.multiline = true;
         _text.wordWrap = true;
         _text.selectable = true;
         _text.defaultTextFormat = new TextFormat("Courier",12,16777215);
         addChild(_text);
         _lines = [];
      }
      
      override public function destroy() : void
      {
         removeChild(_text);
         _text = null;
         _lines = null;
         super.destroy();
      }
      
      public function add(param1:String) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = 0;
         if(_lines.length <= 0)
         {
            _text.text = "";
         }
         _lines.push(param1);
         if(_lines.length > 200)
         {
            _lines.shift();
            _loc2_ = "";
            _loc3_ = 0;
            while(_loc3_ < _lines.length)
            {
               _loc2_ = _loc2_ + (_lines[_loc3_] + "\n");
               _loc3_++;
            }
            _text.text = _loc2_;
         }
         else
         {
            _text.appendText(param1 + "\n");
         }
         _text.scrollV = _text.height;
      }
      
      override protected function updateSize() : void
      {
         super.updateSize();
         _text.width = _width - 10;
         _text.height = _height - 15;
      }
   }
}
