package Box2D.Dynamics.Contacts
{
   import Box2D.Common.b2internal;
   import Box2D.Collision.b2TOIInput;
   import Box2D.Collision.b2Manifold;
   import Box2D.Collision.b2WorldManifold;
   import Box2D.Dynamics.b2Body;
   import Box2D.Collision.Shapes.b2Shape;
   import Box2D.Dynamics.b2Fixture;
   import Box2D.Dynamics.b2ContactListener;
   import Box2D.Common.Math.b2Transform;
   import Box2D.Collision.b2ManifoldPoint;
   import Box2D.Collision.b2ContactID;
   import Box2D.Common.Math.b2Sweep;
   import Box2D.Collision.b2TimeOfImpact;
   
   use namespace b2internal;
   
   public class b2Contact
   {
      
      b2internal static var e_sensorFlag:uint = 1;
      
      b2internal static var e_continuousFlag:uint = 2;
      
      b2internal static var e_islandFlag:uint = 4;
      
      b2internal static var e_toiFlag:uint = 8;
      
      b2internal static var e_touchingFlag:uint = 16;
      
      b2internal static var e_enabledFlag:uint = 32;
      
      b2internal static var e_filterFlag:uint = 64;
      
      private static var s_input:b2TOIInput = new b2TOIInput();
       
      b2internal var m_flags:uint;
      
      b2internal var m_prev:Box2D.Dynamics.Contacts.b2Contact;
      
      b2internal var m_next:Box2D.Dynamics.Contacts.b2Contact;
      
      b2internal var m_nodeA:Box2D.Dynamics.Contacts.b2ContactEdge;
      
      b2internal var m_nodeB:Box2D.Dynamics.Contacts.b2ContactEdge;
      
      b2internal var m_fixtureA:b2Fixture;
      
      b2internal var m_fixtureB:b2Fixture;
      
      b2internal var m_manifold:b2Manifold;
      
      b2internal var m_oldManifold:b2Manifold;
      
      b2internal var m_toi:Number;
      
      public function b2Contact()
      {
         m_nodeA = new Box2D.Dynamics.Contacts.b2ContactEdge();
         m_nodeB = new Box2D.Dynamics.Contacts.b2ContactEdge();
         m_manifold = new b2Manifold();
         m_oldManifold = new b2Manifold();
         super();
      }
      
      public function GetManifold() : b2Manifold
      {
         return m_manifold;
      }
      
      public function GetWorldManifold(param1:b2WorldManifold) : void
      {
         var _loc4_:b2Body = m_fixtureA.GetBody();
         var _loc5_:b2Body = m_fixtureB.GetBody();
         var _loc2_:b2Shape = m_fixtureA.GetShape();
         var _loc3_:b2Shape = m_fixtureB.GetShape();
         param1.Initialize(m_manifold,_loc4_.GetTransform(),_loc2_.m_radius,_loc5_.GetTransform(),_loc3_.m_radius);
      }
      
      public function IsTouching() : Boolean
      {
         return (m_flags & e_touchingFlag) == e_touchingFlag;
      }
      
      public function IsContinuous() : Boolean
      {
         return (m_flags & e_continuousFlag) == e_continuousFlag;
      }
      
      public function SetSensor(param1:Boolean) : void
      {
         if(param1)
         {
            m_flags = §§dup().m_flags | e_sensorFlag;
         }
         else
         {
            m_flags = §§dup().m_flags & ~e_sensorFlag;
         }
      }
      
      public function IsSensor() : Boolean
      {
         return (m_flags & e_sensorFlag) == e_sensorFlag;
      }
      
      public function SetEnabled(param1:Boolean) : void
      {
         if(param1)
         {
            m_flags = §§dup().m_flags | e_enabledFlag;
         }
         else
         {
            m_flags = §§dup().m_flags & ~e_enabledFlag;
         }
      }
      
      public function IsEnabled() : Boolean
      {
         return (m_flags & e_enabledFlag) == e_enabledFlag;
      }
      
      public function GetNext() : Box2D.Dynamics.Contacts.b2Contact
      {
         return m_next;
      }
      
      public function GetFixtureA() : b2Fixture
      {
         return m_fixtureA;
      }
      
      public function GetFixtureB() : b2Fixture
      {
         return m_fixtureB;
      }
      
      public function FlagForFiltering() : void
      {
         m_flags = §§dup().m_flags | e_filterFlag;
      }
      
      b2internal function Reset(param1:b2Fixture = null, param2:b2Fixture = null) : void
      {
         m_flags = e_enabledFlag;
         if(!param1 || !param2)
         {
            m_fixtureA = null;
            m_fixtureB = null;
            return;
         }
         if(param1.IsSensor() || param2.IsSensor())
         {
            m_flags = §§dup().m_flags | e_sensorFlag;
         }
         var _loc3_:b2Body = param1.GetBody();
         var _loc4_:b2Body = param2.GetBody();
         if(_loc3_.GetType() != b2Body.b2_dynamicBody || _loc3_.IsBullet() || _loc4_.GetType() != b2Body.b2_dynamicBody || _loc4_.IsBullet())
         {
            m_flags = §§dup().m_flags | e_continuousFlag;
         }
         m_fixtureA = param1;
         m_fixtureB = param2;
         m_manifold.m_pointCount = 0;
         m_prev = null;
         m_next = null;
         m_nodeA.contact = null;
         m_nodeA.prev = null;
         m_nodeA.next = null;
         m_nodeA.other = null;
         m_nodeB.contact = null;
         m_nodeB.prev = null;
         m_nodeB.next = null;
         m_nodeB.other = null;
      }
      
      b2internal function Update(param1:b2ContactListener) : void
      {
         var _loc3_:* = null;
         var _loc5_:* = null;
         var _loc13_:* = null;
         var _loc14_:* = null;
         var _loc8_:* = 0;
         var _loc11_:* = null;
         var _loc15_:* = null;
         var _loc9_:* = 0;
         var _loc12_:* = null;
         var _loc2_:b2Manifold = m_oldManifold;
         m_oldManifold = m_manifold;
         m_manifold = _loc2_;
         m_flags = §§dup().m_flags | e_enabledFlag;
         var _loc4_:* = false;
         var _loc10_:* = (m_flags & e_touchingFlag) == e_touchingFlag;
         var _loc6_:b2Body = m_fixtureA.m_body;
         var _loc16_:b2Body = m_fixtureB.m_body;
         var _loc7_:Boolean = m_fixtureA.m_aabb.TestOverlap(m_fixtureB.m_aabb);
         if(m_flags & e_sensorFlag)
         {
            if(_loc7_)
            {
               _loc3_ = m_fixtureA.GetShape();
               _loc5_ = m_fixtureB.GetShape();
               _loc13_ = _loc6_.GetTransform();
               _loc14_ = _loc16_.GetTransform();
               _loc4_ = b2Shape.TestOverlap(_loc3_,_loc13_,_loc5_,_loc14_);
            }
            m_manifold.m_pointCount = 0;
         }
         else
         {
            if(_loc6_.GetType() != b2Body.b2_dynamicBody || _loc6_.IsBullet() || _loc16_.GetType() != b2Body.b2_dynamicBody || _loc16_.IsBullet())
            {
               m_flags = §§dup().m_flags | e_continuousFlag;
            }
            else
            {
               m_flags = §§dup().m_flags & ~e_continuousFlag;
            }
            if(_loc7_)
            {
               Evaluate();
               _loc4_ = m_manifold.m_pointCount > 0;
               _loc8_ = 0;
               while(_loc8_ < m_manifold.m_pointCount)
               {
                  _loc11_ = m_manifold.m_points[_loc8_];
                  _loc11_.m_normalImpulse = 0;
                  _loc11_.m_tangentImpulse = 0;
                  _loc15_ = _loc11_.m_id;
                  _loc9_ = 0;
                  while(_loc9_ < m_oldManifold.m_pointCount)
                  {
                     _loc12_ = m_oldManifold.m_points[_loc9_];
                     if(_loc12_.m_id.key == _loc15_.key)
                     {
                        _loc11_.m_normalImpulse = _loc12_.m_normalImpulse;
                        _loc11_.m_tangentImpulse = _loc12_.m_tangentImpulse;
                        break;
                     }
                     _loc9_++;
                  }
                  _loc8_++;
               }
            }
            else
            {
               m_manifold.m_pointCount = 0;
            }
            if(_loc4_ != _loc10_)
            {
               _loc6_.SetAwake(true);
               _loc16_.SetAwake(true);
            }
         }
         if(_loc4_)
         {
            m_flags = §§dup().m_flags | e_touchingFlag;
         }
         else
         {
            m_flags = §§dup().m_flags & ~e_touchingFlag;
         }
         if(_loc10_ == false && _loc4_ == true)
         {
            param1.BeginContact(this);
         }
         if(_loc10_ == true && _loc4_ == false)
         {
            param1.EndContact(this);
         }
         if((m_flags & e_sensorFlag) == 0)
         {
            param1.PreSolve(this,m_oldManifold);
         }
      }
      
      b2internal function Evaluate() : void
      {
      }
      
      b2internal function ComputeTOI(param1:b2Sweep, param2:b2Sweep) : Number
      {
         s_input.proxyA.Set(m_fixtureA.GetShape());
         s_input.proxyB.Set(m_fixtureB.GetShape());
         s_input.sweepA = param1;
         s_input.sweepB = param2;
         s_input.tolerance = 0.005;
         return b2TimeOfImpact.TimeOfImpact(s_input);
      }
   }
}
