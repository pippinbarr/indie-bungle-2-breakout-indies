package Box2D.Dynamics
{
   import Box2D.Collision.Shapes.b2Shape;
   
   public class b2FixtureDef
   {
       
      public var shape:b2Shape;
      
      public var userData;
      
      public var friction:Number;
      
      public var restitution:Number;
      
      public var density:Number;
      
      public var isSensor:Boolean;
      
      public var filter:Box2D.Dynamics.b2FilterData;
      
      public function b2FixtureDef()
      {
         filter = new Box2D.Dynamics.b2FilterData();
         super();
         shape = null;
         userData = null;
         friction = 0.2;
         restitution = 0;
         density = 0;
         filter.categoryBits = 1;
         filter.maskBits = 65535;
         filter.groupIndex = 0;
         isSensor = false;
      }
   }
}
