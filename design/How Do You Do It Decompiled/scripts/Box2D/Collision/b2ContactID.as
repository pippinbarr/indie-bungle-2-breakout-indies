package Box2D.Collision
{
   import Box2D.Common.b2internal;
   
   use namespace b2internal;
   
   public class b2ContactID
   {
       
      public var features:Box2D.Collision.Features;
      
      b2internal var _key:uint;
      
      public function b2ContactID()
      {
         features = new Box2D.Collision.Features();
         super();
         features._m_id = this;
      }
      
      public function Set(param1:b2ContactID) : void
      {
         key = param1._key;
      }
      
      public function Copy() : b2ContactID
      {
         var _loc1_:b2ContactID = new b2ContactID();
         _loc1_.key = key;
         return _loc1_;
      }
      
      public function get key() : uint
      {
         return _key;
      }
      
      public function set key(param1:uint) : void
      {
         _key = param1;
         features._referenceEdge = _key & 255;
         features._incidentEdge = (_key & 65280) >> 8 & 255;
         features._incidentVertex = (_key & 16711680) >> 16 & 255;
         features._flip = (_key & 4.27819008E9) >> 24 & 255;
      }
   }
}
