package Box2D.Dynamics.Contacts
{
   import Box2D.Collision.b2WorldManifold;
   import Box2D.Dynamics.b2TimeStep;
   import Box2D.Common.b2internal;
   import Box2D.Dynamics.b2Fixture;
   import Box2D.Collision.Shapes.b2Shape;
   import Box2D.Dynamics.b2Body;
   import Box2D.Collision.b2Manifold;
   import Box2D.Common.b2Settings;
   import Box2D.Collision.b2ManifoldPoint;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.Math.b2Math;
   import Box2D.Common.Math.b2Mat22;
   
   use namespace b2internal;
   
   public class b2ContactSolver
   {
      
      private static var s_worldManifold:b2WorldManifold = new b2WorldManifold();
      
      private static var s_psm:Box2D.Dynamics.Contacts.b2PositionSolverManifold = new Box2D.Dynamics.Contacts.b2PositionSolverManifold();
       
      private var m_step:b2TimeStep;
      
      private var m_allocator;
      
      b2internal var m_constraints:Vector.<Box2D.Dynamics.Contacts.b2ContactConstraint>;
      
      private var m_constraintCount:int;
      
      public function b2ContactSolver()
      {
         m_step = new b2TimeStep();
         m_constraints = new Vector.<Box2D.Dynamics.Contacts.b2ContactConstraint>();
         super();
      }
      
      public function Initialize(param1:b2TimeStep, param2:Vector.<b2Contact>, param3:int, param4:*) : void
      {
         var _loc13_:* = null;
         var _loc52_:* = 0;
         var _loc23_:* = null;
         var _loc61_:* = null;
         var _loc43_:* = null;
         var _loc42_:* = null;
         var _loc47_:* = null;
         var _loc49_:* = null;
         var _loc37_:* = NaN;
         var _loc36_:* = NaN;
         var _loc29_:* = null;
         var _loc60_:* = null;
         var _loc14_:* = null;
         var _loc56_:* = NaN;
         var _loc58_:* = NaN;
         var _loc19_:* = NaN;
         var _loc20_:* = NaN;
         var _loc34_:* = NaN;
         var _loc33_:* = NaN;
         var _loc16_:* = NaN;
         var _loc17_:* = NaN;
         var _loc5_:* = NaN;
         var _loc6_:* = NaN;
         var _loc44_:* = null;
         var _loc54_:* = 0;
         var _loc55_:* = null;
         var _loc11_:* = null;
         var _loc15_:* = NaN;
         var _loc18_:* = NaN;
         var _loc31_:* = NaN;
         var _loc30_:* = NaN;
         var _loc7_:* = NaN;
         var _loc8_:* = NaN;
         var _loc12_:* = NaN;
         var _loc57_:* = NaN;
         var _loc51_:* = NaN;
         var _loc45_:* = NaN;
         var _loc26_:* = NaN;
         var _loc28_:* = NaN;
         var _loc24_:* = NaN;
         var _loc48_:* = NaN;
         var _loc50_:* = NaN;
         var _loc59_:* = NaN;
         var _loc10_:* = null;
         var _loc9_:* = null;
         var _loc39_:* = NaN;
         var _loc22_:* = NaN;
         var _loc38_:* = NaN;
         var _loc21_:* = NaN;
         var _loc41_:* = NaN;
         var _loc40_:* = NaN;
         var _loc27_:* = NaN;
         var _loc25_:* = NaN;
         var _loc32_:* = NaN;
         var _loc53_:* = NaN;
         var _loc35_:* = NaN;
         var _loc46_:* = NaN;
         m_step.Set(param1);
         m_allocator = param4;
         m_constraintCount = param3;
         while(m_constraints.length < m_constraintCount)
         {
            m_constraints[m_constraints.length] = new Box2D.Dynamics.Contacts.b2ContactConstraint();
         }
         _loc52_ = 0;
         while(_loc52_ < param3)
         {
            _loc13_ = param2[_loc52_];
            _loc43_ = _loc13_.m_fixtureA;
            _loc42_ = _loc13_.m_fixtureB;
            _loc47_ = _loc43_.m_shape;
            _loc49_ = _loc42_.m_shape;
            _loc37_ = _loc47_.m_radius;
            _loc36_ = _loc49_.m_radius;
            _loc29_ = _loc43_.m_body;
            _loc60_ = _loc42_.m_body;
            _loc14_ = _loc13_.GetManifold();
            _loc56_ = b2Settings.b2MixFriction(_loc43_.GetFriction(),_loc42_.GetFriction());
            _loc58_ = b2Settings.b2MixRestitution(_loc43_.GetRestitution(),_loc42_.GetRestitution());
            _loc19_ = _loc29_.m_linearVelocity.x;
            _loc20_ = _loc29_.m_linearVelocity.y;
            _loc34_ = _loc60_.m_linearVelocity.x;
            _loc33_ = _loc60_.m_linearVelocity.y;
            _loc16_ = _loc29_.m_angularVelocity;
            _loc17_ = _loc60_.m_angularVelocity;
            b2Settings.b2Assert(_loc14_.m_pointCount > 0);
            s_worldManifold.Initialize(_loc14_,_loc29_.m_xf,_loc37_,_loc60_.m_xf,_loc36_);
            _loc5_ = s_worldManifold.m_normal.x;
            _loc6_ = s_worldManifold.m_normal.y;
            _loc44_ = m_constraints[_loc52_];
            _loc44_.bodyA = _loc29_;
            _loc44_.bodyB = _loc60_;
            _loc44_.manifold = _loc14_;
            _loc44_.normal.x = _loc5_;
            _loc44_.normal.y = _loc6_;
            _loc44_.pointCount = _loc14_.m_pointCount;
            _loc44_.friction = _loc56_;
            _loc44_.restitution = _loc58_;
            _loc44_.localPlaneNormal.x = _loc14_.m_localPlaneNormal.x;
            _loc44_.localPlaneNormal.y = _loc14_.m_localPlaneNormal.y;
            _loc44_.localPoint.x = _loc14_.m_localPoint.x;
            _loc44_.localPoint.y = _loc14_.m_localPoint.y;
            _loc44_.radius = _loc37_ + _loc36_;
            _loc44_.type = _loc14_.m_type;
            _loc54_ = 0;
            while(_loc54_ < _loc44_.pointCount)
            {
               _loc55_ = _loc14_.m_points[_loc54_];
               _loc11_ = _loc44_.points[_loc54_];
               _loc11_.normalImpulse = _loc55_.m_normalImpulse;
               _loc11_.tangentImpulse = _loc55_.m_tangentImpulse;
               _loc11_.localPoint.SetV(_loc55_.m_localPoint);
               var _loc62_:* = s_worldManifold.m_points[_loc54_].x - _loc29_.m_sweep.c.x;
               _loc11_.rA.x = _loc62_;
               _loc15_ = _loc62_;
               _loc62_ = s_worldManifold.m_points[_loc54_].y - _loc29_.m_sweep.c.y;
               _loc11_.rA.y = _loc62_;
               _loc18_ = _loc62_;
               _loc62_ = s_worldManifold.m_points[_loc54_].x - _loc60_.m_sweep.c.x;
               _loc11_.rB.x = _loc62_;
               _loc31_ = _loc62_;
               _loc62_ = s_worldManifold.m_points[_loc54_].y - _loc60_.m_sweep.c.y;
               _loc11_.rB.y = _loc62_;
               _loc30_ = _loc62_;
               _loc7_ = _loc15_ * _loc6_ - _loc18_ * _loc5_;
               _loc8_ = _loc31_ * _loc6_ - _loc30_ * _loc5_;
               _loc7_ = _loc7_ * _loc7_;
               _loc8_ = _loc8_ * _loc8_;
               _loc12_ = _loc29_.m_invMass + _loc60_.m_invMass + _loc29_.m_invI * _loc7_ + _loc60_.m_invI * _loc8_;
               _loc11_.normalMass = 1 / _loc12_;
               _loc57_ = _loc29_.m_mass * _loc29_.m_invMass + _loc60_.m_mass * _loc60_.m_invMass;
               _loc57_ = _loc57_ + (_loc29_.m_mass * _loc29_.m_invI * _loc7_ + _loc60_.m_mass * _loc60_.m_invI * _loc8_);
               _loc11_.equalizedMass = 1 / _loc57_;
               _loc51_ = _loc6_;
               _loc45_ = -_loc5_;
               _loc26_ = _loc15_ * _loc45_ - _loc18_ * _loc51_;
               _loc28_ = _loc31_ * _loc45_ - _loc30_ * _loc51_;
               _loc26_ = _loc26_ * _loc26_;
               _loc28_ = _loc28_ * _loc28_;
               _loc24_ = _loc29_.m_invMass + _loc60_.m_invMass + _loc29_.m_invI * _loc26_ + _loc60_.m_invI * _loc28_;
               _loc11_.tangentMass = 1 / _loc24_;
               _loc11_.velocityBias = 0;
               _loc48_ = _loc34_ + -_loc17_ * _loc30_ - _loc19_ - -_loc16_ * _loc18_;
               _loc50_ = _loc33_ + _loc17_ * _loc31_ - _loc20_ - _loc16_ * _loc15_;
               _loc59_ = _loc44_.normal.x * _loc48_ + _loc44_.normal.y * _loc50_;
               if(_loc59_ < -1)
               {
                  _loc11_.velocityBias = _loc11_.velocityBias + -_loc44_.restitution * _loc59_;
               }
               _loc54_++;
            }
            if(_loc44_.pointCount == 2)
            {
               _loc10_ = _loc44_.points[0];
               _loc9_ = _loc44_.points[1];
               _loc39_ = _loc29_.m_invMass;
               _loc22_ = _loc29_.m_invI;
               _loc38_ = _loc60_.m_invMass;
               _loc21_ = _loc60_.m_invI;
               _loc41_ = _loc10_.rA.x * _loc6_ - _loc10_.rA.y * _loc5_;
               _loc40_ = _loc10_.rB.x * _loc6_ - _loc10_.rB.y * _loc5_;
               _loc27_ = _loc9_.rA.x * _loc6_ - _loc9_.rA.y * _loc5_;
               _loc25_ = _loc9_.rB.x * _loc6_ - _loc9_.rB.y * _loc5_;
               _loc32_ = _loc39_ + _loc38_ + _loc22_ * _loc41_ * _loc41_ + _loc21_ * _loc40_ * _loc40_;
               _loc53_ = _loc39_ + _loc38_ + _loc22_ * _loc27_ * _loc27_ + _loc21_ * _loc25_ * _loc25_;
               _loc35_ = _loc39_ + _loc38_ + _loc22_ * _loc41_ * _loc27_ + _loc21_ * _loc40_ * _loc25_;
               _loc46_ = 100.0;
               if(_loc32_ * _loc32_ < _loc46_ * (_loc32_ * _loc53_ - _loc35_ * _loc35_))
               {
                  _loc44_.K.col1.Set(_loc32_,_loc35_);
                  _loc44_.K.col2.Set(_loc35_,_loc53_);
                  _loc44_.K.GetInverse(_loc44_.normalMass);
               }
               else
               {
                  _loc44_.pointCount = 1;
               }
            }
            _loc52_++;
         }
      }
      
      public function InitVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc20_:* = null;
         var _loc22_:* = null;
         var _loc23_:* = null;
         var _loc10_:* = 0;
         var _loc5_:* = null;
         var _loc7_:* = null;
         var _loc21_:* = null;
         var _loc19_:* = NaN;
         var _loc17_:* = NaN;
         var _loc18_:* = NaN;
         var _loc15_:* = NaN;
         var _loc3_:* = NaN;
         var _loc4_:* = NaN;
         var _loc8_:* = NaN;
         var _loc2_:* = NaN;
         var _loc6_:* = NaN;
         var _loc12_:* = 0;
         var _loc14_:* = 0;
         var _loc16_:* = null;
         var _loc9_:* = NaN;
         var _loc11_:* = NaN;
         var _loc13_:* = null;
         _loc10_ = 0;
         while(_loc10_ < m_constraintCount)
         {
            _loc5_ = m_constraints[_loc10_];
            _loc7_ = _loc5_.bodyA;
            _loc21_ = _loc5_.bodyB;
            _loc19_ = _loc7_.m_invMass;
            _loc17_ = _loc7_.m_invI;
            _loc18_ = _loc21_.m_invMass;
            _loc15_ = _loc21_.m_invI;
            _loc3_ = _loc5_.normal.x;
            _loc4_ = _loc5_.normal.y;
            _loc8_ = _loc4_;
            _loc2_ = -_loc3_;
            if(param1.warmStarting)
            {
               _loc14_ = _loc5_.pointCount;
               _loc12_ = 0;
               while(_loc12_ < _loc14_)
               {
                  _loc16_ = _loc5_.points[_loc12_];
                  _loc16_.normalImpulse = _loc16_.normalImpulse * param1.dtRatio;
                  _loc16_.tangentImpulse = _loc16_.tangentImpulse * param1.dtRatio;
                  _loc9_ = _loc16_.normalImpulse * _loc3_ + _loc16_.tangentImpulse * _loc8_;
                  _loc11_ = _loc16_.normalImpulse * _loc4_ + _loc16_.tangentImpulse * _loc2_;
                  _loc7_.m_angularVelocity = _loc7_.m_angularVelocity - _loc17_ * (_loc16_.rA.x * _loc11_ - _loc16_.rA.y * _loc9_);
                  _loc7_.m_linearVelocity.x = _loc7_.m_linearVelocity.x - _loc19_ * _loc9_;
                  _loc7_.m_linearVelocity.y = _loc7_.m_linearVelocity.y - _loc19_ * _loc11_;
                  _loc21_.m_angularVelocity = _loc21_.m_angularVelocity + _loc15_ * (_loc16_.rB.x * _loc11_ - _loc16_.rB.y * _loc9_);
                  _loc21_.m_linearVelocity.x = _loc21_.m_linearVelocity.x + _loc18_ * _loc9_;
                  _loc21_.m_linearVelocity.y = _loc21_.m_linearVelocity.y + _loc18_ * _loc11_;
                  _loc12_++;
               }
            }
            else
            {
               _loc14_ = _loc5_.pointCount;
               _loc12_ = 0;
               while(_loc12_ < _loc14_)
               {
                  _loc13_ = _loc5_.points[_loc12_];
                  _loc13_.normalImpulse = 0;
                  _loc13_.tangentImpulse = 0;
                  _loc12_++;
               }
            }
            _loc10_++;
         }
      }
      
      public function SolveVelocityConstraints() : void
      {
         var _loc47_:* = 0;
         var _loc9_:* = null;
         var _loc15_:* = NaN;
         var _loc17_:* = NaN;
         var _loc33_:* = NaN;
         var _loc31_:* = NaN;
         var _loc4_:* = NaN;
         var _loc3_:* = NaN;
         var _loc28_:* = NaN;
         var _loc29_:* = NaN;
         var _loc10_:* = NaN;
         var _loc32_:* = NaN;
         var _loc53_:* = NaN;
         var _loc5_:* = NaN;
         var _loc6_:* = NaN;
         var _loc49_:* = NaN;
         var _loc50_:* = NaN;
         var _loc11_:* = NaN;
         var _loc14_:* = NaN;
         var _loc26_:* = NaN;
         var _loc23_:* = NaN;
         var _loc56_:* = null;
         var _loc24_:* = null;
         var _loc46_:* = 0;
         var _loc41_:* = null;
         var _loc30_:* = null;
         var _loc54_:* = null;
         var _loc16_:* = NaN;
         var _loc18_:* = NaN;
         var _loc7_:* = null;
         var _loc8_:* = null;
         var _loc35_:* = NaN;
         var _loc21_:* = NaN;
         var _loc34_:* = NaN;
         var _loc20_:* = NaN;
         var _loc1_:* = NaN;
         var _loc2_:* = NaN;
         var _loc45_:* = NaN;
         var _loc38_:* = NaN;
         var _loc48_:* = NaN;
         var _loc42_:* = NaN;
         var _loc19_:* = 0;
         var _loc44_:* = null;
         var _loc43_:* = null;
         var _loc12_:* = NaN;
         var _loc13_:* = NaN;
         var _loc52_:* = NaN;
         var _loc51_:* = NaN;
         var _loc37_:* = NaN;
         var _loc36_:* = NaN;
         var _loc55_:* = NaN;
         var _loc57_:* = NaN;
         var _loc25_:* = NaN;
         var _loc27_:* = NaN;
         var _loc22_:* = NaN;
         var _loc39_:* = NaN;
         var _loc40_:* = NaN;
         _loc46_ = 0;
         while(_loc46_ < m_constraintCount)
         {
            _loc41_ = m_constraints[_loc46_];
            _loc30_ = _loc41_.bodyA;
            _loc54_ = _loc41_.bodyB;
            _loc16_ = _loc30_.m_angularVelocity;
            _loc18_ = _loc54_.m_angularVelocity;
            _loc7_ = _loc30_.m_linearVelocity;
            _loc8_ = _loc54_.m_linearVelocity;
            _loc35_ = _loc30_.m_invMass;
            _loc21_ = _loc30_.m_invI;
            _loc34_ = _loc54_.m_invMass;
            _loc20_ = _loc54_.m_invI;
            _loc1_ = _loc41_.normal.x;
            _loc2_ = _loc41_.normal.y;
            _loc45_ = _loc2_;
            _loc38_ = -_loc1_;
            _loc48_ = _loc41_.friction;
            _loc47_ = 0;
            while(_loc47_ < _loc41_.pointCount)
            {
               _loc9_ = _loc41_.points[_loc47_];
               _loc4_ = _loc8_.x - _loc18_ * _loc9_.rB.y - _loc7_.x + _loc16_ * _loc9_.rA.y;
               _loc3_ = _loc8_.y + _loc18_ * _loc9_.rB.x - _loc7_.y - _loc16_ * _loc9_.rA.x;
               _loc29_ = _loc4_ * _loc45_ + _loc3_ * _loc38_;
               _loc10_ = _loc9_.tangentMass * -_loc29_;
               _loc32_ = _loc48_ * _loc9_.normalImpulse;
               _loc53_ = b2Math.Clamp(_loc9_.tangentImpulse + _loc10_,-_loc32_,_loc32_);
               _loc10_ = _loc53_ - _loc9_.tangentImpulse;
               _loc5_ = _loc10_ * _loc45_;
               _loc6_ = _loc10_ * _loc38_;
               _loc7_.x = _loc7_.x - _loc35_ * _loc5_;
               _loc7_.y = _loc7_.y - _loc35_ * _loc6_;
               _loc16_ = _loc16_ - _loc21_ * (_loc9_.rA.x * _loc6_ - _loc9_.rA.y * _loc5_);
               _loc8_.x = _loc8_.x + _loc34_ * _loc5_;
               _loc8_.y = _loc8_.y + _loc34_ * _loc6_;
               _loc18_ = _loc18_ + _loc20_ * (_loc9_.rB.x * _loc6_ - _loc9_.rB.y * _loc5_);
               _loc9_.tangentImpulse = _loc53_;
               _loc47_++;
            }
            _loc19_ = _loc41_.pointCount;
            if(_loc41_.pointCount == 1)
            {
               _loc9_ = _loc41_.points[0];
               _loc4_ = _loc8_.x + -_loc18_ * _loc9_.rB.y - _loc7_.x - -_loc16_ * _loc9_.rA.y;
               _loc3_ = _loc8_.y + _loc18_ * _loc9_.rB.x - _loc7_.y - _loc16_ * _loc9_.rA.x;
               _loc28_ = _loc4_ * _loc1_ + _loc3_ * _loc2_;
               _loc10_ = -_loc9_.normalMass * (_loc28_ - _loc9_.velocityBias);
               _loc53_ = _loc9_.normalImpulse + _loc10_;
               _loc53_ = _loc53_ > 0?_loc53_:0.0;
               _loc10_ = _loc53_ - _loc9_.normalImpulse;
               _loc5_ = _loc10_ * _loc1_;
               _loc6_ = _loc10_ * _loc2_;
               _loc7_.x = _loc7_.x - _loc35_ * _loc5_;
               _loc7_.y = _loc7_.y - _loc35_ * _loc6_;
               _loc16_ = _loc16_ - _loc21_ * (_loc9_.rA.x * _loc6_ - _loc9_.rA.y * _loc5_);
               _loc8_.x = _loc8_.x + _loc34_ * _loc5_;
               _loc8_.y = _loc8_.y + _loc34_ * _loc6_;
               _loc18_ = _loc18_ + _loc20_ * (_loc9_.rB.x * _loc6_ - _loc9_.rB.y * _loc5_);
               _loc9_.normalImpulse = _loc53_;
            }
            else
            {
               _loc44_ = _loc41_.points[0];
               _loc43_ = _loc41_.points[1];
               _loc12_ = _loc44_.normalImpulse;
               _loc13_ = _loc43_.normalImpulse;
               _loc52_ = _loc8_.x - _loc18_ * _loc44_.rB.y - _loc7_.x + _loc16_ * _loc44_.rA.y;
               _loc51_ = _loc8_.y + _loc18_ * _loc44_.rB.x - _loc7_.y - _loc16_ * _loc44_.rA.x;
               _loc37_ = _loc8_.x - _loc18_ * _loc43_.rB.y - _loc7_.x + _loc16_ * _loc43_.rA.y;
               _loc36_ = _loc8_.y + _loc18_ * _loc43_.rB.x - _loc7_.y - _loc16_ * _loc43_.rA.x;
               _loc55_ = _loc52_ * _loc1_ + _loc51_ * _loc2_;
               _loc57_ = _loc37_ * _loc1_ + _loc36_ * _loc2_;
               _loc25_ = _loc55_ - _loc44_.velocityBias;
               _loc27_ = _loc57_ - _loc43_.velocityBias;
               _loc56_ = _loc41_.K;
               _loc25_ = _loc25_ - (_loc56_.col1.x * _loc12_ + _loc56_.col2.x * _loc13_);
               _loc27_ = _loc27_ - (_loc56_.col1.y * _loc12_ + _loc56_.col2.y * _loc13_);
               _loc22_ = 0.001;
               _loc56_ = _loc41_.normalMass;
               _loc39_ = -(_loc56_.col1.x * _loc25_ + _loc56_.col2.x * _loc27_);
               _loc40_ = -(_loc56_.col1.y * _loc25_ + _loc56_.col2.y * _loc27_);
               if(_loc39_ >= 0 && _loc40_ >= 0)
               {
                  _loc49_ = _loc39_ - _loc12_;
                  _loc50_ = _loc40_ - _loc13_;
                  _loc11_ = _loc49_ * _loc1_;
                  _loc14_ = _loc49_ * _loc2_;
                  _loc26_ = _loc50_ * _loc1_;
                  _loc23_ = _loc50_ * _loc2_;
                  _loc7_.x = _loc7_.x - _loc35_ * (_loc11_ + _loc26_);
                  _loc7_.y = _loc7_.y - _loc35_ * (_loc14_ + _loc23_);
                  _loc16_ = _loc16_ - _loc21_ * (_loc44_.rA.x * _loc14_ - _loc44_.rA.y * _loc11_ + _loc43_.rA.x * _loc23_ - _loc43_.rA.y * _loc26_);
                  _loc8_.x = _loc8_.x + _loc34_ * (_loc11_ + _loc26_);
                  _loc8_.y = _loc8_.y + _loc34_ * (_loc14_ + _loc23_);
                  _loc18_ = _loc18_ + _loc20_ * (_loc44_.rB.x * _loc14_ - _loc44_.rB.y * _loc11_ + _loc43_.rB.x * _loc23_ - _loc43_.rB.y * _loc26_);
                  _loc44_.normalImpulse = _loc39_;
                  _loc43_.normalImpulse = _loc40_;
               }
               else
               {
                  _loc39_ = -_loc44_.normalMass * _loc25_;
                  _loc40_ = 0.0;
                  _loc55_ = 0.0;
                  _loc57_ = _loc41_.K.col1.y * _loc39_ + _loc27_;
                  if(_loc39_ >= 0 && _loc57_ >= 0)
                  {
                     _loc49_ = _loc39_ - _loc12_;
                     _loc50_ = _loc40_ - _loc13_;
                     _loc11_ = _loc49_ * _loc1_;
                     _loc14_ = _loc49_ * _loc2_;
                     _loc26_ = _loc50_ * _loc1_;
                     _loc23_ = _loc50_ * _loc2_;
                     _loc7_.x = _loc7_.x - _loc35_ * (_loc11_ + _loc26_);
                     _loc7_.y = _loc7_.y - _loc35_ * (_loc14_ + _loc23_);
                     _loc16_ = _loc16_ - _loc21_ * (_loc44_.rA.x * _loc14_ - _loc44_.rA.y * _loc11_ + _loc43_.rA.x * _loc23_ - _loc43_.rA.y * _loc26_);
                     _loc8_.x = _loc8_.x + _loc34_ * (_loc11_ + _loc26_);
                     _loc8_.y = _loc8_.y + _loc34_ * (_loc14_ + _loc23_);
                     _loc18_ = _loc18_ + _loc20_ * (_loc44_.rB.x * _loc14_ - _loc44_.rB.y * _loc11_ + _loc43_.rB.x * _loc23_ - _loc43_.rB.y * _loc26_);
                     _loc44_.normalImpulse = _loc39_;
                     _loc43_.normalImpulse = _loc40_;
                  }
                  else
                  {
                     _loc39_ = 0.0;
                     _loc40_ = -_loc43_.normalMass * _loc27_;
                     _loc55_ = _loc41_.K.col2.x * _loc40_ + _loc25_;
                     _loc57_ = 0.0;
                     if(_loc40_ >= 0 && _loc55_ >= 0)
                     {
                        _loc49_ = _loc39_ - _loc12_;
                        _loc50_ = _loc40_ - _loc13_;
                        _loc11_ = _loc49_ * _loc1_;
                        _loc14_ = _loc49_ * _loc2_;
                        _loc26_ = _loc50_ * _loc1_;
                        _loc23_ = _loc50_ * _loc2_;
                        _loc7_.x = _loc7_.x - _loc35_ * (_loc11_ + _loc26_);
                        _loc7_.y = _loc7_.y - _loc35_ * (_loc14_ + _loc23_);
                        _loc16_ = _loc16_ - _loc21_ * (_loc44_.rA.x * _loc14_ - _loc44_.rA.y * _loc11_ + _loc43_.rA.x * _loc23_ - _loc43_.rA.y * _loc26_);
                        _loc8_.x = _loc8_.x + _loc34_ * (_loc11_ + _loc26_);
                        _loc8_.y = _loc8_.y + _loc34_ * (_loc14_ + _loc23_);
                        _loc18_ = _loc18_ + _loc20_ * (_loc44_.rB.x * _loc14_ - _loc44_.rB.y * _loc11_ + _loc43_.rB.x * _loc23_ - _loc43_.rB.y * _loc26_);
                        _loc44_.normalImpulse = _loc39_;
                        _loc43_.normalImpulse = _loc40_;
                     }
                     else
                     {
                        _loc39_ = 0.0;
                        _loc40_ = 0.0;
                        _loc55_ = _loc25_;
                        _loc57_ = _loc27_;
                        if(_loc55_ >= 0 && _loc57_ >= 0)
                        {
                           _loc49_ = _loc39_ - _loc12_;
                           _loc50_ = _loc40_ - _loc13_;
                           _loc11_ = _loc49_ * _loc1_;
                           _loc14_ = _loc49_ * _loc2_;
                           _loc26_ = _loc50_ * _loc1_;
                           _loc23_ = _loc50_ * _loc2_;
                           _loc7_.x = _loc7_.x - _loc35_ * (_loc11_ + _loc26_);
                           _loc7_.y = _loc7_.y - _loc35_ * (_loc14_ + _loc23_);
                           _loc16_ = _loc16_ - _loc21_ * (_loc44_.rA.x * _loc14_ - _loc44_.rA.y * _loc11_ + _loc43_.rA.x * _loc23_ - _loc43_.rA.y * _loc26_);
                           _loc8_.x = _loc8_.x + _loc34_ * (_loc11_ + _loc26_);
                           _loc8_.y = _loc8_.y + _loc34_ * (_loc14_ + _loc23_);
                           _loc18_ = _loc18_ + _loc20_ * (_loc44_.rB.x * _loc14_ - _loc44_.rB.y * _loc11_ + _loc43_.rB.x * _loc23_ - _loc43_.rB.y * _loc26_);
                           _loc44_.normalImpulse = _loc39_;
                           _loc43_.normalImpulse = _loc40_;
                        }
                     }
                  }
               }
            }
            _loc30_.m_angularVelocity = _loc16_;
            _loc54_.m_angularVelocity = _loc18_;
            _loc46_++;
         }
      }
      
      public function FinalizeVelocityConstraints() : void
      {
         var _loc2_:* = 0;
         var _loc1_:* = null;
         var _loc4_:* = null;
         var _loc3_:* = 0;
         var _loc5_:* = null;
         var _loc6_:* = null;
         _loc2_ = 0;
         while(_loc2_ < m_constraintCount)
         {
            _loc1_ = m_constraints[_loc2_];
            _loc4_ = _loc1_.manifold;
            _loc3_ = 0;
            while(_loc3_ < _loc1_.pointCount)
            {
               _loc5_ = _loc4_.m_points[_loc3_];
               _loc6_ = _loc1_.points[_loc3_];
               _loc5_.m_normalImpulse = _loc6_.normalImpulse;
               _loc5_.m_tangentImpulse = _loc6_.tangentImpulse;
               _loc3_++;
            }
            _loc2_++;
         }
      }
      
      public function SolvePositionConstraints(param1:Number) : Boolean
      {
         var _loc10_:* = 0;
         var _loc3_:* = null;
         var _loc5_:* = null;
         var _loc22_:* = null;
         var _loc20_:* = NaN;
         var _loc18_:* = NaN;
         var _loc19_:* = NaN;
         var _loc16_:* = NaN;
         var _loc2_:* = null;
         var _loc13_:* = 0;
         var _loc17_:* = null;
         var _loc15_:* = null;
         var _loc21_:* = NaN;
         var _loc7_:* = NaN;
         var _loc14_:* = NaN;
         var _loc11_:* = NaN;
         var _loc8_:* = NaN;
         var _loc4_:* = NaN;
         var _loc23_:* = NaN;
         var _loc9_:* = NaN;
         var _loc12_:* = NaN;
         var _loc6_:* = 0.0;
         _loc10_ = 0;
         while(_loc10_ < m_constraintCount)
         {
            _loc3_ = m_constraints[_loc10_];
            _loc5_ = _loc3_.bodyA;
            _loc22_ = _loc3_.bodyB;
            _loc20_ = _loc5_.m_mass * _loc5_.m_invMass;
            _loc18_ = _loc5_.m_mass * _loc5_.m_invI;
            _loc19_ = _loc22_.m_mass * _loc22_.m_invMass;
            _loc16_ = _loc22_.m_mass * _loc22_.m_invI;
            s_psm.Initialize(_loc3_);
            _loc2_ = s_psm.m_normal;
            _loc13_ = 0;
            while(_loc13_ < _loc3_.pointCount)
            {
               _loc17_ = _loc3_.points[_loc13_];
               _loc15_ = s_psm.m_points[_loc13_];
               _loc21_ = s_psm.m_separations[_loc13_];
               _loc7_ = _loc15_.x - _loc5_.m_sweep.c.x;
               _loc14_ = _loc15_.y - _loc5_.m_sweep.c.y;
               _loc11_ = _loc15_.x - _loc22_.m_sweep.c.x;
               _loc8_ = _loc15_.y - _loc22_.m_sweep.c.y;
               _loc6_ = _loc6_ < _loc21_?_loc6_:_loc21_;
               _loc4_ = b2Math.Clamp(param1 * (_loc21_ + 0.005),-0.2,0);
               _loc23_ = -_loc17_.equalizedMass * _loc4_;
               _loc9_ = _loc23_ * _loc2_.x;
               _loc12_ = _loc23_ * _loc2_.y;
               _loc5_.m_sweep.c.x = _loc5_.m_sweep.c.x - _loc20_ * _loc9_;
               _loc5_.m_sweep.c.y = _loc5_.m_sweep.c.y - _loc20_ * _loc12_;
               _loc5_.m_sweep.a = _loc5_.m_sweep.a - _loc18_ * (_loc7_ * _loc12_ - _loc14_ * _loc9_);
               _loc5_.SynchronizeTransform();
               _loc22_.m_sweep.c.x = _loc22_.m_sweep.c.x + _loc19_ * _loc9_;
               _loc22_.m_sweep.c.y = _loc22_.m_sweep.c.y + _loc19_ * _loc12_;
               _loc22_.m_sweep.a = _loc22_.m_sweep.a + _loc16_ * (_loc11_ * _loc12_ - _loc8_ * _loc9_);
               _loc22_.SynchronizeTransform();
               _loc13_++;
            }
            _loc10_++;
         }
         return _loc6_ > -1.5 * 0.005;
      }
   }
}
