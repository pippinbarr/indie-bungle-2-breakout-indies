package Box2D.Dynamics
{
   import Box2D.Common.b2internal;
   import Box2D.Collision.Shapes.b2Shape;
   import Box2D.Dynamics.Contacts.b2ContactEdge;
   import Box2D.Dynamics.Contacts.b2Contact;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Collision.b2RayCastOutput;
   import Box2D.Collision.b2RayCastInput;
   import Box2D.Collision.Shapes.b2MassData;
   import Box2D.Collision.b2AABB;
   import Box2D.Common.Math.b2Transform;
   import Box2D.Collision.IBroadPhase;
   import Box2D.Common.Math.b2Math;
   
   use namespace b2internal;
   
   public class b2Fixture
   {
       
      private var m_massData:b2MassData;
      
      b2internal var m_aabb:b2AABB;
      
      b2internal var m_density:Number;
      
      b2internal var m_next:Box2D.Dynamics.b2Fixture;
      
      b2internal var m_body:Box2D.Dynamics.b2Body;
      
      b2internal var m_shape:b2Shape;
      
      b2internal var m_friction:Number;
      
      b2internal var m_restitution:Number;
      
      b2internal var m_proxy;
      
      b2internal var m_filter:Box2D.Dynamics.b2FilterData;
      
      b2internal var m_isSensor:Boolean;
      
      b2internal var m_userData;
      
      public function b2Fixture()
      {
         m_filter = new Box2D.Dynamics.b2FilterData();
         super();
         m_aabb = new b2AABB();
         m_userData = null;
         m_body = null;
         m_next = null;
         m_shape = null;
         m_density = 0;
         m_friction = 0;
         m_restitution = 0;
      }
      
      public function GetType() : int
      {
         return m_shape.GetType();
      }
      
      public function GetShape() : b2Shape
      {
         return m_shape;
      }
      
      public function SetSensor(param1:Boolean) : void
      {
         var _loc3_:* = null;
         var _loc5_:* = null;
         var _loc4_:* = null;
         if(m_isSensor == param1)
         {
            return;
         }
         m_isSensor = param1;
         if(m_body == null)
         {
            return;
         }
         var _loc2_:b2ContactEdge = m_body.GetContactList();
         while(_loc2_)
         {
            _loc3_ = _loc2_.contact;
            _loc5_ = _loc3_.GetFixtureA();
            _loc4_ = _loc3_.GetFixtureB();
            if(_loc5_ == this || _loc4_ == this)
            {
               _loc3_.SetSensor(_loc5_.IsSensor() || _loc4_.IsSensor());
            }
            _loc2_ = _loc2_.next;
         }
      }
      
      public function IsSensor() : Boolean
      {
         return m_isSensor;
      }
      
      public function SetFilterData(param1:Box2D.Dynamics.b2FilterData) : void
      {
         var _loc3_:* = null;
         var _loc5_:* = null;
         var _loc4_:* = null;
         m_filter = param1.Copy();
         if(m_body)
         {
            return;
         }
         var _loc2_:b2ContactEdge = m_body.GetContactList();
         while(_loc2_)
         {
            _loc3_ = _loc2_.contact;
            _loc5_ = _loc3_.GetFixtureA();
            _loc4_ = _loc3_.GetFixtureB();
            if(_loc5_ == this || _loc4_ == this)
            {
               _loc3_.FlagForFiltering();
            }
            _loc2_ = _loc2_.next;
         }
      }
      
      public function GetFilterData() : Box2D.Dynamics.b2FilterData
      {
         return m_filter.Copy();
      }
      
      public function GetBody() : Box2D.Dynamics.b2Body
      {
         return m_body;
      }
      
      public function GetNext() : Box2D.Dynamics.b2Fixture
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
      
      public function TestPoint(param1:b2Vec2) : Boolean
      {
         return m_shape.TestPoint(m_body.GetTransform(),param1);
      }
      
      public function RayCast(param1:b2RayCastOutput, param2:b2RayCastInput) : Boolean
      {
         return m_shape.RayCast(param1,param2,m_body.GetTransform());
      }
      
      public function GetMassData(param1:b2MassData = null) : b2MassData
      {
         if(param1 == null)
         {
            var param1:b2MassData = new b2MassData();
         }
         m_shape.ComputeMass(param1,m_density);
         return param1;
      }
      
      public function SetDensity(param1:Number) : void
      {
         m_density = param1;
      }
      
      public function GetDensity() : Number
      {
         return m_density;
      }
      
      public function GetFriction() : Number
      {
         return m_friction;
      }
      
      public function SetFriction(param1:Number) : void
      {
         m_friction = param1;
      }
      
      public function GetRestitution() : Number
      {
         return m_restitution;
      }
      
      public function SetRestitution(param1:Number) : void
      {
         m_restitution = param1;
      }
      
      public function GetAABB() : b2AABB
      {
         return m_aabb;
      }
      
      b2internal function Create(param1:Box2D.Dynamics.b2Body, param2:b2Transform, param3:b2FixtureDef) : void
      {
         m_userData = param3.userData;
         m_friction = param3.friction;
         m_restitution = param3.restitution;
         m_body = param1;
         m_next = null;
         m_filter = param3.filter.Copy();
         m_isSensor = param3.isSensor;
         m_shape = param3.shape.Copy();
         m_density = param3.density;
      }
      
      b2internal function Destroy() : void
      {
         m_shape = null;
      }
      
      b2internal function CreateProxy(param1:IBroadPhase, param2:b2Transform) : void
      {
         m_shape.ComputeAABB(m_aabb,param2);
         m_proxy = param1.CreateProxy(m_aabb,this);
      }
      
      b2internal function DestroyProxy(param1:IBroadPhase) : void
      {
         if(m_proxy == null)
         {
            return;
         }
         param1.DestroyProxy(m_proxy);
         m_proxy = null;
      }
      
      b2internal function Synchronize(param1:IBroadPhase, param2:b2Transform, param3:b2Transform) : void
      {
         if(!m_proxy)
         {
            return;
         }
         var _loc4_:b2AABB = new b2AABB();
         var _loc5_:b2AABB = new b2AABB();
         m_shape.ComputeAABB(_loc4_,param2);
         m_shape.ComputeAABB(_loc5_,param3);
         m_aabb.Combine(_loc4_,_loc5_);
         var _loc6_:b2Vec2 = b2Math.SubtractVV(param3.position,param2.position);
         param1.MoveProxy(m_proxy,m_aabb,_loc6_);
      }
   }
}
