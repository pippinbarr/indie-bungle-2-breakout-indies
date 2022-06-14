package org.flixel
{
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.display.BitmapData;
   
   public class FlxText extends FlxSprite
   {
       
      protected var _textField:TextField;
      
      protected var _regen:Boolean;
      
      protected var _shadow:uint;
      
      public function FlxText(param1:Number, param2:Number, param3:uint, param4:String = null, param5:Boolean = true)
      {
         super(param1,param2);
         makeGraphic(param3,1,0);
         if(param4 == null)
         {
            var param4:String = "";
         }
         _textField = new TextField();
         _textField.width = param3;
         _textField.embedFonts = param5;
         _textField.selectable = false;
         _textField.sharpness = 100;
         _textField.multiline = true;
         _textField.wordWrap = true;
         _textField.text = param4;
         var _loc6_:TextFormat = new TextFormat("system",8,16777215);
         _textField.defaultTextFormat = _loc6_;
         _textField.setTextFormat(_loc6_);
         if(param4.length <= 0)
         {
            _textField.height = 1;
         }
         else
         {
            _textField.height = 10;
         }
         _regen = true;
         _shadow = 0;
         allowCollisions = 0;
         calcFrame();
      }
      
      override public function destroy() : void
      {
         _textField = null;
         super.destroy();
      }
      
      public function setFormat(param1:String = null, param2:Number = 8, param3:uint = 16777215, param4:String = null, param5:uint = 0) : FlxText
      {
         if(param1 == null)
         {
            var param1:String = "";
         }
         var _loc6_:TextFormat = dtfCopy();
         _loc6_.font = param1;
         _loc6_.size = param2;
         _loc6_.color = param3;
         _loc6_.align = param4;
         _textField.defaultTextFormat = _loc6_;
         _textField.setTextFormat(_loc6_);
         _shadow = param5;
         _regen = true;
         calcFrame();
         return this;
      }
      
      public function get text() : String
      {
         return _textField.text;
      }
      
      public function set text(param1:String) : void
      {
         var _loc2_:String = _textField.text;
         _textField.text = param1;
         if(_textField.text != _loc2_)
         {
            _regen = true;
            calcFrame();
         }
      }
      
      public function get size() : Number
      {
         return _textField.defaultTextFormat.size as Number;
      }
      
      public function set size(param1:Number) : void
      {
         var _loc2_:TextFormat = dtfCopy();
         _loc2_.size = param1;
         _textField.defaultTextFormat = _loc2_;
         _textField.setTextFormat(_loc2_);
         _regen = true;
         calcFrame();
      }
      
      override public function get color() : uint
      {
         return _textField.defaultTextFormat.color as uint;
      }
      
      override public function set color(param1:uint) : void
      {
         var _loc2_:TextFormat = dtfCopy();
         _loc2_.color = param1;
         _textField.defaultTextFormat = _loc2_;
         _textField.setTextFormat(_loc2_);
         _regen = true;
         calcFrame();
      }
      
      public function get font() : String
      {
         return _textField.defaultTextFormat.font;
      }
      
      public function set font(param1:String) : void
      {
         var _loc2_:TextFormat = dtfCopy();
         _loc2_.font = param1;
         _textField.defaultTextFormat = _loc2_;
         _textField.setTextFormat(_loc2_);
         _regen = true;
         calcFrame();
      }
      
      public function get alignment() : String
      {
         return _textField.defaultTextFormat.align;
      }
      
      public function set alignment(param1:String) : void
      {
         var _loc2_:TextFormat = dtfCopy();
         _loc2_.align = param1;
         _textField.defaultTextFormat = _loc2_;
         _textField.setTextFormat(_loc2_);
         calcFrame();
      }
      
      public function get shadow() : uint
      {
         return _shadow;
      }
      
      public function set shadow(param1:uint) : void
      {
         _shadow = param1;
         calcFrame();
      }
      
      override protected function calcFrame() : void
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc2_:* = null;
         var _loc1_:* = null;
         if(_regen)
         {
            _loc3_ = 0;
            _loc4_ = _textField.numLines;
            height = 0;
            while(_loc3_ < _loc4_)
            {
               height = §§dup().height + _textField.getLineMetrics(_loc3_++).height;
            }
            height = §§dup().height + 4;
            _pixels = new BitmapData(width,height,true,0);
            frameHeight = height;
            _textField.height = height * 1.2;
            _flashRect.x = 0;
            _flashRect.y = 0;
            _flashRect.width = width;
            _flashRect.height = height;
            _regen = false;
         }
         else
         {
            _pixels.fillRect(_flashRect,0);
         }
         if(_textField != null && _textField.text != null && _textField.text.length > 0)
         {
            _loc2_ = _textField.defaultTextFormat;
            _loc1_ = _loc2_;
            _matrix.identity();
            if(_loc2_.align == "center" && _textField.numLines == 1)
            {
               _loc1_ = new TextFormat(_loc2_.font,_loc2_.size,_loc2_.color,null,null,null,null,null,"left");
               _textField.setTextFormat(_loc1_);
               _matrix.translate(Math.floor((width - _textField.getLineMetrics(0).width) / 2),0);
            }
            if(_shadow > 0)
            {
               _textField.setTextFormat(new TextFormat(_loc1_.font,_loc1_.size,_shadow,null,null,null,null,null,_loc1_.align));
               _matrix.translate(1,1);
               _pixels.draw(_textField,_matrix,_colorTransform);
               _matrix.translate(-1,-1);
               _textField.setTextFormat(new TextFormat(_loc1_.font,_loc1_.size,_loc1_.color,null,null,null,null,null,_loc1_.align));
            }
            _pixels.draw(_textField,_matrix,_colorTransform);
            _textField.setTextFormat(new TextFormat(_loc2_.font,_loc2_.size,_loc2_.color,null,null,null,null,null,_loc2_.align));
         }
         if(framePixels == null || framePixels.width != _pixels.width || framePixels.height != _pixels.height)
         {
            framePixels = new BitmapData(_pixels.width,_pixels.height,true,0);
         }
         framePixels.copyPixels(_pixels,_flashRect,_flashPointZero);
      }
      
      protected function dtfCopy() : TextFormat
      {
         var _loc1_:TextFormat = _textField.defaultTextFormat;
         return new TextFormat(_loc1_.font,_loc1_.size,_loc1_.color,_loc1_.bold,_loc1_.italic,_loc1_.underline,_loc1_.url,_loc1_.target,_loc1_.align);
      }
   }
}
