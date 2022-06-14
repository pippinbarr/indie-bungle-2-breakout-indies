package org.flixel.system.input
{
   import flash.events.KeyboardEvent;
   
   public class Keyboard extends Input
   {
       
      public var ESCAPE:Boolean;
      
      public var F1:Boolean;
      
      public var F2:Boolean;
      
      public var F3:Boolean;
      
      public var F4:Boolean;
      
      public var F5:Boolean;
      
      public var F6:Boolean;
      
      public var F7:Boolean;
      
      public var F8:Boolean;
      
      public var F9:Boolean;
      
      public var F10:Boolean;
      
      public var F11:Boolean;
      
      public var F12:Boolean;
      
      public var ONE:Boolean;
      
      public var TWO:Boolean;
      
      public var THREE:Boolean;
      
      public var FOUR:Boolean;
      
      public var FIVE:Boolean;
      
      public var SIX:Boolean;
      
      public var SEVEN:Boolean;
      
      public var EIGHT:Boolean;
      
      public var NINE:Boolean;
      
      public var ZERO:Boolean;
      
      public var NUMPADONE:Boolean;
      
      public var NUMPADTWO:Boolean;
      
      public var NUMPADTHREE:Boolean;
      
      public var NUMPADFOUR:Boolean;
      
      public var NUMPADFIVE:Boolean;
      
      public var NUMPADSIX:Boolean;
      
      public var NUMPADSEVEN:Boolean;
      
      public var NUMPADEIGHT:Boolean;
      
      public var NUMPADNINE:Boolean;
      
      public var NUMPADZERO:Boolean;
      
      public var PAGEUP:Boolean;
      
      public var PAGEDOWN:Boolean;
      
      public var HOME:Boolean;
      
      public var END:Boolean;
      
      public var INSERT:Boolean;
      
      public var MINUS:Boolean;
      
      public var NUMPADMINUS:Boolean;
      
      public var PLUS:Boolean;
      
      public var NUMPADPLUS:Boolean;
      
      public var DELETE:Boolean;
      
      public var BACKSPACE:Boolean;
      
      public var TAB:Boolean;
      
      public var Q:Boolean;
      
      public var W:Boolean;
      
      public var E:Boolean;
      
      public var R:Boolean;
      
      public var T:Boolean;
      
      public var Y:Boolean;
      
      public var U:Boolean;
      
      public var I:Boolean;
      
      public var O:Boolean;
      
      public var P:Boolean;
      
      public var LBRACKET:Boolean;
      
      public var RBRACKET:Boolean;
      
      public var BACKSLASH:Boolean;
      
      public var CAPSLOCK:Boolean;
      
      public var A:Boolean;
      
      public var S:Boolean;
      
      public var D:Boolean;
      
      public var F:Boolean;
      
      public var G:Boolean;
      
      public var H:Boolean;
      
      public var J:Boolean;
      
      public var K:Boolean;
      
      public var L:Boolean;
      
      public var SEMICOLON:Boolean;
      
      public var QUOTE:Boolean;
      
      public var ENTER:Boolean;
      
      public var SHIFT:Boolean;
      
      public var Z:Boolean;
      
      public var X:Boolean;
      
      public var C:Boolean;
      
      public var V:Boolean;
      
      public var B:Boolean;
      
      public var N:Boolean;
      
      public var M:Boolean;
      
      public var COMMA:Boolean;
      
      public var PERIOD:Boolean;
      
      public var NUMPADPERIOD:Boolean;
      
      public var SLASH:Boolean;
      
      public var NUMPADSLASH:Boolean;
      
      public var CONTROL:Boolean;
      
      public var ALT:Boolean;
      
      public var SPACE:Boolean;
      
      public var UP:Boolean;
      
      public var DOWN:Boolean;
      
      public var LEFT:Boolean;
      
      public var RIGHT:Boolean;
      
      public function Keyboard()
      {
         var _loc1_:* = 0;
         super();
         _loc1_ = 65;
         while(_loc1_ <= 90)
         {
            addKey(String.fromCharCode(_loc1_),_loc1_++);
         }
         _loc1_ = 48;
         addKey("ZERO",_loc1_++);
         addKey("ONE",_loc1_++);
         addKey("TWO",_loc1_++);
         addKey("THREE",_loc1_++);
         addKey("FOUR",_loc1_++);
         addKey("FIVE",_loc1_++);
         addKey("SIX",_loc1_++);
         addKey("SEVEN",_loc1_++);
         addKey("EIGHT",_loc1_++);
         addKey("NINE",_loc1_++);
         _loc1_ = 96;
         addKey("NUMPADZERO",_loc1_++);
         addKey("NUMPADONE",_loc1_++);
         addKey("NUMPADTWO",_loc1_++);
         addKey("NUMPADTHREE",_loc1_++);
         addKey("NUMPADFOUR",_loc1_++);
         addKey("NUMPADFIVE",_loc1_++);
         addKey("NUMPADSIX",_loc1_++);
         addKey("NUMPADSEVEN",_loc1_++);
         addKey("NUMPADEIGHT",_loc1_++);
         addKey("NUMPADNINE",_loc1_++);
         addKey("PAGEUP",33);
         addKey("PAGEDOWN",34);
         addKey("HOME",36);
         addKey("END",35);
         addKey("INSERT",45);
         _loc1_ = 1;
         while(_loc1_ <= 12)
         {
            addKey("F" + _loc1_,111 + _loc1_++);
         }
         addKey("ESCAPE",27);
         addKey("MINUS",189);
         addKey("NUMPADMINUS",109);
         addKey("PLUS",187);
         addKey("NUMPADPLUS",107);
         addKey("DELETE",46);
         addKey("BACKSPACE",8);
         addKey("LBRACKET",219);
         addKey("RBRACKET",221);
         addKey("BACKSLASH",220);
         addKey("CAPSLOCK",20);
         addKey("SEMICOLON",186);
         addKey("QUOTE",222);
         addKey("ENTER",13);
         addKey("SHIFT",16);
         addKey("COMMA",188);
         addKey("PERIOD",190);
         addKey("NUMPADPERIOD",110);
         addKey("SLASH",191);
         addKey("NUMPADSLASH",191);
         addKey("CONTROL",17);
         addKey("ALT",18);
         addKey("SPACE",32);
         addKey("UP",38);
         addKey("DOWN",40);
         addKey("LEFT",37);
         addKey("RIGHT",39);
         addKey("TAB",9);
      }
      
      public function handleKeyDown(param1:KeyboardEvent) : void
      {
         var _loc2_:Object = _map[param1.keyCode];
         if(_loc2_ == null)
         {
            return;
         }
         if(_loc2_.current > 0)
         {
            _loc2_.current = 1;
         }
         else
         {
            _loc2_.current = 2;
         }
         this[_loc2_.name] = true;
      }
      
      public function handleKeyUp(param1:KeyboardEvent) : void
      {
         var _loc2_:Object = _map[param1.keyCode];
         if(_loc2_ == null)
         {
            return;
         }
         if(_loc2_.current > 0)
         {
            _loc2_.current = -1;
         }
         else
         {
            _loc2_.current = 0;
         }
         this[_loc2_.name] = false;
      }
   }
}
