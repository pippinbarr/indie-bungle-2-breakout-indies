package Box2D.Dynamics.Joints
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.b2internal;
   import Box2D.Dynamics.b2TimeStep;
   import Box2D.Dynamics.b2Body;
   import Box2D.Common.Math.b2Mat22;
   import Box2D.Common.Math.b2Math;
   
   use namespace b2internal;
   
   public class b2FrictionJoint extends b2Joint
   {
       
      private var m_localAnchorA:b2Vec2;
      
      private var m_localAnchorB:b2Vec2;
      
      public var m_linearMass:b2Mat22;
      
      public var m_angularMass:Number;
      
      private var m_linearImpulse:b2Vec2;
      
      private var m_angularImpulse:Number;
      
      private var m_maxForce:Number;
      
      private var m_maxTorque:Number;
      
      public function b2FrictionJoint(param1:b2FrictionJointDef)
      {
         m_localAnchorA = new b2Vec2();
         m_localAnchorB = new b2Vec2();
         m_linearMass = new b2Mat22();
         m_linearImpulse = new b2Vec2();
         super(param1);
         m_localAnchorA.SetV(param1.localAnchorA);
         m_localAnchorB.SetV(param1.localAnchorB);
         m_linearMass.SetZero();
         m_angularMass = 0;
         m_linearImpulse.SetZero();
         m_angularImpulse = 0;
         m_maxForce = param1.maxForce;
         m_maxTorque = param1.maxTorque;
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
         return new b2Vec2(param1 * m_linearImpulse.x,param1 * m_linearImpulse.y);
      }
      
      override public function GetReactionTorque(param1:Number) : Number
      {
         return param1 * m_angularImpulse;
      }
      
      public function SetMaxForce(param1:Number) : void
      {
         m_maxForce = param1;
      }
      
      public function GetMaxForce() : Number
      {
         return m_maxForce;
      }
      
      public function SetMaxTorque(param1:Number) : void
      {
         m_maxTorque = param1;
      }
      
      public function GetMaxTorque() : Number
      {
         return m_maxTorque;
      }
      
      override b2internal function InitVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc13_:* = null;
         var _loc3_:* = NaN;
         var _loc9_:* = null;
         var _loc15_:b2Body = m_bodyA;
         var _loc2_:b2Body = m_bodyB;
         _loc13_ = _loc15_.m_xf.R;
         var _loc4_:Number = m_localAnchorA.x - _loc15_.m_sweep.localCenter.x;
         var _loc7_:Number = m_localAnchorA.y - _loc15_.m_sweep.localCenter.y;
         _loc3_ = _loc13_.col1.x * _loc4_ + _loc13_.col2.x * _loc7_;
         _loc7_ = _loc13_.col1.y * _loc4_ + _loc13_.col2.y * _loc7_;
         _loc4_ = _loc3_;
         _loc13_ = _loc2_.m_xf.R;
         var _loc6_:Number = m_localAnchorB.x - _loc2_.m_sweep.localCenter.x;
         var _loc5_:Number = m_localAnchorB.y - _loc2_.m_sweep.localCenter.y;
         _loc3_ = _loc13_.col1.x * _loc6_ + _loc13_.col2.x * _loc5_;
         _loc5_ = _loc13_.col1.y * _loc6_ + _loc13_.col2.y * _loc5_;
         _loc6_ = _loc3_;
         var _loc10_:Number = _loc15_.m_invMass;
         var _loc11_:Number = _loc2_.m_invMass;
         var _loc12_:Number = _loc15_.m_invI;
         var _loc14_:Number = _loc2_.m_invI;
         var _loc8_:b2Mat22 = new b2Mat22();
         _loc8_.col1.x = _loc10_ + _loc11_;
         _loc8_.col2.x = 0;
         _loc8_.col1.y = 0;
         _loc8_.col2.y = _loc10_ + _loc11_;
         _loc8_.col1.x = _loc8_.col1.x + _loc12_ * _loc7_ * _loc7_;
         _loc8_.col2.x = _loc8_.col2.x + -_loc12_ * _loc4_ * _loc7_;
         _loc8_.col1.y = _loc8_.col1.y + -_loc12_ * _loc4_ * _loc7_;
         _loc8_.col2.y = _loc8_.col2.y + _loc12_ * _loc4_ * _loc4_;
         _loc8_.col1.x = _loc8_.col1.x + _loc14_ * _loc5_ * _loc5_;
         _loc8_.col2.x = _loc8_.col2.x + -_loc14_ * _loc6_ * _loc5_;
         _loc8_.col1.y = _loc8_.col1.y + -_loc14_ * _loc6_ * _loc5_;
         _loc8_.col2.y = _loc8_.col2.y + _loc14_ * _loc6_ * _loc6_;
         _loc8_.GetInverse(m_linearMass);
         m_angularMass = _loc12_ + _loc14_;
         if(m_angularMass > 0)
         {
            m_angularMass = 1 / m_angularMass;
         }
         if(param1.warmStarting)
         {
            m_linearImpulse.x = m_linearImpulse.x * param1.dtRatio;
            m_linearImpulse.y = m_linearImpulse.y * param1.dtRatio;
            m_angularImpulse = §§dup().m_angularImpulse * param1.dtRatio;
            _loc9_ = m_linearImpulse;
            _loc15_.m_linearVelocity.x = _loc15_.m_linearVelocity.x - _loc10_ * _loc9_.x;
            _loc15_.m_linearVelocity.y = _loc15_.m_linearVelocity.y - _loc10_ * _loc9_.y;
            _loc15_.m_angularVelocity = _loc15_.m_angularVelocity - _loc12_ * (_loc4_ * _loc9_.y - _loc7_ * _loc9_.x + m_angularImpulse);
            _loc2_.m_linearVelocity.x = _loc2_.m_linearVelocity.x + _loc11_ * _loc9_.x;
            _loc2_.m_linearVelocity.y = _loc2_.m_linearVelocity.y + _loc11_ * _loc9_.y;
            _loc2_.m_angularVelocity = _loc2_.m_angularVelocity + _loc14_ * (_loc6_ * _loc9_.y - _loc5_ * _loc9_.x + m_angularImpulse);
         }
         else
         {
            m_linearImpulse.SetZero();
            m_angularImpulse = 0;
         }
      }
      
      override b2internal function SolveVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc20_:* = null;
         var _loc9_:* = NaN;
         var _loc22_:* = NaN;
         var _loc7_:b2Body = m_bodyA;
         var _loc8_:b2Body = m_bodyB;
         var _loc4_:b2Vec2 = _loc7_.m_linearVelocity;
         var _loc12_:Number = _loc7_.m_angularVelocity;
         var _loc5_:b2Vec2 = _loc8_.m_linearVelocity;
         var _loc13_:Number = _loc8_.m_angularVelocity;
         var _loc17_:Number = _loc7_.m_invMass;
         var _loc18_:Number = _loc8_.m_invMass;
         var _loc19_:Number = _loc7_.m_invI;
         var _loc21_:Number = _loc8_.m_invI;
         _loc20_ = _loc7_.m_xf.R;
         var _loc11_:Number = m_localAnchorA.x - _loc7_.m_sweep.localCenter.x;
         var _loc14_:Number = m_localAnchorA.y - _loc7_.m_sweep.localCenter.y;
         _loc9_ = _loc20_.col1.x * _loc11_ + _loc20_.col2.x * _loc14_;
         _loc14_ = _loc20_.col1.y * _loc11_ + _loc20_.col2.y * _loc14_;
         _loc11_ = _loc9_;
         _loc20_ = _loc8_.m_xf.R;
         var _loc3_:Number = m_localAnchorB.x - _loc8_.m_sweep.localCenter.x;
         var _loc2_:Number = m_localAnchorB.y - _loc8_.m_sweep.localCenter.y;
         _loc9_ = _loc20_.col1.x * _loc3_ + _loc20_.col2.x * _loc2_;
         _loc2_ = _loc20_.col1.y * _loc3_ + _loc20_.col2.y * _loc2_;
         _loc3_ = _loc9_;
         var _loc23_:Number = _loc13_ - _loc12_;
         var _loc24_:Number = -m_angularMass * _loc23_;
         var _loc25_:Number = m_angularImpulse;
         _loc22_ = param1.dt * m_maxTorque;
         m_angularImpulse = b2Math.Clamp(m_angularImpulse + _loc24_,-_loc22_,_loc22_);
         _loc24_ = m_angularImpulse - _loc25_;
         _loc12_ = _loc12_ - _loc19_ * _loc24_;
         _loc13_ = _loc13_ + _loc21_ * _loc24_;
         var _loc16_:Number = _loc5_.x - _loc13_ * _loc2_ - _loc4_.x + _loc12_ * _loc14_;
         var _loc15_:Number = _loc5_.y + _loc13_ * _loc3_ - _loc4_.y - _loc12_ * _loc11_;
         var _loc10_:b2Vec2 = b2Math.MulMV(m_linearMass,new b2Vec2(-_loc16_,-_loc15_));
         var _loc6_:b2Vec2 = m_linearImpulse.Copy();
         m_linearImpulse.Add(_loc10_);
         _loc22_ = param1.dt * m_maxForce;
         if(m_linearImpulse.LengthSquared() > _loc22_ * _loc22_)
         {
            m_linearImpulse.Normalize();
            m_linearImpulse.Multiply(_loc22_);
         }
         _loc10_ = b2Math.SubtractVV(m_linearImpulse,_loc6_);
         _loc4_.x = _loc4_.x - _loc17_ * _loc10_.x;
         _loc4_.y = _loc4_.y - _loc17_ * _loc10_.y;
         _loc12_ = _loc12_ - _loc19_ * (_loc11_ * _loc10_.y - _loc14_ * _loc10_.x);
         _loc5_.x = _loc5_.x + _loc18_ * _loc10_.x;
         _loc5_.y = _loc5_.y + _loc18_ * _loc10_.y;
         _loc13_ = _loc13_ + _loc21_ * (_loc3_ * _loc10_.y - _loc2_ * _loc10_.x);
         _loc7_.m_angularVelocity = _loc12_;
         _loc8_.m_angularVelocity = _loc13_;
      }
      
      override b2internal function SolvePositionConstraints(param1:Number) : Boolean
      {
         return true;
      }
   }
}
