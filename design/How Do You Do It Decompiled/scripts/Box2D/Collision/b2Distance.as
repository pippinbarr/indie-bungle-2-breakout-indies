package Box2D.Collision
{
   import Box2D.Common.Math.b2Transform;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.b2internal;
   import Box2D.Common.b2Settings;
   import Box2D.Common.Math.b2Math;
   
   use namespace b2internal;
   
   public class b2Distance
   {
      
      private static var b2_gjkCalls:int;
      
      private static var b2_gjkIters:int;
      
      private static var b2_gjkMaxIters:int;
      
      private static var s_simplex:Box2D.Collision.b2Simplex = new Box2D.Collision.b2Simplex();
      
      private static var s_saveA:Vector.<int> = new Vector.<int>(3);
      
      private static var s_saveB:Vector.<int> = new Vector.<int>(3);
       
      public function b2Distance()
      {
         super();
      }
      
      public static function Distance(param1:b2DistanceOutput, param2:b2SimplexCache, param3:b2DistanceInput) : void
      {
         var _loc13_:* = 0;
         _loc13_ = 20;
         var _loc21_:* = 0;
         var _loc24_:* = null;
         var _loc17_:* = null;
         var _loc4_:* = null;
         var _loc23_:* = false;
         var _loc9_:* = NaN;
         var _loc10_:* = NaN;
         var _loc14_:* = null;
         b2_gjkCalls = b2_gjkCalls + 1;
         var _loc7_:b2DistanceProxy = param3.proxyA;
         var _loc8_:b2DistanceProxy = param3.proxyB;
         var _loc12_:b2Transform = param3.transformA;
         var _loc11_:b2Transform = param3.transformB;
         var _loc6_:Box2D.Collision.b2Simplex = s_simplex;
         _loc6_.ReadCache(param2,_loc7_,_loc12_,_loc8_,_loc11_);
         var _loc5_:Vector.<b2SimplexVertex> = _loc6_.m_vertices;
         var _loc19_:Vector.<int> = s_saveA;
         var _loc20_:Vector.<int> = s_saveB;
         var _loc25_:* = 0;
         var _loc15_:b2Vec2 = _loc6_.GetClosestPoint();
         var _loc18_:Number = _loc15_.LengthSquared();
         var _loc16_:* = _loc18_;
         var _loc22_:* = 0;
         while(_loc22_ < 20)
         {
            _loc25_ = _loc6_.m_count;
            _loc21_ = 0;
            while(_loc21_ < _loc25_)
            {
               _loc19_[_loc21_] = _loc5_[_loc21_].indexA;
               _loc20_[_loc21_] = _loc5_[_loc21_].indexB;
               _loc21_++;
            }
            switch(_loc6_.m_count - 1)
            {
               case 0:
                  break;
               case 1:
                  _loc6_.Solve2();
                  break;
               case 2:
                  _loc6_.Solve3();
                  break;
               default:
                  b2Settings.b2Assert(false);
            }
            if(_loc6_.m_count != 3)
            {
               _loc24_ = _loc6_.GetClosestPoint();
               _loc16_ = _loc24_.LengthSquared();
               if(_loc16_ > _loc18_)
               {
               }
               _loc18_ = _loc16_;
               _loc17_ = _loc6_.GetSearchDirection();
               if(_loc17_.LengthSquared() >= Number.MIN_VALUE * Number.MIN_VALUE)
               {
                  _loc4_ = _loc5_[_loc6_.m_count];
                  _loc4_.indexA = _loc7_.GetSupport(b2Math.MulTMV(_loc12_.R,_loc17_.GetNegative()));
                  _loc4_.wA = b2Math.MulX(_loc12_,_loc7_.GetVertex(_loc4_.indexA));
                  _loc4_.indexB = _loc8_.GetSupport(b2Math.MulTMV(_loc11_.R,_loc17_));
                  _loc4_.wB = b2Math.MulX(_loc11_,_loc8_.GetVertex(_loc4_.indexB));
                  _loc4_.w = b2Math.SubtractVV(_loc4_.wB,_loc4_.wA);
                  _loc22_++;
                  b2_gjkIters = b2_gjkIters + 1;
                  _loc23_ = false;
                  _loc21_ = 0;
                  while(_loc21_ < _loc25_)
                  {
                     if(_loc4_.indexA == _loc19_[_loc21_] && _loc4_.indexB == _loc20_[_loc21_])
                     {
                        _loc23_ = true;
                        break;
                     }
                     _loc21_++;
                  }
                  if(!_loc23_)
                  {
                     _loc6_.m_count = §§dup(_loc6_).m_count + 1;
                     continue;
                  }
                  break;
               }
               break;
            }
            break;
         }
         b2_gjkMaxIters = b2Math.Max(b2_gjkMaxIters,_loc22_);
         _loc6_.GetWitnessPoints(param1.pointA,param1.pointB);
         param1.distance = b2Math.SubtractVV(param1.pointA,param1.pointB).Length();
         param1.iterations = _loc22_;
         _loc6_.WriteCache(param2);
         if(param3.useRadii)
         {
            _loc9_ = _loc7_.m_radius;
            _loc10_ = _loc8_.m_radius;
            if(param1.distance > _loc9_ + _loc10_ && param1.distance > Number.MIN_VALUE)
            {
               param1.distance = param1.distance - (_loc9_ + _loc10_);
               _loc14_ = b2Math.SubtractVV(param1.pointB,param1.pointA);
               _loc14_.Normalize();
               param1.pointA.x = param1.pointA.x + _loc9_ * _loc14_.x;
               param1.pointA.y = param1.pointA.y + _loc9_ * _loc14_.y;
               param1.pointB.x = param1.pointB.x - _loc10_ * _loc14_.x;
               param1.pointB.y = param1.pointB.y - _loc10_ * _loc14_.y;
            }
            else
            {
               _loc24_ = new b2Vec2();
               _loc24_.x = 0.5 * (param1.pointA.x + param1.pointB.x);
               _loc24_.y = 0.5 * (param1.pointA.y + param1.pointB.y);
               var _loc26_:* = _loc24_.x;
               param1.pointB.x = _loc26_;
               param1.pointA.x = _loc26_;
               _loc26_ = _loc24_.y;
               param1.pointB.y = _loc26_;
               param1.pointA.y = _loc26_;
               param1.distance = 0;
            }
         }
      }
   }
}
