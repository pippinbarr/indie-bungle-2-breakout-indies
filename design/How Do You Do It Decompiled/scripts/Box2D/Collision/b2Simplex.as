package Box2D.Collision
{
   import Box2D.Common.Math.b2Transform;
   import Box2D.Common.b2Settings;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.Math.b2Math;
   
   class b2Simplex
   {
       
      public var m_v1:Box2D.Collision.b2SimplexVertex;
      
      public var m_v2:Box2D.Collision.b2SimplexVertex;
      
      public var m_v3:Box2D.Collision.b2SimplexVertex;
      
      public var m_vertices:Vector.<Box2D.Collision.b2SimplexVertex>;
      
      public var m_count:int;
      
      function b2Simplex()
      {
         m_v1 = new Box2D.Collision.b2SimplexVertex();
         m_v2 = new Box2D.Collision.b2SimplexVertex();
         m_v3 = new Box2D.Collision.b2SimplexVertex();
         m_vertices = new Vector.<Box2D.Collision.b2SimplexVertex>(3);
         super();
         m_vertices[0] = m_v1;
         m_vertices[1] = m_v2;
         m_vertices[2] = m_v3;
      }
      
      public function ReadCache(param1:b2SimplexCache, param2:b2DistanceProxy, param3:b2Transform, param4:b2DistanceProxy, param5:b2Transform) : void
      {
         var _loc6_:* = null;
         var _loc9_:* = null;
         var _loc10_:* = 0;
         var _loc8_:* = null;
         var _loc11_:* = NaN;
         var _loc12_:* = NaN;
         b2Settings.b2Assert(0 <= param1.count && param1.count <= 3);
         m_count = param1.count;
         var _loc7_:Vector.<Box2D.Collision.b2SimplexVertex> = m_vertices;
         _loc10_ = 0;
         while(_loc10_ < m_count)
         {
            _loc8_ = _loc7_[_loc10_];
            _loc8_.indexA = param1.indexA[_loc10_];
            _loc8_.indexB = param1.indexB[_loc10_];
            _loc6_ = param2.GetVertex(_loc8_.indexA);
            _loc9_ = param4.GetVertex(_loc8_.indexB);
            _loc8_.wA = b2Math.MulX(param3,_loc6_);
            _loc8_.wB = b2Math.MulX(param5,_loc9_);
            _loc8_.w = b2Math.SubtractVV(_loc8_.wB,_loc8_.wA);
            _loc8_.a = 0;
            _loc10_++;
         }
         if(m_count > 1)
         {
            _loc11_ = param1.metric;
            _loc12_ = GetMetric();
            if(_loc12_ < 0.5 * _loc11_ || 2 * _loc11_ < _loc12_ || _loc12_ < Number.MIN_VALUE)
            {
               m_count = 0;
            }
         }
         if(m_count == 0)
         {
            _loc8_ = _loc7_[0];
            _loc8_.indexA = 0;
            _loc8_.indexB = 0;
            _loc6_ = param2.GetVertex(0);
            _loc9_ = param4.GetVertex(0);
            _loc8_.wA = b2Math.MulX(param3,_loc6_);
            _loc8_.wB = b2Math.MulX(param5,_loc9_);
            _loc8_.w = b2Math.SubtractVV(_loc8_.wB,_loc8_.wA);
            m_count = 1;
         }
      }
      
      public function WriteCache(param1:b2SimplexCache) : void
      {
         var _loc3_:* = 0;
         param1.metric = GetMetric();
         param1.count = m_count;
         var _loc2_:Vector.<Box2D.Collision.b2SimplexVertex> = m_vertices;
         _loc3_ = 0;
         while(_loc3_ < m_count)
         {
            param1.indexA[_loc3_] = _loc2_[_loc3_].indexA;
            param1.indexB[_loc3_] = _loc2_[_loc3_].indexB;
            _loc3_++;
         }
      }
      
      public function GetSearchDirection() : b2Vec2
      {
         var _loc1_:* = null;
         var _loc2_:* = NaN;
         switch(m_count - 1)
         {
            case 0:
               return m_v1.w.GetNegative();
            case 1:
               _loc1_ = b2Math.SubtractVV(m_v2.w,m_v1.w);
               _loc2_ = b2Math.CrossVV(_loc1_,m_v1.w.GetNegative());
               if(_loc2_ > 0)
               {
                  return b2Math.CrossFV(1,_loc1_);
               }
               return b2Math.CrossVF(_loc1_,1);
            default:
               b2Settings.b2Assert(false);
               return new b2Vec2();
         }
      }
      
      public function GetClosestPoint() : b2Vec2
      {
         switch(m_count)
         {
            case 0:
               b2Settings.b2Assert(false);
               return new b2Vec2();
            case 1:
               return m_v1.w;
            case 2:
               return new b2Vec2(m_v1.a * m_v1.w.x + m_v2.a * m_v2.w.x,m_v1.a * m_v1.w.y + m_v2.a * m_v2.w.y);
            default:
               b2Settings.b2Assert(false);
               return new b2Vec2();
         }
      }
      
      public function GetWitnessPoints(param1:b2Vec2, param2:b2Vec2) : void
      {
         switch(m_count)
         {
            case 0:
               b2Settings.b2Assert(false);
               break;
            case 1:
               param1.SetV(m_v1.wA);
               param2.SetV(m_v1.wB);
               break;
            case 2:
               param1.x = m_v1.a * m_v1.wA.x + m_v2.a * m_v2.wA.x;
               param1.y = m_v1.a * m_v1.wA.y + m_v2.a * m_v2.wA.y;
               param2.x = m_v1.a * m_v1.wB.x + m_v2.a * m_v2.wB.x;
               param2.y = m_v1.a * m_v1.wB.y + m_v2.a * m_v2.wB.y;
               break;
            case 3:
               var _loc3_:* = m_v1.a * m_v1.wA.x + m_v2.a * m_v2.wA.x + m_v3.a * m_v3.wA.x;
               param1.x = _loc3_;
               param2.x = _loc3_;
               _loc3_ = m_v1.a * m_v1.wA.y + m_v2.a * m_v2.wA.y + m_v3.a * m_v3.wA.y;
               param1.y = _loc3_;
               param2.y = _loc3_;
               break;
            default:
               b2Settings.b2Assert(false);
         }
      }
      
      public function GetMetric() : Number
      {
         switch(m_count)
         {
            case 0:
               b2Settings.b2Assert(false);
               return 0;
            case 1:
               return 0;
            case 2:
               return b2Math.SubtractVV(m_v1.w,m_v2.w).Length();
            case 3:
               return b2Math.CrossVV(b2Math.SubtractVV(m_v2.w,m_v1.w),b2Math.SubtractVV(m_v3.w,m_v1.w));
            default:
               b2Settings.b2Assert(false);
               return 0;
         }
      }
      
      public function Solve2() : void
      {
         var _loc4_:b2Vec2 = m_v1.w;
         var _loc5_:b2Vec2 = m_v2.w;
         var _loc2_:b2Vec2 = b2Math.SubtractVV(_loc5_,_loc4_);
         var _loc1_:Number = -(_loc4_.x * _loc2_.x + _loc4_.y * _loc2_.y);
         if(_loc1_ <= 0)
         {
            m_v1.a = 1;
            m_count = 1;
            return;
         }
         var _loc6_:Number = _loc5_.x * _loc2_.x + _loc5_.y * _loc2_.y;
         if(_loc6_ <= 0)
         {
            m_v2.a = 1;
            m_count = 1;
            m_v1.Set(m_v2);
            return;
         }
         var _loc3_:Number = 1 / (_loc6_ + _loc1_);
         m_v1.a = _loc6_ * _loc3_;
         m_v2.a = _loc1_ * _loc3_;
         m_count = 2;
      }
      
      public function Solve3() : void
      {
         var _loc26_:* = NaN;
         var _loc25_:* = NaN;
         var _loc10_:* = NaN;
         var _loc11_:b2Vec2 = m_v1.w;
         var _loc12_:b2Vec2 = m_v2.w;
         var _loc13_:b2Vec2 = m_v3.w;
         var _loc3_:b2Vec2 = b2Math.SubtractVV(_loc12_,_loc11_);
         var _loc4_:Number = b2Math.Dot(_loc11_,_loc3_);
         var _loc19_:Number = b2Math.Dot(_loc12_,_loc3_);
         var _loc21_:* = _loc19_;
         var _loc14_:Number = -_loc4_;
         var _loc2_:b2Vec2 = b2Math.SubtractVV(_loc13_,_loc11_);
         var _loc5_:Number = b2Math.Dot(_loc11_,_loc2_);
         var _loc6_:Number = b2Math.Dot(_loc13_,_loc2_);
         var _loc15_:* = _loc6_;
         var _loc16_:Number = -_loc5_;
         var _loc17_:b2Vec2 = b2Math.SubtractVV(_loc13_,_loc12_);
         var _loc7_:Number = b2Math.Dot(_loc12_,_loc17_);
         var _loc22_:Number = b2Math.Dot(_loc13_,_loc17_);
         var _loc8_:* = _loc22_;
         var _loc1_:Number = -_loc7_;
         var _loc24_:Number = b2Math.CrossVV(_loc3_,_loc2_);
         var _loc20_:Number = _loc24_ * b2Math.CrossVV(_loc12_,_loc13_);
         var _loc23_:Number = _loc24_ * b2Math.CrossVV(_loc13_,_loc11_);
         var _loc18_:Number = _loc24_ * b2Math.CrossVV(_loc11_,_loc12_);
         if(_loc14_ <= 0 && _loc16_ <= 0)
         {
            m_v1.a = 1;
            m_count = 1;
            return;
         }
         if(_loc21_ > 0 && _loc14_ > 0 && _loc18_ <= 0)
         {
            _loc26_ = 1 / (_loc21_ + _loc14_);
            m_v1.a = _loc21_ * _loc26_;
            m_v2.a = _loc14_ * _loc26_;
            m_count = 2;
            return;
         }
         if(_loc15_ > 0 && _loc16_ > 0 && _loc23_ <= 0)
         {
            _loc25_ = 1 / (_loc15_ + _loc16_);
            m_v1.a = _loc15_ * _loc25_;
            m_v3.a = _loc16_ * _loc25_;
            m_count = 2;
            m_v2.Set(m_v3);
            return;
         }
         if(_loc21_ <= 0 && _loc1_ <= 0)
         {
            m_v2.a = 1;
            m_count = 1;
            m_v1.Set(m_v2);
            return;
         }
         if(_loc15_ <= 0 && _loc8_ <= 0)
         {
            m_v3.a = 1;
            m_count = 1;
            m_v1.Set(m_v3);
            return;
         }
         if(_loc8_ > 0 && _loc1_ > 0 && _loc20_ <= 0)
         {
            _loc10_ = 1 / (_loc8_ + _loc1_);
            m_v2.a = _loc8_ * _loc10_;
            m_v3.a = _loc1_ * _loc10_;
            m_count = 2;
            m_v1.Set(m_v3);
            return;
         }
         var _loc9_:Number = 1 / (_loc20_ + _loc23_ + _loc18_);
         m_v1.a = _loc20_ * _loc9_;
         m_v2.a = _loc23_ * _loc9_;
         m_v3.a = _loc18_ * _loc9_;
         m_count = 3;
      }
   }
}
