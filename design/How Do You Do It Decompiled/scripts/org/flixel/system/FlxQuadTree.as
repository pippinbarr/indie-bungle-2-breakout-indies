package org.flixel.system
{
   import org.flixel.FlxRect;
   import org.flixel.FlxObject;
   import org.flixel.FlxBasic;
   import org.flixel.FlxGroup;
   
   public class FlxQuadTree extends FlxRect
   {
      
      public static const A_LIST:uint = 0;
      
      public static const B_LIST:uint = 1;
      
      public static var divisions:uint;
      
      protected static var _min:uint;
      
      protected static var _object:FlxObject;
      
      protected static var _objectLeftEdge:Number;
      
      protected static var _objectTopEdge:Number;
      
      protected static var _objectRightEdge:Number;
      
      protected static var _objectBottomEdge:Number;
      
      protected static var _list:uint;
      
      protected static var _useBothLists:Boolean;
      
      protected static var _processingCallback:Function;
      
      protected static var _notifyCallback:Function;
      
      protected static var _iterator:org.flixel.system.FlxList;
      
      protected static var _objectHullX:Number;
      
      protected static var _objectHullY:Number;
      
      protected static var _objectHullWidth:Number;
      
      protected static var _objectHullHeight:Number;
      
      protected static var _checkObjectHullX:Number;
      
      protected static var _checkObjectHullY:Number;
      
      protected static var _checkObjectHullWidth:Number;
      
      protected static var _checkObjectHullHeight:Number;
       
      protected var _canSubdivide:Boolean;
      
      protected var _headA:org.flixel.system.FlxList;
      
      protected var _tailA:org.flixel.system.FlxList;
      
      protected var _headB:org.flixel.system.FlxList;
      
      protected var _tailB:org.flixel.system.FlxList;
      
      protected var _northWestTree:org.flixel.system.FlxQuadTree;
      
      protected var _northEastTree:org.flixel.system.FlxQuadTree;
      
      protected var _southEastTree:org.flixel.system.FlxQuadTree;
      
      protected var _southWestTree:org.flixel.system.FlxQuadTree;
      
      protected var _leftEdge:Number;
      
      protected var _rightEdge:Number;
      
      protected var _topEdge:Number;
      
      protected var _bottomEdge:Number;
      
      protected var _halfWidth:Number;
      
      protected var _halfHeight:Number;
      
      protected var _midpointX:Number;
      
      protected var _midpointY:Number;
      
      public function FlxQuadTree(param1:Number, param2:Number, param3:Number, param4:Number, param5:org.flixel.system.FlxQuadTree = null)
      {
         var _loc6_:* = null;
         var _loc7_:* = null;
         super(param1,param2,param3,param4);
         _tailA = §§dup(new org.flixel.system.FlxList());
         _headA = new org.flixel.system.FlxList();
         _tailB = §§dup(new org.flixel.system.FlxList());
         _headB = new org.flixel.system.FlxList();
         if(param5 != null)
         {
            if(param5._headA.object != null)
            {
               _loc6_ = param5._headA;
               while(_loc6_ != null)
               {
                  if(_tailA.object != null)
                  {
                     _loc7_ = _tailA;
                     _tailA = new org.flixel.system.FlxList();
                     _loc7_.next = _tailA;
                  }
                  _tailA.object = _loc6_.object;
                  _loc6_ = _loc6_.next;
               }
            }
            if(param5._headB.object != null)
            {
               _loc6_ = param5._headB;
               while(_loc6_ != null)
               {
                  if(_tailB.object != null)
                  {
                     _loc7_ = _tailB;
                     _tailB = new org.flixel.system.FlxList();
                     _loc7_.next = _tailB;
                  }
                  _tailB.object = _loc6_.object;
                  _loc6_ = _loc6_.next;
               }
            }
         }
         else
         {
            _min = (width + height) / (2 * divisions);
         }
         _canSubdivide = width > _min || height > _min;
         _northWestTree = null;
         _northEastTree = null;
         _southEastTree = null;
         _southWestTree = null;
         _leftEdge = x;
         _rightEdge = x + width;
         _halfWidth = width / 2;
         _midpointX = _leftEdge + _halfWidth;
         _topEdge = y;
         _bottomEdge = y + height;
         _halfHeight = height / 2;
         _midpointY = _topEdge + _halfHeight;
      }
      
      public function destroy() : void
      {
         _headA.destroy();
         _headA = null;
         _tailA.destroy();
         _tailA = null;
         _headB.destroy();
         _headB = null;
         _tailB.destroy();
         _tailB = null;
         if(_northWestTree != null)
         {
            _northWestTree.destroy();
         }
         _northWestTree = null;
         if(_northEastTree != null)
         {
            _northEastTree.destroy();
         }
         _northEastTree = null;
         if(_southEastTree != null)
         {
            _southEastTree.destroy();
         }
         _southEastTree = null;
         if(_southWestTree != null)
         {
            _southWestTree.destroy();
         }
         _southWestTree = null;
         _object = null;
         _processingCallback = null;
         _notifyCallback = null;
      }
      
      public function load(param1:FlxBasic, param2:FlxBasic = null, param3:Function = null, param4:Function = null) : void
      {
         add(param1,0);
         if(param2 != null)
         {
            add(param2,1);
            _useBothLists = true;
         }
         else
         {
            _useBothLists = false;
         }
         _notifyCallback = param3;
         _processingCallback = param4;
      }
      
      public function add(param1:FlxBasic, param2:uint) : void
      {
         var _loc4_:* = 0;
         var _loc5_:* = null;
         var _loc3_:* = null;
         var _loc6_:* = 0;
         _list = param2;
         if(param1 is FlxGroup)
         {
            _loc4_ = 0;
            _loc3_ = (param1 as FlxGroup).members;
            _loc6_ = (param1 as FlxGroup).length;
            while(_loc4_ < _loc6_)
            {
               _loc5_ = _loc3_[_loc4_++] as FlxBasic;
               if(_loc5_ != null && _loc5_.exists)
               {
                  if(_loc5_ is FlxGroup)
                  {
                     add(_loc5_,param2);
                  }
                  else if(_loc5_ is FlxObject)
                  {
                     _object = _loc5_ as FlxObject;
                     if(_object.exists && _object.allowCollisions)
                     {
                        _objectLeftEdge = _object.x;
                        _objectTopEdge = _object.y;
                        _objectRightEdge = _object.x + _object.width;
                        _objectBottomEdge = _object.y + _object.height;
                        addObject();
                     }
                  }
               }
            }
         }
         else
         {
            _object = param1 as FlxObject;
            if(_object.exists && _object.allowCollisions)
            {
               _objectLeftEdge = _object.x;
               _objectTopEdge = _object.y;
               _objectRightEdge = _object.x + _object.width;
               _objectBottomEdge = _object.y + _object.height;
               addObject();
            }
         }
      }
      
      protected function addObject() : void
      {
         if(!_canSubdivide || _leftEdge >= _objectLeftEdge && _rightEdge <= _objectRightEdge && _topEdge >= _objectTopEdge && _bottomEdge <= _objectBottomEdge)
         {
            addToList();
            return;
         }
         if(_objectLeftEdge > _leftEdge && _objectRightEdge < _midpointX)
         {
            if(_objectTopEdge > _topEdge && _objectBottomEdge < _midpointY)
            {
               if(_northWestTree == null)
               {
                  _northWestTree = new org.flixel.system.FlxQuadTree(_leftEdge,_topEdge,_halfWidth,_halfHeight,this);
               }
               _northWestTree.addObject();
               return;
            }
            if(_objectTopEdge > _midpointY && _objectBottomEdge < _bottomEdge)
            {
               if(_southWestTree == null)
               {
                  _southWestTree = new org.flixel.system.FlxQuadTree(_leftEdge,_midpointY,_halfWidth,_halfHeight,this);
               }
               _southWestTree.addObject();
               return;
            }
         }
         if(_objectLeftEdge > _midpointX && _objectRightEdge < _rightEdge)
         {
            if(_objectTopEdge > _topEdge && _objectBottomEdge < _midpointY)
            {
               if(_northEastTree == null)
               {
                  _northEastTree = new org.flixel.system.FlxQuadTree(_midpointX,_topEdge,_halfWidth,_halfHeight,this);
               }
               _northEastTree.addObject();
               return;
            }
            if(_objectTopEdge > _midpointY && _objectBottomEdge < _bottomEdge)
            {
               if(_southEastTree == null)
               {
                  _southEastTree = new org.flixel.system.FlxQuadTree(_midpointX,_midpointY,_halfWidth,_halfHeight,this);
               }
               _southEastTree.addObject();
               return;
            }
         }
         if(_objectRightEdge > _leftEdge && _objectLeftEdge < _midpointX && _objectBottomEdge > _topEdge && _objectTopEdge < _midpointY)
         {
            if(_northWestTree == null)
            {
               _northWestTree = new org.flixel.system.FlxQuadTree(_leftEdge,_topEdge,_halfWidth,_halfHeight,this);
            }
            _northWestTree.addObject();
         }
         if(_objectRightEdge > _midpointX && _objectLeftEdge < _rightEdge && _objectBottomEdge > _topEdge && _objectTopEdge < _midpointY)
         {
            if(_northEastTree == null)
            {
               _northEastTree = new org.flixel.system.FlxQuadTree(_midpointX,_topEdge,_halfWidth,_halfHeight,this);
            }
            _northEastTree.addObject();
         }
         if(_objectRightEdge > _midpointX && _objectLeftEdge < _rightEdge && _objectBottomEdge > _midpointY && _objectTopEdge < _bottomEdge)
         {
            if(_southEastTree == null)
            {
               _southEastTree = new org.flixel.system.FlxQuadTree(_midpointX,_midpointY,_halfWidth,_halfHeight,this);
            }
            _southEastTree.addObject();
         }
         if(_objectRightEdge > _leftEdge && _objectLeftEdge < _midpointX && _objectBottomEdge > _midpointY && _objectTopEdge < _bottomEdge)
         {
            if(_southWestTree == null)
            {
               _southWestTree = new org.flixel.system.FlxQuadTree(_leftEdge,_midpointY,_halfWidth,_halfHeight,this);
            }
            _southWestTree.addObject();
         }
      }
      
      protected function addToList() : void
      {
         var _loc1_:* = null;
         if(_list == 0)
         {
            if(_tailA.object != null)
            {
               _loc1_ = _tailA;
               _tailA = new org.flixel.system.FlxList();
               _loc1_.next = _tailA;
            }
            _tailA.object = _object;
         }
         else
         {
            if(_tailB.object != null)
            {
               _loc1_ = _tailB;
               _tailB = new org.flixel.system.FlxList();
               _loc1_.next = _tailB;
            }
            _tailB.object = _object;
         }
         if(!_canSubdivide)
         {
            return;
         }
         if(_northWestTree != null)
         {
            _northWestTree.addToList();
         }
         if(_northEastTree != null)
         {
            _northEastTree.addToList();
         }
         if(_southEastTree != null)
         {
            _southEastTree.addToList();
         }
         if(_southWestTree != null)
         {
            _southWestTree.addToList();
         }
      }
      
      public function execute() : Boolean
      {
         var _loc1_:* = null;
         var _loc2_:* = false;
         if(_headA.object != null)
         {
            _loc1_ = _headA;
            while(_loc1_ != null)
            {
               _object = _loc1_.object;
               if(_useBothLists)
               {
                  _iterator = _headB;
               }
               else
               {
                  _iterator = _loc1_.next;
               }
               if(_object.exists && _object.allowCollisions > 0 && _iterator != null && _iterator.object != null && _iterator.object.exists && overlapNode())
               {
                  _loc2_ = true;
               }
               _loc1_ = _loc1_.next;
            }
         }
         if(_northWestTree != null && _northWestTree.execute())
         {
            _loc2_ = true;
         }
         if(_northEastTree != null && _northEastTree.execute())
         {
            _loc2_ = true;
         }
         if(_southEastTree != null && _southEastTree.execute())
         {
            _loc2_ = true;
         }
         if(_southWestTree != null && _southWestTree.execute())
         {
            _loc2_ = true;
         }
         return _loc2_;
      }
      
      protected function overlapNode() : Boolean
      {
         var _loc1_:* = null;
         var _loc2_:* = false;
         while(_iterator != null)
         {
            if(!(!_object.exists || _object.allowCollisions <= 0))
            {
               _loc1_ = _iterator.object;
               if(_object === _loc1_ || !_loc1_.exists || _loc1_.allowCollisions <= 0)
               {
                  _iterator = _iterator.next;
               }
               else
               {
                  _objectHullX = _object.x < _object.last.x?_object.x:_object.last.x;
                  _objectHullY = _object.y < _object.last.y?_object.y:_object.last.y;
                  _objectHullWidth = _object.x - _object.last.x;
                  _objectHullWidth = _object.width + (_objectHullWidth > 0?_objectHullWidth:-_objectHullWidth);
                  _objectHullHeight = _object.y - _object.last.y;
                  _objectHullHeight = _object.height + (_objectHullHeight > 0?_objectHullHeight:-_objectHullHeight);
                  _checkObjectHullX = _loc1_.x < _loc1_.last.x?_loc1_.x:_loc1_.last.x;
                  _checkObjectHullY = _loc1_.y < _loc1_.last.y?_loc1_.y:_loc1_.last.y;
                  _checkObjectHullWidth = _loc1_.x - _loc1_.last.x;
                  _checkObjectHullWidth = _loc1_.width + (_checkObjectHullWidth > 0?_checkObjectHullWidth:-_checkObjectHullWidth);
                  _checkObjectHullHeight = _loc1_.y - _loc1_.last.y;
                  _checkObjectHullHeight = _loc1_.height + (_checkObjectHullHeight > 0?_checkObjectHullHeight:-_checkObjectHullHeight);
                  if(_objectHullX + _objectHullWidth > _checkObjectHullX && _objectHullX < _checkObjectHullX + _checkObjectHullWidth && _objectHullY + _objectHullHeight > _checkObjectHullY && _objectHullY < _checkObjectHullY + _checkObjectHullHeight)
                  {
                     if(_processingCallback == null || _processingCallback(_object,_loc1_))
                     {
                        _loc2_ = true;
                     }
                     if(_loc2_ && _notifyCallback != null)
                     {
                        _notifyCallback(_object,_loc1_);
                     }
                  }
                  _iterator = _iterator.next;
               }
               continue;
            }
            break;
         }
         return _loc2_;
      }
   }
}
