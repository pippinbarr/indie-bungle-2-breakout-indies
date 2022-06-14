package
{
   import org.flixel.FlxState;
   
   public class TimedState extends FlxState
   {
       
      public var timeFrame:Number = 0;
      
      public var timeSec:Number = 0;
      
      public var endTime:Number = 30;
      
      public function TimedState()
      {
         super();
      }
      
      override public function update() : void
      {
         super.update();
         timeFrame = timeFrame + 1;
         if(timeFrame % 100 == 0)
         {
            timeSec = timeSec + 1;
         }
         if(timeSec == this.endTime)
         {
            this.endCallback();
         }
      }
      
      public function endCallback() : void
      {
      }
   }
}
