package Box2D.Collision
{
   import Box2D.Common.Math.b2Vec2;
   
   public class b2AABB
   {
       
      public var lowerBound:b2Vec2;
      
      public var upperBound:b2Vec2;
      
      public function b2AABB()
      {
         lowerBound = new b2Vec2();
         upperBound = new b2Vec2();
         super();
      }
      
      public static function Combine(param1:b2AABB, param2:b2AABB) : b2AABB
      {
         var _loc3_:b2AABB = new b2AABB();
         _loc3_.Combine(param1,param2);
         return _loc3_;
      }
      
      public function IsValid() : Boolean
      {
         var _loc2_:Number = upperBound.x - lowerBound.x;
         var _loc3_:Number = upperBound.y - lowerBound.y;
         var _loc1_:Boolean = _loc2_ >= 0 && _loc3_ >= 0;
         _loc1_ = _loc1_ && lowerBound.IsValid() && upperBound.IsValid();
         return _loc1_;
      }
      
      public function GetCenter() : b2Vec2
      {
         return new b2Vec2((lowerBound.x + upperBound.x) / 2,(lowerBound.y + upperBound.y) / 2);
      }
      
      public function GetExtents() : b2Vec2
      {
         return new b2Vec2((upperBound.x - lowerBound.x) / 2,(upperBound.y - lowerBound.y) / 2);
      }
      
      public function Contains(param1:b2AABB) : Boolean
      {
         var _loc2_:* = true;
         if(_loc2_)
         {
            _loc2_ = lowerBound.x <= param1.lowerBound.x;
         }
         if(_loc2_)
         {
            _loc2_ = lowerBound.y <= param1.lowerBound.y;
         }
         if(_loc2_)
         {
            _loc2_ = param1.upperBound.x <= upperBound.x;
         }
         if(_loc2_)
         {
            _loc2_ = param1.upperBound.y <= upperBound.y;
         }
         return _loc2_;
      }
      
      public function RayCast(param1:b2RayCastOutput, param2:b2RayCastInput) : Boolean
      {
         var _loc10_:* = NaN;
         var _loc14_:* = NaN;
         var _loc15_:* = NaN;
         var _loc16_:* = NaN;
         var _loc11_:* = NaN;
         var _loc7_:* = -1.7976931348623157E308;
         var _loc6_:* = 1.7976931348623157E308;
         var _loc8_:Number = param2.p1.x;
         var _loc9_:Number = param2.p1.y;
         var _loc12_:Number = param2.p2.x - param2.p1.x;
         var _loc13_:Number = param2.p2.y - param2.p1.y;
         var _loc5_:Number = Math.abs(_loc12_);
         var _loc4_:Number = Math.abs(_loc13_);
         var _loc3_:b2Vec2 = param1.normal;
         if(_loc5_ < Number.MIN_VALUE)
         {
            if(_loc8_ < lowerBound.x || upperBound.x < _loc8_)
            {
               return false;
            }
         }
         else
         {
            _loc10_ = 1 / _loc12_;
            _loc14_ = (lowerBound.x - _loc8_) * _loc10_;
            _loc15_ = (upperBound.x - _loc8_) * _loc10_;
            _loc11_ = -1.0;
            if(_loc14_ > _loc15_)
            {
               _loc16_ = _loc14_;
               _loc14_ = _loc15_;
               _loc15_ = _loc16_;
               _loc11_ = 1.0;
            }
            if(_loc14_ > _loc7_)
            {
               _loc3_.x = _loc11_;
               _loc3_.y = 0;
               _loc7_ = _loc14_;
            }
            _loc6_ = Math.min(_loc6_,_loc15_);
            if(_loc7_ > _loc6_)
            {
               return false;
            }
         }
         if(_loc4_ < Number.MIN_VALUE)
         {
            if(_loc9_ < lowerBound.y || upperBound.y < _loc9_)
            {
               return false;
            }
         }
         else
         {
            _loc10_ = 1 / _loc13_;
            _loc14_ = (lowerBound.y - _loc9_) * _loc10_;
            _loc15_ = (upperBound.y - _loc9_) * _loc10_;
            _loc11_ = -1.0;
            if(_loc14_ > _loc15_)
            {
               _loc16_ = _loc14_;
               _loc14_ = _loc15_;
               _loc15_ = _loc16_;
               _loc11_ = 1.0;
            }
            if(_loc14_ > _loc7_)
            {
               _loc3_.y = _loc11_;
               _loc3_.x = 0;
               _loc7_ = _loc14_;
            }
            _loc6_ = Math.min(_loc6_,_loc15_);
            if(_loc7_ > _loc6_)
            {
               return false;
            }
         }
         param1.fraction = _loc7_;
         return true;
      }
      
      public function TestOverlap(param1:b2AABB) : Boolean
      {
         var _loc2_:Number = param1.lowerBound.x - upperBound.x;
         var _loc5_:Number = param1.lowerBound.y - upperBound.y;
         var _loc4_:Number = lowerBound.x - param1.upperBound.x;
         var _loc3_:Number = lowerBound.y - param1.upperBound.y;
         if(_loc2_ > 0 || _loc5_ > 0)
         {
            return false;
         }
         if(_loc4_ > 0 || _loc3_ > 0)
         {
            return false;
         }
         return true;
      }
      
      public function Combine(param1:b2AABB, param2:b2AABB) : void
      {
         lowerBound.x = Math.min(param1.lowerBound.x,param2.lowerBound.x);
         lowerBound.y = Math.min(param1.lowerBound.y,param2.lowerBound.y);
         upperBound.x = Math.max(param1.upperBound.x,param2.upperBound.x);
         upperBound.y = Math.max(param1.upperBound.y,param2.upperBound.y);
      }
   }
}
