package org.flixel
{
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import org.flixel.system.FlxTile;
   import org.flixel.system.FlxTilemapBuffer;
   import flash.display.Graphics;
   
   public class FlxTilemap extends FlxObject
   {
      
      public static var ImgAuto:Class = autotiles_png$175ed8cf34e289781a7a5dee40920e8a1402171070;
      
      public static var ImgAutoAlt:Class = §autotiles_alt_png$3e3c40458111039b5126f0c8748eb451-214835696§;
      
      public static const OFF:uint = 0;
      
      public static const AUTO:uint = 1;
      
      public static const ALT:uint = 2;
       
      public var auto:uint;
      
      public var widthInTiles:uint;
      
      public var heightInTiles:uint;
      
      public var totalTiles:uint;
      
      protected var _flashPoint:Point;
      
      protected var _flashRect:Rectangle;
      
      protected var _tiles:BitmapData;
      
      protected var _buffers:Array;
      
      protected var _data:Array;
      
      protected var _rects:Array;
      
      protected var _tileWidth:uint;
      
      protected var _tileHeight:uint;
      
      protected var _tileObjects:Array;
      
      protected var _debugTileNotSolid:BitmapData;
      
      protected var _debugTilePartial:BitmapData;
      
      protected var _debugTileSolid:BitmapData;
      
      protected var _debugRect:Rectangle;
      
      protected var _lastVisualDebug:Boolean;
      
      protected var _startingIndex:uint;
      
      public function FlxTilemap()
      {
         super();
         auto = 0;
         widthInTiles = 0;
         heightInTiles = 0;
         totalTiles = 0;
         _buffers = [];
         _flashPoint = new Point();
         _flashRect = null;
         _data = null;
         _tileWidth = 0;
         _tileHeight = 0;
         _rects = null;
         _tiles = null;
         _tileObjects = null;
         immovable = true;
         cameras = null;
         _debugTileNotSolid = null;
         _debugTilePartial = null;
         _debugTileSolid = null;
         _debugRect = null;
         _lastVisualDebug = FlxG.visualDebug;
         _startingIndex = 0;
      }
      
      public static function arrayToCSV(param1:Array, param2:int, param3:Boolean = false) : String
      {
         var _loc5_:* = 0;
         var _loc4_:* = null;
         var _loc6_:* = 0;
         var _loc8_:uint = 0;
         var _loc7_:int = param1.length / param2;
         while(_loc8_ < _loc7_)
         {
            _loc5_ = 0;
            while(_loc5_ < param2)
            {
               _loc6_ = param1[_loc8_ * param2 + _loc5_];
               if(param3)
               {
                  if(_loc6_ == 0)
                  {
                     _loc6_ = 1;
                  }
                  else if(_loc6_ == 1)
                  {
                     _loc6_ = 0;
                  }
               }
               if(_loc5_ == 0)
               {
                  if(_loc8_ == 0)
                  {
                     _loc4_ = _loc4_ + _loc6_;
                  }
                  else
                  {
                     _loc4_ = _loc4_ + ("\n" + _loc6_);
                  }
               }
               else
               {
                  _loc4_ = _loc4_ + (", " + _loc6_);
               }
               _loc5_++;
            }
            _loc8_++;
         }
         return _loc4_;
      }
      
      public static function bitmapToCSV(param1:BitmapData, param2:Boolean = false, param3:uint = 1) : String
      {
         var _loc5_:* = null;
         var _loc4_:* = null;
         var _loc9_:* = 0;
         var _loc11_:* = 0;
         if(param3 > 1)
         {
            _loc5_ = param1;
            var param1:BitmapData = new BitmapData(param1.width * param3,param1.height * param3);
            _loc4_ = new Matrix();
            _loc4_.scale(param3,param3);
            param1.draw(_loc5_,_loc4_);
         }
         var _loc10_:uint = 0;
         var _loc8_:String = "";
         var _loc6_:uint = param1.width;
         var _loc7_:uint = param1.height;
         while(_loc10_ < _loc7_)
         {
            _loc9_ = 0;
            while(_loc9_ < _loc6_)
            {
               _loc11_ = param1.getPixel(_loc9_,_loc10_);
               if(param2 && _loc11_ > 0 || !param2 && _loc11_ == 0)
               {
                  _loc11_ = 1;
               }
               else
               {
                  _loc11_ = 0;
               }
               if(_loc9_ == 0)
               {
                  if(_loc10_ == 0)
                  {
                     _loc8_ = _loc8_ + _loc11_;
                  }
                  else
                  {
                     _loc8_ = _loc8_ + ("\n" + _loc11_);
                  }
               }
               else
               {
                  _loc8_ = _loc8_ + (", " + _loc11_);
               }
               _loc9_++;
            }
            _loc10_++;
         }
         return _loc8_;
      }
      
      public static function imageToCSV(param1:Class, param2:Boolean = false, param3:uint = 1) : String
      {
         return bitmapToCSV(new param1().bitmapData,param2,param3);
      }
      
      override public function destroy() : void
      {
         _flashPoint = null;
         _flashRect = null;
         _tiles = null;
         var _loc1_:uint = 0;
         var _loc2_:uint = _tileObjects.length;
         while(_loc1_ < _loc2_)
         {
            (_tileObjects[_loc1_++] as FlxTile).destroy();
         }
         _tileObjects = null;
         _loc1_ = 0;
         _loc2_ = _buffers.length;
         while(_loc1_ < _loc2_)
         {
            (_buffers[_loc1_++] as FlxTilemapBuffer).destroy();
         }
         _buffers = null;
         _data = null;
         _rects = null;
         _debugTileNotSolid = null;
         _debugTilePartial = null;
         _debugTileSolid = null;
         _debugRect = null;
         super.destroy();
      }
      
      public function loadMap(param1:String, param2:Class, param3:uint = 0, param4:uint = 0, param5:uint = 0, param6:uint = 0, param7:uint = 1, param8:uint = 1) : FlxTilemap
      {
         var _loc10_:* = null;
         var _loc11_:* = 0;
         var _loc12_:* = 0;
         var _loc9_:* = 0;
         auto = param5;
         _startingIndex = param6;
         var _loc13_:Array = param1.split("\n");
         heightInTiles = _loc13_.length;
         _data = [];
         var _loc15_:uint = 0;
         while(_loc15_ < heightInTiles)
         {
            _loc10_ = _loc13_[_loc15_++].split(",");
            if(_loc10_.length <= 1)
            {
               heightInTiles = heightInTiles - 1;
            }
            else
            {
               if(widthInTiles == 0)
               {
                  widthInTiles = _loc10_.length;
               }
               _loc11_ = 0;
               while(_loc11_ < widthInTiles)
               {
                  _data.push(_loc10_[_loc11_++]);
               }
            }
         }
         totalTiles = widthInTiles * heightInTiles;
         if(auto > 0)
         {
            _startingIndex = 1;
            var param7:uint = 1;
            var param8:uint = 1;
            _loc12_ = 0;
            while(_loc12_ < totalTiles)
            {
               autoTile(_loc12_++);
            }
         }
         _tiles = FlxG.addBitmap(param2);
         _tileWidth = param3;
         if(_tileWidth == 0)
         {
            _tileWidth = _tiles.height;
         }
         _tileHeight = param4;
         if(_tileHeight == 0)
         {
            _tileHeight = _tileWidth;
         }
         _loc12_ = 0;
         var _loc14_:uint = _tiles.width / _tileWidth * _tiles.height / _tileHeight;
         if(auto > 0)
         {
            _loc14_++;
         }
         _tileObjects = new Array(_loc14_);
         while(_loc12_ < _loc14_)
         {
            _tileObjects[_loc12_] = new FlxTile(this,_loc12_,_tileWidth,_tileHeight,_loc12_ >= param7,_loc12_ >= param8?allowCollisions:0);
            _loc12_++;
         }
         _debugTileNotSolid = makeDebugTile(4278227177);
         _debugTilePartial = makeDebugTile(4293926655);
         _debugTileSolid = makeDebugTile(4278252069);
         _debugRect = new Rectangle(0,0,_tileWidth,_tileHeight);
         width = widthInTiles * _tileWidth;
         height = heightInTiles * _tileHeight;
         _rects = new Array(totalTiles);
         _loc12_ = 0;
         while(_loc12_ < totalTiles)
         {
            updateTile(_loc12_++);
         }
         return this;
      }
      
      protected function makeDebugTile(param1:uint) : BitmapData
      {
         var _loc3_:* = null;
         _loc3_ = new BitmapData(_tileWidth,_tileHeight,true,0);
         var _loc2_:Graphics = FlxG.flashGfx;
         _loc2_.clear();
         _loc2_.moveTo(0,0);
         _loc2_.lineStyle(1,param1,0.5);
         _loc2_.lineTo(_tileWidth - 1,0);
         _loc2_.lineTo(_tileWidth - 1,_tileHeight - 1);
         _loc2_.lineTo(0,_tileHeight - 1);
         _loc2_.lineTo(0,0);
         _loc3_.draw(FlxG.flashGfxSprite);
         return _loc3_;
      }
      
      override public function update() : void
      {
         if(_lastVisualDebug != FlxG.visualDebug)
         {
            _lastVisualDebug = FlxG.visualDebug;
            setDirty();
         }
      }
      
      protected function drawTilemap(param1:FlxTilemapBuffer, param2:FlxCamera) : void
      {
         var _loc4_:* = 0;
         var _loc8_:* = 0;
         var _loc5_:* = null;
         var _loc12_:* = null;
         param1.fill();
         _point.x = param2.scroll.x * scrollFactor.x - x;
         _point.y = param2.scroll.y * scrollFactor.y - y;
         var _loc11_:int = (_point.x + (_point.x > 0?1.0E-7:-1.0E-7)) / _tileWidth;
         var _loc6_:int = (_point.y + (_point.y > 0?1.0E-7:-1.0E-7)) / _tileHeight;
         var _loc9_:uint = param1.rows;
         var _loc3_:uint = param1.columns;
         if(_loc11_ < 0)
         {
            _loc11_ = 0;
         }
         if(_loc11_ > widthInTiles - _loc3_)
         {
            _loc11_ = widthInTiles - _loc3_;
         }
         if(_loc6_ < 0)
         {
            _loc6_ = 0;
         }
         if(_loc6_ > heightInTiles - _loc9_)
         {
            _loc6_ = heightInTiles - _loc9_;
         }
         var _loc7_:int = _loc6_ * widthInTiles + _loc11_;
         _flashPoint.y = 0;
         var _loc10_:uint = 0;
         while(_loc10_ < _loc9_)
         {
            _loc8_ = _loc7_;
            _loc4_ = 0;
            _flashPoint.x = 0;
            while(_loc4_ < _loc3_)
            {
               _flashRect = _rects[_loc8_] as Rectangle;
               if(_flashRect != null)
               {
                  param1.pixels.copyPixels(_tiles,_flashRect,_flashPoint,null,null,true);
                  if(FlxG.visualDebug && !ignoreDrawDebug)
                  {
                     _loc5_ = _tileObjects[_data[_loc8_]];
                     if(_loc5_ != null)
                     {
                        if(_loc5_.allowCollisions <= 0)
                        {
                           _loc12_ = _debugTileNotSolid;
                        }
                        else if(_loc5_.allowCollisions != 4369)
                        {
                           _loc12_ = _debugTilePartial;
                        }
                        else
                        {
                           _loc12_ = _debugTileSolid;
                        }
                        param1.pixels.copyPixels(_loc12_,_debugRect,_flashPoint,null,null,true);
                     }
                  }
               }
               _flashPoint.x = _flashPoint.x + _tileWidth;
               _loc4_++;
               _loc8_++;
            }
            _loc7_ = _loc7_ + widthInTiles;
            _flashPoint.y = _flashPoint.y + _tileHeight;
            _loc10_++;
         }
         param1.x = _loc11_ * _tileWidth;
         param1.y = _loc6_ * _tileHeight;
      }
      
      override public function draw() : void
      {
         var _loc3_:* = null;
         var _loc2_:* = null;
         if(_flickerTimer != 0)
         {
            _flicker = !_flicker;
            if(_flicker)
            {
               return;
            }
         }
         if(cameras == null)
         {
            cameras = FlxG.cameras;
         }
         var _loc1_:uint = 0;
         var _loc4_:uint = cameras.length;
         while(_loc1_ < _loc4_)
         {
            _loc3_ = cameras[_loc1_];
            if(_buffers[_loc1_] == null)
            {
               _buffers[_loc1_] = new FlxTilemapBuffer(_tileWidth,_tileHeight,widthInTiles,heightInTiles,_loc3_);
            }
            _loc2_ = _buffers[_loc1_++] as FlxTilemapBuffer;
            if(!_loc2_.dirty)
            {
               _point.x = x - _loc3_.scroll.x * scrollFactor.x + _loc2_.x;
               _point.y = y - _loc3_.scroll.y * scrollFactor.y + _loc2_.y;
               _loc2_.dirty = _point.x > 0 || _point.y > 0 || _point.x + _loc2_.width < _loc3_.width || _point.y + _loc2_.height < _loc3_.height;
            }
            if(_loc2_.dirty)
            {
               drawTilemap(_loc2_,_loc3_);
               _loc2_.dirty = false;
            }
            _flashPoint.x = x - _loc3_.scroll.x * scrollFactor.x + _loc2_.x;
            _flashPoint.y = y - _loc3_.scroll.y * scrollFactor.y + _loc2_.y;
            _flashPoint.x = _flashPoint.x + (_flashPoint.x > 0?1.0E-7:-1.0E-7);
            _flashPoint.y = _flashPoint.y + (_flashPoint.y > 0?1.0E-7:-1.0E-7);
            _loc2_.draw(_loc3_,_flashPoint);
            _VISIBLECOUNT = _VISIBLECOUNT + 1;
         }
      }
      
      public function getData(param1:Boolean = false) : Array
      {
         if(!param1)
         {
            return _data;
         }
         var _loc3_:uint = 0;
         var _loc4_:uint = _data.length;
         var _loc2_:Array = new Array(_loc4_);
         while(_loc3_ < _loc4_)
         {
            _loc2_[_loc3_] = (_tileObjects[_data[_loc3_]] as FlxTile).allowCollisions > 0?1:0.0;
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function setDirty(param1:Boolean = true) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = _buffers.length;
         while(_loc2_ < _loc3_)
         {
            (_buffers[_loc2_++] as FlxTilemapBuffer).dirty = param1;
         }
      }
      
      public function findPath(param1:FlxPoint, param2:FlxPoint, param3:Boolean = true, param4:Boolean = false) : FlxPath
      {
         var _loc6_:* = null;
         var _loc8_:uint = (param1.y - y) / _tileHeight * widthInTiles + (param1.x - x) / _tileWidth;
         var _loc9_:uint = (param2.y - y) / _tileHeight * widthInTiles + (param2.x - x) / _tileWidth;
         if((_tileObjects[_data[_loc8_]] as FlxTile).allowCollisions > 0 || (_tileObjects[_data[_loc9_]] as FlxTile).allowCollisions > 0)
         {
            return null;
         }
         var _loc5_:Array = computePathDistance(_loc8_,_loc9_);
         if(_loc5_ == null)
         {
            return null;
         }
         var _loc11_:Array = [];
         walkPath(_loc5_,_loc9_,_loc11_);
         _loc6_ = _loc11_[_loc11_.length - 1] as FlxPoint;
         _loc6_.x = param1.x;
         _loc6_.y = param1.y;
         _loc6_ = _loc11_[0] as FlxPoint;
         _loc6_.x = param2.x;
         _loc6_.y = param2.y;
         if(param3)
         {
            simplifyPath(_loc11_);
         }
         if(param4)
         {
            raySimplifyPath(_loc11_);
         }
         var _loc7_:FlxPath = new FlxPath();
         var _loc10_:int = _loc11_.length - 1;
         while(_loc10_ >= 0)
         {
            _loc10_--;
            _loc6_ = _loc11_[_loc10_] as FlxPoint;
            if(_loc6_ != null)
            {
               _loc7_.addPoint(_loc6_,true);
            }
         }
         return _loc7_;
      }
      
      protected function simplifyPath(param1:Array) : void
      {
         var _loc6_:* = NaN;
         var _loc5_:* = NaN;
         var _loc2_:* = null;
         var _loc3_:FlxPoint = param1[0];
         var _loc4_:uint = 1;
         var _loc7_:uint = param1.length - 1;
         while(_loc4_ < _loc7_)
         {
            _loc2_ = param1[_loc4_];
            _loc6_ = (_loc2_.x - _loc3_.x) / (_loc2_.y - _loc3_.y);
            _loc5_ = (_loc2_.x - param1[_loc4_ + 1].x) / (_loc2_.y - param1[_loc4_ + 1].y);
            if(_loc3_.x == param1[_loc4_ + 1].x || _loc3_.y == param1[_loc4_ + 1].y || _loc6_ == _loc5_)
            {
               param1[_loc4_] = null;
            }
            else
            {
               _loc3_ = _loc2_;
            }
            _loc4_++;
         }
      }
      
      protected function raySimplifyPath(param1:Array) : void
      {
         var _loc2_:* = null;
         var _loc4_:FlxPoint = param1[0];
         var _loc5_:* = -1;
         var _loc3_:uint = 1;
         var _loc6_:uint = param1.length;
         while(_loc3_ < _loc6_)
         {
            _loc2_ = param1[_loc3_++];
            if(_loc2_ != null)
            {
               if(ray(_loc4_,_loc2_,_point))
               {
                  if(_loc5_ >= 0)
                  {
                     param1[_loc5_] = null;
                  }
               }
               else
               {
                  _loc4_ = param1[_loc5_];
               }
               _loc5_ = _loc3_ - 1;
            }
         }
      }
      
      protected function computePathDistance(param1:uint, param2:uint) : Array
      {
         var _loc12_:* = null;
         var _loc9_:* = 0;
         var _loc13_:* = false;
         var _loc8_:* = false;
         var _loc16_:* = false;
         var _loc10_:* = false;
         var _loc11_:* = 0;
         var _loc7_:* = 0;
         var _loc4_:uint = widthInTiles * heightInTiles;
         var _loc3_:Array = new Array(_loc4_);
         var _loc6_:* = 0;
         while(_loc6_ < _loc4_)
         {
            if((_tileObjects[_data[_loc6_]] as FlxTile).allowCollisions)
            {
               _loc3_[_loc6_] = -2;
            }
            else
            {
               _loc3_[_loc6_] = -1;
            }
            _loc6_++;
         }
         _loc3_[param1] = 0;
         var _loc5_:uint = 1;
         var _loc14_:Array = [param1];
         var _loc15_:* = false;
         while(_loc14_.length > 0)
         {
            _loc12_ = _loc14_;
            _loc14_ = [];
            _loc6_ = 0;
            _loc11_ = _loc12_.length;
            while(_loc6_ < _loc11_)
            {
               _loc6_++;
               _loc9_ = _loc12_[_loc6_];
               if(_loc9_ == param2)
               {
                  _loc15_ = true;
                  _loc14_.length = 0;
                  break;
               }
               _loc13_ = _loc9_ % widthInTiles > 0;
               _loc8_ = _loc9_ % widthInTiles < widthInTiles - 1;
               _loc16_ = _loc9_ / widthInTiles > 0;
               _loc10_ = _loc9_ / widthInTiles < heightInTiles - 1;
               if(_loc16_)
               {
                  _loc7_ = _loc9_ - widthInTiles;
                  if(_loc3_[_loc7_] == -1)
                  {
                     _loc3_[_loc7_] = _loc5_;
                     _loc14_.push(_loc7_);
                  }
               }
               if(_loc8_)
               {
                  _loc7_ = _loc9_ + 1;
                  if(_loc3_[_loc7_] == -1)
                  {
                     _loc3_[_loc7_] = _loc5_;
                     _loc14_.push(_loc7_);
                  }
               }
               if(_loc10_)
               {
                  _loc7_ = _loc9_ + widthInTiles;
                  if(_loc3_[_loc7_] == -1)
                  {
                     _loc3_[_loc7_] = _loc5_;
                     _loc14_.push(_loc7_);
                  }
               }
               if(_loc13_)
               {
                  _loc7_ = _loc9_ - 1;
                  if(_loc3_[_loc7_] == -1)
                  {
                     _loc3_[_loc7_] = _loc5_;
                     _loc14_.push(_loc7_);
                  }
               }
               if(_loc16_ && _loc8_)
               {
                  _loc7_ = _loc9_ - widthInTiles + 1;
                  if(_loc3_[_loc7_] == -1 && _loc3_[_loc9_ - widthInTiles] >= -1 && _loc3_[_loc9_ + 1] >= -1)
                  {
                     _loc3_[_loc7_] = _loc5_;
                     _loc14_.push(_loc7_);
                  }
               }
               if(_loc8_ && _loc10_)
               {
                  _loc7_ = _loc9_ + widthInTiles + 1;
                  if(_loc3_[_loc7_] == -1 && _loc3_[_loc9_ + widthInTiles] >= -1 && _loc3_[_loc9_ + 1] >= -1)
                  {
                     _loc3_[_loc7_] = _loc5_;
                     _loc14_.push(_loc7_);
                  }
               }
               if(_loc13_ && _loc10_)
               {
                  _loc7_ = _loc9_ + widthInTiles - 1;
                  if(_loc3_[_loc7_] == -1 && _loc3_[_loc9_ + widthInTiles] >= -1 && _loc3_[_loc9_ - 1] >= -1)
                  {
                     _loc3_[_loc7_] = _loc5_;
                     _loc14_.push(_loc7_);
                  }
               }
               if(_loc16_ && _loc13_)
               {
                  _loc7_ = _loc9_ - widthInTiles - 1;
                  if(_loc3_[_loc7_] == -1 && _loc3_[_loc9_ - widthInTiles] >= -1 && _loc3_[_loc9_ - 1] >= -1)
                  {
                     _loc3_[_loc7_] = _loc5_;
                     _loc14_.push(_loc7_);
                  }
               }
            }
            _loc5_++;
         }
         if(!_loc15_)
         {
            _loc3_ = null;
         }
         return _loc3_;
      }
      
      protected function walkPath(param1:Array, param2:uint, param3:Array) : void
      {
         var _loc6_:* = 0;
         param3.push(new FlxPoint(x + param2 % widthInTiles * _tileWidth + _tileWidth * 0.5,y + param2 / widthInTiles * _tileHeight + _tileHeight * 0.5));
         if(param1[param2] == 0)
         {
            return;
         }
         var _loc5_:* = param2 % widthInTiles > 0;
         var _loc7_:* = param2 % widthInTiles < widthInTiles - 1;
         var _loc8_:* = param2 / widthInTiles > 0;
         var _loc9_:* = param2 / widthInTiles < heightInTiles - 1;
         var _loc4_:uint = param1[param2];
         if(_loc8_)
         {
            _loc6_ = param2 - widthInTiles;
            if(param1[_loc6_] >= 0 && param1[_loc6_] < _loc4_)
            {
               walkPath(param1,_loc6_,param3);
               return;
            }
         }
         if(_loc7_)
         {
            _loc6_ = param2 + 1;
            if(param1[_loc6_] >= 0 && param1[_loc6_] < _loc4_)
            {
               walkPath(param1,_loc6_,param3);
               return;
            }
         }
         if(_loc9_)
         {
            _loc6_ = param2 + widthInTiles;
            if(param1[_loc6_] >= 0 && param1[_loc6_] < _loc4_)
            {
               walkPath(param1,_loc6_,param3);
               return;
            }
         }
         if(_loc5_)
         {
            _loc6_ = param2 - 1;
            if(param1[_loc6_] >= 0 && param1[_loc6_] < _loc4_)
            {
               walkPath(param1,_loc6_,param3);
               return;
            }
         }
         if(_loc8_ && _loc7_)
         {
            _loc6_ = param2 - widthInTiles + 1;
            if(param1[_loc6_] >= 0 && param1[_loc6_] < _loc4_)
            {
               walkPath(param1,_loc6_,param3);
               return;
            }
         }
         if(_loc7_ && _loc9_)
         {
            _loc6_ = param2 + widthInTiles + 1;
            if(param1[_loc6_] >= 0 && param1[_loc6_] < _loc4_)
            {
               walkPath(param1,_loc6_,param3);
               return;
            }
         }
         if(_loc5_ && _loc9_)
         {
            _loc6_ = param2 + widthInTiles - 1;
            if(param1[_loc6_] >= 0 && param1[_loc6_] < _loc4_)
            {
               walkPath(param1,_loc6_,param3);
               return;
            }
         }
         if(_loc8_ && _loc5_)
         {
            _loc6_ = param2 - widthInTiles - 1;
            if(param1[_loc6_] >= 0 && param1[_loc6_] < _loc4_)
            {
               walkPath(param1,_loc6_,param3);
               return;
            }
         }
      }
      
      override public function overlaps(param1:FlxBasic, param2:Boolean = false, param3:FlxCamera = null) : Boolean
      {
         var _loc7_:* = false;
         var _loc6_:* = null;
         var _loc5_:* = 0;
         var _loc4_:* = null;
         if(param1 is FlxGroup)
         {
            _loc7_ = false;
            _loc5_ = 0;
            _loc4_ = (param1 as FlxGroup).members;
            while(_loc5_ < 1)
            {
               _loc6_ = _loc4_[_loc5_++] as FlxBasic;
               if(_loc6_ is FlxObject)
               {
                  if(overlapsWithCallback(_loc6_ as FlxObject))
                  {
                     _loc7_ = true;
                  }
               }
               else if(overlaps(_loc6_,param2,param3))
               {
                  _loc7_ = true;
               }
            }
            return _loc7_;
         }
         if(param1 is FlxObject)
         {
            return overlapsWithCallback(param1 as FlxObject);
         }
         return false;
      }
      
      override public function overlapsAt(param1:Number, param2:Number, param3:FlxBasic, param4:Boolean = false, param5:FlxCamera = null) : Boolean
      {
         var _loc9_:* = false;
         var _loc8_:* = null;
         var _loc7_:* = 0;
         var _loc6_:* = null;
         if(param3 is FlxGroup)
         {
            _loc9_ = false;
            _loc7_ = 0;
            _loc6_ = (param3 as FlxGroup).members;
            while(_loc7_ < 1)
            {
               _loc8_ = _loc6_[_loc7_++] as FlxBasic;
               if(_loc8_ is FlxObject)
               {
                  _point.x = param1;
                  _point.y = param2;
                  if(overlapsWithCallback(_loc8_ as FlxObject,null,false,_point))
                  {
                     _loc9_ = true;
                  }
               }
               else if(overlapsAt(param1,param2,_loc8_,param4,param5))
               {
                  _loc9_ = true;
               }
            }
            return _loc9_;
         }
         if(param3 is FlxObject)
         {
            _point.x = param1;
            _point.y = param2;
            return overlapsWithCallback(param3 as FlxObject,null,false,_point);
         }
         return false;
      }
      
      public function overlapsWithCallback(param1:FlxObject, param2:Function = null, param3:Boolean = false, param4:FlxPoint = null) : Boolean
      {
         var _loc7_:* = 0;
         var _loc12_:* = null;
         var _loc9_:* = false;
         var _loc17_:* = false;
         var _loc10_:Number = x;
         var _loc13_:Number = y;
         if(param4 != null)
         {
            _loc10_ = param4.x;
            _loc13_ = param4.y;
         }
         var _loc14_:int = FlxU.floor((param1.x - _loc10_) / _tileWidth);
         var _loc11_:int = FlxU.floor((param1.y - _loc13_) / _tileHeight);
         var _loc18_:uint = _loc14_ + FlxU.ceil(param1.width / _tileWidth) + 1;
         var _loc8_:uint = _loc11_ + FlxU.ceil(param1.height / _tileHeight) + 1;
         if(_loc14_ < 0)
         {
            _loc14_ = 0;
         }
         if(_loc11_ < 0)
         {
            _loc11_ = 0;
         }
         if(_loc18_ > widthInTiles)
         {
            _loc18_ = widthInTiles;
         }
         if(_loc8_ > heightInTiles)
         {
            _loc8_ = heightInTiles;
         }
         var _loc15_:uint = _loc11_ * widthInTiles;
         var _loc16_:uint = _loc11_;
         var _loc5_:Number = _loc10_ - last.x;
         var _loc6_:Number = _loc13_ - last.y;
         while(_loc16_ < _loc8_)
         {
            _loc7_ = _loc14_;
            while(_loc7_ < _loc18_)
            {
               _loc9_ = false;
               _loc12_ = _tileObjects[_data[_loc15_ + _loc7_]] as FlxTile;
               if(_loc12_.allowCollisions)
               {
                  _loc12_.x = _loc10_ + _loc7_ * _tileWidth;
                  _loc12_.y = _loc13_ + _loc16_ * _tileHeight;
                  _loc12_.last.x = _loc12_.x - _loc5_;
                  _loc12_.last.y = _loc12_.y - _loc6_;
                  if(param2 != null)
                  {
                     if(param3)
                     {
                        _loc9_ = param2(param1,_loc12_);
                     }
                     else
                     {
                        _loc9_ = param2(_loc12_,param1);
                     }
                  }
                  else
                  {
                     _loc9_ = param1.x + param1.width > _loc12_.x && param1.x < _loc12_.x + _loc12_.width && param1.y + param1.height > _loc12_.y && param1.y < _loc12_.y + _loc12_.height;
                  }
                  if(_loc9_)
                  {
                     if(_loc12_.callback != null && (_loc12_.filter == null || param1 is _loc12_.filter))
                     {
                        _loc12_.mapIndex = _loc15_ + _loc7_;
                        _loc12_.callback(_loc12_,param1);
                     }
                     _loc17_ = true;
                  }
               }
               else if(_loc12_.callback != null && (_loc12_.filter == null || param1 is _loc12_.filter))
               {
                  _loc12_.mapIndex = _loc15_ + _loc7_;
                  _loc12_.callback(_loc12_,param1);
               }
               _loc7_++;
            }
            _loc15_ = _loc15_ + widthInTiles;
            _loc16_++;
         }
         return _loc17_;
      }
      
      override public function overlapsPoint(param1:FlxPoint, param2:Boolean = false, param3:FlxCamera = null) : Boolean
      {
         if(!param2)
         {
            return (_tileObjects[_data[(param1.y - y) / _tileHeight * widthInTiles + (param1.x - x) / _tileWidth]] as FlxTile).allowCollisions > 0;
         }
         if(param3 == null)
         {
            var param3:FlxCamera = FlxG.camera;
         }
         param1.x = param1.x - param3.scroll.x;
         param1.y = param1.y - param3.scroll.y;
         getScreenXY(_point,param3);
         return (_tileObjects[_data[(param1.y - _point.y) / _tileHeight * widthInTiles + (param1.x - _point.x) / _tileWidth]] as FlxTile).allowCollisions > 0;
      }
      
      public function getTile(param1:uint, param2:uint) : uint
      {
         return _data[param2 * widthInTiles + param1] as uint;
      }
      
      public function getTileByIndex(param1:uint) : uint
      {
         return _data[param1] as uint;
      }
      
      public function getTileInstances(param1:uint) : Array
      {
         var _loc2_:Array = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = widthInTiles * heightInTiles;
         while(_loc3_ < _loc4_)
         {
            if(_data[_loc3_] == param1)
            {
               if(_loc2_ == null)
               {
                  _loc2_ = [];
               }
               _loc2_.push(_loc3_);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function getTileCoords(param1:uint, param2:Boolean = true) : Array
      {
         var _loc6_:* = null;
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = widthInTiles * heightInTiles;
         while(_loc4_ < _loc5_)
         {
            if(_data[_loc4_] == param1)
            {
               _loc6_ = new FlxPoint(x + _loc4_ % widthInTiles * _tileWidth,y + _loc4_ / widthInTiles * _tileHeight);
               if(param2)
               {
                  _loc6_.x = _loc6_.x + _tileWidth * 0.5;
                  _loc6_.y = _loc6_.y + _tileHeight * 0.5;
               }
               if(_loc3_ == null)
               {
                  _loc3_ = [];
               }
               _loc3_.push(_loc6_);
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function setTile(param1:uint, param2:uint, param3:uint, param4:Boolean = true) : Boolean
      {
         if(param1 >= widthInTiles || param2 >= heightInTiles)
         {
            return false;
         }
         return setTileByIndex(param2 * widthInTiles + param1,param3,param4);
      }
      
      public function setTileByIndex(param1:uint, param2:uint, param3:Boolean = true) : Boolean
      {
         var _loc7_:* = 0;
         if(param1 >= _data.length)
         {
            return false;
         }
         var _loc9_:* = true;
         _data[param1] = param2;
         if(!param3)
         {
            return _loc9_;
         }
         setDirty();
         if(auto == 0)
         {
            updateTile(param1);
            return _loc9_;
         }
         var _loc8_:int = param1 / widthInTiles - 1;
         var _loc4_:int = _loc8_ + 3;
         var _loc6_:int = param1 % widthInTiles - 1;
         var _loc5_:int = _loc6_ + 3;
         while(_loc8_ < _loc4_)
         {
            _loc6_ = _loc5_ - 3;
            while(_loc6_ < _loc5_)
            {
               if(_loc8_ >= 0 && _loc8_ < heightInTiles && _loc6_ >= 0 && _loc6_ < widthInTiles)
               {
                  _loc7_ = _loc8_ * widthInTiles + _loc6_;
                  autoTile(_loc7_);
                  updateTile(_loc7_);
               }
               _loc6_++;
            }
            _loc8_++;
         }
         return _loc9_;
      }
      
      public function setTileProperties(param1:uint, param2:uint = 4369, param3:Function = null, param4:Class = null, param5:uint = 1) : void
      {
         var _loc6_:* = null;
         if(param5 <= 0)
         {
            var param5:uint = 1;
         }
         var _loc7_:* = param1;
         var _loc8_:uint = param1 + param5;
         while(_loc7_ < _loc8_)
         {
            _loc6_ = _tileObjects[_loc7_++] as FlxTile;
            _loc6_.allowCollisions = param2;
            _loc6_.callback = param3;
            _loc6_.filter = param4;
         }
      }
      
      public function follow(param1:FlxCamera = null, param2:int = 0, param3:Boolean = true) : void
      {
         if(param1 == null)
         {
            var param1:FlxCamera = FlxG.camera;
         }
         param1.setBounds(x + param2 * _tileWidth,y + param2 * _tileHeight,width - param2 * _tileWidth * 2,height - param2 * _tileHeight * 2,param3);
      }
      
      public function getBounds(param1:FlxRect = null) : FlxRect
      {
         if(param1 == null)
         {
            var param1:FlxRect = new FlxRect();
         }
         return param1.make(x,y,width,height);
      }
      
      public function ray(param1:FlxPoint, param2:FlxPoint, param3:FlxPoint = null, param4:Number = 1) : Boolean
      {
         var _loc20_:* = 0;
         var _loc21_:* = 0;
         var _loc8_:* = NaN;
         var _loc11_:* = NaN;
         var _loc16_:* = NaN;
         var _loc13_:* = NaN;
         var _loc15_:* = NaN;
         var _loc19_:Number = _tileWidth;
         if(_tileHeight < _tileWidth)
         {
            _loc19_ = _tileHeight;
         }
         _loc19_ = _loc19_ / param4;
         var _loc6_:Number = param2.x - param1.x;
         var _loc9_:Number = param2.y - param1.y;
         var _loc5_:Number = Math.sqrt(_loc6_ * _loc6_ + _loc9_ * _loc9_);
         var _loc14_:uint = Math.ceil(_loc5_ / _loc19_);
         var _loc7_:Number = _loc6_ / _loc14_;
         var _loc10_:Number = _loc9_ / _loc14_;
         var _loc17_:Number = param1.x - _loc7_ - x;
         var _loc18_:Number = param1.y - _loc10_ - y;
         var _loc12_:uint = 0;
         while(_loc12_ < _loc14_)
         {
            _loc17_ = _loc17_ + _loc7_;
            _loc18_ = _loc18_ + _loc10_;
            if(_loc17_ < 0 || _loc17_ > width || _loc18_ < 0 || _loc18_ > height)
            {
               _loc12_++;
            }
            else
            {
               _loc20_ = _loc17_ / _tileWidth;
               _loc21_ = _loc18_ / _tileHeight;
               if((_tileObjects[_data[_loc21_ * widthInTiles + _loc20_]] as FlxTile).allowCollisions)
               {
                  _loc20_ = _loc20_ * _tileWidth;
                  _loc21_ = _loc21_ * _tileHeight;
                  _loc8_ = 0.0;
                  _loc11_ = 0.0;
                  _loc13_ = _loc17_ - _loc7_;
                  _loc15_ = _loc18_ - _loc10_;
                  _loc16_ = _loc20_;
                  if(_loc6_ < 0)
                  {
                     _loc16_ = _loc16_ + _tileWidth;
                  }
                  _loc8_ = _loc16_;
                  _loc11_ = _loc15_ + _loc10_ * (_loc16_ - _loc13_) / _loc7_;
                  if(_loc11_ > _loc21_ && _loc11_ < _loc21_ + _tileHeight)
                  {
                     if(param3 == null)
                     {
                        var param3:FlxPoint = new FlxPoint();
                     }
                     param3.x = _loc8_;
                     param3.y = _loc11_;
                     return false;
                  }
                  _loc16_ = _loc21_;
                  if(_loc9_ < 0)
                  {
                     _loc16_ = _loc16_ + _tileHeight;
                  }
                  _loc8_ = _loc13_ + _loc7_ * (_loc16_ - _loc15_) / _loc10_;
                  _loc11_ = _loc16_;
                  if(_loc8_ > _loc20_ && _loc8_ < _loc20_ + _tileWidth)
                  {
                     if(param3 == null)
                     {
                        param3 = new FlxPoint();
                     }
                     param3.x = _loc8_;
                     param3.y = _loc11_;
                     return false;
                  }
                  return true;
               }
               _loc12_++;
            }
         }
         return true;
      }
      
      protected function autoTile(param1:uint) : void
      {
         if(_data[param1] == 0)
         {
            return;
         }
         _data[param1] = 0;
         if(param1 - widthInTiles < 0 || _data[param1 - widthInTiles] > 0)
         {
            var _loc2_:* = param1;
            var _loc3_:* = _data[_loc2_] + 1;
            _data[_loc2_] = _loc3_;
         }
         if(param1 % widthInTiles >= widthInTiles - 1 || _data[param1 + 1] > 0)
         {
            _loc3_ = param1;
            _loc2_ = _data[_loc3_] + 2;
            _data[_loc3_] = _loc2_;
         }
         if(param1 + widthInTiles >= totalTiles || _data[param1 + widthInTiles] > 0)
         {
            _loc2_ = param1;
            _loc3_ = _data[_loc2_] + 4;
            _data[_loc2_] = _loc3_;
         }
         if(param1 % widthInTiles <= 0 || _data[param1 - 1] > 0)
         {
            _loc3_ = param1;
            _loc2_ = _data[_loc3_] + 8;
            _data[_loc3_] = _loc2_;
         }
         if(auto == 2 && _data[param1] == 15)
         {
            if(param1 % widthInTiles > 0 && param1 + widthInTiles < totalTiles && _data[param1 + widthInTiles - 1] <= 0)
            {
               _data[param1] = 1;
            }
            if(param1 % widthInTiles > 0 && param1 - widthInTiles >= 0 && _data[param1 - widthInTiles - 1] <= 0)
            {
               _data[param1] = 2;
            }
            if(param1 % widthInTiles < widthInTiles - 1 && param1 - widthInTiles >= 0 && _data[param1 - widthInTiles + 1] <= 0)
            {
               _data[param1] = 4;
            }
            if(param1 % widthInTiles < widthInTiles - 1 && param1 + widthInTiles < totalTiles && _data[param1 + widthInTiles + 1] <= 0)
            {
               _data[param1] = 8;
            }
         }
         _loc2_ = param1;
         _loc3_ = _data[_loc2_] + 1;
         _data[_loc2_] = _loc3_;
      }
      
      protected function updateTile(param1:uint) : void
      {
         var _loc4_:FlxTile = _tileObjects[_data[param1]] as FlxTile;
         if(_loc4_ == null || !_loc4_.visible)
         {
            _rects[param1] = null;
            return;
         }
         var _loc2_:uint = (_data[param1] - _startingIndex) * _tileWidth;
         var _loc3_:uint = 0;
         if(_loc2_ >= _tiles.width)
         {
            _loc3_ = _loc2_ / _tiles.width * _tileHeight;
            _loc2_ = _loc2_ % _tiles.width;
         }
         _rects[param1] = new Rectangle(_loc2_,_loc3_,_tileWidth,_tileHeight);
      }
   }
}
