package Box2D.Common.Math
{
   public class b2Vec3
   {
       
      public var x:Number;
      
      public var y:Number;
      
      public var z:Number;
      
      public function b2Vec3(param1:Number = 0, param2:Number = 0, param3:Number = 0)
      {
         super();
         this.x = param1;
         this.y = param2;
         this.z = param3;
      }
      
      public function SetZero() : void
      {
         z = 0;
         y = 0;
         x = 0;
      }
      
      public function Set(param1:Number, param2:Number, param3:Number) : void
      {
         this.x = param1;
         this.y = param2;
         this.z = param3;
      }
      
      public function SetV(param1:b2Vec3) : void
      {
         x = param1.x;
         y = param1.y;
         z = param1.z;
      }
      
      public function GetNegative() : b2Vec3
      {
         return new b2Vec3(-x,-y,-z);
      }
      
      public function NegativeSelf() : void
      {
         x = -x;
         y = -y;
         z = -z;
      }
      
      public function Copy() : b2Vec3
      {
         return new b2Vec3(x,y,z);
      }
      
      public function Add(param1:b2Vec3) : void
      {
         x = §§dup().x + param1.x;
         y = §§dup().y + param1.y;
         z = §§dup().z + param1.z;
      }
      
      public function Subtract(param1:b2Vec3) : void
      {
         x = §§dup().x - param1.x;
         y = §§dup().y - param1.y;
         z = §§dup().z - param1.z;
      }
      
      public function Multiply(param1:Number) : void
      {
         x = §§dup().x * param1;
         y = §§dup().y * param1;
         z = §§dup().z * param1;
      }
   }
}
