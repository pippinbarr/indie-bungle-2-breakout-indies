package Box2D.Dynamics
{
   import Box2D.Common.Math.b2Transform;
   import Box2D.Common.b2internal;
   import Box2D.Collision.Shapes.b2EdgeShape;
   import Box2D.Common.Math.b2Math;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Collision.IBroadPhase;
   import Box2D.Collision.Shapes.b2Shape;
   import Box2D.Dynamics.Contacts.b2ContactEdge;
   import Box2D.Dynamics.Contacts.b2Contact;
   import Box2D.Common.Math.b2Mat22;
   import Box2D.Collision.Shapes.b2MassData;
   import Box2D.Common.b2Settings;
   import Box2D.Dynamics.Joints.b2JointEdge;
   import Box2D.Dynamics.Controllers.b2ControllerEdge;
   import Box2D.Common.Math.b2Sweep;
   
   use namespace b2internal;
   
   public class b2Body
   {
      
      private static var s_xf1:b2Transform = new b2Transform();
      
      b2internal static var e_islandFlag:uint = 1;
      
      b2internal static var e_awakeFlag:uint = 2;
      
      b2internal static var e_allowSleepFlag:uint = 4;
      
      b2internal static var e_bulletFlag:uint = 8;
      
      b2internal static var e_fixedRotationFlag:uint = 16;
      
      b2internal static var e_activeFlag:uint = 32;
      
      public static var b2_staticBody:uint = 0;
      
      public static var b2_kinematicBody:uint = 1;
      
      public static var b2_dynamicBody:uint = 2;
       
      b2internal var m_flags:uint;
      
      b2internal var m_type:int;
      
      b2internal var m_islandIndex:int;
      
      b2internal var m_xf:b2Transform;
      
      b2internal var m_sweep:b2Sweep;
      
      b2internal var m_linearVelocity:b2Vec2;
      
      b2internal var m_angularVelocity:Number;
      
      b2internal var m_force:b2Vec2;
      
      b2internal var m_torque:Number;
      
      b2internal var m_world:Box2D.Dynamics.b2World;
      
      b2internal var m_prev:Box2D.Dynamics.b2Body;
      
      b2internal var m_next:Box2D.Dynamics.b2Body;
      
      b2internal var m_fixtureList:Box2D.Dynamics.b2Fixture;
      
      b2internal var m_fixtureCount:int;
      
      b2internal var m_controllerList:b2ControllerEdge;
      
      b2internal var m_controllerCount:int;
      
      b2internal var m_jointList:b2JointEdge;
      
      b2internal var m_contactList:b2ContactEdge;
      
      b2internal var m_mass:Number;
      
      b2internal var m_invMass:Number;
      
      b2internal var m_I:Number;
      
      b2internal var m_invI:Number;
      
      b2internal var m_inertiaScale:Number;
      
      b2internal var m_linearDamping:Number;
      
      b2internal var m_angularDamping:Number;
      
      b2internal var m_sleepTime:Number;
      
      private var m_userData;
      
      public function b2Body(param1:b2BodyDef, param2:Box2D.Dynamics.b2World)
      {
         m_xf = new b2Transform();
         m_sweep = new b2Sweep();
         m_linearVelocity = new b2Vec2();
         m_force = new b2Vec2();
         super();
         m_flags = 0;
         if(param1.bullet)
         {
            m_flags = §§dup().m_flags | e_bulletFlag;
         }
         if(param1.fixedRotation)
         {
            m_flags = §§dup().m_flags | e_fixedRotationFlag;
         }
         if(param1.allowSleep)
         {
            m_flags = §§dup().m_flags | e_allowSleepFlag;
         }
         if(param1.awake)
         {
            m_flags = §§dup().m_flags | e_awakeFlag;
         }
         if(param1.active)
         {
            m_flags = §§dup().m_flags | e_activeFlag;
         }
         m_world = param2;
         m_xf.position.SetV(param1.position);
         m_xf.R.Set(param1.angle);
         m_sweep.localCenter.SetZero();
         m_sweep.t0 = 1;
         var _loc5_:* = param1.angle;
         m_sweep.a = _loc5_;
         m_sweep.a0 = _loc5_;
         var _loc4_:b2Mat22 = m_xf.R;
         var _loc3_:b2Vec2 = m_sweep.localCenter;
         m_sweep.c.x = _loc4_.col1.x * _loc3_.x + _loc4_.col2.x * _loc3_.y;
         m_sweep.c.y = _loc4_.col1.y * _loc3_.x + _loc4_.col2.y * _loc3_.y;
         m_sweep.c.x = m_sweep.c.x + m_xf.position.x;
         m_sweep.c.y = m_sweep.c.y + m_xf.position.y;
         m_sweep.c0.SetV(m_sweep.c);
         m_jointList = null;
         m_controllerList = null;
         m_contactList = null;
         m_controllerCount = 0;
         m_prev = null;
         m_next = null;
         m_linearVelocity.SetV(param1.linearVelocity);
         m_angularVelocity = param1.angularVelocity;
         m_linearDamping = param1.linearDamping;
         m_angularDamping = param1.angularDamping;
         m_force.Set(0,0);
         m_torque = 0;
         m_sleepTime = 0;
         m_type = param1.type;
         if(m_type == b2_dynamicBody)
         {
            m_mass = 1;
            m_invMass = 1;
         }
         else
         {
            m_mass = 0;
            m_invMass = 0;
         }
         m_I = 0;
         m_invI = 0;
         m_inertiaScale = param1.inertiaScale;
         m_userData = param1.userData;
         m_fixtureList = null;
         m_fixtureCount = 0;
      }
      
      private function connectEdges(param1:b2EdgeShape, param2:b2EdgeShape, param3:Number) : Number
      {
         var _loc8_:Number = Math.atan2(param2.GetDirectionVector().y,param2.GetDirectionVector().x);
         var _loc6_:Number = Math.tan((_loc8_ - param3) * 0.5);
         var _loc5_:b2Vec2 = b2Math.MulFV(_loc6_,param2.GetDirectionVector());
         _loc5_ = b2Math.SubtractVV(_loc5_,param2.GetNormalVector());
         _loc5_ = b2Math.MulFV(0.04,_loc5_);
         _loc5_ = b2Math.AddVV(_loc5_,param2.GetVertex1());
         var _loc4_:b2Vec2 = b2Math.AddVV(param1.GetDirectionVector(),param2.GetDirectionVector());
         _loc4_.Normalize();
         var _loc7_:* = b2Math.Dot(param1.GetDirectionVector(),param2.GetNormalVector()) > 0;
         param1.SetNextEdge(param2,_loc5_,_loc4_,_loc7_);
         param2.SetPrevEdge(param1,_loc5_,_loc4_,_loc7_);
         return _loc8_;
      }
      
      public function CreateFixture(param1:b2FixtureDef) : Box2D.Dynamics.b2Fixture
      {
         var _loc3_:* = null;
         if(m_world.IsLocked() == true)
         {
            return null;
         }
         var _loc2_:Box2D.Dynamics.b2Fixture = new Box2D.Dynamics.b2Fixture();
         _loc2_.Create(this,m_xf,param1);
         if(m_flags & e_activeFlag)
         {
            _loc3_ = m_world.m_contactManager.m_broadPhase;
            _loc2_.CreateProxy(_loc3_,m_xf);
         }
         _loc2_.m_next = m_fixtureList;
         m_fixtureList = _loc2_;
         m_fixtureCount = m_fixtureCount + 1;
         _loc2_.m_body = this;
         if(_loc2_.m_density > 0)
         {
            ResetMassData();
         }
         m_world.m_flags = m_world.m_flags | 1;
         return _loc2_;
      }
      
      public function CreateFixture2(param1:b2Shape, param2:Number = 0.0) : Box2D.Dynamics.b2Fixture
      {
         var _loc3_:b2FixtureDef = new b2FixtureDef();
         _loc3_.shape = param1;
         _loc3_.density = param2;
         return CreateFixture(_loc3_);
      }
      
      public function DestroyFixture(param1:Box2D.Dynamics.b2Fixture) : void
      {
         var _loc5_:* = null;
         var _loc9_:* = null;
         var _loc8_:* = null;
         var _loc7_:* = null;
         if(m_world.IsLocked() == true)
         {
            return;
         }
         var _loc2_:Box2D.Dynamics.b2Fixture = m_fixtureList;
         var _loc6_:Box2D.Dynamics.b2Fixture = null;
         var _loc4_:* = false;
         while(_loc2_ != null)
         {
            if(_loc2_ == param1)
            {
               if(_loc6_)
               {
                  _loc6_.m_next = param1.m_next;
               }
               else
               {
                  m_fixtureList = param1.m_next;
               }
               _loc4_ = true;
               break;
            }
            _loc6_ = _loc2_;
            _loc2_ = _loc2_.m_next;
         }
         var _loc3_:b2ContactEdge = m_contactList;
         while(_loc3_)
         {
            _loc5_ = _loc3_.contact;
            _loc3_ = _loc3_.next;
            _loc9_ = _loc5_.GetFixtureA();
            _loc8_ = _loc5_.GetFixtureB();
            if(param1 == _loc9_ || param1 == _loc8_)
            {
               m_world.m_contactManager.Destroy(_loc5_);
            }
         }
         if(m_flags & e_activeFlag)
         {
            _loc7_ = m_world.m_contactManager.m_broadPhase;
            param1.DestroyProxy(_loc7_);
         }
         param1.Destroy();
         param1.m_body = null;
         param1.m_next = null;
         m_fixtureCount = m_fixtureCount - 1;
         ResetMassData();
      }
      
      public function SetPositionAndAngle(param1:b2Vec2, param2:Number) : void
      {
         var _loc3_:* = null;
         if(m_world.IsLocked() == true)
         {
            return;
         }
         m_xf.R.Set(param2);
         m_xf.position.SetV(param1);
         var _loc5_:b2Mat22 = m_xf.R;
         var _loc4_:b2Vec2 = m_sweep.localCenter;
         m_sweep.c.x = _loc5_.col1.x * _loc4_.x + _loc5_.col2.x * _loc4_.y;
         m_sweep.c.y = _loc5_.col1.y * _loc4_.x + _loc5_.col2.y * _loc4_.y;
         m_sweep.c.x = m_sweep.c.x + m_xf.position.x;
         m_sweep.c.y = m_sweep.c.y + m_xf.position.y;
         m_sweep.c0.SetV(m_sweep.c);
         var _loc7_:* = param2;
         m_sweep.a = _loc7_;
         m_sweep.a0 = _loc7_;
         var _loc6_:IBroadPhase = m_world.m_contactManager.m_broadPhase;
         _loc3_ = m_fixtureList;
         while(_loc3_)
         {
            _loc3_.Synchronize(_loc6_,m_xf,m_xf);
            _loc3_ = _loc3_.m_next;
         }
         m_world.m_contactManager.FindNewContacts();
      }
      
      public function SetTransform(param1:b2Transform) : void
      {
         SetPositionAndAngle(param1.position,param1.GetAngle());
      }
      
      public function GetTransform() : b2Transform
      {
         return m_xf;
      }
      
      public function GetPosition() : b2Vec2
      {
         return m_xf.position;
      }
      
      public function SetPosition(param1:b2Vec2) : void
      {
         SetPositionAndAngle(param1,GetAngle());
      }
      
      public function GetAngle() : Number
      {
         return m_sweep.a;
      }
      
      public function SetAngle(param1:Number) : void
      {
         SetPositionAndAngle(GetPosition(),param1);
      }
      
      public function GetWorldCenter() : b2Vec2
      {
         return m_sweep.c;
      }
      
      public function GetLocalCenter() : b2Vec2
      {
         return m_sweep.localCenter;
      }
      
      public function SetLinearVelocity(param1:b2Vec2) : void
      {
         if(m_type == b2_staticBody)
         {
            return;
         }
         m_linearVelocity.SetV(param1);
      }
      
      public function GetLinearVelocity() : b2Vec2
      {
         return m_linearVelocity;
      }
      
      public function SetAngularVelocity(param1:Number) : void
      {
         if(m_type == b2_staticBody)
         {
            return;
         }
         m_angularVelocity = param1;
      }
      
      public function GetAngularVelocity() : Number
      {
         return m_angularVelocity;
      }
      
      public function GetDefinition() : b2BodyDef
      {
         var _loc1_:b2BodyDef = new b2BodyDef();
         _loc1_.type = GetType();
         _loc1_.allowSleep = (m_flags & e_allowSleepFlag) == e_allowSleepFlag;
         _loc1_.angle = GetAngle();
         _loc1_.angularDamping = m_angularDamping;
         _loc1_.angularVelocity = m_angularVelocity;
         _loc1_.fixedRotation = (m_flags & e_fixedRotationFlag) == e_fixedRotationFlag;
         _loc1_.bullet = (m_flags & e_bulletFlag) == e_bulletFlag;
         _loc1_.awake = (m_flags & e_awakeFlag) == e_awakeFlag;
         _loc1_.linearDamping = m_linearDamping;
         _loc1_.linearVelocity.SetV(GetLinearVelocity());
         _loc1_.position = GetPosition();
         _loc1_.userData = GetUserData();
         return _loc1_;
      }
      
      public function ApplyForce(param1:b2Vec2, param2:b2Vec2) : void
      {
         if(m_type != b2_dynamicBody)
         {
            return;
         }
         if(IsAwake() == false)
         {
            SetAwake(true);
         }
         m_force.x = m_force.x + param1.x;
         m_force.y = m_force.y + param1.y;
         m_torque = §§dup().m_torque + ((param2.x - m_sweep.c.x) * param1.y - (param2.y - m_sweep.c.y) * param1.x);
      }
      
      public function ApplyTorque(param1:Number) : void
      {
         if(m_type != b2_dynamicBody)
         {
            return;
         }
         if(IsAwake() == false)
         {
            SetAwake(true);
         }
         m_torque = §§dup().m_torque + param1;
      }
      
      public function ApplyImpulse(param1:b2Vec2, param2:b2Vec2) : void
      {
         if(m_type != b2_dynamicBody)
         {
            return;
         }
         if(IsAwake() == false)
         {
            SetAwake(true);
         }
         m_linearVelocity.x = m_linearVelocity.x + m_invMass * param1.x;
         m_linearVelocity.y = m_linearVelocity.y + m_invMass * param1.y;
         m_angularVelocity = §§dup().m_angularVelocity + m_invI * ((param2.x - m_sweep.c.x) * param1.y - (param2.y - m_sweep.c.y) * param1.x);
      }
      
      public function Split(param1:Function) : Box2D.Dynamics.b2Body
      {
         var _loc7_:* = null;
         var _loc5_:* = null;
         var _loc2_:* = null;
         var _loc13_:b2Vec2 = GetLinearVelocity().Copy();
         var _loc9_:Number = GetAngularVelocity();
         var _loc6_:b2Vec2 = GetWorldCenter();
         var _loc10_:* = this;
         var _loc8_:Box2D.Dynamics.b2Body = m_world.CreateBody(GetDefinition());
         _loc5_ = _loc10_.m_fixtureList;
         while(_loc5_)
         {
            if(param1(_loc5_))
            {
               _loc2_ = _loc5_.m_next;
               if(_loc7_)
               {
                  _loc7_.m_next = _loc2_;
               }
               else
               {
                  _loc10_.m_fixtureList = _loc2_;
               }
               _loc10_.m_fixtureCount = §§dup(_loc10_).m_fixtureCount - 1;
               _loc5_.m_next = _loc8_.m_fixtureList;
               _loc8_.m_fixtureList = _loc5_;
               _loc8_.m_fixtureCount = §§dup(_loc8_).m_fixtureCount + 1;
               _loc5_.m_body = _loc8_;
               _loc5_ = _loc2_;
            }
            else
            {
               _loc7_ = _loc5_;
               _loc5_ = _loc5_.m_next;
            }
         }
         _loc10_.ResetMassData();
         _loc8_.ResetMassData();
         var _loc11_:b2Vec2 = _loc10_.GetWorldCenter();
         var _loc12_:b2Vec2 = _loc8_.GetWorldCenter();
         var _loc4_:b2Vec2 = b2Math.AddVV(_loc13_,b2Math.CrossFV(_loc9_,b2Math.SubtractVV(_loc11_,_loc6_)));
         var _loc3_:b2Vec2 = b2Math.AddVV(_loc13_,b2Math.CrossFV(_loc9_,b2Math.SubtractVV(_loc12_,_loc6_)));
         _loc10_.SetLinearVelocity(_loc4_);
         _loc8_.SetLinearVelocity(_loc3_);
         _loc10_.SetAngularVelocity(_loc9_);
         _loc8_.SetAngularVelocity(_loc9_);
         _loc10_.SynchronizeFixtures();
         _loc8_.SynchronizeFixtures();
         return _loc8_;
      }
      
      public function Merge(param1:Box2D.Dynamics.b2Body) : void
      {
         var _loc6_:* = null;
         var _loc2_:* = null;
         var _loc7_:* = null;
         var _loc8_:* = null;
         _loc6_ = param1.m_fixtureList;
         while(_loc6_)
         {
            _loc2_ = _loc6_.m_next;
            §§dup(param1).m_fixtureCount--;
            _loc6_.m_next = m_fixtureList;
            m_fixtureList = _loc6_;
            m_fixtureCount = m_fixtureCount + 1;
            _loc6_.m_body = _loc8_;
            _loc6_ = _loc2_;
         }
         _loc7_.m_fixtureCount = 0;
         _loc7_ = this;
         _loc8_ = param1;
         var _loc9_:b2Vec2 = _loc7_.GetWorldCenter();
         var _loc11_:b2Vec2 = _loc8_.GetWorldCenter();
         var _loc5_:b2Vec2 = _loc7_.GetLinearVelocity().Copy();
         var _loc4_:b2Vec2 = _loc8_.GetLinearVelocity().Copy();
         var _loc10_:Number = _loc7_.GetAngularVelocity();
         var _loc3_:Number = _loc8_.GetAngularVelocity();
         _loc7_.ResetMassData();
         SynchronizeFixtures();
      }
      
      public function GetMass() : Number
      {
         return m_mass;
      }
      
      public function GetInertia() : Number
      {
         return m_I;
      }
      
      public function GetMassData(param1:b2MassData) : void
      {
         param1.mass = m_mass;
         param1.I = m_I;
         param1.center.SetV(m_sweep.localCenter);
      }
      
      public function SetMassData(param1:b2MassData) : void
      {
         b2Settings.b2Assert(m_world.IsLocked() == false);
         if(m_world.IsLocked() == true)
         {
            return;
         }
         if(m_type != b2_dynamicBody)
         {
            return;
         }
         m_invMass = 0;
         m_I = 0;
         m_invI = 0;
         m_mass = param1.mass;
         if(m_mass <= 0)
         {
            m_mass = 1;
         }
         m_invMass = 1 / m_mass;
         if(param1.I > 0 && (m_flags & e_fixedRotationFlag) == 0)
         {
            m_I = param1.I - m_mass * (param1.center.x * param1.center.x + param1.center.y * param1.center.y);
            m_invI = 1 / m_I;
         }
         var _loc2_:b2Vec2 = m_sweep.c.Copy();
         m_sweep.localCenter.SetV(param1.center);
         m_sweep.c0.SetV(b2Math.MulX(m_xf,m_sweep.localCenter));
         m_sweep.c.SetV(m_sweep.c0);
         m_linearVelocity.x = m_linearVelocity.x + m_angularVelocity * -(m_sweep.c.y - _loc2_.y);
         m_linearVelocity.y = m_linearVelocity.y + m_angularVelocity * (m_sweep.c.x - _loc2_.x);
      }
      
      public function ResetMassData() : void
      {
         var _loc2_:* = null;
         var _loc1_:* = null;
         m_mass = 0;
         m_invMass = 0;
         m_I = 0;
         m_invI = 0;
         m_sweep.localCenter.SetZero();
         if(m_type == b2_staticBody || m_type == b2_kinematicBody)
         {
            return;
         }
         var _loc3_:b2Vec2 = b2Vec2.Make(0,0);
         _loc2_ = m_fixtureList;
         while(_loc2_)
         {
            if(_loc2_.m_density != 0)
            {
               _loc1_ = _loc2_.GetMassData();
               m_mass = §§dup().m_mass + _loc1_.mass;
               _loc3_.x = _loc3_.x + _loc1_.center.x * _loc1_.mass;
               _loc3_.y = _loc3_.y + _loc1_.center.y * _loc1_.mass;
               m_I = §§dup().m_I + _loc1_.I;
            }
            _loc2_ = _loc2_.m_next;
         }
         if(m_mass > 0)
         {
            m_invMass = 1 / m_mass;
            _loc3_.x = _loc3_.x * m_invMass;
            _loc3_.y = _loc3_.y * m_invMass;
         }
         else
         {
            m_mass = 1;
            m_invMass = 1;
         }
         if(m_I > 0 && (m_flags & e_fixedRotationFlag) == 0)
         {
            m_I = §§dup().m_I - m_mass * (_loc3_.x * _loc3_.x + _loc3_.y * _loc3_.y);
            m_I = §§dup().m_I * m_inertiaScale;
            b2Settings.b2Assert(m_I > 0);
            m_invI = 1 / m_I;
         }
         else
         {
            m_I = 0;
            m_invI = 0;
         }
         var _loc4_:b2Vec2 = m_sweep.c.Copy();
         m_sweep.localCenter.SetV(_loc3_);
         m_sweep.c0.SetV(b2Math.MulX(m_xf,m_sweep.localCenter));
         m_sweep.c.SetV(m_sweep.c0);
         m_linearVelocity.x = m_linearVelocity.x + m_angularVelocity * -(m_sweep.c.y - _loc4_.y);
         m_linearVelocity.y = m_linearVelocity.y + m_angularVelocity * (m_sweep.c.x - _loc4_.x);
      }
      
      public function GetWorldPoint(param1:b2Vec2) : b2Vec2
      {
         var _loc2_:b2Mat22 = m_xf.R;
         var _loc3_:b2Vec2 = new b2Vec2(_loc2_.col1.x * param1.x + _loc2_.col2.x * param1.y,_loc2_.col1.y * param1.x + _loc2_.col2.y * param1.y);
         _loc3_.x = _loc3_.x + m_xf.position.x;
         _loc3_.y = _loc3_.y + m_xf.position.y;
         return _loc3_;
      }
      
      public function GetWorldVector(param1:b2Vec2) : b2Vec2
      {
         return b2Math.MulMV(m_xf.R,param1);
      }
      
      public function GetLocalPoint(param1:b2Vec2) : b2Vec2
      {
         return b2Math.MulXT(m_xf,param1);
      }
      
      public function GetLocalVector(param1:b2Vec2) : b2Vec2
      {
         return b2Math.MulTMV(m_xf.R,param1);
      }
      
      public function GetLinearVelocityFromWorldPoint(param1:b2Vec2) : b2Vec2
      {
         return new b2Vec2(m_linearVelocity.x - m_angularVelocity * (param1.y - m_sweep.c.y),m_linearVelocity.y + m_angularVelocity * (param1.x - m_sweep.c.x));
      }
      
      public function GetLinearVelocityFromLocalPoint(param1:b2Vec2) : b2Vec2
      {
         var _loc2_:b2Mat22 = m_xf.R;
         var _loc3_:b2Vec2 = new b2Vec2(_loc2_.col1.x * param1.x + _loc2_.col2.x * param1.y,_loc2_.col1.y * param1.x + _loc2_.col2.y * param1.y);
         _loc3_.x = _loc3_.x + m_xf.position.x;
         _loc3_.y = _loc3_.y + m_xf.position.y;
         return new b2Vec2(m_linearVelocity.x - m_angularVelocity * (_loc3_.y - m_sweep.c.y),m_linearVelocity.y + m_angularVelocity * (_loc3_.x - m_sweep.c.x));
      }
      
      public function GetLinearDamping() : Number
      {
         return m_linearDamping;
      }
      
      public function SetLinearDamping(param1:Number) : void
      {
         m_linearDamping = param1;
      }
      
      public function GetAngularDamping() : Number
      {
         return m_angularDamping;
      }
      
      public function SetAngularDamping(param1:Number) : void
      {
         m_angularDamping = param1;
      }
      
      public function SetType(param1:uint) : void
      {
         var _loc2_:* = null;
         if(m_type == param1)
         {
            return;
         }
         m_type = param1;
         ResetMassData();
         if(m_type == b2_staticBody)
         {
            m_linearVelocity.SetZero();
            m_angularVelocity = 0;
         }
         SetAwake(true);
         m_force.SetZero();
         m_torque = 0;
         _loc2_ = m_contactList;
         while(_loc2_)
         {
            _loc2_.contact.FlagForFiltering();
            _loc2_ = _loc2_.next;
         }
      }
      
      public function GetType() : uint
      {
         return m_type;
      }
      
      public function SetBullet(param1:Boolean) : void
      {
         if(param1)
         {
            m_flags = §§dup().m_flags | e_bulletFlag;
         }
         else
         {
            m_flags = §§dup().m_flags & ~e_bulletFlag;
         }
      }
      
      public function IsBullet() : Boolean
      {
         return (m_flags & e_bulletFlag) == e_bulletFlag;
      }
      
      public function SetSleepingAllowed(param1:Boolean) : void
      {
         if(param1)
         {
            m_flags = §§dup().m_flags | e_allowSleepFlag;
         }
         else
         {
            m_flags = §§dup().m_flags & ~e_allowSleepFlag;
            SetAwake(true);
         }
      }
      
      public function SetAwake(param1:Boolean) : void
      {
         if(param1)
         {
            m_flags = §§dup().m_flags | e_awakeFlag;
            m_sleepTime = 0;
         }
         else
         {
            m_flags = §§dup().m_flags & ~e_awakeFlag;
            m_sleepTime = 0;
            m_linearVelocity.SetZero();
            m_angularVelocity = 0;
            m_force.SetZero();
            m_torque = 0;
         }
      }
      
      public function IsAwake() : Boolean
      {
         return (m_flags & e_awakeFlag) == e_awakeFlag;
      }
      
      public function SetFixedRotation(param1:Boolean) : void
      {
         if(param1)
         {
            m_flags = §§dup().m_flags | e_fixedRotationFlag;
         }
         else
         {
            m_flags = §§dup().m_flags & ~e_fixedRotationFlag;
         }
         ResetMassData();
      }
      
      public function IsFixedRotation() : Boolean
      {
         return (m_flags & e_fixedRotationFlag) == e_fixedRotationFlag;
      }
      
      public function SetActive(param1:Boolean) : void
      {
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc2_:* = null;
         var _loc5_:* = null;
         if(param1 == IsActive())
         {
            return;
         }
         if(param1)
         {
            m_flags = §§dup().m_flags | e_activeFlag;
            _loc4_ = m_world.m_contactManager.m_broadPhase;
            _loc3_ = m_fixtureList;
            while(_loc3_)
            {
               _loc3_.CreateProxy(_loc4_,m_xf);
               _loc3_ = _loc3_.m_next;
            }
         }
         else
         {
            m_flags = §§dup().m_flags & ~e_activeFlag;
            _loc4_ = m_world.m_contactManager.m_broadPhase;
            _loc3_ = m_fixtureList;
            while(_loc3_)
            {
               _loc3_.DestroyProxy(_loc4_);
               _loc3_ = _loc3_.m_next;
            }
            _loc2_ = m_contactList;
            while(_loc2_)
            {
               _loc5_ = _loc2_;
               _loc2_ = _loc2_.next;
               m_world.m_contactManager.Destroy(_loc5_.contact);
            }
            m_contactList = null;
         }
      }
      
      public function IsActive() : Boolean
      {
         return (m_flags & e_activeFlag) == e_activeFlag;
      }
      
      public function IsSleepingAllowed() : Boolean
      {
         return (m_flags & e_allowSleepFlag) == e_allowSleepFlag;
      }
      
      public function GetFixtureList() : Box2D.Dynamics.b2Fixture
      {
         return m_fixtureList;
      }
      
      public function GetJointList() : b2JointEdge
      {
         return m_jointList;
      }
      
      public function GetControllerList() : b2ControllerEdge
      {
         return m_controllerList;
      }
      
      public function GetContactList() : b2ContactEdge
      {
         return m_contactList;
      }
      
      public function GetNext() : Box2D.Dynamics.b2Body
      {
         return m_next;
      }
      
      public function GetUserData() : *
      {
         return m_userData;
      }
      
      public function SetUserData(param1:*) : void
      {
         m_userData = param1;
      }
      
      public function GetWorld() : Box2D.Dynamics.b2World
      {
         return m_world;
      }
      
      b2internal function SynchronizeFixtures() : void
      {
         var _loc3_:* = null;
         var _loc1_:b2Transform = s_xf1;
         _loc1_.R.Set(m_sweep.a0);
         var _loc4_:b2Mat22 = _loc1_.R;
         var _loc2_:b2Vec2 = m_sweep.localCenter;
         _loc1_.position.x = m_sweep.c0.x - (_loc4_.col1.x * _loc2_.x + _loc4_.col2.x * _loc2_.y);
         _loc1_.position.y = m_sweep.c0.y - (_loc4_.col1.y * _loc2_.x + _loc4_.col2.y * _loc2_.y);
         var _loc5_:IBroadPhase = m_world.m_contactManager.m_broadPhase;
         _loc3_ = m_fixtureList;
         while(_loc3_)
         {
            _loc3_.Synchronize(_loc5_,_loc1_,m_xf);
            _loc3_ = _loc3_.m_next;
         }
      }
      
      b2internal function SynchronizeTransform() : void
      {
         m_xf.R.Set(m_sweep.a);
         var _loc2_:b2Mat22 = m_xf.R;
         var _loc1_:b2Vec2 = m_sweep.localCenter;
         m_xf.position.x = m_sweep.c.x - (_loc2_.col1.x * _loc1_.x + _loc2_.col2.x * _loc1_.y);
         m_xf.position.y = m_sweep.c.y - (_loc2_.col1.y * _loc1_.x + _loc2_.col2.y * _loc1_.y);
      }
      
      b2internal function ShouldCollide(param1:Box2D.Dynamics.b2Body) : Boolean
      {
         var _loc2_:* = null;
         if(m_type != b2_dynamicBody && param1.m_type != b2_dynamicBody)
         {
            return false;
         }
         _loc2_ = m_jointList;
         while(_loc2_)
         {
            if(_loc2_.other == param1)
            {
               if(_loc2_.joint.m_collideConnected == false)
               {
                  return false;
               }
            }
            _loc2_ = _loc2_.next;
         }
         return true;
      }
      
      b2internal function Advance(param1:Number) : void
      {
         m_sweep.Advance(param1);
         m_sweep.c.SetV(m_sweep.c0);
         m_sweep.a = m_sweep.a0;
         SynchronizeTransform();
      }
   }
}
