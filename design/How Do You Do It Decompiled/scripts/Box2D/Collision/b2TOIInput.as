package Box2D.Collision
{
   import Box2D.Common.Math.b2Sweep;
   
   public class b2TOIInput
   {
       
      public var proxyA:Box2D.Collision.b2DistanceProxy;
      
      public var proxyB:Box2D.Collision.b2DistanceProxy;
      
      public var sweepA:b2Sweep;
      
      public var sweepB:b2Sweep;
      
      public var tolerance:Number;
      
      public function b2TOIInput()
      {
         proxyA = new Box2D.Collision.b2DistanceProxy();
         proxyB = new Box2D.Collision.b2DistanceProxy();
         sweepA = new b2Sweep();
         sweepB = new b2Sweep();
         super();
      }
   }
}
