package Box2D.Dynamics
{
   public class b2TimeStep
   {
       
      public var dt:Number;
      
      public var inv_dt:Number;
      
      public var dtRatio:Number;
      
      public var velocityIterations:int;
      
      public var positionIterations:int;
      
      public var warmStarting:Boolean;
      
      public function b2TimeStep()
      {
         super();
      }
      
      public function Set(param1:b2TimeStep) : void
      {
         dt = param1.dt;
         inv_dt = param1.inv_dt;
         positionIterations = param1.positionIterations;
         velocityIterations = param1.velocityIterations;
         warmStarting = param1.warmStarting;
      }
   }
}
