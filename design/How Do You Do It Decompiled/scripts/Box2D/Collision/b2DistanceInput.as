package Box2D.Collision
{
   import Box2D.Common.Math.b2Transform;
   
   public class b2DistanceInput
   {
       
      public var proxyA:Box2D.Collision.b2DistanceProxy;
      
      public var proxyB:Box2D.Collision.b2DistanceProxy;
      
      public var transformA:b2Transform;
      
      public var transformB:b2Transform;
      
      public var useRadii:Boolean;
      
      public function b2DistanceInput()
      {
         super();
      }
   }
}
