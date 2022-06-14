package Box2D.Common.Math
{
   public class b2Transform
   {
       
      public var position:Box2D.Common.Math.b2Vec2;
      
      public var R:Box2D.Common.Math.b2Mat22;
      
      public function b2Transform(param1:Box2D.Common.Math.b2Vec2 = null, param2:Box2D.Common.Math.b2Mat22 = null)
      {
         position = new Box2D.Common.Math.b2Vec2();
         R = new Box2D.Common.Math.b2Mat22();
         super();
         if(param1)
         {
            position.SetV(param1);
            R.SetM(param2);
         }
      }
      
      public function Initialize(param1:Box2D.Common.Math.b2Vec2, param2:Box2D.Common.Math.b2Mat22) : void
      {
         position.SetV(param1);
         R.SetM(param2);
      }
      
      public function SetIdentity() : void
      {
         position.SetZero();
         R.SetIdentity();
      }
      
      public function Set(param1:b2Transform) : void
      {
         position.SetV(param1.position);
         R.SetM(param1.R);
      }
      
      public function GetAngle() : Number
      {
         return Math.atan2(R.col1.y,R.col1.x);
      }
   }
}
