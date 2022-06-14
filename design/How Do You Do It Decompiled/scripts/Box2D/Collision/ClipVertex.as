package Box2D.Collision
{
   import Box2D.Common.Math.b2Vec2;
   
   public class ClipVertex
   {
       
      public var v:b2Vec2;
      
      public var id:Box2D.Collision.b2ContactID;
      
      public function ClipVertex()
      {
         v = new b2Vec2();
         id = new Box2D.Collision.b2ContactID();
         super();
      }
      
      public function Set(param1:ClipVertex) : void
      {
         v.SetV(param1.v);
         id.Set(param1.id);
      }
   }
}
