package Box2D.Dynamics.Joints
{
   import Box2D.Dynamics.b2Body;
   
   public class b2JointDef
   {
       
      public var type:int;
      
      public var userData;
      
      public var bodyA:b2Body;
      
      public var bodyB:b2Body;
      
      public var collideConnected:Boolean;
      
      public function b2JointDef()
      {
         super();
         type = 0;
         userData = null;
         bodyA = null;
         bodyB = null;
         collideConnected = false;
      }
   }
}
