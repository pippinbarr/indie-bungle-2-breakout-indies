package Box2D.Dynamics.Joints
{
   import Box2D.Common.Math.b2Vec2;
   
   public class b2Jacobian
   {
       
      public var linearA:b2Vec2;
      
      public var angularA:Number;
      
      public var linearB:b2Vec2;
      
      public var angularB:Number;
      
      public function b2Jacobian()
      {
         linearA = new b2Vec2();
         linearB = new b2Vec2();
         super();
      }
      
      public function SetZero() : void
      {
         linearA.SetZero();
         angularA = 0;
         linearB.SetZero();
         angularB = 0;
      }
      
      public function Set(param1:b2Vec2, param2:Number, param3:b2Vec2, param4:Number) : void
      {
         linearA.SetV(param1);
         angularA = param2;
         linearB.SetV(param3);
         angularB = param4;
      }
      
      public function Compute(param1:b2Vec2, param2:Number, param3:b2Vec2, param4:Number) : Number
      {
         return linearA.x * param1.x + linearA.y * param1.y + angularA * param2 + (linearB.x * param3.x + linearB.y * param3.y) + angularB * param4;
      }
   }
}
