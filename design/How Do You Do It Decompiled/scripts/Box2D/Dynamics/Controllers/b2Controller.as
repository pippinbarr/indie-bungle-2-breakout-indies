package Box2D.Dynamics.Controllers
{
   import Box2D.Dynamics.b2TimeStep;
   import Box2D.Dynamics.b2DebugDraw;
   import Box2D.Dynamics.b2Body;
   import Box2D.Common.b2internal;
   import Box2D.Dynamics.b2World;
   
   use namespace b2internal;
   
   public class b2Controller
   {
       
      b2internal var m_next:Box2D.Dynamics.Controllers.b2Controller;
      
      b2internal var m_prev:Box2D.Dynamics.Controllers.b2Controller;
      
      protected var m_bodyList:Box2D.Dynamics.Controllers.b2ControllerEdge;
      
      protected var m_bodyCount:int;
      
      b2internal var m_world:b2World;
      
      public function b2Controller()
      {
         super();
      }
      
      public function Step(param1:b2TimeStep) : void
      {
      }
      
      public function Draw(param1:b2DebugDraw) : void
      {
      }
      
      public function AddBody(param1:b2Body) : void
      {
         var _loc2_:Box2D.Dynamics.Controllers.b2ControllerEdge = new Box2D.Dynamics.Controllers.b2ControllerEdge();
         _loc2_.controller = this;
         _loc2_.body = param1;
         _loc2_.nextBody = m_bodyList;
         _loc2_.prevBody = null;
         m_bodyList = _loc2_;
         if(_loc2_.nextBody)
         {
            _loc2_.nextBody.prevBody = _loc2_;
         }
         m_bodyCount = m_bodyCount + 1;
         _loc2_.nextController = param1.m_controllerList;
         _loc2_.prevController = null;
         param1.m_controllerList = _loc2_;
         if(_loc2_.nextController)
         {
            _loc2_.nextController.prevController = _loc2_;
         }
         §§dup(param1).m_controllerCount++;
      }
      
      public function RemoveBody(param1:b2Body) : void
      {
         var _loc2_:Box2D.Dynamics.Controllers.b2ControllerEdge = param1.m_controllerList;
         while(_loc2_ && _loc2_.controller != this)
         {
            _loc2_ = _loc2_.nextController;
         }
         if(_loc2_.prevBody)
         {
            _loc2_.prevBody.nextBody = _loc2_.nextBody;
         }
         if(_loc2_.nextBody)
         {
            _loc2_.nextBody.prevBody = _loc2_.prevBody;
         }
         if(_loc2_.nextController)
         {
            _loc2_.nextController.prevController = _loc2_.prevController;
         }
         if(_loc2_.prevController)
         {
            _loc2_.prevController.nextController = _loc2_.nextController;
         }
         if(m_bodyList == _loc2_)
         {
            m_bodyList = _loc2_.nextBody;
         }
         if(param1.m_controllerList == _loc2_)
         {
            param1.m_controllerList = _loc2_.nextController;
         }
         §§dup(param1).m_controllerCount--;
         m_bodyCount = m_bodyCount - 1;
      }
      
      public function Clear() : void
      {
         while(m_bodyList)
         {
            RemoveBody(m_bodyList.body);
         }
      }
      
      public function GetNext() : Box2D.Dynamics.Controllers.b2Controller
      {
         return m_next;
      }
      
      public function GetWorld() : b2World
      {
         return m_world;
      }
      
      public function GetBodyList() : Box2D.Dynamics.Controllers.b2ControllerEdge
      {
         return m_bodyList;
      }
   }
}
