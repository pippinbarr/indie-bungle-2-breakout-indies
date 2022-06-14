package Box2D.Dynamics.Joints
{
   import Box2D.Common.b2internal;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2TimeStep;
   import Box2D.Dynamics.b2Body;
   import Box2D.Common.Math.b2Mat22;
   import Box2D.Common.Math.b2Math;
   
   use namespace b2internal;
   
   public class b2PulleyJoint extends b2Joint
   {
      
      b2internal static const b2_minPulleyLength:Number = 2.0;
       
      private var m_ground:b2Body;
      
      private var m_groundAnchor1:b2Vec2;
      
      private var m_groundAnchor2:b2Vec2;
      
      private var m_localAnchor1:b2Vec2;
      
      private var m_localAnchor2:b2Vec2;
      
      private var m_u1:b2Vec2;
      
      private var m_u2:b2Vec2;
      
      private var m_constant:Number;
      
      private var m_ratio:Number;
      
      private var m_maxLength1:Number;
      
      private var m_maxLength2:Number;
      
      private var m_pulleyMass:Number;
      
      private var m_limitMass1:Number;
      
      private var m_limitMass2:Number;
      
      private var m_impulse:Number;
      
      private var m_limitImpulse1:Number;
      
      private var m_limitImpulse2:Number;
      
      private var m_state:int;
      
      private var m_limitState1:int;
      
      private var m_limitState2:int;
      
      public function b2PulleyJoint(param1:b2PulleyJointDef)
      {
         var _loc4_:* = null;
         var _loc2_:* = NaN;
         var _loc3_:* = NaN;
         m_groundAnchor1 = new b2Vec2();
         m_groundAnchor2 = new b2Vec2();
         m_localAnchor1 = new b2Vec2();
         m_localAnchor2 = new b2Vec2();
         m_u1 = new b2Vec2();
         m_u2 = new b2Vec2();
         super(param1);
         m_ground = m_bodyA.m_world.m_groundBody;
         m_groundAnchor1.x = param1.groundAnchorA.x - m_ground.m_xf.position.x;
         m_groundAnchor1.y = param1.groundAnchorA.y - m_ground.m_xf.position.y;
         m_groundAnchor2.x = param1.groundAnchorB.x - m_ground.m_xf.position.x;
         m_groundAnchor2.y = param1.groundAnchorB.y - m_ground.m_xf.position.y;
         m_localAnchor1.SetV(param1.localAnchorA);
         m_localAnchor2.SetV(param1.localAnchorB);
         m_ratio = param1.ratio;
         m_constant = param1.lengthA + m_ratio * param1.lengthB;
         m_maxLength1 = b2Math.Min(param1.maxLengthA,m_constant - m_ratio * 2);
         m_maxLength2 = b2Math.Min(param1.maxLengthB,(m_constant - 2) / m_ratio);
         m_impulse = 0;
         m_limitImpulse1 = 0;
         m_limitImpulse2 = 0;
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
         return new b2Vec2(param1 * m_impulse * m_u2.x,param1 * m_impulse * m_u2.y);
      }
      
      override public function GetReactionTorque(param1:Number) : Number
      {
         return 0;
      }
      
      public function GetGroundAnchorA() : b2Vec2
      {
         var _loc1_:b2Vec2 = m_ground.m_xf.position.Copy();
         _loc1_.Add(m_groundAnchor1);
         return _loc1_;
      }
      
      public function GetGroundAnchorB() : b2Vec2
      {
         var _loc1_:b2Vec2 = m_ground.m_xf.position.Copy();
         _loc1_.Add(m_groundAnchor2);
         return _loc1_;
      }
      
      public function GetLength1() : Number
      {
         var _loc1_:b2Vec2 = m_bodyA.GetWorldPoint(m_localAnchor1);
         var _loc3_:Number = m_ground.m_xf.position.x + m_groundAnchor1.x;
         var _loc5_:Number = m_ground.m_xf.position.y + m_groundAnchor1.y;
         var _loc2_:Number = _loc1_.x - _loc3_;
         var _loc4_:Number = _loc1_.y - _loc5_;
         return Math.sqrt(_loc2_ * _loc2_ + _loc4_ * _loc4_);
      }
      
      public function GetLength2() : Number
      {
         var _loc1_:b2Vec2 = m_bodyB.GetWorldPoint(m_localAnchor2);
         var _loc3_:Number = m_ground.m_xf.position.x + m_groundAnchor2.x;
         var _loc5_:Number = m_ground.m_xf.position.y + m_groundAnchor2.y;
         var _loc2_:Number = _loc1_.x - _loc3_;
         var _loc4_:Number = _loc1_.y - _loc5_;
         return Math.sqrt(_loc2_ * _loc2_ + _loc4_ * _loc4_);
      }
      
      public function GetRatio() : Number
      {
         return m_ratio;
      }
      
      override b2internal function InitVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc22_:* = null;
         var _loc4_:* = NaN;
         var _loc10_:* = NaN;
         var _loc20_:* = NaN;
         var _loc19_:* = NaN;
         var _loc12_:b2Body = m_bodyA;
         var _loc13_:b2Body = m_bodyB;
         _loc22_ = _loc12_.m_xf.R;
         var _loc21_:Number = m_localAnchor1.x - _loc12_.m_sweep.localCenter.x;
         var _loc25_:Number = m_localAnchor1.y - _loc12_.m_sweep.localCenter.y;
         var _loc14_:Number = _loc22_.col1.x * _loc21_ + _loc22_.col2.x * _loc25_;
         _loc25_ = _loc22_.col1.y * _loc21_ + _loc22_.col2.y * _loc25_;
         _loc21_ = _loc14_;
         _loc22_ = _loc13_.m_xf.R;
         var _loc8_:Number = m_localAnchor2.x - _loc13_.m_sweep.localCenter.x;
         var _loc6_:Number = m_localAnchor2.y - _loc13_.m_sweep.localCenter.y;
         _loc14_ = _loc22_.col1.x * _loc8_ + _loc22_.col2.x * _loc6_;
         _loc6_ = _loc22_.col1.y * _loc8_ + _loc22_.col2.y * _loc6_;
         _loc8_ = _loc14_;
         var _loc18_:Number = _loc12_.m_sweep.c.x + _loc21_;
         var _loc23_:Number = _loc12_.m_sweep.c.y + _loc25_;
         var _loc5_:Number = _loc13_.m_sweep.c.x + _loc8_;
         var _loc3_:Number = _loc13_.m_sweep.c.y + _loc6_;
         var _loc26_:Number = m_ground.m_xf.position.x + m_groundAnchor1.x;
         var _loc24_:Number = m_ground.m_xf.position.y + m_groundAnchor1.y;
         var _loc7_:Number = m_ground.m_xf.position.x + m_groundAnchor2.x;
         var _loc11_:Number = m_ground.m_xf.position.y + m_groundAnchor2.y;
         m_u1.Set(_loc18_ - _loc26_,_loc23_ - _loc24_);
         m_u2.Set(_loc5_ - _loc7_,_loc3_ - _loc11_);
         var _loc16_:Number = m_u1.Length();
         var _loc17_:Number = m_u2.Length();
         if(_loc16_ > 0.005)
         {
            m_u1.Multiply(1 / _loc16_);
         }
         else
         {
            m_u1.SetZero();
         }
         if(_loc17_ > 0.005)
         {
            m_u2.Multiply(1 / _loc17_);
         }
         else
         {
            m_u2.SetZero();
         }
         var _loc2_:Number = m_constant - _loc16_ - m_ratio * _loc17_;
         if(_loc2_ > 0)
         {
            m_state = 0;
            m_impulse = 0;
         }
         else
         {
            m_state = 2;
         }
         if(_loc16_ < m_maxLength1)
         {
            m_limitState1 = 0;
            m_limitImpulse1 = 0;
         }
         else
         {
            m_limitState1 = 2;
         }
         if(_loc17_ < m_maxLength2)
         {
            m_limitState2 = 0;
            m_limitImpulse2 = 0;
         }
         else
         {
            m_limitState2 = 2;
         }
         var _loc9_:Number = _loc21_ * m_u1.y - _loc25_ * m_u1.x;
         var _loc15_:Number = _loc8_ * m_u2.y - _loc6_ * m_u2.x;
         m_limitMass1 = _loc12_.m_invMass + _loc12_.m_invI * _loc9_ * _loc9_;
         m_limitMass2 = _loc13_.m_invMass + _loc13_.m_invI * _loc15_ * _loc15_;
         m_pulleyMass = m_limitMass1 + m_ratio * m_ratio * m_limitMass2;
         m_limitMass1 = 1 / m_limitMass1;
         m_limitMass2 = 1 / m_limitMass2;
         m_pulleyMass = 1 / m_pulleyMass;
         if(param1.warmStarting)
         {
            m_impulse = §§dup().m_impulse * param1.dtRatio;
            m_limitImpulse1 = §§dup().m_limitImpulse1 * param1.dtRatio;
            m_limitImpulse2 = §§dup().m_limitImpulse2 * param1.dtRatio;
            _loc4_ = (-m_impulse - m_limitImpulse1) * m_u1.x;
            _loc10_ = (-m_impulse - m_limitImpulse1) * m_u1.y;
            _loc20_ = (-m_ratio * m_impulse - m_limitImpulse2) * m_u2.x;
            _loc19_ = (-m_ratio * m_impulse - m_limitImpulse2) * m_u2.y;
            _loc12_.m_linearVelocity.x = _loc12_.m_linearVelocity.x + _loc12_.m_invMass * _loc4_;
            _loc12_.m_linearVelocity.y = _loc12_.m_linearVelocity.y + _loc12_.m_invMass * _loc10_;
            _loc12_.m_angularVelocity = _loc12_.m_angularVelocity + _loc12_.m_invI * (_loc21_ * _loc10_ - _loc25_ * _loc4_);
            _loc13_.m_linearVelocity.x = _loc13_.m_linearVelocity.x + _loc13_.m_invMass * _loc20_;
            _loc13_.m_linearVelocity.y = _loc13_.m_linearVelocity.y + _loc13_.m_invMass * _loc19_;
            _loc13_.m_angularVelocity = _loc13_.m_angularVelocity + _loc13_.m_invI * (_loc8_ * _loc19_ - _loc6_ * _loc20_);
         }
         else
         {
            m_impulse = 0;
            m_limitImpulse1 = 0;
            m_limitImpulse2 = 0;
         }
      }
      
      override b2internal function SolveVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc9_:* = null;
         var _loc16_:* = NaN;
         var _loc20_:* = NaN;
         var _loc18_:* = NaN;
         var _loc17_:* = NaN;
         var _loc4_:* = NaN;
         var _loc11_:* = NaN;
         var _loc6_:* = NaN;
         var _loc5_:* = NaN;
         var _loc12_:* = NaN;
         var _loc13_:* = NaN;
         var _loc14_:* = NaN;
         var _loc19_:b2Body = m_bodyA;
         var _loc2_:b2Body = m_bodyB;
         _loc9_ = _loc19_.m_xf.R;
         var _loc7_:Number = m_localAnchor1.x - _loc19_.m_sweep.localCenter.x;
         var _loc15_:Number = m_localAnchor1.y - _loc19_.m_sweep.localCenter.y;
         var _loc3_:Number = _loc9_.col1.x * _loc7_ + _loc9_.col2.x * _loc15_;
         _loc15_ = _loc9_.col1.y * _loc7_ + _loc9_.col2.y * _loc15_;
         _loc7_ = _loc3_;
         _loc9_ = _loc2_.m_xf.R;
         var _loc10_:Number = m_localAnchor2.x - _loc2_.m_sweep.localCenter.x;
         var _loc8_:Number = m_localAnchor2.y - _loc2_.m_sweep.localCenter.y;
         _loc3_ = _loc9_.col1.x * _loc10_ + _loc9_.col2.x * _loc8_;
         _loc8_ = _loc9_.col1.y * _loc10_ + _loc9_.col2.y * _loc8_;
         _loc10_ = _loc3_;
         if(m_state == 2)
         {
            _loc16_ = _loc19_.m_linearVelocity.x + -_loc19_.m_angularVelocity * _loc15_;
            _loc20_ = _loc19_.m_linearVelocity.y + _loc19_.m_angularVelocity * _loc7_;
            _loc18_ = _loc2_.m_linearVelocity.x + -_loc2_.m_angularVelocity * _loc8_;
            _loc17_ = _loc2_.m_linearVelocity.y + _loc2_.m_angularVelocity * _loc10_;
            _loc12_ = -(m_u1.x * _loc16_ + m_u1.y * _loc20_) - m_ratio * (m_u2.x * _loc18_ + m_u2.y * _loc17_);
            _loc13_ = m_pulleyMass * -_loc12_;
            _loc14_ = m_impulse;
            m_impulse = b2Math.Max(0,m_impulse + _loc13_);
            _loc13_ = m_impulse - _loc14_;
            _loc4_ = -_loc13_ * m_u1.x;
            _loc11_ = -_loc13_ * m_u1.y;
            _loc6_ = -m_ratio * _loc13_ * m_u2.x;
            _loc5_ = -m_ratio * _loc13_ * m_u2.y;
            _loc19_.m_linearVelocity.x = _loc19_.m_linearVelocity.x + _loc19_.m_invMass * _loc4_;
            _loc19_.m_linearVelocity.y = _loc19_.m_linearVelocity.y + _loc19_.m_invMass * _loc11_;
            _loc19_.m_angularVelocity = _loc19_.m_angularVelocity + _loc19_.m_invI * (_loc7_ * _loc11_ - _loc15_ * _loc4_);
            _loc2_.m_linearVelocity.x = _loc2_.m_linearVelocity.x + _loc2_.m_invMass * _loc6_;
            _loc2_.m_linearVelocity.y = _loc2_.m_linearVelocity.y + _loc2_.m_invMass * _loc5_;
            _loc2_.m_angularVelocity = _loc2_.m_angularVelocity + _loc2_.m_invI * (_loc10_ * _loc5_ - _loc8_ * _loc6_);
         }
         if(m_limitState1 == 2)
         {
            _loc16_ = _loc19_.m_linearVelocity.x + -_loc19_.m_angularVelocity * _loc15_;
            _loc20_ = _loc19_.m_linearVelocity.y + _loc19_.m_angularVelocity * _loc7_;
            _loc12_ = -(m_u1.x * _loc16_ + m_u1.y * _loc20_);
            _loc13_ = -m_limitMass1 * _loc12_;
            _loc14_ = m_limitImpulse1;
            m_limitImpulse1 = b2Math.Max(0,m_limitImpulse1 + _loc13_);
            _loc13_ = m_limitImpulse1 - _loc14_;
            _loc4_ = -_loc13_ * m_u1.x;
            _loc11_ = -_loc13_ * m_u1.y;
            _loc19_.m_linearVelocity.x = _loc19_.m_linearVelocity.x + _loc19_.m_invMass * _loc4_;
            _loc19_.m_linearVelocity.y = _loc19_.m_linearVelocity.y + _loc19_.m_invMass * _loc11_;
            _loc19_.m_angularVelocity = _loc19_.m_angularVelocity + _loc19_.m_invI * (_loc7_ * _loc11_ - _loc15_ * _loc4_);
         }
         if(m_limitState2 == 2)
         {
            _loc18_ = _loc2_.m_linearVelocity.x + -_loc2_.m_angularVelocity * _loc8_;
            _loc17_ = _loc2_.m_linearVelocity.y + _loc2_.m_angularVelocity * _loc10_;
            _loc12_ = -(m_u2.x * _loc18_ + m_u2.y * _loc17_);
            _loc13_ = -m_limitMass2 * _loc12_;
            _loc14_ = m_limitImpulse2;
            m_limitImpulse2 = b2Math.Max(0,m_limitImpulse2 + _loc13_);
            _loc13_ = m_limitImpulse2 - _loc14_;
            _loc6_ = -_loc13_ * m_u2.x;
            _loc5_ = -_loc13_ * m_u2.y;
            _loc2_.m_linearVelocity.x = _loc2_.m_linearVelocity.x + _loc2_.m_invMass * _loc6_;
            _loc2_.m_linearVelocity.y = _loc2_.m_linearVelocity.y + _loc2_.m_invMass * _loc5_;
            _loc2_.m_angularVelocity = _loc2_.m_angularVelocity + _loc2_.m_invI * (_loc10_ * _loc5_ - _loc8_ * _loc6_);
         }
      }
      
      override b2internal function SolvePositionConstraints(param1:Number) : Boolean
      {
         var _loc14_:* = null;
         var _loc12_:* = NaN;
         var _loc22_:* = NaN;
         var _loc15_:* = NaN;
         var _loc13_:* = NaN;
         var _loc8_:* = NaN;
         var _loc16_:* = NaN;
         var _loc10_:* = NaN;
         var _loc9_:* = NaN;
         var _loc6_:* = NaN;
         var _loc7_:* = NaN;
         var _loc3_:* = NaN;
         var _loc18_:* = NaN;
         var _loc19_:* = NaN;
         var _loc23_:* = NaN;
         var _loc5_:* = NaN;
         var _loc24_:b2Body = m_bodyA;
         var _loc2_:b2Body = m_bodyB;
         var _loc20_:Number = m_ground.m_xf.position.x + m_groundAnchor1.x;
         var _loc17_:Number = m_ground.m_xf.position.y + m_groundAnchor1.y;
         var _loc11_:Number = m_ground.m_xf.position.x + m_groundAnchor2.x;
         var _loc21_:Number = m_ground.m_xf.position.y + m_groundAnchor2.y;
         var _loc4_:* = 0.0;
         if(m_state == 2)
         {
            _loc14_ = _loc24_.m_xf.R;
            _loc12_ = m_localAnchor1.x - _loc24_.m_sweep.localCenter.x;
            _loc22_ = m_localAnchor1.y - _loc24_.m_sweep.localCenter.y;
            _loc5_ = _loc14_.col1.x * _loc12_ + _loc14_.col2.x * _loc22_;
            _loc22_ = _loc14_.col1.y * _loc12_ + _loc14_.col2.y * _loc22_;
            _loc12_ = _loc5_;
            _loc14_ = _loc2_.m_xf.R;
            _loc15_ = m_localAnchor2.x - _loc2_.m_sweep.localCenter.x;
            _loc13_ = m_localAnchor2.y - _loc2_.m_sweep.localCenter.y;
            _loc5_ = _loc14_.col1.x * _loc15_ + _loc14_.col2.x * _loc13_;
            _loc13_ = _loc14_.col1.y * _loc15_ + _loc14_.col2.y * _loc13_;
            _loc15_ = _loc5_;
            _loc8_ = _loc24_.m_sweep.c.x + _loc12_;
            _loc16_ = _loc24_.m_sweep.c.y + _loc22_;
            _loc10_ = _loc2_.m_sweep.c.x + _loc15_;
            _loc9_ = _loc2_.m_sweep.c.y + _loc13_;
            m_u1.Set(_loc8_ - _loc20_,_loc16_ - _loc17_);
            m_u2.Set(_loc10_ - _loc11_,_loc9_ - _loc21_);
            _loc6_ = m_u1.Length();
            _loc7_ = m_u2.Length();
            if(_loc6_ > 0.005)
            {
               m_u1.Multiply(1 / _loc6_);
            }
            else
            {
               m_u1.SetZero();
            }
            if(_loc7_ > 0.005)
            {
               m_u2.Multiply(1 / _loc7_);
            }
            else
            {
               m_u2.SetZero();
            }
            _loc3_ = m_constant - _loc6_ - m_ratio * _loc7_;
            _loc4_ = b2Math.Max(_loc4_,-_loc3_);
            _loc3_ = b2Math.Clamp(_loc3_ + 0.005,-0.2,0);
            _loc18_ = -m_pulleyMass * _loc3_;
            _loc8_ = -_loc18_ * m_u1.x;
            _loc16_ = -_loc18_ * m_u1.y;
            _loc10_ = -m_ratio * _loc18_ * m_u2.x;
            _loc9_ = -m_ratio * _loc18_ * m_u2.y;
            _loc24_.m_sweep.c.x = _loc24_.m_sweep.c.x + _loc24_.m_invMass * _loc8_;
            _loc24_.m_sweep.c.y = _loc24_.m_sweep.c.y + _loc24_.m_invMass * _loc16_;
            _loc24_.m_sweep.a = _loc24_.m_sweep.a + _loc24_.m_invI * (_loc12_ * _loc16_ - _loc22_ * _loc8_);
            _loc2_.m_sweep.c.x = _loc2_.m_sweep.c.x + _loc2_.m_invMass * _loc10_;
            _loc2_.m_sweep.c.y = _loc2_.m_sweep.c.y + _loc2_.m_invMass * _loc9_;
            _loc2_.m_sweep.a = _loc2_.m_sweep.a + _loc2_.m_invI * (_loc15_ * _loc9_ - _loc13_ * _loc10_);
            _loc24_.SynchronizeTransform();
            _loc2_.SynchronizeTransform();
         }
         if(m_limitState1 == 2)
         {
            _loc14_ = _loc24_.m_xf.R;
            _loc12_ = m_localAnchor1.x - _loc24_.m_sweep.localCenter.x;
            _loc22_ = m_localAnchor1.y - _loc24_.m_sweep.localCenter.y;
            _loc5_ = _loc14_.col1.x * _loc12_ + _loc14_.col2.x * _loc22_;
            _loc22_ = _loc14_.col1.y * _loc12_ + _loc14_.col2.y * _loc22_;
            _loc12_ = _loc5_;
            _loc8_ = _loc24_.m_sweep.c.x + _loc12_;
            _loc16_ = _loc24_.m_sweep.c.y + _loc22_;
            m_u1.Set(_loc8_ - _loc20_,_loc16_ - _loc17_);
            _loc6_ = m_u1.Length();
            if(_loc6_ > 0.005)
            {
               m_u1.x = m_u1.x * 1 / _loc6_;
               m_u1.y = m_u1.y * 1 / _loc6_;
            }
            else
            {
               m_u1.SetZero();
            }
            _loc3_ = m_maxLength1 - _loc6_;
            _loc4_ = b2Math.Max(_loc4_,-_loc3_);
            _loc3_ = b2Math.Clamp(_loc3_ + 0.005,-0.2,0);
            _loc18_ = -m_limitMass1 * _loc3_;
            _loc8_ = -_loc18_ * m_u1.x;
            _loc16_ = -_loc18_ * m_u1.y;
            _loc24_.m_sweep.c.x = _loc24_.m_sweep.c.x + _loc24_.m_invMass * _loc8_;
            _loc24_.m_sweep.c.y = _loc24_.m_sweep.c.y + _loc24_.m_invMass * _loc16_;
            _loc24_.m_sweep.a = _loc24_.m_sweep.a + _loc24_.m_invI * (_loc12_ * _loc16_ - _loc22_ * _loc8_);
            _loc24_.SynchronizeTransform();
         }
         if(m_limitState2 == 2)
         {
            _loc14_ = _loc2_.m_xf.R;
            _loc15_ = m_localAnchor2.x - _loc2_.m_sweep.localCenter.x;
            _loc13_ = m_localAnchor2.y - _loc2_.m_sweep.localCenter.y;
            _loc5_ = _loc14_.col1.x * _loc15_ + _loc14_.col2.x * _loc13_;
            _loc13_ = _loc14_.col1.y * _loc15_ + _loc14_.col2.y * _loc13_;
            _loc15_ = _loc5_;
            _loc10_ = _loc2_.m_sweep.c.x + _loc15_;
            _loc9_ = _loc2_.m_sweep.c.y + _loc13_;
            m_u2.Set(_loc10_ - _loc11_,_loc9_ - _loc21_);
            _loc7_ = m_u2.Length();
            if(_loc7_ > 0.005)
            {
               m_u2.x = m_u2.x * 1 / _loc7_;
               m_u2.y = m_u2.y * 1 / _loc7_;
            }
            else
            {
               m_u2.SetZero();
            }
            _loc3_ = m_maxLength2 - _loc7_;
            _loc4_ = b2Math.Max(_loc4_,-_loc3_);
            _loc3_ = b2Math.Clamp(_loc3_ + 0.005,-0.2,0);
            _loc18_ = -m_limitMass2 * _loc3_;
            _loc10_ = -_loc18_ * m_u2.x;
            _loc9_ = -_loc18_ * m_u2.y;
            _loc2_.m_sweep.c.x = _loc2_.m_sweep.c.x + _loc2_.m_invMass * _loc10_;
            _loc2_.m_sweep.c.y = _loc2_.m_sweep.c.y + _loc2_.m_invMass * _loc9_;
            _loc2_.m_sweep.a = _loc2_.m_sweep.a + _loc2_.m_invI * (_loc15_ * _loc9_ - _loc13_ * _loc10_);
            _loc2_.SynchronizeTransform();
         }
         return _loc4_ < 0.005;
      }
   }
}
