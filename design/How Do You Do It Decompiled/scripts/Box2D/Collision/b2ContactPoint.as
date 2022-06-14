package Box2D.Collision
{
   import Box2D.Collision.Shapes.b2Shape;
   import Box2D.Common.Math.b2Vec2;
   
   public class b2ContactPoint
   {
       
      public var shape1:b2Shape;
      
      public var shape2:b2Shape;
      
      public var position:b2Vec2;
      
      public var velocity:b2Vec2;
      
      public var normal:b2Vec2;
      
      public var separation:Number;
      
      public var friction:Number;
      
      public var restitution:Number;
      
      public var id:Box2D.Collision.b2ContactID;
      
      public function b2ContactPoint()
      {
         position = new b2Vec2();
         velocity = new b2Vec2();
         normal = new b2Vec2();
         id = new Box2D.Collision.b2ContactID();
         super();
      }
   }
}
