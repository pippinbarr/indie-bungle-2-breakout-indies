package
{
   import Box2D.Dynamics.b2ContactListener;
   import org.flixel.FlxText;
   import Box2D.Dynamics.Contacts.b2Contact;
   import Box2D.Dynamics.b2Fixture;
   import org.flixel.FlxG;
   
   public class DollContactListener extends b2ContactListener
   {
       
      private var SndToy1:Class;
      
      private var SndToy2:Class;
      
      private var SndToy3:Class;
      
      private var SndToy4:Class;
      
      private var SndToy5:Class;
      
      private var SndToy6:Class;
      
      private var SndToy7:Class;
      
      private var Blegh:Class;
      
      private var Confused:Class;
      
      private var Hehe:Class;
      
      private var Hmm:Class;
      
      private var Hmph:Class;
      
      private var Kissu:Class;
      
      private var Ooh:Class;
      
      private var Uh:Class;
      
      public var t:FlxText;
      
      public var face:Face;
      
      public var sex:Number = 0;
      
      public var isColliding:Boolean = false;
      
      public function DollContactListener(param1:Face)
      {
         SndToy1 = toy1_mp3$f9f3df6ab771acb742b767bde523a1f6375508787;
         SndToy2 = toy2_mp3$632935aa30638ba6b31bc01d081909bf376956082;
         SndToy3 = toy3_mp3$0df4fcc466721637ec045557d39d6524373562421;
         SndToy4 = toy4_mp3$c57f6e140b09265d2bb3b89679cf3265373962164;
         SndToy5 = toy5_mp3$7d10397c6d95f59eb0d1b9c8bfdc5e88374877495;
         SndToy6 = toy6_mp3$4403eed84ab14d59186ac8d97fa7063d363741878;
         SndToy7 = toy7_mp3$d0dd6040cb928d6d0ab922da243c10b9364673577;
         Blegh = blegh_mp3$9eaa3f70bf10159d946f6869a33a915d1476674448;
         Confused = confused_mp3$a3e0d136609c2fb91888417a2494e5f91860792929;
         Hehe = hehe_mp3$061aa0034cc884e1390b159dea6a4874532137864;
         Hmm = hmm_mp3$59b669085dd311694a1437988b06109b1936232780;
         Hmph = §hmph_mp3$e1a7ea29c86e4f93cbef6680406a5c36-1565479667§;
         Kissu = kissu_mp3$8cc88103707fb77f94b4e0de55f611cd663443613;
         Ooh = §ooh_mp3$ad99084d3c5eb4f092e12daff3ac0828-979809332§;
         Uh = uh_mp3$207edbe5dcbfe548026d500029635b9a42687219;
         t = new FlxText(200,200,100,"COLLIDING");
         super();
         this.face = param1;
      }
      
      override public function BeginContact(param1:b2Contact) : void
      {
         var _loc3_:* = NaN;
         var _loc4_:b2Fixture = param1.GetFixtureA();
         var _loc5_:b2Fixture = param1.GetFixtureB();
         var _loc2_:Number = FlxG.random() * 12;
         if(_loc4_.IsSensor() && _loc5_.IsSensor())
         {
            this.isColliding = true;
            this.face.increaseBlush();
            if(_loc4_.GetUserData().toString() == "HEAD")
            {
               if(_loc5_.GetUserData().toString() == "HEAD")
               {
                  this.face.play("excited");
                  if(_loc2_ < 1)
                  {
                     FlxG.play(Kissu);
                  }
               }
            }
            if(_loc4_.GetUserData().toString() == "GROIN")
            {
               if(_loc5_.GetUserData().toString() == "GROIN")
               {
                  this.face.play("surprised");
                  if(_loc2_ < 1)
                  {
                     FlxG.play(Ooh);
                  }
               }
            }
            if(_loc4_.GetUserData().toString() == "HEAD")
            {
               if(_loc5_.GetUserData().toString() == "GROIN")
               {
                  this.face.play("disgusted");
                  if(_loc2_ < 1)
                  {
                     FlxG.play(Hmph);
                  }
               }
            }
            if(_loc5_.GetUserData().toString() == "HEAD")
            {
               if(_loc4_.GetUserData().toString() == "GROIN")
               {
                  this.face.play("disgusted");
                  if(_loc2_ < 1)
                  {
                     FlxG.play(Hmm);
                  }
               }
            }
            if(_loc4_.GetUserData().toString() == "HEAD")
            {
               if(_loc5_.GetUserData().toString() == "L_HAND")
               {
                  this.face.play("confused");
                  if(_loc2_ < 1)
                  {
                     FlxG.play(Uh);
                  }
               }
            }
            if(_loc5_.GetUserData().toString() == "HEAD")
            {
               if(_loc4_.GetUserData().toString() == "L_HAND")
               {
                  this.face.play("confused");
                  if(_loc2_ < 1)
                  {
                     FlxG.play(Hmm);
                  }
               }
            }
            if(_loc4_.GetUserData().toString() == "HEAD")
            {
               if(_loc5_.GetUserData().toString() == "R_HAND")
               {
                  this.face.play("confused");
                  if(_loc2_ < 1)
                  {
                     FlxG.play(Uh);
                  }
               }
            }
            if(_loc5_.GetUserData().toString() == "HEAD")
            {
               if(_loc4_.GetUserData().toString() == "R_HAND")
               {
                  this.face.play("confused");
                  if(_loc2_ < 1)
                  {
                     FlxG.play(Confused);
                  }
               }
            }
            if(_loc4_.GetUserData().toString() == "GROIN")
            {
               if(_loc5_.GetUserData().toString() == "L_HAND")
               {
                  this.face.play("excited");
                  if(_loc2_ < 1)
                  {
                     FlxG.play(Hehe);
                  }
               }
            }
            if(_loc5_.GetUserData().toString() == "GROIN")
            {
               if(_loc4_.GetUserData().toString() == "L_HAND")
               {
                  this.face.play("disgusted");
                  if(_loc2_ < 1)
                  {
                     FlxG.play(Blegh);
                  }
               }
            }
            if(_loc4_.GetUserData().toString() == "GROIN")
            {
               if(_loc5_.GetUserData().toString() == "R_HAND")
               {
                  this.face.play("disgusted");
                  if(_loc2_ < 1)
                  {
                     FlxG.play(Ooh);
                  }
               }
            }
            if(_loc5_.GetUserData().toString() == "GROIN")
            {
               if(_loc4_.GetUserData().toString() == "R_HAND")
               {
                  this.face.play("surprised");
                  if(_loc2_ < 1)
                  {
                     FlxG.play(Hehe);
                  }
               }
            }
            _loc3_ = FlxG.random() * 12;
            if(_loc3_ < 1)
            {
               FlxG.play(SndToy1);
            }
            else if(_loc3_ < 2)
            {
               FlxG.play(SndToy2);
            }
            else if(_loc3_ < 3)
            {
               FlxG.play(SndToy3);
            }
            else if(_loc3_ < 4)
            {
               FlxG.play(SndToy4);
            }
            else if(_loc3_ < 5)
            {
               FlxG.play(SndToy5);
            }
            else if(_loc3_ < 6)
            {
               FlxG.play(SndToy6);
            }
            else if(_loc3_ < 7)
            {
               FlxG.play(SndToy7);
            }
         }
      }
      
      override public function EndContact(param1:b2Contact) : void
      {
         var _loc2_:b2Fixture = param1.GetFixtureA();
         var _loc3_:b2Fixture = param1.GetFixtureB();
         if(_loc2_.IsSensor() && _loc3_.IsSensor())
         {
            sex = sex + 1;
            this.isColliding = false;
         }
      }
   }
}
