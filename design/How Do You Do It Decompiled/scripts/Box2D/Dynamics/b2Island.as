package Box2D.Dynamics
{
   import Box2D.Dynamics.Contacts.b2ContactSolver;
   import Box2D.Common.b2internal;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.Math.b2Math;
   import Box2D.Dynamics.Joints.b2Joint;
   import Box2D.Dynamics.Contacts.b2ContactConstraint;
   import Box2D.Dynamics.Contacts.b2Contact;
   
   use namespace b2internal;
   
   public class b2Island
   {
      
      private static var s_impulse:Box2D.Dynamics.b2ContactImpulse = new Box2D.Dynamics.b2ContactImpulse();
       
      private var m_allocator;
      
      private var m_listener:Box2D.Dynamics.b2ContactListener;
      
      private var m_contactSolver:b2ContactSolver;
      
      b2internal var m_bodies:Vector.<Box2D.Dynamics.b2Body>;
      
      b2internal var m_contacts:Vector.<b2Contact>;
      
      b2internal var m_joints:Vector.<b2Joint>;
      
      b2internal var m_bodyCount:int;
      
      b2internal var m_jointCount:int;
      
      b2internal var m_contactCount:int;
      
      private var m_bodyCapacity:int;
      
      b2internal var m_contactCapacity:int;
      
      b2internal var m_jointCapacity:int;
      
      public function b2Island()
      {
         super();
         m_bodies = new Vector.<Box2D.Dynamics.b2Body>();
         m_contacts = new Vector.<b2Contact>();
         m_joints = new Vector.<b2Joint>();
      }
      
      public function Initialize(param1:int, param2:int, param3:int, param4:*, param5:Box2D.Dynamics.b2ContactListener, param6:b2ContactSolver) : void
      {
         var _loc7_:* = 0;
         m_bodyCapacity = param1;
         m_contactCapacity = param2;
         m_jointCapacity = param3;
         m_bodyCount = 0;
         m_contactCount = 0;
         m_jointCount = 0;
         m_allocator = param4;
         m_listener = param5;
         m_contactSolver = param6;
         _loc7_ = m_bodies.length;
         while(_loc7_ < param1)
         {
            m_bodies[_loc7_] = null;
            _loc7_++;
         }
         _loc7_ = m_contacts.length;
         while(_loc7_ < param2)
         {
            m_contacts[_loc7_] = null;
            _loc7_++;
         }
         _loc7_ = m_joints.length;
         while(_loc7_ < param3)
         {
            m_joints[_loc7_] = null;
            _loc7_++;
         }
      }
      
      public function Clear() : void
      {
         m_bodyCount = 0;
         m_contactCount = 0;
         m_jointCount = 0;
      }
      
      public function Solve(param1:b2TimeStep, param2:b2Vec2, param3:Boolean) : void
      {
         var _loc7_:* = 0;
         var _loc8_:* = 0;
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc10_:* = NaN;
         var _loc15_:* = NaN;
         var _loc6_:* = NaN;
         var _loc11_:* = false;
         var _loc13_:* = false;
         var _loc16_:* = false;
         var _loc17_:* = NaN;
         var _loc14_:* = NaN;
         var _loc9_:* = NaN;
         _loc7_ = 0;
         while(_loc7_ < m_bodyCount)
         {
            _loc4_ = m_bodies[_loc7_];
            if(_loc4_.GetType() == Box2D.Dynamics.b2Body.b2_dynamicBody)
            {
               _loc4_.m_linearVelocity.x = _loc4_.m_linearVelocity.x + param1.dt * (param2.x + _loc4_.m_invMass * _loc4_.m_force.x);
               _loc4_.m_linearVelocity.y = _loc4_.m_linearVelocity.y + param1.dt * (param2.y + _loc4_.m_invMass * _loc4_.m_force.y);
               _loc4_.m_angularVelocity = _loc4_.m_angularVelocity + param1.dt * _loc4_.m_invI * _loc4_.m_torque;
               _loc4_.m_linearVelocity.Multiply(b2Math.Clamp(1 - param1.dt * _loc4_.m_linearDamping,0,1));
               _loc4_.m_angularVelocity = _loc4_.m_angularVelocity * b2Math.Clamp(1 - param1.dt * _loc4_.m_angularDamping,0,1);
            }
            _loc7_++;
         }
         m_contactSolver.Initialize(param1,m_contacts,m_contactCount,m_allocator);
         var _loc12_:b2ContactSolver = m_contactSolver;
         _loc12_.InitVelocityConstraints(param1);
         _loc7_ = 0;
         while(_loc7_ < m_jointCount)
         {
            _loc5_ = m_joints[_loc7_];
            _loc5_.InitVelocityConstraints(param1);
            _loc7_++;
         }
         _loc7_ = 0;
         while(_loc7_ < param1.velocityIterations)
         {
            _loc8_ = 0;
            while(_loc8_ < m_jointCount)
            {
               _loc5_ = m_joints[_loc8_];
               _loc5_.SolveVelocityConstraints(param1);
               _loc8_++;
            }
            _loc12_.SolveVelocityConstraints();
            _loc7_++;
         }
         _loc7_ = 0;
         while(_loc7_ < m_jointCount)
         {
            _loc5_ = m_joints[_loc7_];
            _loc5_.FinalizeVelocityConstraints();
            _loc7_++;
         }
         _loc12_.FinalizeVelocityConstraints();
         _loc7_ = 0;
         while(_loc7_ < m_bodyCount)
         {
            _loc4_ = m_bodies[_loc7_];
            if(_loc4_.GetType() != Box2D.Dynamics.b2Body.b2_staticBody)
            {
               _loc10_ = param1.dt * _loc4_.m_linearVelocity.x;
               _loc15_ = param1.dt * _loc4_.m_linearVelocity.y;
               if(_loc10_ * _loc10_ + _loc15_ * _loc15_ > 4)
               {
                  _loc4_.m_linearVelocity.Normalize();
                  _loc4_.m_linearVelocity.x = _loc4_.m_linearVelocity.x * 2 * param1.inv_dt;
                  _loc4_.m_linearVelocity.y = _loc4_.m_linearVelocity.y * 2 * param1.inv_dt;
               }
               _loc6_ = param1.dt * _loc4_.m_angularVelocity;
               if(_loc6_ * _loc6_ > 2.4674011002723395)
               {
                  if(_loc4_.m_angularVelocity < 0)
                  {
                     _loc4_.m_angularVelocity = -1.5707963267948966 * param1.inv_dt;
                  }
                  else
                  {
                     _loc4_.m_angularVelocity = 1.5707963267948966 * param1.inv_dt;
                  }
               }
               _loc4_.m_sweep.c0.SetV(_loc4_.m_sweep.c);
               _loc4_.m_sweep.a0 = _loc4_.m_sweep.a;
               _loc4_.m_sweep.c.x = _loc4_.m_sweep.c.x + param1.dt * _loc4_.m_linearVelocity.x;
               _loc4_.m_sweep.c.y = _loc4_.m_sweep.c.y + param1.dt * _loc4_.m_linearVelocity.y;
               _loc4_.m_sweep.a = _loc4_.m_sweep.a + param1.dt * _loc4_.m_angularVelocity;
               _loc4_.SynchronizeTransform();
            }
            _loc7_++;
         }
         _loc7_ = 0;
         while(_loc7_ < param1.positionIterations)
         {
            _loc11_ = _loc12_.SolvePositionConstraints(0.2);
            _loc13_ = true;
            _loc8_ = 0;
            while(_loc8_ < m_jointCount)
            {
               _loc5_ = m_joints[_loc8_];
               _loc16_ = _loc5_.SolvePositionConstraints(0.2);
               _loc13_ = _loc13_ && _loc16_;
               _loc8_++;
            }
            if(!(_loc11_ && _loc13_))
            {
               _loc7_++;
               continue;
            }
            break;
         }
         Report(_loc12_.m_constraints);
         if(param3)
         {
            _loc17_ = 1.7976931348623157E308;
            _loc14_ = 1.0E-4;
            _loc9_ = 0.0012184696791468343;
            _loc7_ = 0;
            while(_loc7_ < m_bodyCount)
            {
               _loc4_ = m_bodies[_loc7_];
               if(_loc4_.GetType() != Box2D.Dynamics.b2Body.b2_staticBody)
               {
                  if((_loc4_.m_flags & Box2D.Dynamics.b2Body.e_allowSleepFlag) == 0)
                  {
                     _loc4_.m_sleepTime = 0;
                     _loc17_ = 0.0;
                  }
                  if((_loc4_.m_flags & Box2D.Dynamics.b2Body.e_allowSleepFlag) == 0 || _loc4_.m_angularVelocity * _loc4_.m_angularVelocity > _loc9_ || b2Math.Dot(_loc4_.m_linearVelocity,_loc4_.m_linearVelocity) > _loc14_)
                  {
                     _loc4_.m_sleepTime = 0;
                     _loc17_ = 0.0;
                  }
                  else
                  {
                     _loc4_.m_sleepTime = _loc4_.m_sleepTime + param1.dt;
                     _loc17_ = b2Math.Min(_loc17_,_loc4_.m_sleepTime);
                  }
               }
               _loc7_++;
            }
            if(_loc17_ >= 0.5)
            {
               _loc7_ = 0;
               while(_loc7_ < m_bodyCount)
               {
                  _loc4_ = m_bodies[_loc7_];
                  _loc4_.SetAwake(false);
                  _loc7_++;
               }
            }
         }
      }
      
      public function SolveTOI(param1:b2TimeStep) : void
      {
         var _loc8_:* = 0;
         var _loc9_:* = 0;
         var _loc2_:* = null;
         var _loc3_:* = NaN;
         var _loc11_:* = NaN;
         var _loc6_:* = NaN;
         var _loc4_:* = false;
         var _loc7_:* = false;
         var _loc12_:* = false;
         m_contactSolver.Initialize(param1,m_contacts,m_contactCount,m_allocator);
         var _loc5_:b2ContactSolver = m_contactSolver;
         _loc8_ = 0;
         while(_loc8_ < m_jointCount)
         {
            m_joints[_loc8_].InitVelocityConstraints(param1);
            _loc8_++;
         }
         _loc8_ = 0;
         while(_loc8_ < param1.velocityIterations)
         {
            _loc5_.SolveVelocityConstraints();
            _loc9_ = 0;
            while(_loc9_ < m_jointCount)
            {
               m_joints[_loc9_].SolveVelocityConstraints(param1);
               _loc9_++;
            }
            _loc8_++;
         }
         _loc8_ = 0;
         while(_loc8_ < m_bodyCount)
         {
            _loc2_ = m_bodies[_loc8_];
            if(_loc2_.GetType() != Box2D.Dynamics.b2Body.b2_staticBody)
            {
               _loc3_ = param1.dt * _loc2_.m_linearVelocity.x;
               _loc11_ = param1.dt * _loc2_.m_linearVelocity.y;
               if(_loc3_ * _loc3_ + _loc11_ * _loc11_ > 4)
               {
                  _loc2_.m_linearVelocity.Normalize();
                  _loc2_.m_linearVelocity.x = _loc2_.m_linearVelocity.x * 2 * param1.inv_dt;
                  _loc2_.m_linearVelocity.y = _loc2_.m_linearVelocity.y * 2 * param1.inv_dt;
               }
               _loc6_ = param1.dt * _loc2_.m_angularVelocity;
               if(_loc6_ * _loc6_ > 2.4674011002723395)
               {
                  if(_loc2_.m_angularVelocity < 0)
                  {
                     _loc2_.m_angularVelocity = -1.5707963267948966 * param1.inv_dt;
                  }
                  else
                  {
                     _loc2_.m_angularVelocity = 1.5707963267948966 * param1.inv_dt;
                  }
               }
               _loc2_.m_sweep.c0.SetV(_loc2_.m_sweep.c);
               _loc2_.m_sweep.a0 = _loc2_.m_sweep.a;
               _loc2_.m_sweep.c.x = _loc2_.m_sweep.c.x + param1.dt * _loc2_.m_linearVelocity.x;
               _loc2_.m_sweep.c.y = _loc2_.m_sweep.c.y + param1.dt * _loc2_.m_linearVelocity.y;
               _loc2_.m_sweep.a = _loc2_.m_sweep.a + param1.dt * _loc2_.m_angularVelocity;
               _loc2_.SynchronizeTransform();
            }
            _loc8_++;
         }
         var _loc10_:* = 0.75;
         _loc8_ = 0;
         while(_loc8_ < param1.positionIterations)
         {
            _loc4_ = _loc5_.SolvePositionConstraints(_loc10_);
            _loc7_ = true;
            _loc9_ = 0;
            while(_loc9_ < m_jointCount)
            {
               _loc12_ = m_joints[_loc9_].SolvePositionConstraints(0.2);
               _loc7_ = _loc7_ && _loc12_;
               _loc9_++;
            }
            if(!(_loc4_ && _loc7_))
            {
               _loc8_++;
               continue;
            }
            break;
         }
         Report(_loc5_.m_constraints);
      }
      
      public function Report(param1:Vector.<b2ContactConstraint>) : void
      {
         var _loc4_:* = 0;
         var _loc3_:* = null;
         var _loc2_:* = null;
         var _loc5_:* = 0;
         if(m_listener == null)
         {
            return;
         }
         _loc4_ = 0;
         while(_loc4_ < m_contactCount)
         {
            _loc3_ = m_contacts[_loc4_];
            _loc2_ = param1[_loc4_];
            _loc5_ = 0;
            while(_loc5_ < _loc2_.pointCount)
            {
               s_impulse.normalImpulses[_loc5_] = _loc2_.points[_loc5_].normalImpulse;
               s_impulse.tangentImpulses[_loc5_] = _loc2_.points[_loc5_].tangentImpulse;
               _loc5_++;
            }
            m_listener.PostSolve(_loc3_,s_impulse);
            _loc4_++;
         }
      }
      
      public function AddBody(param1:Box2D.Dynamics.b2Body) : void
      {
         param1.m_islandIndex = m_bodyCount;
         m_bodyCount = §§dup(m_bodyCount) + 1;
         m_bodies[m_bodyCount] = param1;
      }
      
      public function AddContact(param1:b2Contact) : void
      {
         m_contactCount = §§dup(m_contactCount) + 1;
         m_contacts[m_contactCount] = param1;
      }
      
      public function AddJoint(param1:b2Joint) : void
      {
         m_jointCount = §§dup(m_jointCount) + 1;
         m_joints[m_jointCount] = param1;
      }
   }
}
