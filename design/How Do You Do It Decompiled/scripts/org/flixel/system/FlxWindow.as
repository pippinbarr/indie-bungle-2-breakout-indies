package org.flixel.system
{
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.display.Bitmap;
   import flash.text.TextField;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.flixel.FlxU;
   import flash.display.BitmapData;
   import flash.text.TextFormat;
   
   public class FlxWindow extends Sprite
   {
       
      protected var ImgHandle:Class;
      
      public var minSize:Point;
      
      public var maxSize:Point;
      
      protected var _width:uint;
      
      protected var _height:uint;
      
      protected var _bounds:Rectangle;
      
      protected var _background:Bitmap;
      
      protected var _header:Bitmap;
      
      protected var _shadow:Bitmap;
      
      protected var _title:TextField;
      
      protected var _handle:Bitmap;
      
      protected var _overHeader:Boolean;
      
      protected var _overHandle:Boolean;
      
      protected var _drag:Point;
      
      protected var _dragging:Boolean;
      
      protected var _resizing:Boolean;
      
      protected var _resizable:Boolean;
      
      public function FlxWindow(param1:String, param2:Number, param3:Number, param4:Boolean = true, param5:Rectangle = null, param6:uint = 2139062143, param7:uint = 2130706432)
      {
         ImgHandle = handle_png$2ee5f4f542955fbec247a7730c69801d1302644430;
         super();
         _width = param2;
         _height = param3;
         _bounds = param5;
         minSize = new Point(50,30);
         if(_bounds != null)
         {
            maxSize = new Point(_bounds.width,_bounds.height);
         }
         else
         {
            maxSize = new Point(1.7976931348623157E308,1.7976931348623157E308);
         }
         _drag = new Point();
         _resizable = param4;
         _shadow = new Bitmap(new BitmapData(1,2,true,4.27819008E9));
         addChild(_shadow);
         _background = new Bitmap(new BitmapData(1,1,true,param6));
         _background.y = 15;
         addChild(_background);
         _header = new Bitmap(new BitmapData(1,15,true,param7));
         addChild(_header);
         _title = new TextField();
         _title.x = 2;
         _title.height = 16;
         _title.selectable = false;
         _title.multiline = false;
         _title.defaultTextFormat = new TextFormat("Courier",12,16777215);
         _title.text = param1;
         addChild(_title);
         if(_resizable)
         {
            _handle = new ImgHandle();
            addChild(_handle);
         }
         if(_width != 0 || _height != 0)
         {
            updateSize();
         }
         bound();
         addEventListener("enterFrame",init);
      }
      
      public function destroy() : void
      {
         minSize = null;
         maxSize = null;
         _bounds = null;
         removeChild(_shadow);
         _shadow = null;
         removeChild(_background);
         _background = null;
         removeChild(_header);
         _header = null;
         removeChild(_title);
         _title = null;
         if(_handle != null)
         {
            removeChild(_handle);
         }
         _handle = null;
         _drag = null;
      }
      
      public function resize(param1:Number, param2:Number) : void
      {
         _width = param1;
         _height = param2;
         updateSize();
      }
      
      public function reposition(param1:Number, param2:Number) : void
      {
         x = param1;
         y = param2;
         bound();
      }
      
      protected function init(param1:Event = null) : void
      {
         if(root == null)
         {
            return;
         }
         removeEventListener("enterFrame",init);
         stage.addEventListener("mouseMove",onMouseMove);
         stage.addEventListener("mouseDown",onMouseDown);
         stage.addEventListener("mouseUp",onMouseUp);
      }
      
      protected function onMouseMove(param1:MouseEvent = null) : void
      {
         if(_dragging)
         {
            _overHeader = true;
            reposition(parent.mouseX - _drag.x,parent.mouseY - _drag.y);
         }
         else if(_resizing)
         {
            _overHandle = true;
            resize(mouseX - _drag.x,mouseY - _drag.y);
         }
         else if(mouseX >= 0 && mouseX <= _width && mouseY >= 0 && mouseY <= _height)
         {
            _overHeader = mouseX <= _header.width && mouseY <= _header.height;
            if(_resizable)
            {
               _overHandle = mouseX >= _width - _handle.width && mouseY >= _height - _handle.height;
            }
         }
         else
         {
            _overHeader = false;
            _overHandle = false;
         }
         updateGUI();
      }
      
      protected function onMouseDown(param1:MouseEvent = null) : void
      {
         if(_overHeader)
         {
            _dragging = true;
            _drag.x = mouseX;
            _drag.y = mouseY;
         }
         else if(_overHandle)
         {
            _resizing = true;
            _drag.x = _width - mouseX;
            _drag.y = _height - mouseY;
         }
      }
      
      protected function onMouseUp(param1:MouseEvent = null) : void
      {
         _dragging = false;
         _resizing = false;
      }
      
      protected function bound() : void
      {
         if(_bounds != null)
         {
            x = FlxU.bound(x,_bounds.left,_bounds.right - _width);
            y = FlxU.bound(y,_bounds.top,_bounds.bottom - _height);
         }
      }
      
      protected function updateSize() : void
      {
         _width = FlxU.bound(_width,minSize.x,maxSize.x);
         _height = FlxU.bound(_height,minSize.y,maxSize.y);
         _header.scaleX = _width;
         _background.scaleX = _width;
         _background.scaleY = _height - 15;
         _shadow.scaleX = _width;
         _shadow.y = _height;
         _title.width = _width - 4;
         if(_resizable)
         {
            _handle.x = _width - _handle.width;
            _handle.y = _height - _handle.height;
         }
      }
      
      protected function updateGUI() : void
      {
         if(_overHeader || _overHandle)
         {
            if(_title.alpha != 1)
            {
               _title.alpha = 1;
            }
         }
         else if(_title.alpha != 0.65)
         {
            _title.alpha = 0.65;
         }
      }
   }
}
