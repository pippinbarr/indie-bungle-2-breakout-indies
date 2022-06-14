package
{
   import org.flixel.FlxState;
   import org.flixel.FlxG;
   import org.flixel.FlxSprite;
   import org.flixel.FlxText;
   
   public class MenuState extends FlxState
   {
       
      private var ImgBG:Class;
      
      public function MenuState()
      {
         ImgBG = title_screen_png$f768ce88d3245777fd2386baa47ab77a2128434415;
         super();
      }
      
      override public function create() : void
      {
         var _loc1_:* = null;
         FlxG.mouse.hide();
         var _loc2_:FlxSprite = new FlxSprite(0,0);
         _loc2_.loadGraphic(ImgBG,true,true,320,240,true);
         add(_loc2_);
         _loc1_ = new FlxText(-9,FlxG.height / 2 + 20,FlxG.width,"Press any key to play");
         _loc1_.alignment = "right";
         _loc1_.color = 16371892;
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
