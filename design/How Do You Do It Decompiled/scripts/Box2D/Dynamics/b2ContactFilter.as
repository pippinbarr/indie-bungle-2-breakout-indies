package Box2D.Dynamics
{
   import Box2D.Common.b2internal;
   
   use namespace b2internal;
   
   public class b2ContactFilter
   {
      
      b2internal static var b2_defaultFilter:Box2D.Dynamics.b2ContactFilter = new Box2D.Dynamics.b2ContactFilter();
       
      public function b2ContactFilter()
      {
         super();
      }
      
      public function ShouldCollide(param1:b2Fixture, param2:b2Fixture) : Boolean
      {
         var _loc3_:b2FilterData = param1.GetFilterData();
         var _loc5_:b2FilterData = param2.GetFilterData();
         if(_loc3_.groupIndex == _loc5_.groupIndex && _loc3_.groupIndex != 0)
         {
            return _loc3_.groupIndex > 0;
         }
         var _loc4_:Boolean = (_loc3_.maskBits & _loc5_.categoryBits) != 0 && (_loc3_.categoryBits & _loc5_.maskBits) != 0;
         return _loc4_;
      }
      
      public function RayCollide(param1:*, param2:b2Fixture) : Boolean
      {
         if(!param1)
         {
            return true;
         }
         return ShouldCollide(param1 as b2Fixture,param2);
      }
   }
}
