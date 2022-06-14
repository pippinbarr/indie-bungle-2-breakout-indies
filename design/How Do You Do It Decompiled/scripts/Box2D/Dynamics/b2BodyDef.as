package Box2D.Dynamics
{
   import Box2D.Common.Math.b2Vec2;
   
   public class b2BodyDef
   {
       
      public var type:uint;
      
      public var position:b2Vec2;
      
      public var angle:Number;
      
      public var linearVelocity:b2Vec2;
      
      public var angularVelocity:Number;
      
      public var linearDamping:Number;
      
      public var angularDamping:Number;
      
      public var allowSleep:Boolean;
      
      public var awake:Boolean;
      
      public var fixedRotation:Boolean;
      
      public var bullet:Boolean;
      
      public var active:Boolean;
      
      public var userData;
      
      public var inertiaScale:Number;
      
      public function b2BodyDef()
      {
         position = new b2Vec2();
         linearVelocity = new b2Vec2();
         super();
         userData = null;
         position.Set(0,0);
         angle = 0;
         linearVelocity.Set(0,0);
         angularVelocity = 0;
         linearDamping = 0;
         angularDamping = 0;
         allowSleep = true;
         awake = true;
         fixedRotation = false;
         bullet = false;
         type = b2Body.b2_staticBody;
         active = true;
         inertiaScale = 1;
      }
   }
}
