package Box2D.Collision
{
   import Box2D.Common.Math.b2Vec2;
   
   class b2SimplexVertex
   {
       
      public var wA:b2Vec2;
      
      public var wB:b2Vec2;
      
      public var w:b2Vec2;
      
      public var a:Number;
      
      public var indexA:int;
      
      public var indexB:int;
      
      function b2SimplexVertex()
      {
         super();
      }
      
      public function Set(param1:b2SimplexVertex) : void
      {
         wA.SetV(param1.wA);
         wB.SetV(param1.wB);
         w.SetV(param1.w);
         a = param1.a;
         indexA = param1.indexA;
         indexB = param1.indexB;
      }
   }
}
