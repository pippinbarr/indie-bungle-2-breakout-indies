package org.flixel
{
   import org.flixel.plugin.DebugPathDisplay;
   import flash.display.Graphics;
   
   public class FlxPath
   {
       
      public var nodes:Array;
      
      public var debugColor:uint;
      
      public var debugScrollFactor:org.flixel.FlxPoint;
      
      public var ignoreDrawDebug:Boolean;
      
      protected var _point:org.flixel.FlxPoint;
      
      public function FlxPath(param1:Array = null)
      {
         super();
         if(param1 == null)
         {
            nodes = [];
         }
         else
         {
            nodes = param1;
         }
         _point = new org.flixel.FlxPoint();
         debugScrollFactor = new org.flixel.FlxPoint(1,1);
         debugColor = 16777215;
         ignoreDrawDebug = false;
         var _loc2_:DebugPathDisplay = manager;
         if(_loc2_ != null)
         {
            _loc2_.add(this);
         }
      }
      
      public static function get manager() : DebugPathDisplay
      {
         return FlxG.getPlugin(DebugPathDisplay) as DebugPathDisplay;
      }
      
      public function destroy() : void
      {
         var _loc1_:DebugPathDisplay = manager;
         if(_loc1_ != null)
         {
            _loc1_.remove(this);
         }
         debugScrollFactor = null;
         _point = null;
         nodes = null;
      }
      
      public function add(param1:Number, param2:Number) : void
      {
         nodes.push(new org.flixel.FlxPoint(param1,param2));
      }
      
      public function addAt(param1:Number, param2:Number, param3:uint) : void
      {
         if(param3 > nodes.length)
         {
            var param3:uint = nodes.length;
         }
         nodes.splice(param3,0,new org.flixel.FlxPoint(param1,param2));
      }
      
      public function addPoint(param1:org.flixel.FlxPoint, param2:Boolean = false) : void
      {
         if(param2)
         {
            nodes.push(param1);
         }
         else
         {
            nodes.push(new org.flixel.FlxPoint(param1.x,param1.y));
         }
      }
      
      public function addPointAt(param1:org.flixel.FlxPoint, param2:uint, param3:Boolean = false) : void
      {
         if(param2 > nodes.length)
         {
            var param2:uint = nodes.length;
         }
         if(param3)
         {
            nodes.splice(param2,0,param1);
         }
         else
         {
            nodes.splice(param2,0,new org.flixel.FlxPoint(param1.x,param1.y));
         }
      }
      
      public function remove(param1:org.flixel.FlxPoint) : org.flixel.FlxPoint
      {
         var _loc2_:int = nodes.indexOf(param1);
         if(_loc2_ >= 0)
         {
            return nodes.splice(_loc2_,1)[0];
         }
         return null;
      }
      
      public function removeAt(param1:uint) : org.flixel.FlxPoint
      {
         if(nodes.length <= 0)
         {
            return null;
         }
         if(param1 >= nodes.length)
         {
            var param1:uint = nodes.length - 1;
         }
         return nodes.splice(param1,1)[0];
      }
      
      public function head() : org.flixel.FlxPoint
      {
         if(nodes.length > 0)
         {
            return nodes[0];
         }
         return null;
      }
      
      public function tail() : org.flixel.FlxPoint
      {
         if(nodes.length > 0)
         {
            return nodes[nodes.length - 1];
         }
         return null;
      }
      
      public function drawDebug(param1:FlxCamera = null) : void
      {
         var _loc3_:* = null;
         var _loc5_:* = null;
         var _loc4_:* = 0;
         var _loc6_:* = 0;
         var _loc2_:* = NaN;
         if(nodes.length <= 0)
         {
            return;
         }
         if(param1 == null)
         {
            var param1:FlxCamera = FlxG.camera;
         }
         var _loc7_:Graphics = FlxG.flashGfx;
         _loc7_.clear();
         var _loc8_:uint = 0;
         var _loc9_:uint = nodes.length;
         while(_loc8_ < _loc9_)
         {
            _loc3_ = nodes[_loc8_] as org.flixel.FlxPoint;
            _point.x = _loc3_.x - param1.scroll.x * debugScrollFactor.x;
            _point.y = _loc3_.y - param1.scroll.y * debugScrollFactor.y;
            _point.x = _point.x + (_point.x > 0?1.0E-7:-1.0E-7);
            _point.y = _point.y + (_point.y > 0?1.0E-7:-1.0E-7);
            _loc4_ = 2;
            if(_loc8_ == 0 || _loc8_ == _loc9_ - 1)
            {
               _loc4_ = _loc4_ * 2;
            }
            _loc6_ = debugColor;
            if(_loc9_ > 1)
            {
               if(_loc8_ == 0)
               {
                  _loc6_ = 4278252069;
               }
               else if(_loc8_ == _loc9_ - 1)
               {
                  _loc6_ = 4294901778;
               }
            }
            _loc7_.beginFill(_loc6_,0.5);
            _loc7_.lineStyle();
            _loc7_.drawRect(_point.x - _loc4_ * 0.5,_point.y - _loc4_ * 0.5,_loc4_,_loc4_);
            _loc7_.endFill();
            _loc2_ = 0.3;
            if(_loc8_ < _loc9_ - 1)
            {
               _loc5_ = nodes[_loc8_ + 1];
            }
            else
            {
               _loc5_ = nodes[0];
               _loc2_ = 0.15;
            }
            _loc7_.moveTo(_point.x,_point.y);
            _loc7_.lineStyle(1,debugColor,_loc2_);
            _point.x = _loc5_.x - param1.scroll.x * debugScrollFactor.x;
            _point.y = _loc5_.y - param1.scroll.y * debugScrollFactor.y;
            _point.x = _point.x + (_point.x > 0?1.0E-7:-1.0E-7);
            _point.y = _point.y + (_point.y > 0?1.0E-7:-1.0E-7);
            _loc7_.lineTo(_point.x,_point.y);
            _loc8_++;
         }
         param1.buffer.draw(FlxG.flashGfxSprite);
      }
   }
}
