package Box2D.Dynamics.Joints
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.b2internal;
   import Box2D.Dynamics.b2TimeStep;
   import Box2D.Dynamics.b2Body;
   import Box2D.Common.Math.b2Mat22;
   import Box2D.Common.Math.b2Vec3;
   import Box2D.Common.Math.b2Math;
   import Box2D.Common.Math.b2Mat33;
   
   use namespace b2internal;
   
   public class b2WeldJoint extends b2Joint
   {
       
      private var m_localAnchorA:b2Vec2;
      
      private var m_localAnchorB:b2Vec2;
      
      private var m_referenceAngle:Number;
      
      private var m_impulse:b2Vec3;
      
      private var m_mass:b2Mat33;
      
      public function b2WeldJoint(param1:b2WeldJointDef)
      {
         m_localAnchorA = new b2Vec2();
         m_localAnchorB = new b2Vec2();
         m_impulse = new b2Vec3();
         m_mass = new b2Mat33();
         super(param1);
         m_localAnchorA.SetV(param1.localAnchorA);
         m_localAnchorB.SetV(param1.localAnchorB);
         m_referenceAngle = param1.referenceAngle;
         m_impulse.SetZero();
         m_mass = new b2Mat33();
      }
      
      override public function GetAnchorA() : b2Vec2
      {
         return m_bodyA.GetWorldPoint(m_localAnchorA);
      }
      
      override public function GetAnchorB() : b2Vec2
      {
         return m_bodyB.GetWorldPoint(m_localAnchorB);
      }
      
      override public function GetReactionForce(param1:Number) : b2Vec2
      {
         return new b2Vec2(param1 * m_impulse.x,param1 * m_impulse.y);
      }
      
      override public function GetReactionTorque(param1:Number) : Number
      {
         return param1 * m_impulse.z;
      }
      
      override b2internal function InitVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc11_:* = null;
         var _loc3_:* = NaN;
         var _loc13_:b2Body = m_bodyA;
         var _loc2_:b2Body = m_bodyB;
         _loc11_ = _loc13_.m_xf.R;
         var _loc4_:Number = m_localAnchorA.x - _loc13_.m_sweep.localCenter.x;
         var _loc7_:Number = m_localAnchorA.y - _loc13_.m_sweep.localCenter.y;
         _loc3_ = _loc11_.col1.x * _loc4_ + _loc11_.col2.x * _loc7_;
         _loc7_ = _loc11_.col1.y * _loc4_ + _loc11_.col2.y * _loc7_;
         _loc4_ = _loc3_;
         _loc11_ = _loc2_.m_xf.R;
         var _loc6_:Number = m_localAnchorB.x - _loc2_.m_sweep.localCenter.x;
         var _loc5_:Number = m_localAnchorB.y - _loc2_.m_sweep.localCenter.y;
         _loc3_ = _loc11_.col1.x * _loc6_ + _loc11_.col2.x * _loc5_;
         _loc5_ = _loc11_.col1.y * _loc6_ + _loc11_.col2.y * _loc5_;
         _loc6_ = _loc3_;
         var _loc8_:Number = _loc13_.m_invMass;
         var _loc9_:Number = _loc2_.m_invMass;
         var _loc10_:Number = _loc13_.m_invI;
         var _loc12_:Number = _loc2_.m_invI;
         m_mass.col1.x = _loc8_ + _loc9_ + _loc7_ * _loc7_ * _loc10_ + _loc5_ * _loc5_ * _loc12_;
         m_mass.col2.x = -_loc7_ * _loc4_ * _loc10_ - _loc5_ * _loc6_ * _loc12_;
         m_mass.col3.x = -_loc7_ * _loc10_ - _loc5_ * _loc12_;
         m_mass.col1.y = m_mass.col2.x;
         m_mass.col2.y = _loc8_ + _loc9_ + _loc4_ * _loc4_ * _loc10_ + _loc6_ * _loc6_ * _loc12_;
         m_mass.col3.y = _loc4_ * _loc10_ + _loc6_ * _loc12_;
         m_mass.col1.z = m_mass.col3.x;
         m_mass.col2.z = m_mass.col3.y;
         m_mass.col3.z = _loc10_ + _loc12_;
         if(param1.warmStarting)
         {
            m_impulse.x = m_impulse.x * param1.dtRatio;
            m_impulse.y = m_impulse.y * param1.dtRatio;
            m_impulse.z = m_impulse.z * param1.dtRatio;
            _loc13_.m_linearVelocity.x = _loc13_.m_linearVelocity.x - _loc8_ * m_impulse.x;
            _loc13_.m_linearVelocity.y = _loc13_.m_linearVelocity.y - _loc8_ * m_impulse.y;
            _loc13_.m_angularVelocity = _loc13_.m_angularVelocity - _loc10_ * (_loc4_ * m_impulse.y - _loc7_ * m_impulse.x + m_impulse.z);
            _loc2_.m_linearVelocity.x = _loc2_.m_linearVelocity.x + _loc9_ * m_impulse.x;
            _loc2_.m_linearVelocity.y = _loc2_.m_linearVelocity.y + _loc9_ * m_impulse.y;
            _loc2_.m_angularVelocity = _loc2_.m_angularVelocity + _loc12_ * (_loc6_ * m_impulse.y - _loc5_ * m_impulse.x + m_impulse.z);
         }
         else
         {
            m_impulse.SetZero();
         }
      }
      
      override b2internal function SolveVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc18_:* = null;
         var _loc3_:* = NaN;
         var _loc21_:b2Body = m_bodyA;
         var _loc2_:b2Body = m_bodyB;
         var _loc10_:b2Vec2 = _loc21_.m_linearVelocity;
         var _loc9_:Number = _loc21_.m_angularVelocity;
         var _loc13_:b2Vec2 = _loc2_.m_linearVelocity;
         var _loc11_:Number = _loc2_.m_angularVelocity;
         var _loc15_:Number = _loc21_.m_invMass;
         var _loc16_:Number = _loc2_.m_invMass;
         var _loc17_:Number = _loc21_.m_invI;
         var _loc19_:Number = _loc2_.m_invI;
         _loc18_ = _loc21_.m_xf.R;
         var _loc6_:Number = m_localAnchorA.x - _loc21_.m_sweep.localCenter.x;
         var _loc12_:Number = m_localAnchorA.y - _loc21_.m_sweep.localCenter.y;
         _loc3_ = _loc18_.col1.x * _loc6_ + _loc18_.col2.x * _loc12_;
         _loc12_ = _loc18_.col1.y * _loc6_ + _loc18_.col2.y * _loc12_;
         _loc6_ = _loc3_;
         _loc18_ = _loc2_.m_xf.R;
         var _loc8_:Number = m_localAnchorB.x - _loc2_.m_sweep.localCenter.x;
         var _loc7_:Number = m_localAnchorB.y - _loc2_.m_sweep.localCenter.y;
         _loc3_ = _loc18_.col1.x * _loc8_ + _loc18_.col2.x * _loc7_;
         _loc7_ = _loc18_.col1.y * _loc8_ + _loc18_.col2.y * _loc7_;
         _loc8_ = _loc3_;
         var _loc5_:Number = _loc13_.x - _loc11_ * _loc7_ - _loc10_.x + _loc9_ * _loc12_;
         var _loc4_:Number = _loc13_.y + _loc11_ * _loc8_ - _loc10_.y - _loc9_ * _loc6_;
         var _loc14_:Number = _loc11_ - _loc9_;
         var _loc20_:b2Vec3 = new b2Vec3();
         m_mass.Solve33(_loc20_,-_loc5_,-_loc4_,-_loc14_);
         m_impulse.Add(_loc20_);
         _loc10_.x = _loc10_.x - _loc15_ * _loc20_.x;
         _loc10_.y = _loc10_.y - _loc15_ * _loc20_.y;
         _loc9_ = _loc9_ - _loc17_ * (_loc6_ * _loc20_.y - _loc12_ * _loc20_.x + _loc20_.z);
         _loc13_.x = _loc13_.x + _loc16_ * _loc20_.x;
         _loc13_.y = _loc13_.y + _loc16_ * _loc20_.y;
         _loc11_ = _loc11_ + _loc19_ * (_loc8_ * _loc20_.y - _loc7_ * _loc20_.x + _loc20_.z);
         _loc21_.m_angularVelocity = _loc9_;
         _loc2_.m_angularVelocity = _loc11_;
      }
      
      override b2internal function SolvePositionConstraints(param1:Number) : Boolean
      {
         var _loc17_:* = null;
         var _loc4_:* = NaN;
         var _loc20_:b2Body = m_bodyA;
         var _loc2_:b2Body = m_bodyB;
         _loc17_ = _loc20_.m_xf.R;
         var _loc6_:Number = m_localAnchorA.x - _loc20_.m_sweep.localCenter.x;
         var _loc10_:Number = m_localAnchorA.y - _loc20_.m_sweep.localCenter.y;
         _loc4_ = _loc17_.col1.x * _loc6_ + _loc17_.col2.x * _loc10_;
         _loc10_ = _loc17_.col1.y * _loc6_ + _loc17_.col2.y * _loc10_;
         _loc6_ = _loc4_;
         _loc17_ = _loc2_.m_xf.R;
         var _loc8_:Number = m_localAnchorB.x - _loc2_.m_sweep.localCenter.x;
         var _loc7_:Number = m_localAnchorB.y - _loc2_.m_sweep.localCenter.y;
         _loc4_ = _loc17_.col1.x * _loc8_ + _loc17_.col2.x * _loc7_;
         _loc7_ = _loc17_.col1.y * _loc8_ + _loc17_.col2.y * _loc7_;
         _loc8_ = _loc4_;
         var _loc14_:Number = _loc20_.m_invMass;
         var _loc15_:Number = _loc2_.m_invMass;
         var _loc16_:Number = _loc20_.m_invI;
         var _loc18_:Number = _loc2_.m_invI;
         var _loc11_:Number = _loc2_.m_sweep.c.x + _loc8_ - _loc20_.m_sweep.c.x - _loc6_;
         var _loc9_:Number = _loc2_.m_sweep.c.y + _loc7_ - _loc20_.m_sweep.c.y - _loc10_;
         var _loc13_:Number = _loc2_.m_sweep.a - _loc20_.m_sweep.a - m_referenceAngle;
         var _loc5_:* = 0.05;
         var _loc3_:Number = Math.sqrt(_loc11_ * _loc11_ + _loc9_ * _loc9_);
         var _loc12_:Number = b2Math.Abs(_loc13_);
         if(_loc3_ > _loc5_)
         {
            _loc16_ = _loc16_ * 1;
            _loc18_ = _loc18_ * 1;
         }
         m_mass.col1.x = _loc14_ + _loc15_ + _loc10_ * _loc10_ * _loc16_ + _loc7_ * _loc7_ * _loc18_;
         m_mass.col2.x = -_loc10_ * _loc6_ * _loc16_ - _loc7_ * _loc8_ * _loc18_;
         m_mass.col3.x = -_loc10_ * _loc16_ - _loc7_ * _loc18_;
         m_mass.col1.y = m_mass.col2.x;
         m_mass.col2.y = _loc14_ + _loc15_ + _loc6_ * _loc6_ * _loc16_ + _loc8_ * _loc8_ * _loc18_;
         m_mass.col3.y = _loc6_ * _loc16_ + _loc8_ * _loc18_;
         m_mass.col1.z = m_mass.col3.x;
         m_mass.col2.z = m_mass.col3.y;
         m_mass.col3.z = _loc16_ + _loc18_;
         var _loc19_:b2Vec3 = new b2Vec3();
         m_mass.Solve33(_loc19_,-_loc11_,-_loc9_,-_loc13_);
         _loc20_.m_sweep.c.x = _loc20_.m_sweep.c.x - _loc14_ * _loc19_.x;
         _loc20_.m_sweep.c.y = _loc20_.m_sweep.c.y - _loc14_ * _loc19_.y;
         _loc20_.m_sweep.a = _loc20_.m_sweep.a - _loc16_ * (_loc6_ * _loc19_.y - _loc10_ * _loc19_.x + _loc19_.z);
         _loc2_.m_sweep.c.x = _loc2_.m_sweep.c.x + _loc15_ * _loc19_.x;
         _loc2_.m_sweep.c.y = _loc2_.m_sweep.c.y + _loc15_ * _loc19_.y;
         _loc2_.m_sweep.a = _loc2_.m_sweep.a + _loc18_ * (_loc8_ * _loc19_.y - _loc7_ * _loc19_.x + _loc19_.z);
         _loc20_.SynchronizeTransform();
         _loc2_.SynchronizeTransform();
         return _loc3_ <= 0.005 && _loc12_ <= 0.03490658503988659;
      }
   }
}
