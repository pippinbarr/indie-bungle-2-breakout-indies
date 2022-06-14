package Box2D.Dynamics
{
   public class b2ContactImpulse
   {
       
      public var normalImpulses:Vector.<Number>;
      
      public var tangentImpulses:Vector.<Number>;
      
      public function b2ContactImpulse()
      {
         normalImpulses = new Vector.<Number>(2);
         tangentImpulses = new Vector.<Number>(2);
         super();
      }
   }
}
