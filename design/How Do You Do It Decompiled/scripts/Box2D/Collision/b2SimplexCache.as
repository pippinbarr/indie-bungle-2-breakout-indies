package Box2D.Collision
{
   public class b2SimplexCache
   {
       
      public var metric:Number;
      
      public var count:uint;
      
      public var indexA:Vector.<int>;
      
      public var indexB:Vector.<int>;
      
      public function b2SimplexCache()
      {
         indexA = new Vector.<int>(3);
         indexB = new Vector.<int>(3);
         super();
      }
   }
}
