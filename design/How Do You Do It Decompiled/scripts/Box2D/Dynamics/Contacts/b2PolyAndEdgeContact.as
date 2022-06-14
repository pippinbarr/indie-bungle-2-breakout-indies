package Box2D.Dynamics.Contacts
{
   import Box2D.Dynamics.b2Fixture;
   import Box2D.Common.b2internal;
   import Box2D.Common.b2Settings;
   import Box2D.Dynamics.b2Body;
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Collision.Shapes.b2EdgeShape;
   import Box2D.Collision.b2Manifold;
   import Box2D.Common.Math.b2Transform;
   
   use namespace b2internal;
   
   public class b2PolyAndEdgeContact extends b2Contact
   {
       
      public function b2PolyAndEdgeContact()
      {
         super();
      }
      
      public static function Create(param1:*) : b2Contact
      {
         return new b2PolyAndEdgeContact();
      }
      
      public static function Destroy(param1:b2Contact, param2:*) : void
      {
      }
      
      public function Reset(param1:b2Fixture, param2:b2Fixture) : void
      {
         super.Reset(param1,param2);
         b2Settings.b2Assert(param1.GetType() == 1);
         b2Settings.b2Assert(param2.GetType() == 2);
      }
      
      override b2internal function Evaluate() : void
      {
         var _loc2_:b2Body = m_fixtureA.GetBody();
         var _loc1_:b2Body = m_fixtureB.GetBody();
         b2CollidePolyAndEdge(m_manifold,m_fixtureA.GetShape() as b2PolygonShape,_loc2_.m_xf,m_fixtureB.GetShape() as b2EdgeShape,_loc1_.m_xf);
      }
      
      private function b2CollidePolyAndEdge(param1:b2Manifold, param2:b2PolygonShape, param3:b2Transform, param4:b2EdgeShape, param5:b2Transform) : void
      {
      }
   }
}
