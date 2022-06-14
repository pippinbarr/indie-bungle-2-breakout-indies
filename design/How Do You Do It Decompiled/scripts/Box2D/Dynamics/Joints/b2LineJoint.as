package Box2D.Dynamics.Joints
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.b2internal;
   import Box2D.Dynamics.b2Body;
   import Box2D.Common.Math.b2Mat22;
   import Box2D.Dynamics.b2TimeStep;
   import Box2D.Common.Math.b2Transform;
   import Box2D.Common.Math.b2Math;
   
   use namespace b2internal;
   
   public class b2LineJoint extends b2Joint
   {
       
      b2internal var m_localAnchor1:b2Vec2;
      
      b2internal var m_localAnchor2:b2Vec2;
      
      b2internal var m_localXAxis1:b2Vec2;
      
      private var m_localYAxis1:b2Vec2;
      
      private var m_axis:b2Vec2;
      
      private var m_perp:b2Vec2;
      
      private var m_s1:Number;
      
      private var m_s2:Number;
      
      private var m_a1:Number;
      
      private var m_a2:Number;
      
      private var m_K:b2Mat22;
      
      private var m_impulse:b2Vec2;
      
      private var m_motorMass:Number;
      
      private var m_motorImpulse:Number;
      
      private var m_lowerTranslation:Number;
      
      private var m_upperTranslation:Number;
      
      private var m_maxMotorForce:Number;
      
      private var m_motorSpeed:Number;
      
      private var m_enableLimit:Boolean;
      
      private var m_enableMotor:Boolean;
      
      private var m_limitState:int;
      
      public function b2LineJoint(param1:b2LineJointDef)
      {
         var _loc4_:* = null;
         var _loc2_:* = NaN;
         var _loc3_:* = NaN;
         m_localAnchor1 = new b2Vec2();
         m_localAnchor2 = new b2Vec2();
         m_localXAxis1 = new b2Vec2();
         m_localYAxis1 = new b2Vec2();
         m_axis = new b2Vec2();
         m_perp = new b2Vec2();
         m_K = new b2Mat22();
         m_impulse = new b2Vec2();
         super(param1);
         m_localAnchor1.SetV(param1.localAnchorA);
         m_localAnchor2.SetV(param1.localAnchorB);
         m_localXAxis1.SetV(param1.localAxisA);
         m_localYAxis1.x = -m_localXAxis1.y;
         m_localYAxis1.y = m_localXAxis1.x;
         m_impulse.SetZero();
         m_motorMass = 0;
         m_motorImpulse = 0;
         m_lowerTranslation = param1.lowerTranslation;
         m_upperTranslation = param1.upperTranslation;
         m_maxMotorForce = param1.maxMotorForce;
         m_motorSpeed = param1.motorSpeed;
         m_enableLimit = param1.enableLimit;
         m_enableMotor = param1.enableMotor;
         m_limitState = 0;
         m_axis.SetZero();
         m_perp.SetZero();
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
         return new b2Vec2(param1 * (m_impulse.x * m_perp.x + (m_motorImpulse + m_impulse.y) * m_axis.x),param1 * (m_impulse.x * m_perp.y + (m_motorImpulse + m_impulse.y) * m_axis.y));
      }
      
      override public function GetReactionTorque(param1:Number) : Number
      {
         return param1 * m_impulse.y;
      }
      
      public function GetJointTranslation() : Number
      {
         var _loc7_:* = null;
         var _loc9_:b2Body = m_bodyA;
         var _loc1_:b2Body = m_bodyB;
         var _loc2_:b2Vec2 = _loc9_.GetWorldPoint(m_localAnchor1);
         var _loc3_:b2Vec2 = _loc1_.GetWorldPoint(m_localAnchor2);
         var _loc4_:Number = _loc3_.x - _loc2_.x;
         var _loc5_:Number = _loc3_.y - _loc2_.y;
         var _loc8_:b2Vec2 = _loc9_.GetWorldVector(m_localXAxis1);
         var _loc6_:Number = _loc8_.x * _loc4_ + _loc8_.y * _loc5_;
         return _loc6_;
      }
      
      public function GetJointSpeed() : Number
      {
         var _loc12_:* = null;
         var _loc20_:b2Body = m_bodyA;
         var _loc1_:b2Body = m_bodyB;
         _loc12_ = _loc20_.m_xf.R;
         var _loc10_:Number = m_localAnchor1.x - _loc20_.m_sweep.localCenter.x;
         var _loc16_:Number = m_localAnchor1.y - _loc20_.m_sweep.localCenter.y;
         var _loc2_:Number = _loc12_.col1.x * _loc10_ + _loc12_.col2.x * _loc16_;
         _loc16_ = _loc12_.col1.y * _loc10_ + _loc12_.col2.y * _loc16_;
         _loc10_ = _loc2_;
         _loc12_ = _loc1_.m_xf.R;
         var _loc13_:Number = m_localAnchor2.x - _loc1_.m_sweep.localCenter.x;
         var _loc11_:Number = m_localAnchor2.y - _loc1_.m_sweep.localCenter.y;
         _loc2_ = _loc12_.col1.x * _loc13_ + _loc12_.col2.x * _loc11_;
         _loc11_ = _loc12_.col1.y * _loc13_ + _loc12_.col2.y * _loc11_;
         _loc13_ = _loc2_;
         var _loc7_:Number = _loc20_.m_sweep.c.x + _loc10_;
         var _loc14_:Number = _loc20_.m_sweep.c.y + _loc16_;
         var _loc9_:Number = _loc1_.m_sweep.c.x + _loc13_;
         var _loc8_:Number = _loc1_.m_sweep.c.y + _loc11_;
         var _loc5_:Number = _loc9_ - _loc7_;
         var _loc6_:Number = _loc8_ - _loc14_;
         var _loc3_:b2Vec2 = _loc20_.GetWorldVector(m_localXAxis1);
         var _loc17_:b2Vec2 = _loc20_.m_linearVelocity;
         var _loc19_:b2Vec2 = _loc1_.m_linearVelocity;
         var _loc15_:Number = _loc20_.m_angularVelocity;
         var _loc18_:Number = _loc1_.m_angularVelocity;
         var _loc4_:Number = _loc5_ * -_loc15_ * _loc3_.y + _loc6_ * _loc15_ * _loc3_.x + (_loc3_.x * (_loc19_.x + -_loc18_ * _loc11_ - _loc17_.x - -_loc15_ * _loc16_) + _loc3_.y * (_loc19_.y + _loc18_ * _loc13_ - _loc17_.y - _loc15_ * _loc10_));
         return _loc4_;
      }
      
      public function IsLimitEnabled() : Boolean
      {
         return m_enableLimit;
      }
      
      public function EnableLimit(param1:Boolean) : void
      {
         m_bodyA.SetAwake(true);
         m_bodyB.SetAwake(true);
         m_enableLimit = param1;
      }
      
      public function GetLowerLimit() : Number
      {
         return m_lowerTranslation;
      }
      
      public function GetUpperLimit() : Number
      {
         return m_upperTranslation;
      }
      
      public function SetLimits(param1:Number, param2:Number) : void
      {
         m_bodyA.SetAwake(true);
         m_bodyB.SetAwake(true);
         m_lowerTranslation = param1;
         m_upperTranslation = param2;
      }
      
      public function IsMotorEnabled() : Boolean
      {
         return m_enableMotor;
      }
      
      public function EnableMotor(param1:Boolean) : void
      {
         m_bodyA.SetAwake(true);
         m_bodyB.SetAwake(true);
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
      
      public function SetMaxMotorForce(param1:Number) : void
      {
         m_bodyA.SetAwake(true);
         m_bodyB.SetAwake(true);
         m_maxMotorForce = param1;
      }
      
      public function GetMaxMotorForce() : Number
      {
         return m_maxMotorForce;
      }
      
      public function GetMotorForce() : Number
      {
         return m_motorImpulse;
      }
      
      override b2internal function InitVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc18_:* = null;
         var _loc4_:* = NaN;
         var _loc20_:* = NaN;
         var _loc11_:* = NaN;
         var _loc13_:* = NaN;
         var _loc8_:* = NaN;
         var _loc9_:* = NaN;
         var _loc22_:b2Body = m_bodyA;
         var _loc2_:b2Body = m_bodyB;
         m_localCenterA.SetV(_loc22_.GetLocalCenter());
         m_localCenterB.SetV(_loc2_.GetLocalCenter());
         var _loc3_:b2Transform = _loc22_.GetTransform();
         var _loc6_:b2Transform = _loc2_.GetTransform();
         _loc18_ = _loc22_.m_xf.R;
         var _loc16_:Number = m_localAnchor1.x - m_localCenterA.x;
         var _loc21_:Number = m_localAnchor1.y - m_localCenterA.y;
         _loc4_ = _loc18_.col1.x * _loc16_ + _loc18_.col2.x * _loc21_;
         _loc21_ = _loc18_.col1.y * _loc16_ + _loc18_.col2.y * _loc21_;
         _loc16_ = _loc4_;
         _loc18_ = _loc2_.m_xf.R;
         var _loc19_:Number = m_localAnchor2.x - m_localCenterB.x;
         var _loc17_:Number = m_localAnchor2.y - m_localCenterB.y;
         _loc4_ = _loc18_.col1.x * _loc19_ + _loc18_.col2.x * _loc17_;
         _loc17_ = _loc18_.col1.y * _loc19_ + _loc18_.col2.y * _loc17_;
         _loc19_ = _loc4_;
         var _loc14_:Number = _loc2_.m_sweep.c.x + _loc19_ - _loc22_.m_sweep.c.x - _loc16_;
         var _loc15_:Number = _loc2_.m_sweep.c.y + _loc17_ - _loc22_.m_sweep.c.y - _loc21_;
         m_invMassA = _loc22_.m_invMass;
         m_invMassB = _loc2_.m_invMass;
         m_invIA = _loc22_.m_invI;
         m_invIB = _loc2_.m_invI;
         m_axis.SetV(b2Math.MulMV(_loc3_.R,m_localXAxis1));
         m_a1 = (_loc14_ + _loc16_) * m_axis.y - (_loc15_ + _loc21_) * m_axis.x;
         m_a2 = _loc19_ * m_axis.y - _loc17_ * m_axis.x;
         m_motorMass = m_invMassA + m_invMassB + m_invIA * m_a1 * m_a1 + m_invIB * m_a2 * m_a2;
         m_motorMass = m_motorMass > Number.MIN_VALUE?1 / m_motorMass:0.0;
         m_perp.SetV(b2Math.MulMV(_loc3_.R,m_localYAxis1));
         m_s1 = (_loc14_ + _loc16_) * m_perp.y - (_loc15_ + _loc21_) * m_perp.x;
         m_s2 = _loc19_ * m_perp.y - _loc17_ * m_perp.x;
         var _loc5_:Number = m_invMassA;
         var _loc7_:Number = m_invMassB;
         var _loc10_:Number = m_invIA;
         var _loc12_:Number = m_invIB;
         m_K.col1.x = _loc5_ + _loc7_ + _loc10_ * m_s1 * m_s1 + _loc12_ * m_s2 * m_s2;
         m_K.col1.y = _loc10_ * m_s1 * m_a1 + _loc12_ * m_s2 * m_a2;
         m_K.col2.x = m_K.col1.y;
         m_K.col2.y = _loc5_ + _loc7_ + _loc10_ * m_a1 * m_a1 + _loc12_ * m_a2 * m_a2;
         if(m_enableLimit)
         {
            _loc20_ = m_axis.x * _loc14_ + m_axis.y * _loc15_;
            if(b2Math.Abs(m_upperTranslation - m_lowerTranslation) < 2 * 0.005)
            {
               m_limitState = 3;
            }
            else if(_loc20_ <= m_lowerTranslation)
            {
               if(m_limitState != 1)
               {
                  m_limitState = 1;
                  m_impulse.y = 0;
               }
            }
            else if(_loc20_ >= m_upperTranslation)
            {
               if(m_limitState != 2)
               {
                  m_limitState = 2;
                  m_impulse.y = 0;
               }
            }
            else
            {
               m_limitState = 0;
               m_impulse.y = 0;
            }
         }
         else
         {
            m_limitState = 0;
         }
         if(m_enableMotor == false)
         {
            m_motorImpulse = 0;
         }
         if(param1.warmStarting)
         {
            m_impulse.x = m_impulse.x * param1.dtRatio;
            m_impulse.y = m_impulse.y * param1.dtRatio;
            m_motorImpulse = §§dup().m_motorImpulse * param1.dtRatio;
            _loc11_ = m_impulse.x * m_perp.x + (m_motorImpulse + m_impulse.y) * m_axis.x;
            _loc13_ = m_impulse.x * m_perp.y + (m_motorImpulse + m_impulse.y) * m_axis.y;
            _loc8_ = m_impulse.x * m_s1 + (m_motorImpulse + m_impulse.y) * m_a1;
            _loc9_ = m_impulse.x * m_s2 + (m_motorImpulse + m_impulse.y) * m_a2;
            _loc22_.m_linearVelocity.x = _loc22_.m_linearVelocity.x - m_invMassA * _loc11_;
            _loc22_.m_linearVelocity.y = _loc22_.m_linearVelocity.y - m_invMassA * _loc13_;
            _loc22_.m_angularVelocity = _loc22_.m_angularVelocity - m_invIA * _loc8_;
            _loc2_.m_linearVelocity.x = _loc2_.m_linearVelocity.x + m_invMassB * _loc11_;
            _loc2_.m_linearVelocity.y = _loc2_.m_linearVelocity.y + m_invMassB * _loc13_;
            _loc2_.m_angularVelocity = _loc2_.m_angularVelocity + m_invIB * _loc9_;
         }
         else
         {
            m_impulse.SetZero();
            m_motorImpulse = 0;
         }
      }
      
      override b2internal function SolveVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc8_:* = NaN;
         var _loc9_:* = NaN;
         var _loc5_:* = NaN;
         var _loc6_:* = NaN;
         var _loc14_:* = NaN;
         var _loc17_:* = NaN;
         var _loc18_:* = NaN;
         var _loc15_:* = NaN;
         var _loc12_:* = NaN;
         var _loc10_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = NaN;
         var _loc7_:* = NaN;
         var _loc11_:* = NaN;
         var _loc22_:b2Body = m_bodyA;
         var _loc2_:b2Body = m_bodyB;
         var _loc19_:b2Vec2 = _loc22_.m_linearVelocity;
         var _loc16_:Number = _loc22_.m_angularVelocity;
         var _loc21_:b2Vec2 = _loc2_.m_linearVelocity;
         var _loc20_:Number = _loc2_.m_angularVelocity;
         if(m_enableMotor && m_limitState != 3)
         {
            _loc14_ = m_axis.x * (_loc21_.x - _loc19_.x) + m_axis.y * (_loc21_.y - _loc19_.y) + m_a2 * _loc20_ - m_a1 * _loc16_;
            _loc17_ = m_motorMass * (m_motorSpeed - _loc14_);
            _loc18_ = m_motorImpulse;
            _loc15_ = param1.dt * m_maxMotorForce;
            m_motorImpulse = b2Math.Clamp(m_motorImpulse + _loc17_,-_loc15_,_loc15_);
            _loc17_ = m_motorImpulse - _loc18_;
            _loc8_ = _loc17_ * m_axis.x;
            _loc9_ = _loc17_ * m_axis.y;
            _loc5_ = _loc17_ * m_a1;
            _loc6_ = _loc17_ * m_a2;
            _loc19_.x = _loc19_.x - m_invMassA * _loc8_;
            _loc19_.y = _loc19_.y - m_invMassA * _loc9_;
            _loc16_ = _loc16_ - m_invIA * _loc5_;
            _loc21_.x = _loc21_.x + m_invMassB * _loc8_;
            _loc21_.y = _loc21_.y + m_invMassB * _loc9_;
            _loc20_ = _loc20_ + m_invIB * _loc6_;
         }
         var _loc13_:Number = m_perp.x * (_loc21_.x - _loc19_.x) + m_perp.y * (_loc21_.y - _loc19_.y) + m_s2 * _loc20_ - m_s1 * _loc16_;
         if(m_enableLimit && m_limitState != 0)
         {
            _loc12_ = m_axis.x * (_loc21_.x - _loc19_.x) + m_axis.y * (_loc21_.y - _loc19_.y) + m_a2 * _loc20_ - m_a1 * _loc16_;
            _loc10_ = m_impulse.Copy();
            _loc3_ = m_K.Solve(new b2Vec2(),-_loc13_,-_loc12_);
            m_impulse.Add(_loc3_);
            if(m_limitState == 1)
            {
               m_impulse.y = b2Math.Max(m_impulse.y,0);
            }
            else if(m_limitState == 2)
            {
               m_impulse.y = b2Math.Min(m_impulse.y,0);
            }
            _loc4_ = -_loc13_ - (m_impulse.y - _loc10_.y) * m_K.col2.x;
            if(m_K.col1.x != 0)
            {
               _loc7_ = _loc4_ / m_K.col1.x + _loc10_.x;
            }
            else
            {
               _loc7_ = _loc10_.x;
            }
            m_impulse.x = _loc7_;
            _loc3_.x = m_impulse.x - _loc10_.x;
            _loc3_.y = m_impulse.y - _loc10_.y;
            _loc8_ = _loc3_.x * m_perp.x + _loc3_.y * m_axis.x;
            _loc9_ = _loc3_.x * m_perp.y + _loc3_.y * m_axis.y;
            _loc5_ = _loc3_.x * m_s1 + _loc3_.y * m_a1;
            _loc6_ = _loc3_.x * m_s2 + _loc3_.y * m_a2;
            _loc19_.x = _loc19_.x - m_invMassA * _loc8_;
            _loc19_.y = _loc19_.y - m_invMassA * _loc9_;
            _loc16_ = _loc16_ - m_invIA * _loc5_;
            _loc21_.x = _loc21_.x + m_invMassB * _loc8_;
            _loc21_.y = _loc21_.y + m_invMassB * _loc9_;
            _loc20_ = _loc20_ + m_invIB * _loc6_;
         }
         else
         {
            if(m_K.col1.x != 0)
            {
               _loc11_ = -_loc13_ / m_K.col1.x;
            }
            else
            {
               _loc11_ = 0.0;
            }
            m_impulse.x = m_impulse.x + _loc11_;
            _loc8_ = _loc11_ * m_perp.x;
            _loc9_ = _loc11_ * m_perp.y;
            _loc5_ = _loc11_ * m_s1;
            _loc6_ = _loc11_ * m_s2;
            _loc19_.x = _loc19_.x - m_invMassA * _loc8_;
            _loc19_.y = _loc19_.y - m_invMassA * _loc9_;
            _loc16_ = _loc16_ - m_invIA * _loc5_;
            _loc21_.x = _loc21_.x + m_invMassB * _loc8_;
            _loc21_.y = _loc21_.y + m_invMassB * _loc9_;
            _loc20_ = _loc20_ + m_invIB * _loc6_;
         }
         _loc22_.m_linearVelocity.SetV(_loc19_);
         _loc22_.m_angularVelocity = _loc16_;
         _loc2_.m_linearVelocity.SetV(_loc21_);
         _loc2_.m_angularVelocity = _loc20_;
      }
      
      override b2internal function SolvePositionConstraints(param1:Number) : Boolean
      {
         var _loc24_:* = NaN;
         var _loc8_:* = NaN;
         var _loc34_:* = null;
         var _loc15_:* = NaN;
         var _loc16_:* = NaN;
         var _loc17_:* = NaN;
         var _loc20_:* = NaN;
         var _loc21_:* = NaN;
         var _loc32_:* = NaN;
         var _loc5_:* = NaN;
         var _loc33_:* = NaN;
         var _loc11_:b2Body = m_bodyA;
         var _loc13_:b2Body = m_bodyB;
         var _loc25_:b2Vec2 = _loc11_.m_sweep.c;
         var _loc27_:Number = _loc11_.m_sweep.a;
         var _loc26_:b2Vec2 = _loc13_.m_sweep.c;
         var _loc28_:Number = _loc13_.m_sweep.a;
         var _loc2_:* = 0.0;
         var _loc23_:* = 0.0;
         var _loc22_:* = false;
         var _loc7_:* = 0.0;
         var _loc12_:b2Mat22 = b2Mat22.FromAngle(_loc27_);
         var _loc14_:b2Mat22 = b2Mat22.FromAngle(_loc28_);
         _loc34_ = _loc12_;
         var _loc31_:Number = m_localAnchor1.x - m_localCenterA.x;
         var _loc36_:Number = m_localAnchor1.y - m_localCenterA.y;
         _loc15_ = _loc34_.col1.x * _loc31_ + _loc34_.col2.x * _loc36_;
         _loc36_ = _loc34_.col1.y * _loc31_ + _loc34_.col2.y * _loc36_;
         _loc31_ = _loc15_;
         _loc34_ = _loc14_;
         var _loc10_:Number = m_localAnchor2.x - m_localCenterB.x;
         var _loc9_:Number = m_localAnchor2.y - m_localCenterB.y;
         _loc15_ = _loc34_.col1.x * _loc10_ + _loc34_.col2.x * _loc9_;
         _loc9_ = _loc34_.col1.y * _loc10_ + _loc34_.col2.y * _loc9_;
         _loc10_ = _loc15_;
         var _loc29_:Number = _loc26_.x + _loc10_ - _loc25_.x - _loc31_;
         var _loc30_:Number = _loc26_.y + _loc9_ - _loc25_.y - _loc36_;
         if(m_enableLimit)
         {
            m_axis = b2Math.MulMV(_loc12_,m_localXAxis1);
            m_a1 = (_loc29_ + _loc31_) * m_axis.y - (_loc30_ + _loc36_) * m_axis.x;
            m_a2 = _loc10_ * m_axis.y - _loc9_ * m_axis.x;
            _loc32_ = m_axis.x * _loc29_ + m_axis.y * _loc30_;
            if(b2Math.Abs(m_upperTranslation - m_lowerTranslation) < 2 * 0.005)
            {
               _loc7_ = b2Math.Clamp(_loc32_,-0.2,0.2);
               _loc2_ = b2Math.Abs(_loc32_);
               _loc22_ = true;
            }
            else if(_loc32_ <= m_lowerTranslation)
            {
               _loc7_ = b2Math.Clamp(_loc32_ - m_lowerTranslation + 0.005,-0.2,0);
               _loc2_ = m_lowerTranslation - _loc32_;
               _loc22_ = true;
            }
            else if(_loc32_ >= m_upperTranslation)
            {
               _loc7_ = b2Math.Clamp(_loc32_ - m_upperTranslation + 0.005,0,0.2);
               _loc2_ = _loc32_ - m_upperTranslation;
               _loc22_ = true;
            }
         }
         m_perp = b2Math.MulMV(_loc12_,m_localYAxis1);
         m_s1 = (_loc29_ + _loc31_) * m_perp.y - (_loc30_ + _loc36_) * m_perp.x;
         m_s2 = _loc10_ * m_perp.y - _loc9_ * m_perp.x;
         var _loc35_:b2Vec2 = new b2Vec2();
         var _loc6_:Number = m_perp.x * _loc29_ + m_perp.y * _loc30_;
         _loc2_ = b2Math.Max(_loc2_,b2Math.Abs(_loc6_));
         _loc23_ = 0.0;
         if(_loc22_)
         {
            _loc16_ = m_invMassA;
            _loc17_ = m_invMassB;
            _loc20_ = m_invIA;
            _loc21_ = m_invIB;
            m_K.col1.x = _loc16_ + _loc17_ + _loc20_ * m_s1 * m_s1 + _loc21_ * m_s2 * m_s2;
            m_K.col1.y = _loc20_ * m_s1 * m_a1 + _loc21_ * m_s2 * m_a2;
            m_K.col2.x = m_K.col1.y;
            m_K.col2.y = _loc16_ + _loc17_ + _loc20_ * m_a1 * m_a1 + _loc21_ * m_a2 * m_a2;
            m_K.Solve(_loc35_,-_loc6_,-_loc7_);
         }
         else
         {
            _loc16_ = m_invMassA;
            _loc17_ = m_invMassB;
            _loc20_ = m_invIA;
            _loc21_ = m_invIB;
            _loc5_ = _loc16_ + _loc17_ + _loc20_ * m_s1 * m_s1 + _loc21_ * m_s2 * m_s2;
            if(_loc5_ != 0)
            {
               _loc33_ = -_loc6_ / _loc5_;
            }
            else
            {
               _loc33_ = 0.0;
            }
            _loc35_.x = _loc33_;
            _loc35_.y = 0;
         }
         var _loc3_:Number = _loc35_.x * m_perp.x + _loc35_.y * m_axis.x;
         var _loc4_:Number = _loc35_.x * m_perp.y + _loc35_.y * m_axis.y;
         var _loc18_:Number = _loc35_.x * m_s1 + _loc35_.y * m_a1;
         var _loc19_:Number = _loc35_.x * m_s2 + _loc35_.y * m_a2;
         _loc25_.x = _loc25_.x - m_invMassA * _loc3_;
         _loc25_.y = _loc25_.y - m_invMassA * _loc4_;
         _loc27_ = _loc27_ - m_invIA * _loc18_;
         _loc26_.x = _loc26_.x + m_invMassB * _loc3_;
         _loc26_.y = _loc26_.y + m_invMassB * _loc4_;
         _loc28_ = _loc28_ + m_invIB * _loc19_;
         _loc11_.m_sweep.a = _loc27_;
         _loc13_.m_sweep.a = _loc28_;
         _loc11_.SynchronizeTransform();
         _loc13_.SynchronizeTransform();
         return _loc2_ <= 0.005 && _loc23_ <= 0.03490658503988659;
      }
   }
}
