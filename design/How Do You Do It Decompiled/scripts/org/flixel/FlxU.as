package org.flixel
{
   import flash.net.navigateToURL;
   import flash.net.URLRequest;
   import flash.utils.getTimer;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getDefinitionByName;
   
   public class FlxU
   {
       
      public function FlxU()
      {
         super();
      }
      
      public static function openURL(param1:String) : void
      {
      }
      
      public static function abs(param1:Number) : Number
      {
         return param1 > 0?param1:-param1;
      }
      
      public static function floor(param1:Number) : Number
      {
         var _loc2_:Number = param1;
         return param1 > 0?_loc2_:_loc2_ != param1?_loc2_ - 1:_loc2_;
      }
      
      public static function ceil(param1:Number) : Number
      {
         var _loc2_:Number = param1;
         return param1 > 0?_loc2_ != param1?_loc2_ + 1:_loc2_:_loc2_;
      }
      
      public static function round(param1:Number) : Number
      {
         var _loc2_:Number = param1 + (param1 > 0?0.5:-0.5);
         return param1 > 0?_loc2_:_loc2_ != param1?_loc2_ - 1:_loc2_;
      }
      
      public static function min(param1:Number, param2:Number) : Number
      {
         return param1 <= param2?param1:param2;
      }
      
      public static function max(param1:Number, param2:Number) : Number
      {
         return param1 >= param2?param1:param2;
      }
      
      public static function bound(param1:Number, param2:Number, param3:Number) : Number
      {
         var _loc4_:Number = param1 < param2?param2:param1;
         return _loc4_ > param3?param3:_loc4_;
      }
      
      public static function srand(param1:Number) : Number
      {
         return 69621 * param1 * 2147483647 % 2147483647 / 2147483647;
      }
      
      public static function shuffle(param1:Array, param2:uint) : Array
      {
         var _loc3_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:* = null;
         var _loc4_:uint = 0;
         while(_loc4_ < param2)
         {
            _loc3_ = Math.random() * param1.length;
            _loc5_ = Math.random() * param1.length;
            _loc6_ = param1[_loc5_];
            param1[_loc5_] = param1[_loc3_];
            param1[_loc3_] = _loc6_;
            _loc4_++;
         }
         return param1;
      }
      
      public static function getRandom(param1:Array, param2:uint = 0, param3:uint = 0) : Object
      {
         var _loc4_:* = 0;
         if(param1 != null)
         {
            _loc4_ = param3;
            if(_loc4_ == 0 || _loc4_ > param1.length - param2)
            {
               _loc4_ = param1.length - param2;
            }
            if(_loc4_ > 0)
            {
               return param1[param2 + Math.random() * _loc4_];
            }
         }
         return null;
      }
      
      public static function getTicks() : uint
      {
         return getTimer();
      }
      
      public static function formatTicks(param1:uint, param2:uint) : String
      {
         return (param2 - param1) / 1000 + "s";
      }
      
      public static function makeColor(param1:uint, param2:uint, param3:uint, param4:Number = 1.0) : uint
      {
         return ((param4 > 1?param4:param4 * 255) & 255) << 24 | (param1 & 255) << 16 | (param2 & 255) << 8 | param3 & 255;
      }
      
      public static function makeColorFromHSB(param1:Number, param2:Number, param3:Number, param4:Number = 1.0) : uint
      {
         var _loc5_:* = NaN;
         var _loc9_:* = NaN;
         var _loc10_:* = NaN;
         var _loc11_:* = 0;
         var _loc12_:* = NaN;
         var _loc6_:* = NaN;
         var _loc7_:* = NaN;
         var _loc8_:* = NaN;
         if(param2 == 0)
         {
            _loc5_ = param3;
            _loc9_ = param3;
            _loc10_ = param3;
         }
         else
         {
            if(param1 == 360)
            {
               var param1:* = 0.0;
            }
            _loc11_ = param1 / 60;
            _loc12_ = param1 / 60 - _loc11_;
            _loc6_ = param3 * (1 - param2);
            _loc7_ = param3 * (1 - param2 * _loc12_);
            _loc8_ = param3 * (1 - param2 * (1 - _loc12_));
            switch(_loc11_)
            {
               case 0:
                  _loc5_ = param3;
                  _loc9_ = _loc8_;
                  _loc10_ = _loc6_;
                  break;
               case 1:
                  _loc5_ = _loc7_;
                  _loc9_ = param3;
                  _loc10_ = _loc6_;
                  break;
               case 2:
                  _loc5_ = _loc6_;
                  _loc9_ = param3;
                  _loc10_ = _loc8_;
                  break;
               case 3:
                  _loc5_ = _loc6_;
                  _loc9_ = _loc7_;
                  _loc10_ = param3;
                  break;
               case 4:
                  _loc5_ = _loc8_;
                  _loc9_ = _loc6_;
                  _loc10_ = param3;
                  break;
               case 5:
                  _loc5_ = param3;
                  _loc9_ = _loc6_;
                  _loc10_ = _loc7_;
                  break;
               default:
                  _loc5_ = 0.0;
                  _loc9_ = 0.0;
                  _loc10_ = 0.0;
            }
         }
         return ((param4 > 1?param4:param4 * 255) & 255) << 24 | _loc5_ * 255 << 16 | _loc9_ * 255 << 8 | _loc10_ * 255;
      }
      
      public static function getRGBA(param1:uint, param2:Array = null) : Array
      {
         if(param2 == null)
         {
            var param2:Array = [];
         }
         param2[0] = param1 >> 16 & 255;
         param2[1] = param1 >> 8 & 255;
         param2[2] = param1 & 255;
         param2[3] = (param1 >> 24 & 255) / 255;
         return param2;
      }
      
      public static function getHSB(param1:uint, param2:Array = null) : Array
      {
         if(param2 == null)
         {
            var param2:Array = [];
         }
         var _loc3_:Number = (param1 >> 16 & 255) / 255;
         var _loc5_:Number = (param1 >> 8 & 255) / 255;
         var _loc6_:Number = (param1 & 255) / 255;
         var _loc8_:Number = _loc3_ > _loc5_?_loc3_:_loc5_;
         var _loc9_:Number = _loc8_ > _loc6_?_loc8_:_loc6_;
         _loc8_ = _loc3_ > _loc5_?_loc5_:_loc3_;
         var _loc4_:Number = _loc8_ > _loc6_?_loc6_:_loc8_;
         var _loc7_:Number = _loc9_ - _loc4_;
         param2[2] = _loc9_;
         param2[1] = 0;
         param2[0] = 0;
         if(_loc9_ != 0)
         {
            param2[1] = _loc7_ / _loc9_;
         }
         if(param2[1] != 0)
         {
            if(_loc3_ == _loc9_)
            {
               param2[0] = (_loc5_ - _loc6_) / _loc7_;
            }
            else if(_loc5_ == _loc9_)
            {
               param2[0] = 2 + (_loc6_ - _loc3_) / _loc7_;
            }
            else if(_loc6_ == _loc9_)
            {
               param2[0] = 4 + (_loc3_ - _loc5_) / _loc7_;
            }
            var _loc10_:* = 0;
            var _loc11_:* = param2[_loc10_] * 60;
            param2[_loc10_] = _loc11_;
            if(param2[0] < 0)
            {
               _loc11_ = 0;
               _loc10_ = param2[_loc11_] + 360;
               param2[_loc11_] = _loc10_;
            }
         }
         param2[3] = (param1 >> 24 & 255) / 255;
         return param2;
      }
      
      public static function formatTime(param1:Number, param2:Boolean = false) : String
      {
         var _loc4_:String = param1 / 60 + ":";
         var _loc3_:int = param1 % 60;
         if(_loc3_ < 10)
         {
            _loc4_ = _loc4_ + "0";
         }
         _loc4_ = _loc4_ + _loc3_;
         if(param2)
         {
            _loc4_ = _loc4_ + ".";
            _loc3_ = (param1 - param1) * 100;
            if(_loc3_ < 10)
            {
               _loc4_ = _loc4_ + "0";
            }
            _loc4_ = _loc4_ + _loc3_;
         }
         return _loc4_;
      }
      
      public static function formatArray(param1:Array) : String
      {
         if(param1 == null || param1.length <= 0)
         {
            return "";
         }
         var _loc2_:String = param1[0].toString();
         var _loc3_:uint = 0;
         var _loc4_:uint = param1.length;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = _loc2_ + (", " + param1[_loc3_++].toString());
         }
         return _loc2_;
      }
      
      public static function formatMoney(param1:Number, param2:Boolean = true, param3:Boolean = true) : String
      {
         var _loc7_:* = 0;
         var _loc4_:int = param1;
         var _loc8_:String = "";
         var _loc5_:String = "";
         var _loc6_:String = "";
         while(_loc4_ > 0)
         {
            if(_loc8_.length > 0 && _loc5_.length <= 0)
            {
               if(param3)
               {
                  _loc5_ = ",";
               }
               else
               {
                  _loc5_ = ".";
               }
            }
            _loc6_ = "";
            _loc7_ = _loc4_ - _loc4_ / 1000 * 1000;
            _loc4_ = _loc4_ / 1000;
            if(_loc4_ > 0)
            {
               if(_loc7_ < 100)
               {
                  _loc6_ = _loc6_ + "0";
               }
               if(_loc7_ < 10)
               {
                  _loc6_ = _loc6_ + "0";
               }
            }
            _loc8_ = _loc6_ + _loc7_ + _loc5_ + _loc8_;
         }
         if(param2)
         {
            _loc4_ = param1 * 100 - param1 * 100;
            _loc8_ = _loc8_ + ((param3?".":",") + _loc4_);
            if(_loc4_ < 10)
            {
               _loc8_ = _loc8_ + "0";
            }
         }
         return _loc8_;
      }
      
      public static function getClassName(param1:Object, param2:Boolean = false) : String
      {
         var _loc3_:String = getQualifiedClassName(param1);
         _loc3_ = _loc3_.replace("::",".");
         if(param2)
         {
            _loc3_ = _loc3_.substr(_loc3_.lastIndexOf(".") + 1);
         }
         return _loc3_;
      }
      
      public static function compareClassNames(param1:Object, param2:Object) : Boolean
      {
         return getQualifiedClassName(param1) == getQualifiedClassName(param2);
      }
      
      public static function getClass(param1:String) : Class
      {
         return getDefinitionByName(param1) as Class;
      }
      
      public static function computeVelocity(param1:Number, param2:Number = 0, param3:Number = 0, param4:Number = 10000) : Number
      {
         var _loc5_:* = NaN;
         if(param2 != 0)
         {
            var param1:Number = param1 + param2 * FlxG.elapsed;
         }
         else if(param3 != 0)
         {
            _loc5_ = param3 * FlxG.elapsed;
            if(param1 - _loc5_ > 0)
            {
               param1 = param1 - _loc5_;
            }
            else if(param1 + _loc5_ < 0)
            {
               param1 = param1 + _loc5_;
            }
            else
            {
               param1 = 0.0;
            }
         }
         if(param1 != 0 && param4 != 10000)
         {
            if(param1 > param4)
            {
               param1 = param4;
            }
            else if(param1 < -param4)
            {
               param1 = -param4;
            }
         }
         return param1;
      }
      
      public static function rotatePoint(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:FlxPoint = null) : FlxPoint
      {
         var _loc10_:* = 0.0;
         var _loc9_:* = 0.0;
         var _loc11_:Number = param5 * -0.017453293;
         while(_loc11_ < -3.14159265)
         {
            _loc11_ = _loc11_ + 6.28318531;
         }
         while(_loc11_ > 3.14159265)
         {
            _loc11_ = _loc11_ - 6.28318531;
         }
         if(_loc11_ < 0)
         {
            _loc10_ = 1.27323954 * _loc11_ + 0.405284735 * _loc11_ * _loc11_;
            if(_loc10_ < 0)
            {
               _loc10_ = 0.225 * (_loc10_ * -_loc10_ - _loc10_) + _loc10_;
            }
            else
            {
               _loc10_ = 0.225 * (_loc10_ * _loc10_ - _loc10_) + _loc10_;
            }
         }
         else
         {
            _loc10_ = 1.27323954 * _loc11_ - 0.405284735 * _loc11_ * _loc11_;
            if(_loc10_ < 0)
            {
               _loc10_ = 0.225 * (_loc10_ * -_loc10_ - _loc10_) + _loc10_;
            }
            else
            {
               _loc10_ = 0.225 * (_loc10_ * _loc10_ - _loc10_) + _loc10_;
            }
         }
         _loc11_ = _loc11_ + 1.57079632;
         if(_loc11_ > 3.14159265)
         {
            _loc11_ = _loc11_ - 6.28318531;
         }
         if(_loc11_ < 0)
         {
            _loc9_ = 1.27323954 * _loc11_ + 0.405284735 * _loc11_ * _loc11_;
            if(_loc9_ < 0)
            {
               _loc9_ = 0.225 * (_loc9_ * -_loc9_ - _loc9_) + _loc9_;
            }
            else
            {
               _loc9_ = 0.225 * (_loc9_ * _loc9_ - _loc9_) + _loc9_;
            }
         }
         else
         {
            _loc9_ = 1.27323954 * _loc11_ - 0.405284735 * _loc11_ * _loc11_;
            if(_loc9_ < 0)
            {
               _loc9_ = 0.225 * (_loc9_ * -_loc9_ - _loc9_) + _loc9_;
            }
            else
            {
               _loc9_ = 0.225 * (_loc9_ * _loc9_ - _loc9_) + _loc9_;
            }
         }
         var _loc7_:Number = param1 - param3;
         var _loc8_:Number = param4 + param2;
         if(param6 == null)
         {
            var param6:FlxPoint = new FlxPoint();
         }
         param6.x = param3 + _loc9_ * _loc7_ - _loc10_ * _loc8_;
         param6.y = param4 - _loc10_ * _loc7_ - _loc9_ * _loc8_;
         return param6;
      }
      
      public static function getAngle(param1:FlxPoint, param2:FlxPoint) : Number
      {
         var _loc3_:Number = param2.x - param1.x;
         var _loc5_:Number = param2.y - param1.y;
         if(_loc3_ == 0 && _loc5_ == 0)
         {
            return 0;
         }
         var _loc7_:* = 0.7853981625;
         var _loc8_:Number = 3 * _loc7_;
         var _loc4_:Number = _loc5_ < 0?-_loc5_:_loc5_;
         var _loc6_:* = 0.0;
         if(_loc3_ >= 0)
         {
            _loc6_ = _loc7_ - _loc7_ * (_loc3_ - _loc4_) / (_loc3_ + _loc4_);
         }
         else
         {
            _loc6_ = _loc8_ - _loc7_ * (_loc3_ + _loc4_) / (_loc4_ - _loc3_);
         }
         _loc6_ = (_loc5_ < 0?-_loc6_:_loc6_) * 57.2957796;
         if(_loc6_ > 90)
         {
            _loc6_ = _loc6_ - 270;
         }
         else
         {
            _loc6_ = _loc6_ + 90;
         }
         return _loc6_;
      }
      
      public static function getDistance(param1:FlxPoint, param2:FlxPoint) : Number
      {
         var _loc3_:Number = param1.x - param2.x;
         var _loc4_:Number = param1.y - param2.y;
         return Math.sqrt(_loc3_ * _loc3_ + _loc4_ * _loc4_);
      }
   }
}
