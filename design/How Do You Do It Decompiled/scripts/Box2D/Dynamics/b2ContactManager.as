package Box2D.Dynamics
{
   import Box2D.Collision.b2ContactPoint;
   import Box2D.Dynamics.Contacts.b2ContactEdge;
   import Box2D.Common.b2internal;
   import Box2D.Dynamics.Contacts.b2Contact;
   import Box2D.Collision.IBroadPhase;
   import Box2D.Dynamics.Contacts.b2ContactFactory;
   import Box2D.Collision.b2DynamicTreeBroadPhase;
   
   use namespace b2internal;
   
   public class b2ContactManager
   {
      
      private static const s_evalCP:b2ContactPoint = new b2ContactPoint();
       
      b2internal var m_world:Box2D.Dynamics.b2World;
      
      b2internal var m_broadPhase:IBroadPhase;
      
      b2internal var m_contactList:b2Contact;
      
      b2internal var m_contactCount:int;
      
      b2internal var m_contactFilter:Box2D.Dynamics.b2ContactFilter;
      
      b2internal var m_contactListener:Box2D.Dynamics.b2ContactListener;
      
      b2internal var m_contactFactory:b2ContactFactory;
      
      b2internal var m_allocator;
      
      public function b2ContactManager()
      {
         super();
         m_world = null;
         m_contactCount = 0;
         m_contactFilter = Box2D.Dynamics.b2ContactFilter.b2_defaultFilter;
         m_contactListener = Box2D.Dynamics.b2ContactListener.b2_defaultListener;
         m_contactFactory = new b2ContactFactory(m_allocator);
         m_broadPhase = new b2DynamicTreeBroadPhase();
      }
      
      public function AddPair(param1:*, param2:*) : void
      {
         var _loc7_:* = null;
         var _loc9_:* = null;
         var _loc10_:b2Fixture = param1 as b2Fixture;
         var _loc8_:b2Fixture = param2 as b2Fixture;
         var _loc5_:b2Body = _loc10_.GetBody();
         var _loc6_:b2Body = _loc8_.GetBody();
         if(_loc5_ == _loc6_)
         {
            return;
         }
         var _loc3_:b2ContactEdge = _loc6_.GetContactList();
         while(_loc3_)
         {
            if(_loc3_.other == _loc5_)
            {
               _loc7_ = _loc3_.contact.GetFixtureA();
               _loc9_ = _loc3_.contact.GetFixtureB();
               if(_loc7_ == _loc10_ && _loc9_ == _loc8_)
               {
                  return;
               }
               if(_loc7_ == _loc8_ && _loc9_ == _loc10_)
               {
                  return;
               }
            }
            _loc3_ = _loc3_.next;
         }
         if(_loc6_.ShouldCollide(_loc5_) == false)
         {
            return;
         }
         if(m_contactFilter.ShouldCollide(_loc10_,_loc8_) == false)
         {
            return;
         }
         var _loc4_:b2Contact = m_contactFactory.Create(_loc10_,_loc8_);
         _loc10_ = _loc4_.GetFixtureA();
         _loc8_ = _loc4_.GetFixtureB();
         _loc5_ = _loc10_.m_body;
         _loc6_ = _loc8_.m_body;
         _loc4_.m_prev = null;
         _loc4_.m_next = m_world.m_contactList;
         if(m_world.m_contactList != null)
         {
            m_world.m_contactList.m_prev = _loc4_;
         }
         m_world.m_contactList = _loc4_;
         _loc4_.m_nodeA.contact = _loc4_;
         _loc4_.m_nodeA.other = _loc6_;
         _loc4_.m_nodeA.prev = null;
         _loc4_.m_nodeA.next = _loc5_.m_contactList;
         if(_loc5_.m_contactList != null)
         {
            _loc5_.m_contactList.prev = _loc4_.m_nodeA;
         }
         _loc5_.m_contactList = _loc4_.m_nodeA;
         _loc4_.m_nodeB.contact = _loc4_;
         _loc4_.m_nodeB.other = _loc5_;
         _loc4_.m_nodeB.prev = null;
         _loc4_.m_nodeB.next = _loc6_.m_contactList;
         if(_loc6_.m_contactList != null)
         {
            _loc6_.m_contactList.prev = _loc4_.m_nodeB;
         }
         _loc6_.m_contactList = _loc4_.m_nodeB;
         §§dup(m_world).m_contactCount++;
      }
      
      public function FindNewContacts() : void
      {
         m_broadPhase.UpdatePairs(AddPair);
      }
      
      public function Destroy(param1:b2Contact) : void
      {
         var _loc5_:b2Fixture = param1.GetFixtureA();
         var _loc4_:b2Fixture = param1.GetFixtureB();
         var _loc2_:b2Body = _loc5_.GetBody();
         var _loc3_:b2Body = _loc4_.GetBody();
         if(param1.IsTouching())
         {
            m_contactListener.EndContact(param1);
         }
         if(param1.m_prev)
         {
            param1.m_prev.m_next = param1.m_next;
         }
         if(param1.m_next)
         {
            param1.m_next.m_prev = param1.m_prev;
         }
         if(param1 == m_world.m_contactList)
         {
            m_world.m_contactList = param1.m_next;
         }
         if(param1.m_nodeA.prev)
         {
            param1.m_nodeA.prev.next = param1.m_nodeA.next;
         }
         if(param1.m_nodeA.next)
         {
            param1.m_nodeA.next.prev = param1.m_nodeA.prev;
         }
         if(param1.m_nodeA == _loc2_.m_contactList)
         {
            _loc2_.m_contactList = param1.m_nodeA.next;
         }
         if(param1.m_nodeB.prev)
         {
            param1.m_nodeB.prev.next = param1.m_nodeB.next;
         }
         if(param1.m_nodeB.next)
         {
            param1.m_nodeB.next.prev = param1.m_nodeB.prev;
         }
         if(param1.m_nodeB == _loc3_.m_contactList)
         {
            _loc3_.m_contactList = param1.m_nodeB.next;
         }
         m_contactFactory.Destroy(param1);
         m_contactCount = m_contactCount - 1;
      }
      
      public function Collide() : void
      {
         var _loc8_:* = null;
         var _loc6_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc7_:* = null;
         var _loc5_:* = undefined;
         var _loc9_:* = undefined;
         var _loc2_:* = false;
         var _loc1_:b2Contact = m_world.m_contactList;
         while(_loc1_)
         {
            _loc8_ = _loc1_.GetFixtureA();
            _loc6_ = _loc1_.GetFixtureB();
            _loc3_ = _loc8_.GetBody();
            _loc4_ = _loc6_.GetBody();
            if(_loc3_.IsAwake() == false && _loc4_.IsAwake() == false)
            {
               _loc1_ = _loc1_.GetNext();
            }
            else
            {
               if(_loc1_.m_flags & b2Contact.e_filterFlag)
               {
                  if(_loc4_.ShouldCollide(_loc3_) == false)
                  {
                     _loc7_ = _loc1_;
                     _loc1_ = _loc7_.GetNext();
                     Destroy(_loc7_);
                     continue;
                  }
                  if(m_contactFilter.ShouldCollide(_loc8_,_loc6_) == false)
                  {
                     _loc7_ = _loc1_;
                     _loc1_ = _loc7_.GetNext();
                     Destroy(_loc7_);
                     continue;
                  }
                  _loc1_.m_flags = _loc1_.m_flags & ~b2Contact.e_filterFlag;
               }
               _loc5_ = _loc8_.m_proxy;
               _loc9_ = _loc6_.m_proxy;
               _loc2_ = m_broadPhase.TestOverlap(_loc5_,_loc9_);
               if(_loc2_ == false)
               {
                  _loc7_ = _loc1_;
                  _loc1_ = _loc7_.GetNext();
                  Destroy(_loc7_);
               }
               else
               {
                  _loc1_.Update(m_contactListener);
                  _loc1_ = _loc1_.GetNext();
               }
            }
         }
      }
   }
}
