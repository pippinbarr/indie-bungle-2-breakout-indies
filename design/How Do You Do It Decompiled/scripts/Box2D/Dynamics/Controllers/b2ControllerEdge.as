package Box2D.Dynamics.Controllers
{
   import Box2D.Dynamics.b2Body;
   
   public class b2ControllerEdge
   {
       
      public var controller:Box2D.Dynamics.Controllers.b2Controller;
      
      public var body:b2Body;
      
      public var prevBody:Box2D.Dynamics.Controllers.b2ControllerEdge;
      
      public var nextBody:Box2D.Dynamics.Controllers.b2ControllerEdge;
      
      public var prevController:Box2D.Dynamics.Controllers.b2ControllerEdge;
      
      public var nextController:Box2D.Dynamics.Controllers.b2ControllerEdge;
      
      public function b2ControllerEdge()
      {
         super();
      }
   }
}
