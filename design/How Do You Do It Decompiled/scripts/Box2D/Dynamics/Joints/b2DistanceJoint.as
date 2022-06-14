package Box2D.Dynamics.Joints
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.b2internal;
   import Box2D.Dynamics.b2TimeStep;
   import Box2D.Dynamics.b2Body;
   import Box2D.Common.Math.b2Mat22;
   import Box2D.Common.Math.b2Math;
   
   use namespace b2internal;
   
   public class b2DistanceJoint extends b2Joint
   {
       
      private var m_localAnchor1:b2Vec2;
      
      private var m_localAnchor2:b2Vec2;
      
      private var m_u:b2Vec2;
      
      private var m_frequencyHz:Number;
      
      private var m_dampingRatio:Number;
      
      private var m_gamma:Number;
      
      private var m_bias:Number;
      
      private var m_impulse:Number;
      
      private var m_mass:Number;
      
      private var m_length:Number;
      
      public function b2DistanceJoint(param1:b2DistanceJointDef)
      {
         var _loc4_:* = null;
         var _loc2_:* = NaN;
         var _loc3_:* = NaN;
         m_localAnchor1 = new b2Vec2();
         m_localAnchor2 = new b2Vec2();
         m_u = new b2Vec2();
         super(param1);
         m_localAnchor1.SetV(param1.localAnchorA);
         m_localAnchor2.SetV(param1.localAnchorB);
         m_length = param1.length;
         m_frequencyHz = param1.frequencyHz;
         m_dampingRatio = param1.dampingRatio;
         m_impulse = 0;
         m_gamma = 0;
         m_bias = 0;
      }
      
      override public function GetAnchorA() : b2Vec2
      {
         return m_bodyA.GetWorldPoint(m_localAnchor1);
      }
      
      override public function GetAnchorB() : b2Vec2
      {
         return m_bodyB.GetWorldPoint(m_localAnchor2);
      }
      
      override public function GetReactionForce(param1:Number) : b2Vec2
      {
         return new b2Vec2(param1 * m_impulse * m_u.x,param1 * m_impulse * m_u.y);
      }
      
      override public function GetReactionTorque(param1:Number) : Number
      {
         return 0;
      }
      
      public function GetLength() : Number
      {
         return m_length;
      }
      
      public function SetLength(param1:Number) : void
      {
         m_length = param1;
      }
      
      public function GetFrequency() : Number
      {
         return m_frequencyHz;
      }
      
      public function SetFrequency(param1:Number) : void
      {
         m_frequencyHz = param1;
      }
      
      public function GetDampingRatio() : Number
      {
         return m_dampingRatio;
      }
      
      public function SetDampingRatio(param1:Number) : void
      {
         m_dampingRatio = param1;
      }
      
      override b2internal function InitVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc14_:* = null;
         var _loc5_:* = NaN;
         var _loc4_:* = NaN;
         var _loc11_:* = NaN;
         var _loc6_:* = NaN;
         var _loc10_:* = NaN;
         var _loc8_:* = NaN;
         var _loc9_:* = NaN;
         var _loc19_:b2Body = m_bodyA;
         var _loc2_:b2Body = m_bodyB;
         _loc14_ = _loc19_.m_xf.R;
         var _loc12_:Number = m_localAnchor1.x - _loc19_.m_sweep.localCenter.x;
         var _loc16_:Number = m_localAnchor1.y - _loc19_.m_sweep.localCenter.y;
         _loc5_ = _loc14_.col1.x * _loc12_ + _loc14_.col2.x * _loc16_;
         _loc16_ = _loc14_.col1.y * _loc12_ + _loc14_.col2.y * _loc16_;
         _loc12_ = _loc5_;
         _loc14_ = _loc2_.m_xf.R;
         var _loc15_:Number = m_localAnchor2.x - _loc2_.m_sweep.localCenter.x;
         var _loc13_:Number = m_localAnchor2.y - _loc2_.m_sweep.localCenter.y;
         _loc5_ = _loc14_.col1.x * _loc15_ + _loc14_.col2.x * _loc13_;
         _loc13_ = _loc14_.col1.y * _loc15_ + _loc14_.col2.y * _loc13_;
         _loc15_ = _loc5_;
         m_u.x = _loc2_.m_sweep.c.x + _loc15_ - _loc19_.m_sweep.c.x - _loc12_;
         m_u.y = _loc2_.m_sweep.c.y + _loc13_ - _loc19_.m_sweep.c.y - _loc16_;
         var _loc7_:Number = Math.sqrt(m_u.x * m_u.x + m_u.y * m_u.y);
         if(_loc7_ > 0.005)
         {
            m_u.Multiply(1 / _loc7_);
         }
         else
         {
            m_u.SetZero();
         }
         var _loc18_:Number = _loc12_ * m_u.y - _loc16_ * m_u.x;
         var _loc17_:Number = _loc15_ * m_u.y - _loc13_ * m_u.x;
         var _loc3_:Number = _loc19_.m_invMass + _loc19_.m_invI * _loc18_ * _loc18_ + _loc2_.m_invMass + _loc2_.m_invI * _loc17_ * _loc17_;
         m_mass = _loc3_ != 0?1 / _loc3_:0.0;
         if(m_frequencyHz > 0)
         {
            _loc4_ = _loc7_ - m_length;
            _loc11_ = 2 * 3.141592653589793 * m_frequencyHz;
            _loc6_ = 2 * m_mass * m_dampingRatio * _loc11_;
            _loc10_ = m_mass * _loc11_ * _loc11_;
            m_gamma = param1.dt * (_loc6_ + param1.dt * _loc10_);
            m_gamma = m_gamma != 0?1 / m_gamma:0.0;
            m_bias = _loc4_ * param1.dt * _loc10_ * m_gamma;
            m_mass = _loc3_ + m_gamma;
            m_mass = m_mass != 0?1 / m_mass:0.0;
         }
         if(param1.warmStarting)
         {
            m_impulse = §§dup().m_impulse * param1.dtRatio;
            _loc8_ = m_impulse * m_u.x;
            _loc9_ = m_impulse * m_u.y;
            _loc19_.m_linearVelocity.x = _loc19_.m_linearVelocity.x - _loc19_.m_invMass * _loc8_;
            _loc19_.m_linearVelocity.y = _loc19_.m_linearVelocity.y - _loc19_.m_invMass * _loc9_;
            _loc19_.m_angularVelocity = _loc19_.m_angularVelocity - _loc19_.m_invI * (_loc12_ * _loc9_ - _loc16_ * _loc8_);
            _loc2_.m_linearVelocity.x = _loc2_.m_linearVelocity.x + _loc2_.m_invMass * _loc8_;
            _loc2_.m_linearVelocity.y = _loc2_.m_linearVelocity.y + _loc2_.m_invMass * _loc9_;
            _loc2_.m_angularVelocity = _loc2_.m_angularVelocity + _loc2_.m_invI * (_loc15_ * _loc9_ - _loc13_ * _loc8_);
         }
         else
         {
            m_impulse = 0;
         }
      }
      
      override b2internal function SolveVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc8_:* = null;
         var _loc16_:b2Body = m_bodyA;
         var _loc2_:b2Body = m_bodyB;
         _loc8_ = _loc16_.m_xf.R;
         var _loc6_:Number = m_localAnchor1.x - _loc16_.m_sweep.localCenter.x;
         var _loc12_:Number = m_localAnchor1.y - _loc16_.m_sweep.localCenter.y;
         var _loc3_:Number = _loc8_.col1.x * _loc6_ + _loc8_.col2.x * _loc12_;
         _loc12_ = _loc8_.col1.y * _loc6_ + _loc8_.col2.y * _loc12_;
         _loc6_ = _loc3_;
         _loc8_ = _loc2_.m_xf.R;
         var _loc9_:Number = m_localAnchor2.x - _loc2_.m_sweep.localCenter.x;
         var _loc7_:Number = m_localAnchor2.y - _loc2_.m_sweep.localCenter.y;
         _loc3_ = _loc8_.col1.x * _loc9_ + _loc8_.col2.x * _loc7_;
         _loc7_ = _loc8_.col1.y * _loc9_ + _loc8_.col2.y * _loc7_;
         _loc9_ = _loc3_;
         var _loc13_:Number = _loc16_.m_linearVelocity.x + -_loc16_.m_angularVelocity * _loc12_;
         var _loc17_:Number = _loc16_.m_linearVelocity.y + _loc16_.m_angularVelocity * _loc6_;
         var _loc15_:Number = _loc2_.m_linearVelocity.x + -_loc2_.m_angularVelocity * _loc7_;
         var _loc14_:Number = _loc2_.m_linearVelocity.y + _loc2_.m_angularVelocity * _loc9_;
         var _loc10_:Number = m_u.x * (_loc15_ - _loc13_) + m_u.y * (_loc14_ - _loc17_);
         var _loc11_:Number = -m_mass * (_loc10_ + m_bias + m_gamma * m_impulse);
         m_impulse = §§dup().m_impulse + _loc11_;
         var _loc4_:Number = _loc11_ * m_u.x;
         var _loc5_:Number = _loc11_ * m_u.y;
         _loc16_.m_linearVelocity.x = _loc16_.m_linearVelocity.x - _loc16_.m_invMass * _loc4_;
         _loc16_.m_linearVelocity.y = _loc16_.m_linearVelocity.y - _loc16_.m_invMass * _loc5_;
         _loc16_.m_angularVelocity = _loc16_.m_angularVelocity - _loc16_.m_invI * (_loc6_ * _loc5_ - _loc12_ * _loc4_);
         _loc2_.m_linearVelocity.x = _loc2_.m_linearVelocity.x + _loc2_.m_invMass * _loc4_;
         _loc2_.m_linearVelocity.y = _loc2_.m_linearVelocity.y + _loc2_.m_invMass * _loc5_;
         _loc2_.m_angularVelocity = _loc2_.m_angularVelocity + _loc2_.m_invI * (_loc9_ * _loc5_ - _loc7_ * _loc4_);
      }
      
      override b2internal function SolvePositionConstraints(param1:Number) : Boolean
      {
         var _loc12_:* = null;
         if(m_frequencyHz > 0)
         {
            return true;
         }
         var _loc16_:b2Body = m_bodyA;
         var _loc2_:b2Body = m_bodyB;
         _loc12_ = _loc16_.m_xf.R;
         var _loc10_:Number = m_localAnchor1.x - _loc16_.m_sweep.localCenter.x;
         var _loc15_:Number = m_localAnchor1.y - _loc16_.m_sweep.localCenter.y;
         var _loc4_:Number = _loc12_.col1.x * _loc10_ + _loc12_.col2.x * _loc15_;
         _loc15_ = _loc12_.col1.y * _loc10_ + _loc12_.col2.y * _loc15_;
         _loc10_ = _loc4_;
         _loc12_ = _loc2_.m_xf.R;
         var _loc13_:Number = m_localAnchor2.x - _loc2_.m_sweep.localCenter.x;
         var _loc11_:Number = m_localAnchor2.y - _loc2_.m_sweep.localCenter.y;
         _loc4_ = _loc12_.col1.x * _loc13_ + _loc12_.col2.x * _loc11_;
         _loc11_ = _loc12_.col1.y * _loc13_ + _loc12_.col2.y * _loc11_;
         _loc13_ = _loc4_;
         var _loc8_:Number = _loc2_.m_sweep.c.x + _loc13_ - _loc16_.m_sweep.c.x - _loc10_;
         var _loc9_:Number = _loc2_.m_sweep.c.y + _loc11_ - _loc16_.m_sweep.c.y - _loc15_;
         var _loc5_:Number = Math.sqrt(_loc8_ * _loc8_ + _loc9_ * _loc9_);
         _loc8_ = _loc8_ / _loc5_;
         _loc9_ = _loc9_ / _loc5_;
         var _loc3_:Number = _loc5_ - m_length;
         _loc3_ = b2Math.Clamp(_loc3_,-0.2,0.2);
         var _loc14_:Number = -m_mass * _loc3_;
         m_u.Set(_loc8_,_loc9_);
         var _loc6_:Number = _loc14_ * m_u.x;
         var _loc7_:Number = _loc14_ * m_u.y;
         _loc16_.m_sweep.c.x = _loc16_.m_sweep.c.x - _loc16_.m_invMass * _loc6_;
         _loc16_.m_sweep.c.y = _loc16_.m_sweep.c.y - _loc16_.m_invMass * _loc7_;
         _loc16_.m_sweep.a = _loc16_.m_sweep.a - _loc16_.m_invI * (_loc10_ * _loc7_ - _loc15_ * _loc6_);
         _loc2_.m_sweep.c.x = _loc2_.m_sweep.c.x + _loc2_.m_invMass * _loc6_;
         _loc2_.m_sweep.c.y = _loc2_.m_sweep.c.y + _loc2_.m_invMass * _loc7_;
         _loc2_.m_sweep.a = _loc2_.m_sweep.a + _loc2_.m_invI * (_loc13_ * _loc7_ - _loc11_ * _loc6_);
         _loc16_.SynchronizeTransform();
         _loc2_.SynchronizeTransform();
         return b2Math.Abs(_loc3_) < 0.005;
      }
   }
}
