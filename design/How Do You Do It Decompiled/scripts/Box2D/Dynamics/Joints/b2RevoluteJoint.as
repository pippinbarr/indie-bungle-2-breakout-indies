package Box2D.Dynamics.Joints
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.b2internal;
   import Box2D.Common.Math.b2Mat22;
   import Box2D.Dynamics.b2TimeStep;
   import Box2D.Dynamics.b2Body;
   import Box2D.Common.Math.b2Math;
   import Box2D.Common.Math.b2Vec3;
   import Box2D.Common.Math.b2Mat33;
   
   use namespace b2internal;
   
   public class b2RevoluteJoint extends b2Joint
   {
      
      private static var tImpulse:b2Vec2 = new b2Vec2();
       
      private var K:b2Mat22;
      
      private var K1:b2Mat22;
      
      private var K2:b2Mat22;
      
      private var K3:b2Mat22;
      
      private var impulse3:b2Vec3;
      
      private var impulse2:b2Vec2;
      
      private var reduced:b2Vec2;
      
      b2internal var m_localAnchor1:b2Vec2;
      
      b2internal var m_localAnchor2:b2Vec2;
      
      private var m_impulse:b2Vec3;
      
      private var m_motorImpulse:Number;
      
      private var m_mass:b2Mat33;
      
      private var m_motorMass:Number;
      
      private var m_enableMotor:Boolean;
      
      private var m_maxMotorTorque:Number;
      
      private var m_motorSpeed:Number;
      
      private var m_enableLimit:Boolean;
      
      private var m_referenceAngle:Number;
      
      private var m_lowerAngle:Number;
      
      private var m_upperAngle:Number;
      
      private var m_limitState:int;
      
      public function b2RevoluteJoint(param1:b2RevoluteJointDef)
      {
         K = new b2Mat22();
         K1 = new b2Mat22();
         K2 = new b2Mat22();
         K3 = new b2Mat22();
         impulse3 = new b2Vec3();
         impulse2 = new b2Vec2();
         reduced = new b2Vec2();
         m_localAnchor1 = new b2Vec2();
         m_localAnchor2 = new b2Vec2();
         m_impulse = new b2Vec3();
         m_mass = new b2Mat33();
         super(param1);
         m_localAnchor1.SetV(param1.localAnchorA);
         m_localAnchor2.SetV(param1.localAnchorB);
         m_referenceAngle = param1.referenceAngle;
         m_impulse.SetZero();
         m_motorImpulse = 0;
         m_lowerAngle = param1.lowerAngle;
         m_upperAngle = param1.upperAngle;
         m_maxMotorTorque = param1.maxMotorTorque;
         m_motorSpeed = param1.motorSpeed;
         m_enableLimit = param1.enableLimit;
         m_enableMotor = param1.enableMotor;
         m_limitState = 0;
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
         return new b2Vec2(param1 * m_impulse.x,param1 * m_impulse.y);
      }
      
      override public function GetReactionTorque(param1:Number) : Number
      {
         return param1 * m_impulse.z;
      }
      
      public function GetJointAngle() : Number
      {
         return m_bodyB.m_sweep.a - m_bodyA.m_sweep.a - m_referenceAngle;
      }
      
      public function GetJointSpeed() : Number
      {
         return m_bodyB.m_angularVelocity - m_bodyA.m_angularVelocity;
      }
      
      public function IsLimitEnabled() : Boolean
      {
         return m_enableLimit;
      }
      
      public function EnableLimit(param1:Boolean) : void
      {
         m_enableLimit = param1;
      }
      
      public function GetLowerLimit() : Number
      {
         return m_lowerAngle;
      }
      
      public function GetUpperLimit() : Number
      {
         return m_upperAngle;
      }
      
      public function SetLimits(param1:Number, param2:Number) : void
      {
         m_lowerAngle = param1;
         m_upperAngle = param2;
      }
      
      public function IsMotorEnabled() : Boolean
      {
         m_bodyA.SetAwake(true);
         m_bodyB.SetAwake(true);
         return m_enableMotor;
      }
      
      public function EnableMotor(param1:Boolean) : void
      {
         m_enableMotor = param1;
      }
      
      public function SetMotorSpeed(param1:Number) : void
      {
         m_bodyA.SetAwake(true);
         m_bodyB.SetAwake(true);
         m_motorSpeed = param1;
      }
      
      public function GetMotorSpeed() : Number
      {
         return m_motorSpeed;
      }
      
      public function SetMaxMotorTorque(param1:Number) : void
      {
         m_maxMotorTorque = param1;
      }
      
      public function GetMotorTorque() : Number
      {
         return m_maxMotorTorque;
      }
      
      override b2internal function InitVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc12_:* = null;
         var _loc3_:* = NaN;
         var _loc15_:* = NaN;
         var _loc7_:* = NaN;
         var _loc9_:* = NaN;
         var _loc16_:b2Body = m_bodyA;
         var _loc2_:b2Body = m_bodyB;
         if(m_enableMotor || m_enableLimit)
         {
         }
         _loc12_ = _loc16_.m_xf.R;
         var _loc10_:Number = m_localAnchor1.x - _loc16_.m_sweep.localCenter.x;
         var _loc14_:Number = m_localAnchor1.y - _loc16_.m_sweep.localCenter.y;
         _loc3_ = _loc12_.col1.x * _loc10_ + _loc12_.col2.x * _loc14_;
         _loc14_ = _loc12_.col1.y * _loc10_ + _loc12_.col2.y * _loc14_;
         _loc10_ = _loc3_;
         _loc12_ = _loc2_.m_xf.R;
         var _loc13_:Number = m_localAnchor2.x - _loc2_.m_sweep.localCenter.x;
         var _loc11_:Number = m_localAnchor2.y - _loc2_.m_sweep.localCenter.y;
         _loc3_ = _loc12_.col1.x * _loc13_ + _loc12_.col2.x * _loc11_;
         _loc11_ = _loc12_.col1.y * _loc13_ + _loc12_.col2.y * _loc11_;
         _loc13_ = _loc3_;
         var _loc4_:Number = _loc16_.m_invMass;
         var _loc5_:Number = _loc2_.m_invMass;
         var _loc6_:Number = _loc16_.m_invI;
         var _loc8_:Number = _loc2_.m_invI;
         m_mass.col1.x = _loc4_ + _loc5_ + _loc14_ * _loc14_ * _loc6_ + _loc11_ * _loc11_ * _loc8_;
         m_mass.col2.x = -_loc14_ * _loc10_ * _loc6_ - _loc11_ * _loc13_ * _loc8_;
         m_mass.col3.x = -_loc14_ * _loc6_ - _loc11_ * _loc8_;
         m_mass.col1.y = m_mass.col2.x;
         m_mass.col2.y = _loc4_ + _loc5_ + _loc10_ * _loc10_ * _loc6_ + _loc13_ * _loc13_ * _loc8_;
         m_mass.col3.y = _loc10_ * _loc6_ + _loc13_ * _loc8_;
         m_mass.col1.z = m_mass.col3.x;
         m_mass.col2.z = m_mass.col3.y;
         m_mass.col3.z = _loc6_ + _loc8_;
         m_motorMass = 1 / (_loc6_ + _loc8_);
         if(m_enableMotor == false)
         {
            m_motorImpulse = 0;
         }
         if(m_enableLimit)
         {
            _loc15_ = _loc2_.m_sweep.a - _loc16_.m_sweep.a - m_referenceAngle;
            if(b2Math.Abs(m_upperAngle - m_lowerAngle) < 2 * 0.03490658503988659)
            {
               m_limitState = 3;
            }
            else if(_loc15_ <= m_lowerAngle)
            {
               if(m_limitState != 1)
               {
                  m_impulse.z = 0;
               }
               m_limitState = 1;
            }
            else if(_loc15_ >= m_upperAngle)
            {
               if(m_limitState != 2)
               {
                  m_impulse.z = 0;
               }
               m_limitState = 2;
            }
            else
            {
               m_limitState = 0;
               m_impulse.z = 0;
            }
         }
         else
         {
            m_limitState = 0;
         }
         if(param1.warmStarting)
         {
            m_impulse.x = m_impulse.x * param1.dtRatio;
            m_impulse.y = m_impulse.y * param1.dtRatio;
            m_motorImpulse = §§dup().m_motorImpulse * param1.dtRatio;
            _loc7_ = m_impulse.x;
            _loc9_ = m_impulse.y;
            _loc16_.m_linearVelocity.x = _loc16_.m_linearVelocity.x - _loc4_ * _loc7_;
            _loc16_.m_linearVelocity.y = _loc16_.m_linearVelocity.y - _loc4_ * _loc9_;
            _loc16_.m_angularVelocity = _loc16_.m_angularVelocity - _loc6_ * (_loc10_ * _loc9_ - _loc14_ * _loc7_ + m_motorImpulse + m_impulse.z);
            _loc2_.m_linearVelocity.x = _loc2_.m_linearVelocity.x + _loc5_ * _loc7_;
            _loc2_.m_linearVelocity.y = _loc2_.m_linearVelocity.y + _loc5_ * _loc9_;
            _loc2_.m_angularVelocity = _loc2_.m_angularVelocity + _loc8_ * (_loc13_ * _loc9_ - _loc11_ * _loc7_ + m_motorImpulse + m_impulse.z);
         }
         else
         {
            m_impulse.SetZero();
            m_motorImpulse = 0;
         }
      }
      
      override b2internal function SolveVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc20_:* = null;
         var _loc9_:* = NaN;
         var _loc18_:* = NaN;
         var _loc19_:* = NaN;
         var _loc25_:* = NaN;
         var _loc4_:* = NaN;
         var _loc3_:* = NaN;
         var _loc21_:* = NaN;
         var _loc23_:* = NaN;
         var _loc24_:* = NaN;
         var _loc22_:* = NaN;
         var _loc13_:* = NaN;
         var _loc11_:* = NaN;
         var _loc2_:* = NaN;
         var _loc17_:* = NaN;
         var _loc16_:* = NaN;
         var _loc7_:b2Body = m_bodyA;
         var _loc8_:b2Body = m_bodyB;
         var _loc26_:b2Vec2 = _loc7_.m_linearVelocity;
         var _loc5_:Number = _loc7_.m_angularVelocity;
         var _loc27_:b2Vec2 = _loc8_.m_linearVelocity;
         var _loc6_:Number = _loc8_.m_angularVelocity;
         var _loc10_:Number = _loc7_.m_invMass;
         var _loc12_:Number = _loc8_.m_invMass;
         var _loc14_:Number = _loc7_.m_invI;
         var _loc15_:Number = _loc8_.m_invI;
         if(m_enableMotor && m_limitState != 3)
         {
            _loc21_ = _loc6_ - _loc5_ - m_motorSpeed;
            _loc23_ = m_motorMass * -_loc21_;
            _loc24_ = m_motorImpulse;
            _loc22_ = param1.dt * m_maxMotorTorque;
            m_motorImpulse = b2Math.Clamp(m_motorImpulse + _loc23_,-_loc22_,_loc22_);
            _loc23_ = m_motorImpulse - _loc24_;
            _loc5_ = _loc5_ - _loc14_ * _loc23_;
            _loc6_ = _loc6_ + _loc15_ * _loc23_;
         }
         if(m_enableLimit && m_limitState != 0)
         {
            _loc20_ = _loc7_.m_xf.R;
            _loc19_ = m_localAnchor1.x - _loc7_.m_sweep.localCenter.x;
            _loc25_ = m_localAnchor1.y - _loc7_.m_sweep.localCenter.y;
            _loc9_ = _loc20_.col1.x * _loc19_ + _loc20_.col2.x * _loc25_;
            _loc25_ = _loc20_.col1.y * _loc19_ + _loc20_.col2.y * _loc25_;
            _loc19_ = _loc9_;
            _loc20_ = _loc8_.m_xf.R;
            _loc4_ = m_localAnchor2.x - _loc8_.m_sweep.localCenter.x;
            _loc3_ = m_localAnchor2.y - _loc8_.m_sweep.localCenter.y;
            _loc9_ = _loc20_.col1.x * _loc4_ + _loc20_.col2.x * _loc3_;
            _loc3_ = _loc20_.col1.y * _loc4_ + _loc20_.col2.y * _loc3_;
            _loc4_ = _loc9_;
            _loc13_ = _loc27_.x + -_loc6_ * _loc3_ - _loc26_.x - -_loc5_ * _loc25_;
            _loc11_ = _loc27_.y + _loc6_ * _loc4_ - _loc26_.y - _loc5_ * _loc19_;
            _loc2_ = _loc6_ - _loc5_;
            m_mass.Solve33(impulse3,-_loc13_,-_loc11_,-_loc2_);
            if(m_limitState == 3)
            {
               m_impulse.Add(impulse3);
            }
            else if(m_limitState == 1)
            {
               _loc18_ = m_impulse.z + impulse3.z;
               if(_loc18_ < 0)
               {
                  m_mass.Solve22(reduced,-_loc13_,-_loc11_);
                  impulse3.x = reduced.x;
                  impulse3.y = reduced.y;
                  impulse3.z = -m_impulse.z;
                  m_impulse.x = m_impulse.x + reduced.x;
                  m_impulse.y = m_impulse.y + reduced.y;
                  m_impulse.z = 0;
               }
            }
            else if(m_limitState == 2)
            {
               _loc18_ = m_impulse.z + impulse3.z;
               if(_loc18_ > 0)
               {
                  m_mass.Solve22(reduced,-_loc13_,-_loc11_);
                  impulse3.x = reduced.x;
                  impulse3.y = reduced.y;
                  impulse3.z = -m_impulse.z;
                  m_impulse.x = m_impulse.x + reduced.x;
                  m_impulse.y = m_impulse.y + reduced.y;
                  m_impulse.z = 0;
               }
            }
            _loc26_.x = _loc26_.x - _loc10_ * impulse3.x;
            _loc26_.y = _loc26_.y - _loc10_ * impulse3.y;
            _loc5_ = _loc5_ - _loc14_ * (_loc19_ * impulse3.y - _loc25_ * impulse3.x + impulse3.z);
            _loc27_.x = _loc27_.x + _loc12_ * impulse3.x;
            _loc27_.y = _loc27_.y + _loc12_ * impulse3.y;
            _loc6_ = _loc6_ + _loc15_ * (_loc4_ * impulse3.y - _loc3_ * impulse3.x + impulse3.z);
         }
         else
         {
            _loc20_ = _loc7_.m_xf.R;
            _loc19_ = m_localAnchor1.x - _loc7_.m_sweep.localCenter.x;
            _loc25_ = m_localAnchor1.y - _loc7_.m_sweep.localCenter.y;
            _loc9_ = _loc20_.col1.x * _loc19_ + _loc20_.col2.x * _loc25_;
            _loc25_ = _loc20_.col1.y * _loc19_ + _loc20_.col2.y * _loc25_;
            _loc19_ = _loc9_;
            _loc20_ = _loc8_.m_xf.R;
            _loc4_ = m_localAnchor2.x - _loc8_.m_sweep.localCenter.x;
            _loc3_ = m_localAnchor2.y - _loc8_.m_sweep.localCenter.y;
            _loc9_ = _loc20_.col1.x * _loc4_ + _loc20_.col2.x * _loc3_;
            _loc3_ = _loc20_.col1.y * _loc4_ + _loc20_.col2.y * _loc3_;
            _loc4_ = _loc9_;
            _loc17_ = _loc27_.x + -_loc6_ * _loc3_ - _loc26_.x - -_loc5_ * _loc25_;
            _loc16_ = _loc27_.y + _loc6_ * _loc4_ - _loc26_.y - _loc5_ * _loc19_;
            m_mass.Solve22(impulse2,-_loc17_,-_loc16_);
            m_impulse.x = m_impulse.x + impulse2.x;
            m_impulse.y = m_impulse.y + impulse2.y;
            _loc26_.x = _loc26_.x - _loc10_ * impulse2.x;
            _loc26_.y = _loc26_.y - _loc10_ * impulse2.y;
            _loc5_ = _loc5_ - _loc14_ * (_loc19_ * impulse2.y - _loc25_ * impulse2.x);
            _loc27_.x = _loc27_.x + _loc12_ * impulse2.x;
            _loc27_.y = _loc27_.y + _loc12_ * impulse2.y;
            _loc6_ = _loc6_ + _loc15_ * (_loc4_ * impulse2.y - _loc3_ * impulse2.x);
         }
         _loc7_.m_linearVelocity.SetV(_loc26_);
         _loc7_.m_angularVelocity = _loc5_;
         _loc8_.m_linearVelocity.SetV(_loc27_);
         _loc8_.m_angularVelocity = _loc6_;
      }
      
      override b2internal function SolvePositionConstraints(param1:Number) : Boolean
      {
         var _loc10_:* = NaN;
         var _loc6_:* = NaN;
         var _loc28_:* = null;
         var _loc18_:* = NaN;
         var _loc20_:* = NaN;
         var _loc17_:* = NaN;
         var _loc12_:* = NaN;
         var _loc14_:* = NaN;
         var _loc19_:* = NaN;
         _loc19_ = 0.05;
         var _loc8_:* = NaN;
         var _loc9_:* = NaN;
         var _loc22_:* = NaN;
         var _loc23_:* = NaN;
         var _loc30_:* = NaN;
         _loc30_ = 0.5;
         var _loc15_:b2Body = m_bodyA;
         var _loc16_:b2Body = m_bodyB;
         var _loc21_:* = 0.0;
         var _loc3_:* = 0.0;
         if(m_enableLimit && m_limitState != 0)
         {
            _loc12_ = _loc16_.m_sweep.a - _loc15_.m_sweep.a - m_referenceAngle;
            _loc14_ = 0.0;
            if(m_limitState == 3)
            {
               _loc6_ = b2Math.Clamp(_loc12_ - m_lowerAngle,-0.13962634015954636,0.13962634015954636);
               _loc14_ = -m_motorMass * _loc6_;
               _loc21_ = b2Math.Abs(_loc6_);
            }
            else if(m_limitState == 1)
            {
               _loc6_ = _loc12_ - m_lowerAngle;
               _loc21_ = -_loc6_;
               _loc6_ = b2Math.Clamp(_loc6_ + 0.03490658503988659,-0.13962634015954636,0);
               _loc14_ = -m_motorMass * _loc6_;
            }
            else if(m_limitState == 2)
            {
               _loc6_ = _loc12_ - m_upperAngle;
               _loc21_ = _loc6_;
               _loc6_ = b2Math.Clamp(_loc6_ - 0.03490658503988659,0,0.13962634015954636);
               _loc14_ = -m_motorMass * _loc6_;
            }
            _loc15_.m_sweep.a = _loc15_.m_sweep.a - _loc15_.m_invI * _loc14_;
            _loc16_.m_sweep.a = _loc16_.m_sweep.a + _loc16_.m_invI * _loc14_;
            _loc15_.SynchronizeTransform();
            _loc16_.SynchronizeTransform();
         }
         _loc28_ = _loc15_.m_xf.R;
         var _loc27_:Number = m_localAnchor1.x - _loc15_.m_sweep.localCenter.x;
         var _loc29_:Number = m_localAnchor1.y - _loc15_.m_sweep.localCenter.y;
         _loc18_ = _loc28_.col1.x * _loc27_ + _loc28_.col2.x * _loc29_;
         _loc29_ = _loc28_.col1.y * _loc27_ + _loc28_.col2.y * _loc29_;
         _loc27_ = _loc18_;
         _loc28_ = _loc16_.m_xf.R;
         var _loc13_:Number = m_localAnchor2.x - _loc16_.m_sweep.localCenter.x;
         var _loc11_:Number = m_localAnchor2.y - _loc16_.m_sweep.localCenter.y;
         _loc18_ = _loc28_.col1.x * _loc13_ + _loc28_.col2.x * _loc11_;
         _loc11_ = _loc28_.col1.y * _loc13_ + _loc28_.col2.y * _loc11_;
         _loc13_ = _loc18_;
         var _loc25_:Number = _loc16_.m_sweep.c.x + _loc13_ - _loc15_.m_sweep.c.x - _loc27_;
         var _loc26_:Number = _loc16_.m_sweep.c.y + _loc11_ - _loc15_.m_sweep.c.y - _loc29_;
         var _loc24_:Number = _loc25_ * _loc25_ + _loc26_ * _loc26_;
         var _loc31_:Number = Math.sqrt(_loc24_);
         _loc3_ = _loc31_;
         var _loc7_:Number = _loc15_.m_invMass;
         var _loc4_:Number = _loc16_.m_invMass;
         var _loc5_:Number = _loc15_.m_invI;
         var _loc2_:Number = _loc16_.m_invI;
         if(_loc24_ > 0.05 * 0.05)
         {
            _loc8_ = _loc25_ / _loc31_;
            _loc9_ = _loc26_ / _loc31_;
            _loc22_ = _loc7_ + _loc4_;
            _loc23_ = 1 / _loc22_;
            _loc20_ = _loc23_ * -_loc25_;
            _loc17_ = _loc23_ * -_loc26_;
            _loc15_.m_sweep.c.x = _loc15_.m_sweep.c.x - _loc30_ * _loc7_ * _loc20_;
            _loc15_.m_sweep.c.y = _loc15_.m_sweep.c.y - _loc30_ * _loc7_ * _loc17_;
            _loc16_.m_sweep.c.x = _loc16_.m_sweep.c.x + _loc30_ * _loc4_ * _loc20_;
            _loc16_.m_sweep.c.y = _loc16_.m_sweep.c.y + _loc30_ * _loc4_ * _loc17_;
            _loc25_ = _loc16_.m_sweep.c.x + _loc13_ - _loc15_.m_sweep.c.x - _loc27_;
            _loc26_ = _loc16_.m_sweep.c.y + _loc11_ - _loc15_.m_sweep.c.y - _loc29_;
         }
         K1.col1.x = _loc7_ + _loc4_;
         K1.col2.x = 0;
         K1.col1.y = 0;
         K1.col2.y = _loc7_ + _loc4_;
         K2.col1.x = _loc5_ * _loc29_ * _loc29_;
         K2.col2.x = -_loc5_ * _loc27_ * _loc29_;
         K2.col1.y = -_loc5_ * _loc27_ * _loc29_;
         K2.col2.y = _loc5_ * _loc27_ * _loc27_;
         K3.col1.x = _loc2_ * _loc11_ * _loc11_;
         K3.col2.x = -_loc2_ * _loc13_ * _loc11_;
         K3.col1.y = -_loc2_ * _loc13_ * _loc11_;
         K3.col2.y = _loc2_ * _loc13_ * _loc13_;
         K.SetM(K1);
         K.AddM(K2);
         K.AddM(K3);
         K.Solve(tImpulse,-_loc25_,-_loc26_);
         _loc20_ = tImpulse.x;
         _loc17_ = tImpulse.y;
         _loc15_.m_sweep.c.x = _loc15_.m_sweep.c.x - _loc15_.m_invMass * _loc20_;
         _loc15_.m_sweep.c.y = _loc15_.m_sweep.c.y - _loc15_.m_invMass * _loc17_;
         _loc15_.m_sweep.a = _loc15_.m_sweep.a - _loc15_.m_invI * (_loc27_ * _loc17_ - _loc29_ * _loc20_);
         _loc16_.m_sweep.c.x = _loc16_.m_sweep.c.x + _loc16_.m_invMass * _loc20_;
         _loc16_.m_sweep.c.y = _loc16_.m_sweep.c.y + _loc16_.m_invMass * _loc17_;
         _loc16_.m_sweep.a = _loc16_.m_sweep.a + _loc16_.m_invI * (_loc13_ * _loc17_ - _loc11_ * _loc20_);
         _loc15_.SynchronizeTransform();
         _loc16_.SynchronizeTransform();
         return _loc3_ <= 0.005 && _loc21_ <= 0.03490658503988659;
      }
   }
}
