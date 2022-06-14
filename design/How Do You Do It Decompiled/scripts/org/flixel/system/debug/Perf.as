package org.flixel.system.debug
{
   import org.flixel.system.FlxWindow;
   import flash.text.TextField;
   import flash.utils.getTimer;
   import org.flixel.FlxG;
   import flash.system.System;
   import flash.geom.Rectangle;
   import flash.text.TextFormat;
   
   public class Perf extends FlxWindow
   {
       
      protected var _text:TextField;
      
      protected var _lastTime:int;
      
      protected var _updateTimer:int;
      
      protected var _flixelUpdate:Array;
      
      protected var _flixelUpdateMarker:uint;
      
      protected var _flixelDraw:Array;
      
      protected var _flixelDrawMarker:uint;
      
      protected var _flash:Array;
      
      protected var _flashMarker:uint;
      
      protected var _activeObject:Array;
      
      protected var _objectMarker:uint;
      
      protected var _visibleObject:Array;
      
      protected var _visibleObjectMarker:uint;
      
      public function Perf(param1:String, param2:Number, param3:Number, param4:Boolean = true, param5:Rectangle = null, param6:uint = 2139062143, param7:uint = 2130706432)
      {
         super(param1,param2,param3,param4,param5,param6,param7);
         resize(90,66);
         _lastTime = 0;
         _updateTimer = 0;
         _text = new TextField();
         _text.width = _width;
         _text.x = 2;
         _text.y = 15;
         _text.multiline = true;
         _text.wordWrap = true;
         _text.selectable = true;
         _text.defaultTextFormat = new TextFormat("Courier",12,16777215);
         addChild(_text);
         _flixelUpdate = new Array(32);
         _flixelUpdateMarker = 0;
         _flixelDraw = new Array(32);
         _flixelDrawMarker = 0;
         _flash = new Array(32);
         _flashMarker = 0;
         _activeObject = new Array(32);
         _objectMarker = 0;
         _visibleObject = new Array(32);
         _visibleObjectMarker = 0;
      }
      
      override public function destroy() : void
      {
         removeChild(_text);
         _text = null;
         _flixelUpdate = null;
         _flixelDraw = null;
         _flash = null;
         _activeObject = null;
         _visibleObject = null;
         super.destroy();
      }
      
      public function update() : void
      {
         var _loc8_:* = 0;
         var _loc2_:* = null;
         var _loc5_:* = NaN;
         var _loc9_:* = 0;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc7_:* = 0;
         var _loc11_:* = 0;
         var _loc10_:int = getTimer();
         var _loc1_:int = _loc10_ - _lastTime;
         var _loc6_:uint = 500;
         if(_loc1_ > _loc6_)
         {
            _loc1_ = _loc6_;
         }
         _lastTime = _loc10_;
         _updateTimer = §§dup()._updateTimer + _loc1_;
         if(_updateTimer > _loc6_)
         {
            _loc2_ = "";
            _loc5_ = 0.0;
            _loc8_ = 0;
            while(_loc8_ < _flashMarker)
            {
               _loc5_ = _loc5_ + _flash[_loc8_++];
            }
            _loc5_ = _loc5_ / _flashMarker;
            _loc2_ = _loc2_ + (1 / (_loc5_ / 1000) + "/" + FlxG.flashFramerate + "fps\n");
            _loc2_ = _loc2_ + ((System.totalMemory * 9.54E-7).toFixed(2) + "MB\n");
            _loc9_ = 0;
            _loc8_ = 0;
            while(_loc8_ < _flixelUpdateMarker)
            {
               _loc9_ = _loc9_ + _flixelUpdate[_loc8_++];
            }
            _loc3_ = 0;
            _loc4_ = 0;
            _loc8_ = 0;
            while(_loc8_ < _objectMarker)
            {
               _loc3_ = _loc3_ + _activeObject[_loc8_];
               _loc11_ = _loc11_ + _visibleObject[_loc8_++];
            }
            _loc3_ = _loc3_ / _objectMarker;
            _loc2_ = _loc2_ + ("U:" + _loc3_ + " " + _loc9_ / _flixelDrawMarker + "ms\n");
            _loc7_ = 0;
            _loc8_ = 0;
            while(_loc8_ < _flixelDrawMarker)
            {
               _loc7_ = _loc7_ + _flixelDraw[_loc8_++];
            }
            _loc11_ = 0;
            _loc8_ = 0;
            while(_loc8_ < _visibleObjectMarker)
            {
               _loc11_ = _loc11_ + _visibleObject[_loc8_++];
            }
            _loc11_ = _loc11_ / _visibleObjectMarker;
            _loc2_ = _loc2_ + ("D:" + _loc11_ + " " + _loc7_ / _flixelDrawMarker + "ms");
            _text.text = _loc2_;
            _flixelUpdateMarker = 0;
            _flixelDrawMarker = 0;
            _flashMarker = 0;
            _objectMarker = 0;
            _visibleObjectMarker = 0;
            _updateTimer = §§dup()._updateTimer - _loc6_;
         }
      }
      
      public function flixelUpdate(param1:int) : void
      {
         _flixelUpdateMarker = §§dup(_flixelUpdateMarker) + 1;
         _flixelUpdate[_flixelUpdateMarker] = param1;
      }
      
      public function flixelDraw(param1:int) : void
      {
         _flixelDrawMarker = §§dup(_flixelDrawMarker) + 1;
         _flixelDraw[_flixelDrawMarker] = param1;
      }
      
      public function flash(param1:int) : void
      {
         _flashMarker = §§dup(_flashMarker) + 1;
         _flash[_flashMarker] = param1;
      }
      
      public function activeObjects(param1:int) : void
      {
         _objectMarker = §§dup(_objectMarker) + 1;
         _activeObject[_objectMarker] = param1;
      }
      
      public function visibleObjects(param1:int) : void
      {
         _visibleObjectMarker = §§dup(_visibleObjectMarker) + 1;
         _visibleObject[_visibleObjectMarker] = param1;
      }
   }
}
