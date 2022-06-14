package Box2D.Dynamics.Contacts
{
   import Box2D.Common.b2internal;
   import Box2D.Dynamics.b2Fixture;
   
   use namespace b2internal;
   
   public class b2ContactFactory
   {
       
      private var m_registers:Vector.<Vector.<Box2D.Dynamics.Contacts.b2ContactRegister>>;
      
      private var m_allocator;
      
      public function b2ContactFactory(param1:*)
      {
         super();
         m_allocator = param1;
         InitializeRegisters();
      }
      
      b2internal function AddType(param1:Function, param2:Function, param3:int, param4:int) : void
      {
         m_registers[param3][param4].createFcn = param1;
         m_registers[param3][param4].destroyFcn = param2;
         m_registers[param3][param4].primary = true;
         if(param3 != param4)
         {
            m_registers[param4][param3].createFcn = param1;
            m_registers[param4][param3].destroyFcn = param2;
            m_registers[param4][param3].primary = false;
         }
      }
      
      b2internal function InitializeRegisters() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         m_registers = new Vector.<Vector.<Box2D.Dynamics.Contacts.b2ContactRegister>>(3);
         _loc1_ = 0;
         while(_loc1_ < 3)
         {
            m_registers[_loc1_] = new Vector.<Box2D.Dynamics.Contacts.b2ContactRegister>(3);
            _loc2_ = 0;
            while(_loc2_ < 3)
            {
               m_registers[_loc1_][_loc2_] = new Box2D.Dynamics.Contacts.b2ContactRegister();
               _loc2_++;
            }
            _loc1_++;
         }
         AddType(b2CircleContact.Create,b2CircleContact.Destroy,0,0);
         AddType(b2PolyAndCircleContact.Create,b2PolyAndCircleContact.Destroy,1,0);
         AddType(b2PolygonContact.Create,b2PolygonContact.Destroy,1,1);
         AddType(b2EdgeAndCircleContact.Create,b2EdgeAndCircleContact.Destroy,2,0);
         AddType(b2PolyAndEdgeContact.Create,b2PolyAndEdgeContact.Destroy,1,2);
      }
      
      public function Create(param1:b2Fixture, param2:b2Fixture) : b2Contact
      {
         var _loc4_:* = null;
         var _loc6_:int = param1.GetType();
         var _loc3_:int = param2.GetType();
         var _loc5_:Box2D.Dynamics.Contacts.b2ContactRegister = m_registers[_loc6_][_loc3_];
         if(_loc5_.pool)
         {
            _loc4_ = _loc5_.pool;
            _loc5_.pool = _loc4_.m_next;
            _loc5_.poolCount = §§dup(_loc5_).poolCount - 1;
            _loc4_.Reset(param1,param2);
            return _loc4_;
         }
         var _loc7_:Function = _loc5_.createFcn;
         if(_loc7_ != null)
         {
            if(_loc5_.primary)
            {
               _loc4_ = _loc7_(m_allocator);
               _loc4_.Reset(param1,param2);
               return _loc4_;
            }
            _loc4_ = _loc7_(m_allocator);
            _loc4_.Reset(param2,param1);
            return _loc4_;
         }
         return null;
      }
      
      public function Destroy(param1:b2Contact) : void
      {
         if(param1.m_manifold.m_pointCount > 0)
         {
            param1.m_fixtureA.m_body.SetAwake(true);
            param1.m_fixtureB.m_body.SetAwake(true);
         }
         var _loc5_:int = param1.m_fixtureA.GetType();
         var _loc3_:int = param1.m_fixtureB.GetType();
         var _loc4_:Box2D.Dynamics.Contacts.b2ContactRegister = m_registers[_loc5_][_loc3_];
         _loc4_.poolCount = §§dup(_loc4_).poolCount + 1;
         param1.m_next = _loc4_.pool;
         _loc4_.pool = param1;
         var _loc2_:Function = _loc4_.destroyFcn;
      }
   }
}
