package Box2D.Dynamics.Joints
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.b2internal;
   import Box2D.Common.Math.b2Mat22;
   import Box2D.Dynamics.b2TimeStep;
   import Box2D.Dynamics.b2Body;
   
   use namespace b2internal;
   
   public class b2GearJoint extends b2Joint
   {
       
      private var m_ground1:b2Body;
      
      private var m_ground2:b2Body;
      
      private var m_revolute1:Box2D.Dynamics.Joints.b2RevoluteJoint;
      
      private var m_prismatic1:Box2D.Dynamics.Joints.b2PrismaticJoint;
      
      private var m_revolute2:Box2D.Dynamics.Joints.b2RevoluteJoint;
      
      private var m_prismatic2:Box2D.Dynamics.Joints.b2PrismaticJoint;
      
      private var m_groundAnchor1:b2Vec2;
      
      private var m_groundAnchor2:b2Vec2;
      
      private var m_localAnchor1:b2Vec2;
      
      private var m_localAnchor2:b2Vec2;
      
      private var m_J:Box2D.Dynamics.Joints.b2Jacobian;
      
      private var m_constant:Number;
      
      private var m_ratio:Number;
      
      private var m_mass:Number;
      
      private var m_impulse:Number;
      
      public function b2GearJoint(param1:b2GearJointDef)
      {
         var _loc4_:* = NaN;
         var _loc3_:* = NaN;
         m_groundAnchor1 = new b2Vec2();
         m_groundAnchor2 = new b2Vec2();
         m_localAnchor1 = new b2Vec2();
         m_localAnchor2 = new b2Vec2();
         m_J = new Box2D.Dynamics.Joints.b2Jacobian();
         super(param1);
         var _loc5_:int = param1.joint1.m_type;
         var _loc2_:int = param1.joint2.m_type;
         m_revolute1 = null;
         m_prismatic1 = null;
         m_revolute2 = null;
         m_prismatic2 = null;
         m_ground1 = param1.joint1.GetBodyA();
         m_bodyA = param1.joint1.GetBodyB();
         if(_loc5_ == 1)
         {
            m_revolute1 = param1.joint1 as Box2D.Dynamics.Joints.b2RevoluteJoint;
            m_groundAnchor1.SetV(m_revolute1.m_localAnchor1);
            m_localAnchor1.SetV(m_revolute1.m_localAnchor2);
            _loc4_ = m_revolute1.GetJointAngle();
         }
         else
         {
            m_prismatic1 = param1.joint1 as Box2D.Dynamics.Joints.b2PrismaticJoint;
            m_groundAnchor1.SetV(m_prismatic1.m_localAnchor1);
            m_localAnchor1.SetV(m_prismatic1.m_localAnchor2);
            _loc4_ = m_prismatic1.GetJointTranslation();
         }
         m_ground2 = param1.joint2.GetBodyA();
         m_bodyB = param1.joint2.GetBodyB();
         if(_loc2_ == 1)
         {
            m_revolute2 = param1.joint2 as Box2D.Dynamics.Joints.b2RevoluteJoint;
            m_groundAnchor2.SetV(m_revolute2.m_localAnchor1);
            m_localAnchor2.SetV(m_revolute2.m_localAnchor2);
            _loc3_ = m_revolute2.GetJointAngle();
         }
         else
         {
            m_prismatic2 = param1.joint2 as Box2D.Dynamics.Joints.b2PrismaticJoint;
            m_groundAnchor2.SetV(m_prismatic2.m_localAnchor1);
            m_localAnchor2.SetV(m_prismatic2.m_localAnchor2);
            _loc3_ = m_prismatic2.GetJointTranslation();
         }
         m_ratio = param1.ratio;
         m_constant = _loc4_ + m_ratio * _loc3_;
         m_impulse = 0;
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
         return new b2Vec2(param1 * m_impulse * m_J.linearB.x,param1 * m_impulse * m_J.linearB.y);
      }
      
      override public function GetReactionTorque(param1:Number) : Number
      {
         var _loc6_:b2Mat22 = m_bodyB.m_xf.R;
         var _loc3_:Number = m_localAnchor1.x - m_bodyB.m_sweep.localCenter.x;
         var _loc4_:Number = m_localAnchor1.y - m_bodyB.m_sweep.localCenter.y;
         var _loc2_:Number = _loc6_.col1.x * _loc3_ + _loc6_.col2.x * _loc4_;
         _loc4_ = _loc6_.col1.y * _loc3_ + _loc6_.col2.y * _loc4_;
         _loc3_ = _loc2_;
         var _loc5_:Number = m_impulse * m_J.linearB.x;
         var _loc7_:Number = m_impulse * m_J.linearB.y;
         return param1 * (m_impulse * m_J.angularB - _loc3_ * _loc7_ + _loc4_ * _loc5_);
      }
      
      public function GetRatio() : Number
      {
         return m_ratio;
      }
      
      public function SetRatio(param1:Number) : void
      {
         m_ratio = param1;
      }
      
      override b2internal function InitVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc6_:* = NaN;
         var _loc4_:* = NaN;
         var _loc5_:* = NaN;
         var _loc7_:* = NaN;
         var _loc13_:* = null;
         var _loc12_:* = null;
         var _loc11_:* = NaN;
         var _loc3_:* = NaN;
         var _loc8_:b2Body = m_ground1;
         var _loc9_:b2Body = m_ground2;
         var _loc14_:b2Body = m_bodyA;
         var _loc2_:b2Body = m_bodyB;
         var _loc10_:* = 0.0;
         m_J.SetZero();
         if(m_revolute1)
         {
            m_J.angularA = -1;
            _loc10_ = _loc10_ + _loc14_.m_invI;
         }
         else
         {
            _loc13_ = _loc8_.m_xf.R;
            _loc12_ = m_prismatic1.m_localXAxis1;
            _loc6_ = _loc13_.col1.x * _loc12_.x + _loc13_.col2.x * _loc12_.y;
            _loc4_ = _loc13_.col1.y * _loc12_.x + _loc13_.col2.y * _loc12_.y;
            _loc13_ = _loc14_.m_xf.R;
            _loc5_ = m_localAnchor1.x - _loc14_.m_sweep.localCenter.x;
            _loc7_ = m_localAnchor1.y - _loc14_.m_sweep.localCenter.y;
            _loc3_ = _loc13_.col1.x * _loc5_ + _loc13_.col2.x * _loc7_;
            _loc7_ = _loc13_.col1.y * _loc5_ + _loc13_.col2.y * _loc7_;
            _loc5_ = _loc3_;
            _loc11_ = _loc5_ * _loc4_ - _loc7_ * _loc6_;
            m_J.linearA.Set(-_loc6_,-_loc4_);
            m_J.angularA = -_loc11_;
            _loc10_ = _loc10_ + (_loc14_.m_invMass + _loc14_.m_invI * _loc11_ * _loc11_);
         }
         if(m_revolute2)
         {
            m_J.angularB = -m_ratio;
            _loc10_ = _loc10_ + m_ratio * m_ratio * _loc2_.m_invI;
         }
         else
         {
            _loc13_ = _loc9_.m_xf.R;
            _loc12_ = m_prismatic2.m_localXAxis1;
            _loc6_ = _loc13_.col1.x * _loc12_.x + _loc13_.col2.x * _loc12_.y;
            _loc4_ = _loc13_.col1.y * _loc12_.x + _loc13_.col2.y * _loc12_.y;
            _loc13_ = _loc2_.m_xf.R;
            _loc5_ = m_localAnchor2.x - _loc2_.m_sweep.localCenter.x;
            _loc7_ = m_localAnchor2.y - _loc2_.m_sweep.localCenter.y;
            _loc3_ = _loc13_.col1.x * _loc5_ + _loc13_.col2.x * _loc7_;
            _loc7_ = _loc13_.col1.y * _loc5_ + _loc13_.col2.y * _loc7_;
            _loc5_ = _loc3_;
            _loc11_ = _loc5_ * _loc4_ - _loc7_ * _loc6_;
            m_J.linearB.Set(-m_ratio * _loc6_,-m_ratio * _loc4_);
            m_J.angularB = -m_ratio * _loc11_;
            _loc10_ = _loc10_ + m_ratio * m_ratio * (_loc2_.m_invMass + _loc2_.m_invI * _loc11_ * _loc11_);
         }
         m_mass = _loc10_ > 0?1 / _loc10_:0.0;
         if(param1.warmStarting)
         {
            _loc14_.m_linearVelocity.x = _loc14_.m_linearVelocity.x + _loc14_.m_invMass * m_impulse * m_J.linearA.x;
            _loc14_.m_linearVelocity.y = _loc14_.m_linearVelocity.y + _loc14_.m_invMass * m_impulse * m_J.linearA.y;
            _loc14_.m_angularVelocity = _loc14_.m_angularVelocity + _loc14_.m_invI * m_impulse * m_J.angularA;
            _loc2_.m_linearVelocity.x = _loc2_.m_linearVelocity.x + _loc2_.m_invMass * m_impulse * m_J.linearB.x;
            _loc2_.m_linearVelocity.y = _loc2_.m_linearVelocity.y + _loc2_.m_invMass * m_impulse * m_J.linearB.y;
            _loc2_.m_angularVelocity = _loc2_.m_angularVelocity + _loc2_.m_invI * m_impulse * m_J.angularB;
         }
         else
         {
            m_impulse = 0;
         }
      }
      
      override b2internal function SolveVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc5_:b2Body = m_bodyA;
         var _loc2_:b2Body = m_bodyB;
         var _loc3_:Number = m_J.Compute(_loc5_.m_linearVelocity,_loc5_.m_angularVelocity,_loc2_.m_linearVelocity,_loc2_.m_angularVelocity);
         var _loc4_:Number = -m_mass * _loc3_;
         m_impulse = §§dup().m_impulse + _loc4_;
         _loc5_.m_linearVelocity.x = _loc5_.m_linearVelocity.x + _loc5_.m_invMass * _loc4_ * m_J.linearA.x;
         _loc5_.m_linearVelocity.y = _loc5_.m_linearVelocity.y + _loc5_.m_invMass * _loc4_ * m_J.linearA.y;
         _loc5_.m_angularVelocity = _loc5_.m_angularVelocity + _loc5_.m_invI * _loc4_ * m_J.angularA;
         _loc2_.m_linearVelocity.x = _loc2_.m_linearVelocity.x + _loc2_.m_invMass * _loc4_ * m_J.linearB.x;
         _loc2_.m_linearVelocity.y = _loc2_.m_linearVelocity.y + _loc2_.m_invMass * _loc4_ * m_J.linearB.y;
         _loc2_.m_angularVelocity = _loc2_.m_angularVelocity + _loc2_.m_invI * _loc4_ * m_J.angularB;
      }
      
      override b2internal function SolvePositionConstraints(param1:Number) : Boolean
      {
         var _loc6_:* = NaN;
         var _loc5_:* = NaN;
         var _loc3_:* = 0.0;
         var _loc8_:b2Body = m_bodyA;
         var _loc2_:b2Body = m_bodyB;
         if(m_revolute1)
         {
            _loc6_ = m_revolute1.GetJointAngle();
         }
         else
         {
            _loc6_ = m_prismatic1.GetJointTranslation();
         }
         if(m_revolute2)
         {
            _loc5_ = m_revolute2.GetJointAngle();
         }
         else
         {
            _loc5_ = m_prismatic2.GetJointTranslation();
         }
         var _loc4_:Number = m_constant - (_loc6_ + m_ratio * _loc5_);
         var _loc7_:Number = -m_mass * _loc4_;
         _loc8_.m_sweep.c.x = _loc8_.m_sweep.c.x + _loc8_.m_invMass * _loc7_ * m_J.linearA.x;
         _loc8_.m_sweep.c.y = _loc8_.m_sweep.c.y + _loc8_.m_invMass * _loc7_ * m_J.linearA.y;
         _loc8_.m_sweep.a = _loc8_.m_sweep.a + _loc8_.m_invI * _loc7_ * m_J.angularA;
         _loc2_.m_sweep.c.x = _loc2_.m_sweep.c.x + _loc2_.m_invMass * _loc7_ * m_J.linearB.x;
         _loc2_.m_sweep.c.y = _loc2_.m_sweep.c.y + _loc2_.m_invMass * _loc7_ * m_J.linearB.y;
         _loc2_.m_sweep.a = _loc2_.m_sweep.a + _loc2_.m_invI * _loc7_ * m_J.angularB;
         _loc8_.SynchronizeTransform();
         _loc2_.SynchronizeTransform();
         return _loc3_ < 0.005;
      }
   }
}
