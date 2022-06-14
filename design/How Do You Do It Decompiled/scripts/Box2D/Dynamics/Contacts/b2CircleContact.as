package Box2D.Dynamics.Contacts
{
   import Box2D.Dynamics.b2Fixture;
   import Box2D.Common.b2internal;
   import Box2D.Dynamics.b2Body;
   import Box2D.Collision.b2Collision;
   import Box2D.Collision.Shapes.b2CircleShape;
   
   use namespace b2internal;
   
   public class b2CircleContact extends b2Contact
   {
       
      public function b2CircleContact()
      {
         super();
      }
      
      public static function Create(param1:*) : b2Contact
      {
         return new b2CircleContact();
      }
      
      public static function Destroy(param1:b2Contact, param2:*) : void
      {
      }
      
      public function Reset(param1:b2Fixture, param2:b2Fixture) : void
      {
         super.Reset(param1,param2);
      }
      
      override b2internal function Evaluate() : void
      {
         var _loc2_:b2Body = m_fixtureA.GetBody();
         var _loc1_:b2Body = m_fixtureB.GetBody();
         b2Collision.CollideCircles(m_manifold,m_fixtureA.GetShape() as b2CircleShape,_loc2_.m_xf,m_fixtureB.GetShape() as b2CircleShape,_loc1_.m_xf);
      }
   }
}
