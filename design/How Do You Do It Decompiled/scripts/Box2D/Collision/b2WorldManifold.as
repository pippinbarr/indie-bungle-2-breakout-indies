package Box2D.Collision
{
   import Box2D.Common.Math.b2Transform;
   import Box2D.Common.Math.b2Mat22;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.b2internal;
   
   use namespace b2internal;
   
   public class b2WorldManifold
   {
       
      public var m_normal:b2Vec2;
      
      public var m_points:Vector.<b2Vec2>;
      
      public function b2WorldManifold()
      {
         var _loc1_:* = 0;
         m_normal = new b2Vec2();
         super();
         m_points = new Vector.<b2Vec2>(2);
         _loc1_ = 0;
         while(_loc1_ < 2)
         {
            m_points[_loc1_] = new b2Vec2();
            _loc1_++;
         }
      }
      
      public function Initialize(param1:b2Manifold, param2:b2Transform, param3:Number, param4:b2Transform, param5:Number) : void
      {
         var _loc18_:* = 0;
         var _loc21_:* = null;
         var _loc24_:* = null;
         var _loc6_:* = NaN;
         var _loc7_:* = NaN;
         var _loc15_:* = NaN;
         var _loc13_:* = NaN;
         var _loc9_:* = NaN;
         var _loc10_:* = NaN;
         var _loc12_:* = NaN;
         var _loc11_:* = NaN;
         var _loc25_:* = NaN;
         var _loc22_:* = NaN;
         var _loc19_:* = NaN;
         var _loc20_:* = NaN;
         var _loc8_:* = NaN;
         var _loc17_:* = NaN;
         var _loc16_:* = NaN;
         var _loc14_:* = NaN;
         var _loc23_:* = NaN;
         var _loc26_:* = NaN;
         if(param1.m_pointCount == 0)
         {
            return;
         }
         loop2:
         switch(param1.m_type - 1)
         {
            case 0:
               _loc24_ = param2.R;
               _loc21_ = param1.m_localPoint;
               _loc12_ = param2.position.x + _loc24_.col1.x * _loc21_.x + _loc24_.col2.x * _loc21_.y;
               _loc11_ = param2.position.y + _loc24_.col1.y * _loc21_.x + _loc24_.col2.y * _loc21_.y;
               _loc24_ = param4.R;
               _loc21_ = param1.m_points[0].m_localPoint;
               _loc25_ = param4.position.x + _loc24_.col1.x * _loc21_.x + _loc24_.col2.x * _loc21_.y;
               _loc22_ = param4.position.y + _loc24_.col1.y * _loc21_.x + _loc24_.col2.y * _loc21_.y;
               _loc19_ = _loc25_ - _loc12_;
               _loc20_ = _loc22_ - _loc11_;
               _loc8_ = _loc19_ * _loc19_ + _loc20_ * _loc20_;
               if(_loc8_ > Number.MIN_VALUE * Number.MIN_VALUE)
               {
                  _loc17_ = Math.sqrt(_loc8_);
                  m_normal.x = _loc19_ / _loc17_;
                  m_normal.y = _loc20_ / _loc17_;
               }
               else
               {
                  m_normal.x = 1;
                  m_normal.y = 0;
               }
               _loc16_ = _loc12_ + param3 * m_normal.x;
               _loc14_ = _loc11_ + param3 * m_normal.y;
               _loc23_ = _loc25_ - param5 * m_normal.x;
               _loc26_ = _loc22_ - param5 * m_normal.y;
               m_points[0].x = 0.5 * (_loc16_ + _loc23_);
               m_points[0].y = 0.5 * (_loc14_ + _loc26_);
               break;
            case 1:
               _loc24_ = param2.R;
               _loc21_ = param1.m_localPlaneNormal;
               _loc6_ = _loc24_.col1.x * _loc21_.x + _loc24_.col2.x * _loc21_.y;
               _loc7_ = _loc24_.col1.y * _loc21_.x + _loc24_.col2.y * _loc21_.y;
               _loc24_ = param2.R;
               _loc21_ = param1.m_localPoint;
               _loc15_ = param2.position.x + _loc24_.col1.x * _loc21_.x + _loc24_.col2.x * _loc21_.y;
               _loc13_ = param2.position.y + _loc24_.col1.y * _loc21_.x + _loc24_.col2.y * _loc21_.y;
               m_normal.x = _loc6_;
               m_normal.y = _loc7_;
               _loc18_ = 0;
               while(_loc18_ < param1.m_pointCount)
               {
                  _loc24_ = param4.R;
                  _loc21_ = param1.m_points[_loc18_].m_localPoint;
                  _loc9_ = param4.position.x + _loc24_.col1.x * _loc21_.x + _loc24_.col2.x * _loc21_.y;
                  _loc10_ = param4.position.y + _loc24_.col1.y * _loc21_.x + _loc24_.col2.y * _loc21_.y;
                  m_points[_loc18_].x = _loc9_ + 0.5 * (param3 - (_loc9_ - _loc15_) * _loc6_ - (_loc10_ - _loc13_) * _loc7_ - param5) * _loc6_;
                  m_points[_loc18_].y = _loc10_ + 0.5 * (param3 - (_loc9_ - _loc15_) * _loc6_ - (_loc10_ - _loc13_) * _loc7_ - param5) * _loc7_;
                  _loc18_++;
               }
            case 3:
               _loc24_ = param4.R;
               _loc21_ = param1.m_localPlaneNormal;
               _loc6_ = _loc24_.col1.x * _loc21_.x + _loc24_.col2.x * _loc21_.y;
               _loc7_ = _loc24_.col1.y * _loc21_.x + _loc24_.col2.y * _loc21_.y;
               _loc24_ = param4.R;
               _loc21_ = param1.m_localPoint;
               _loc15_ = param4.position.x + _loc24_.col1.x * _loc21_.x + _loc24_.col2.x * _loc21_.y;
               _loc13_ = param4.position.y + _loc24_.col1.y * _loc21_.x + _loc24_.col2.y * _loc21_.y;
               m_normal.x = -_loc6_;
               m_normal.y = -_loc7_;
               _loc18_ = 0;
               while(true)
               {
                  if(_loc18_ >= param1.m_pointCount)
                  {
                     break loop2;
                  }
                  _loc24_ = param2.R;
                  _loc21_ = param1.m_points[_loc18_].m_localPoint;
                  _loc9_ = param2.position.x + _loc24_.col1.x * _loc21_.x + _loc24_.col2.x * _loc21_.y;
                  _loc10_ = param2.position.y + _loc24_.col1.y * _loc21_.x + _loc24_.col2.y * _loc21_.y;
                  m_points[_loc18_].x = _loc9_ + 0.5 * (param5 - (_loc9_ - _loc15_) * _loc6_ - (_loc10_ - _loc13_) * _loc7_ - param3) * _loc6_;
                  m_points[_loc18_].y = _loc10_ + 0.5 * (param5 - (_loc9_ - _loc15_) * _loc6_ - (_loc10_ - _loc13_) * _loc7_ - param3) * _loc7_;
                  _loc18_++;
               }
               break;
            default:
               _loc24_ = param2.R;
               _loc21_ = param1.m_localPlaneNormal;
               _loc6_ = _loc24_.col1.x * _loc21_.x + _loc24_.col2.x * _loc21_.y;
               _loc7_ = _loc24_.col1.y * _loc21_.x + _loc24_.col2.y * _loc21_.y;
               _loc24_ = param2.R;
               _loc21_ = param1.m_localPoint;
               _loc15_ = param2.position.x + _loc24_.col1.x * _loc21_.x + _loc24_.col2.x * _loc21_.y;
               _loc13_ = param2.position.y + _loc24_.col1.y * _loc21_.x + _loc24_.col2.y * _loc21_.y;
               m_normal.x = _loc6_;
               m_normal.y = _loc7_;
               _loc18_ = 0;
               while(_loc18_ < param1.m_pointCount)
               {
                  _loc24_ = param4.R;
                  _loc21_ = param1.m_points[_loc18_].m_localPoint;
                  _loc9_ = param4.position.x + _loc24_.col1.x * _loc21_.x + _loc24_.col2.x * _loc21_.y;
                  _loc10_ = param4.position.y + _loc24_.col1.y * _loc21_.x + _loc24_.col2.y * _loc21_.y;
                  m_points[_loc18_].x = _loc9_ + 0.5 * (param3 - (_loc9_ - _loc15_) * _loc6_ - (_loc10_ - _loc13_) * _loc7_ - param5) * _loc6_;
                  m_points[_loc18_].y = _loc10_ + 0.5 * (param3 - (_loc9_ - _loc15_) * _loc6_ - (_loc10_ - _loc13_) * _loc7_ - param5) * _loc7_;
                  _loc18_++;
               }
         }
      }
   }
}
