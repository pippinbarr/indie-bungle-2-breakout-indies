package Box2D.Collision
{
   import Box2D.Common.Math.b2Vec2;
   
   public class b2DynamicTreeBroadPhase implements IBroadPhase
   {
       
      private var m_tree:Box2D.Collision.b2DynamicTree;
      
      private var m_proxyCount:int;
      
      private var m_moveBuffer:Vector.<Box2D.Collision.b2DynamicTreeNode>;
      
      private var m_pairBuffer:Vector.<Box2D.Collision.b2DynamicTreePair>;
      
      private var m_pairCount:int = 0;
      
      public function b2DynamicTreeBroadPhase()
      {
         m_tree = new Box2D.Collision.b2DynamicTree();
         m_moveBuffer = new Vector.<Box2D.Collision.b2DynamicTreeNode>();
         m_pairBuffer = new Vector.<Box2D.Collision.b2DynamicTreePair>();
         super();
      }
      
      public function CreateProxy(param1:b2AABB, param2:*) : *
      {
         var _loc3_:Box2D.Collision.b2DynamicTreeNode = m_tree.CreateProxy(param1,param2);
         m_proxyCount = m_proxyCount + 1;
         BufferMove(_loc3_);
         return _loc3_;
      }
      
      public function DestroyProxy(param1:*) : void
      {
         UnBufferMove(param1);
         m_proxyCount = m_proxyCount - 1;
         m_tree.DestroyProxy(param1);
      }
      
      public function MoveProxy(param1:*, param2:b2AABB, param3:b2Vec2) : void
      {
         var _loc4_:Boolean = m_tree.MoveProxy(param1,param2,param3);
         if(_loc4_)
         {
            BufferMove(param1);
         }
      }
      
      public function TestOverlap(param1:*, param2:*) : Boolean
      {
         var _loc3_:b2AABB = m_tree.GetFatAABB(param1);
         var _loc4_:b2AABB = m_tree.GetFatAABB(param2);
         return _loc3_.TestOverlap(_loc4_);
      }
      
      public function GetUserData(param1:*) : *
      {
         return m_tree.GetUserData(param1);
      }
      
      public function GetFatAABB(param1:*) : b2AABB
      {
         return m_tree.GetFatAABB(param1);
      }
      
      public function GetProxyCount() : int
      {
         return m_proxyCount;
      }
      
      public function UpdatePairs(param1:Function) : void
      {
         callback = param1;
         m_pairCount = 0;
         var _loc4_:* = 0;
         var _loc3_:* = m_moveBuffer;
         for each(queryProxy in m_moveBuffer)
         {
            QueryCallback = function(param1:b2DynamicTreeNode):Boolean
            {
               if(param1 == queryProxy)
               {
                  return true;
               }
               if(m_pairCount == m_pairBuffer.length)
               {
                  m_pairBuffer[m_pairCount] = new b2DynamicTreePair();
               }
               var _loc2_:b2DynamicTreePair = m_pairBuffer[m_pairCount];
               _loc2_.proxyA = param1 < queryProxy?param1:queryProxy;
               _loc2_.proxyB = param1 >= queryProxy?param1:queryProxy;
               m_pairCount = m_pairCount + 1;
               return true;
            };
            var fatAABB:b2AABB = m_tree.GetFatAABB(queryProxy);
            m_tree.Query(QueryCallback,fatAABB);
         }
         m_moveBuffer.length = 0;
         var i:int = 0;
         while(i < m_pairCount)
         {
            var primaryPair:Box2D.Collision.b2DynamicTreePair = m_pairBuffer[i];
            var userDataA:* = m_tree.GetUserData(primaryPair.proxyA);
            var userDataB:* = m_tree.GetUserData(primaryPair.proxyB);
            callback(userDataA,userDataB);
            i = i + 1;
            while(i < m_pairCount)
            {
               var pair:Box2D.Collision.b2DynamicTreePair = m_pairBuffer[i];
               if(!(pair.proxyA != primaryPair.proxyA || pair.proxyB != primaryPair.proxyB))
               {
                  i = i + 1;
                  continue;
               }
               break;
            }
         }
      }
      
      public function Query(param1:Function, param2:b2AABB) : void
      {
         m_tree.Query(param1,param2);
      }
      
      public function RayCast(param1:Function, param2:b2RayCastInput) : void
      {
         m_tree.RayCast(param1,param2);
      }
      
      public function Validate() : void
      {
      }
      
      public function Rebalance(param1:int) : void
      {
         m_tree.Rebalance(param1);
      }
      
      private function BufferMove(param1:Box2D.Collision.b2DynamicTreeNode) : void
      {
         m_moveBuffer[m_moveBuffer.length] = param1;
      }
      
      private function UnBufferMove(param1:Box2D.Collision.b2DynamicTreeNode) : void
      {
         var _loc2_:int = m_moveBuffer.indexOf(param1);
         m_moveBuffer.splice(_loc2_,1);
      }
      
      private function ComparePairs(param1:Box2D.Collision.b2DynamicTreePair, param2:Box2D.Collision.b2DynamicTreePair) : int
      {
         return 0;
      }
   }
}
