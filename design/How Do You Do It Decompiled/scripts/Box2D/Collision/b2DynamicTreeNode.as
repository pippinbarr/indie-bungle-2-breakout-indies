package Box2D.Collision
{
   public class b2DynamicTreeNode
   {
       
      public var userData;
      
      public var aabb:Box2D.Collision.b2AABB;
      
      public var parent:Box2D.Collision.b2DynamicTreeNode;
      
      public var child1:Box2D.Collision.b2DynamicTreeNode;
      
      public var child2:Box2D.Collision.b2DynamicTreeNode;
      
      public function b2DynamicTreeNode()
      {
         aabb = new Box2D.Collision.b2AABB();
         super();
      }
      
      public function IsLeaf() : Boolean
      {
         return child1 == null;
      }
   }
}
