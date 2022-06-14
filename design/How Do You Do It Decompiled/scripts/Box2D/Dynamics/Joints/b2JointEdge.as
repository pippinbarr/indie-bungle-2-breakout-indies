package Box2D.Dynamics.Joints
{
   import Box2D.Dynamics.b2Body;
   
   public class b2JointEdge
   {
       
      public var other:b2Body;
      
      public var joint:Box2D.Dynamics.Joints.b2Joint;
      
      public var prev:Box2D.Dynamics.Joints.b2JointEdge;
      
      public var next:Box2D.Dynamics.Joints.b2JointEdge;
      
      public function b2JointEdge()
      {
         super();
      }
   }
}
