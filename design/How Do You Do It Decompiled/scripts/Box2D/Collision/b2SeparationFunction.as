package Box2D.Collision
{
   import Box2D.Common.Math.b2Transform;
   import Box2D.Common.b2Settings;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.Math.b2Mat22;
   import Box2D.Common.Math.b2Math;
   
   class b2SeparationFunction
   {
      
      public static const e_points:int = 1;
      
      public static const e_faceA:int = 2;
      
      public static const e_faceB:int = 4;
       
      public var m_proxyA:Box2D.Collision.b2DistanceProxy;
      
      public var m_proxyB:Box2D.Collision.b2DistanceProxy;
      
      public var m_type:int;
      
      public var m_localPoint:b2Vec2;
      
      public var m_axis:b2Vec2;
      
      function b2SeparationFunction()
      {
         m_localPoint = new b2Vec2();
         m_axis = new b2Vec2();
         super();
      }
      
      public function Initialize(param1:b2SimplexCache, param2:Box2D.Collision.b2DistanceProxy, param3:b2Transform, param4:Box2D.Collision.b2DistanceProxy, param5:b2Transform) : void
      {
         var _loc25_:* = null;
         var _loc27_:* = null;
         var _loc24_:* = null;
         var _loc28_:* = null;
         var _loc9_:* = null;
         var _loc11_:* = null;
         var _loc13_:* = NaN;
         var _loc12_:* = NaN;
         var _loc33_:* = NaN;
         var _loc32_:* = NaN;
         var _loc6_:* = NaN;
         var _loc7_:* = NaN;
         var _loc34_:* = null;
         var _loc31_:* = null;
         var _loc29_:* = NaN;
         var _loc14_:* = NaN;
         var _loc8_:* = null;
         var _loc16_:* = null;
         var _loc10_:* = null;
         var _loc17_:* = null;
         var _loc18_:* = NaN;
         var _loc21_:* = NaN;
         var _loc26_:* = null;
         var _loc20_:* = NaN;
         var _loc22_:* = NaN;
         var _loc19_:* = NaN;
         var _loc15_:* = NaN;
         var _loc30_:* = NaN;
         m_proxyA = param2;
         m_proxyB = param4;
         var _loc23_:int = param1.count;
         b2Settings.b2Assert(0 < _loc23_ && _loc23_ < 3);
         if(_loc23_ == 1)
         {
            m_type = 1;
            _loc25_ = m_proxyA.GetVertex(param1.indexA[0]);
            _loc28_ = m_proxyB.GetVertex(param1.indexB[0]);
            _loc31_ = _loc25_;
            _loc34_ = param3.R;
            _loc13_ = param3.position.x + (_loc34_.col1.x * _loc31_.x + _loc34_.col2.x * _loc31_.y);
            _loc12_ = param3.position.y + (_loc34_.col1.y * _loc31_.x + _loc34_.col2.y * _loc31_.y);
            _loc31_ = _loc28_;
            _loc34_ = param5.R;
            _loc33_ = param5.position.x + (_loc34_.col1.x * _loc31_.x + _loc34_.col2.x * _loc31_.y);
            _loc32_ = param5.position.y + (_loc34_.col1.y * _loc31_.x + _loc34_.col2.y * _loc31_.y);
            m_axis.x = _loc33_ - _loc13_;
            m_axis.y = _loc32_ - _loc12_;
            m_axis.Normalize();
         }
         else if(param1.indexB[0] == param1.indexB[1])
         {
            m_type = 2;
            _loc27_ = m_proxyA.GetVertex(param1.indexA[0]);
            _loc24_ = m_proxyA.GetVertex(param1.indexA[1]);
            _loc28_ = m_proxyB.GetVertex(param1.indexB[0]);
            m_localPoint.x = 0.5 * (_loc27_.x + _loc24_.x);
            m_localPoint.y = 0.5 * (_loc27_.y + _loc24_.y);
            m_axis = b2Math.CrossVF(b2Math.SubtractVV(_loc24_,_loc27_),1);
            m_axis.Normalize();
            _loc31_ = m_axis;
            _loc34_ = param3.R;
            _loc6_ = _loc34_.col1.x * _loc31_.x + _loc34_.col2.x * _loc31_.y;
            _loc7_ = _loc34_.col1.y * _loc31_.x + _loc34_.col2.y * _loc31_.y;
            _loc31_ = m_localPoint;
            _loc34_ = param3.R;
            _loc13_ = param3.position.x + (_loc34_.col1.x * _loc31_.x + _loc34_.col2.x * _loc31_.y);
            _loc12_ = param3.position.y + (_loc34_.col1.y * _loc31_.x + _loc34_.col2.y * _loc31_.y);
            _loc31_ = _loc28_;
            _loc34_ = param5.R;
            _loc33_ = param5.position.x + (_loc34_.col1.x * _loc31_.x + _loc34_.col2.x * _loc31_.y);
            _loc32_ = param5.position.y + (_loc34_.col1.y * _loc31_.x + _loc34_.col2.y * _loc31_.y);
            _loc29_ = (_loc33_ - _loc13_) * _loc6_ + (_loc32_ - _loc12_) * _loc7_;
            if(_loc29_ < 0)
            {
               m_axis.NegativeSelf();
            }
         }
         else if(param1.indexA[0] == param1.indexA[0])
         {
            m_type = 4;
            _loc9_ = m_proxyB.GetVertex(param1.indexB[0]);
            _loc11_ = m_proxyB.GetVertex(param1.indexB[1]);
            _loc25_ = m_proxyA.GetVertex(param1.indexA[0]);
            m_localPoint.x = 0.5 * (_loc9_.x + _loc11_.x);
            m_localPoint.y = 0.5 * (_loc9_.y + _loc11_.y);
            m_axis = b2Math.CrossVF(b2Math.SubtractVV(_loc11_,_loc9_),1);
            m_axis.Normalize();
            _loc31_ = m_axis;
            _loc34_ = param5.R;
            _loc6_ = _loc34_.col1.x * _loc31_.x + _loc34_.col2.x * _loc31_.y;
            _loc7_ = _loc34_.col1.y * _loc31_.x + _loc34_.col2.y * _loc31_.y;
            _loc31_ = m_localPoint;
            _loc34_ = param5.R;
            _loc33_ = param5.position.x + (_loc34_.col1.x * _loc31_.x + _loc34_.col2.x * _loc31_.y);
            _loc32_ = param5.position.y + (_loc34_.col1.y * _loc31_.x + _loc34_.col2.y * _loc31_.y);
            _loc31_ = _loc25_;
            _loc34_ = param3.R;
            _loc13_ = param3.position.x + (_loc34_.col1.x * _loc31_.x + _loc34_.col2.x * _loc31_.y);
            _loc12_ = param3.position.y + (_loc34_.col1.y * _loc31_.x + _loc34_.col2.y * _loc31_.y);
            _loc29_ = (_loc13_ - _loc33_) * _loc6_ + (_loc12_ - _loc32_) * _loc7_;
            if(_loc29_ < 0)
            {
               m_axis.NegativeSelf();
            }
         }
         else
         {
            _loc27_ = m_proxyA.GetVertex(param1.indexA[0]);
            _loc24_ = m_proxyA.GetVertex(param1.indexA[1]);
            _loc9_ = m_proxyB.GetVertex(param1.indexB[0]);
            _loc11_ = m_proxyB.GetVertex(param1.indexB[1]);
            _loc8_ = b2Math.MulX(param3,_loc25_);
            _loc16_ = b2Math.MulMV(param3.R,b2Math.SubtractVV(_loc24_,_loc27_));
            _loc10_ = b2Math.MulX(param5,_loc28_);
            _loc17_ = b2Math.MulMV(param5.R,b2Math.SubtractVV(_loc11_,_loc9_));
            _loc18_ = _loc16_.x * _loc16_.x + _loc16_.y * _loc16_.y;
            _loc21_ = _loc17_.x * _loc17_.x + _loc17_.y * _loc17_.y;
            _loc26_ = b2Math.SubtractVV(_loc17_,_loc16_);
            _loc20_ = _loc16_.x * _loc26_.x + _loc16_.y * _loc26_.y;
            _loc22_ = _loc17_.x * _loc26_.x + _loc17_.y * _loc26_.y;
            _loc19_ = _loc16_.x * _loc17_.x + _loc16_.y * _loc17_.y;
            _loc15_ = _loc18_ * _loc21_ - _loc19_ * _loc19_;
            _loc29_ = 0.0;
            if(_loc15_ != 0)
            {
               _loc29_ = b2Math.Clamp((_loc19_ * _loc22_ - _loc20_ * _loc21_) / _loc15_,0,1);
            }
            _loc30_ = (_loc19_ * _loc29_ + _loc22_) / _loc21_;
            if(_loc30_ < 0)
            {
               _loc30_ = 0.0;
               _loc29_ = b2Math.Clamp((_loc19_ - _loc20_) / _loc18_,0,1);
            }
            _loc25_ = new b2Vec2();
            _loc25_.x = _loc27_.x + _loc29_ * (_loc24_.x - _loc27_.x);
            _loc25_.y = _loc27_.y + _loc29_ * (_loc24_.y - _loc27_.y);
            _loc28_ = new b2Vec2();
            _loc28_.x = _loc9_.x + _loc29_ * (_loc11_.x - _loc9_.x);
            _loc28_.y = _loc9_.y + _loc29_ * (_loc11_.y - _loc9_.y);
            if(_loc29_ == 0 || _loc29_ == 1)
            {
               m_type = 4;
               m_axis = b2Math.CrossVF(b2Math.SubtractVV(_loc11_,_loc9_),1);
               m_axis.Normalize();
               m_localPoint = _loc28_;
               _loc31_ = m_axis;
               _loc34_ = param5.R;
               _loc6_ = _loc34_.col1.x * _loc31_.x + _loc34_.col2.x * _loc31_.y;
               _loc7_ = _loc34_.col1.y * _loc31_.x + _loc34_.col2.y * _loc31_.y;
               _loc31_ = m_localPoint;
               _loc34_ = param5.R;
               _loc33_ = param5.position.x + (_loc34_.col1.x * _loc31_.x + _loc34_.col2.x * _loc31_.y);
               _loc32_ = param5.position.y + (_loc34_.col1.y * _loc31_.x + _loc34_.col2.y * _loc31_.y);
               _loc31_ = _loc25_;
               _loc34_ = param3.R;
               _loc13_ = param3.position.x + (_loc34_.col1.x * _loc31_.x + _loc34_.col2.x * _loc31_.y);
               _loc12_ = param3.position.y + (_loc34_.col1.y * _loc31_.x + _loc34_.col2.y * _loc31_.y);
               _loc14_ = (_loc13_ - _loc33_) * _loc6_ + (_loc12_ - _loc32_) * _loc7_;
               if(_loc29_ < 0)
               {
                  m_axis.NegativeSelf();
               }
            }
            else
            {
               m_type = 2;
               m_axis = b2Math.CrossVF(b2Math.SubtractVV(_loc24_,_loc27_),1);
               m_localPoint = _loc25_;
               _loc31_ = m_axis;
               _loc34_ = param3.R;
               _loc6_ = _loc34_.col1.x * _loc31_.x + _loc34_.col2.x * _loc31_.y;
               _loc7_ = _loc34_.col1.y * _loc31_.x + _loc34_.col2.y * _loc31_.y;
               _loc31_ = m_localPoint;
               _loc34_ = param3.R;
               _loc13_ = param3.position.x + (_loc34_.col1.x * _loc31_.x + _loc34_.col2.x * _loc31_.y);
               _loc12_ = param3.position.y + (_loc34_.col1.y * _loc31_.x + _loc34_.col2.y * _loc31_.y);
               _loc31_ = _loc28_;
               _loc34_ = param5.R;
               _loc33_ = param5.position.x + (_loc34_.col1.x * _loc31_.x + _loc34_.col2.x * _loc31_.y);
               _loc32_ = param5.position.y + (_loc34_.col1.y * _loc31_.x + _loc34_.col2.y * _loc31_.y);
               _loc14_ = (_loc33_ - _loc13_) * _loc6_ + (_loc32_ - _loc12_) * _loc7_;
               if(_loc29_ < 0)
               {
                  m_axis.NegativeSelf();
               }
            }
         }
      }
      
      public function Evaluate(param1:b2Transform, param2:b2Transform) : Number
      {
         var _loc10_:* = null;
         var _loc8_:* = null;
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc7_:* = null;
         var _loc9_:* = null;
         var _loc6_:* = NaN;
         var _loc3_:* = null;
         switch(m_type - 1)
         {
            case 0:
               _loc10_ = b2Math.MulTMV(param1.R,m_axis);
               _loc8_ = b2Math.MulTMV(param2.R,m_axis.GetNegative());
               _loc4_ = m_proxyA.GetSupportVertex(_loc10_);
               _loc5_ = m_proxyB.GetSupportVertex(_loc8_);
               _loc7_ = b2Math.MulX(param1,_loc4_);
               _loc9_ = b2Math.MulX(param2,_loc5_);
               _loc6_ = (_loc9_.x - _loc7_.x) * m_axis.x + (_loc9_.y - _loc7_.y) * m_axis.y;
               return _loc6_;
            case 1:
               _loc3_ = b2Math.MulMV(param1.R,m_axis);
               _loc7_ = b2Math.MulX(param1,m_localPoint);
               _loc8_ = b2Math.MulTMV(param2.R,_loc3_.GetNegative());
               _loc5_ = m_proxyB.GetSupportVertex(_loc8_);
               _loc9_ = b2Math.MulX(param2,_loc5_);
               _loc6_ = (_loc9_.x - _loc7_.x) * _loc3_.x + (_loc9_.y - _loc7_.y) * _loc3_.y;
               return _loc6_;
            case 3:
               _loc3_ = b2Math.MulMV(param2.R,m_axis);
               _loc9_ = b2Math.MulX(param2,m_localPoint);
               _loc10_ = b2Math.MulTMV(param1.R,_loc3_.GetNegative());
               _loc4_ = m_proxyA.GetSupportVertex(_loc10_);
               _loc7_ = b2Math.MulX(param1,_loc4_);
               _loc6_ = (_loc7_.x - _loc9_.x) * _loc3_.x + (_loc7_.y - _loc9_.y) * _loc3_.y;
               return _loc6_;
            default:
               b2Settings.b2Assert(false);
               return 0;
         }
      }
   }
}
