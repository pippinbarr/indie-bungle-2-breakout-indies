package Box2D.Collision.Shapes
{
   import Box2D.Common.b2internal;
   import Box2D.Common.Math.b2Transform;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.Math.b2Mat22;
   import Box2D.Collision.b2RayCastOutput;
   import Box2D.Collision.b2RayCastInput;
   import Box2D.Collision.b2AABB;
   import Box2D.Common.Math.b2Math;
   
   use namespace b2internal;
   
   public class b2CircleShape extends b2Shape
   {
       
      b2internal var m_p:b2Vec2;
      
      public function b2CircleShape(param1:Number = 0)
      {
         m_p = new b2Vec2();
         super();
         m_type = 0;
         m_radius = param1;
      }
      
      override public function Copy() : b2Shape
      {
         var _loc1_:b2Shape = new b2CircleShape();
         _loc1_.Set(this);
         return _loc1_;
      }
      
      override public function Set(param1:b2Shape) : void
      {
         var _loc2_:* = null;
         super.Set(param1);
         if(param1 is b2CircleShape)
         {
            _loc2_ = param1 as b2CircleShape;
            m_p.SetV(_loc2_.m_p);
         }
      }
      
      override public function TestPoint(param1:b2Transform, param2:b2Vec2) : Boolean
      {
         var _loc5_:b2Mat22 = param1.R;
         var _loc3_:Number = param1.position.x + (_loc5_.col1.x * m_p.x + _loc5_.col2.x * m_p.y);
         var _loc4_:Number = param1.position.y + (_loc5_.col1.y * m_p.x + _loc5_.col2.y * m_p.y);
         _loc3_ = param2.x - _loc3_;
         _loc4_ = param2.y - _loc4_;
         return _loc3_ * _loc3_ + _loc4_ * _loc4_ <= m_radius * m_radius;
      }
      
      override public function RayCast(param1:b2RayCastOutput, param2:b2RayCastInput, param3:b2Transform) : Boolean
      {
         var _loc15_:b2Mat22 = param3.R;
         var _loc13_:Number = param3.position.x + (_loc15_.col1.x * m_p.x + _loc15_.col2.x * m_p.y);
         var _loc14_:Number = param3.position.y + (_loc15_.col1.y * m_p.x + _loc15_.col2.y * m_p.y);
         var _loc9_:Number = param2.p1.x - _loc13_;
         var _loc10_:Number = param2.p1.y - _loc14_;
         var _loc7_:Number = _loc9_ * _loc9_ + _loc10_ * _loc10_ - m_radius * m_radius;
         var _loc11_:Number = param2.p2.x - param2.p1.x;
         var _loc12_:Number = param2.p2.y - param2.p1.y;
         var _loc8_:Number = _loc9_ * _loc11_ + _loc10_ * _loc12_;
         var _loc4_:Number = _loc11_ * _loc11_ + _loc12_ * _loc12_;
         var _loc5_:Number = _loc8_ * _loc8_ - _loc4_ * _loc7_;
         if(_loc5_ < 0 || _loc4_ < Number.MIN_VALUE)
         {
            return false;
         }
         var _loc6_:Number = -(_loc8_ + Math.sqrt(_loc5_));
         if(0 <= _loc6_ && _loc6_ <= param2.maxFraction * _loc4_)
         {
            _loc6_ = _loc6_ / _loc4_;
            param1.fraction = _loc6_;
            param1.normal.x = _loc9_ + _loc6_ * _loc11_;
            param1.normal.y = _loc10_ + _loc6_ * _loc12_;
            param1.normal.Normalize();
            return true;
         }
         return false;
      }
      
      override public function ComputeAABB(param1:b2AABB, param2:b2Transform) : void
      {
         var _loc4_:b2Mat22 = param2.R;
         var _loc3_:Number = param2.position.x + (_loc4_.col1.x * m_p.x + _loc4_.col2.x * m_p.y);
         var _loc5_:Number = param2.position.y + (_loc4_.col1.y * m_p.x + _loc4_.col2.y * m_p.y);
         param1.lowerBound.Set(_loc3_ - m_radius,_loc5_ - m_radius);
         param1.upperBound.Set(_loc3_ + m_radius,_loc5_ + m_radius);
      }
      
      override public function ComputeMass(param1:b2MassData, param2:Number) : void
      {
         param1.mass = param2 * 3.141592653589793 * m_radius * m_radius;
         param1.center.SetV(m_p);
         param1.I = param1.mass * (0.5 * m_radius * m_radius + (m_p.x * m_p.x + m_p.y * m_p.y));
      }
      
      override public function ComputeSubmergedArea(param1:b2Vec2, param2:Number, param3:b2Transform, param4:b2Vec2) : Number
      {
         var _loc5_:b2Vec2 = b2Math.MulX(param3,m_p);
         var _loc10_:Number = -(b2Math.Dot(param1,_loc5_) - param2);
         if(_loc10_ < -m_radius + Number.MIN_VALUE)
         {
            return 0;
         }
         if(_loc10_ > m_radius)
         {
            param4.SetV(_loc5_);
            return 3.141592653589793 * m_radius * m_radius;
         }
         var _loc6_:Number = m_radius * m_radius;
         var _loc9_:Number = _loc10_ * _loc10_;
         var _loc7_:Number = _loc6_ * (Math.asin(_loc10_ / m_radius) + 3.141592653589793 / 2) + _loc10_ * Math.sqrt(_loc6_ - _loc9_);
         var _loc8_:Number = -0.6666666666666666 * Math.pow(_loc6_ - _loc9_,1.5) / _loc7_;
         param4.x = _loc5_.x + param1.x * _loc8_;
         param4.y = _loc5_.y + param1.y * _loc8_;
         return _loc7_;
      }
      
      public function GetLocalPosition() : b2Vec2
      {
         return m_p;
      }
      
      public function SetLocalPosition(param1:b2Vec2) : void
      {
         m_p.SetV(param1);
      }
      
      public function GetRadius() : Number
      {
         return m_radius;
      }
      
      public function SetRadius(param1:Number) : void
      {
         m_radius = param1;
      }
   }
}
