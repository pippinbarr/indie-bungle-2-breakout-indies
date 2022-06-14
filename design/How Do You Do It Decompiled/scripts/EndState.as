package
{
   import org.flixel.FlxState;
   import org.flixel.FlxG;
   import org.flixel.FlxText;
   
   public class EndState extends FlxState
   {
       
      public var times:Number;
      
      public var caught:Boolean;
      
      public function EndState(param1:Number, param2:Boolean)
      {
         super();
         times = param1;
         this.caught = param2;
      }
      
      override public function create() : void
      {
         var _loc1_:* = null;
         FlxG.mouse.hide();
         var _loc2_:Number = FlxG.width;
         if(times == 1)
         {
            _loc1_ = new FlxText(0,FlxG.height / 2 - 50,_loc2_,"You might have done sex\n" + times + " time...?");
            _loc1_.setFormat("Minecraftia-Regular",16,4.294967295E9,"center");
            add(_loc1_);
         }
         else
         {
            _loc1_ = new FlxText(0,FlxG.height / 2 - 50,_loc2_,"You might have done sex\n" + times + " times...?");
            _loc1_.setFormat("Minecraftia-Regular",16,4.294967295E9,"center");
            add(_loc1_);
         }
         if(this.caught)
         {
            _loc1_.text = _loc1_.text + "\nEep! Mom saw!";
         }
         else
         {
            _loc1_.text = _loc1_.text + "\nAnd you didn\'t get caught!";
         }
         _loc1_ = new FlxText(0,FlxG.height - 40,FlxG.width,"Press any key to play again");
         _loc1_.setFormat("Minecraftia-Regular",16,4.294967295E9,"center");
         add(_loc1_);
      }
      
      override public function update() : void
      {
         super.update();
         if(FlxG.keys.any())
         {
            FlxG.switchState(new MomLeavingState(new PlayState()));
         }
      }
   }
}
