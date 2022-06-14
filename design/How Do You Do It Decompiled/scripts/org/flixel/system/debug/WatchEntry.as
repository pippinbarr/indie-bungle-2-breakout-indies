package org.flixel.system.debug
{
   import flash.text.TextField;
   import flash.text.TextFormat;
   import org.flixel.FlxU;
   import flash.events.MouseEvent;
   import flash.events.KeyboardEvent;
   
   public class WatchEntry
   {
       
      public var object:Object;
      
      public var field:String;
      
      public var custom:String;
      
      public var nameDisplay:TextField;
      
      public var valueDisplay:TextField;
      
      public var editing:Boolean;
      
      public var oldValue:Object;
      
      protected var _whiteText:TextFormat;
      
      protected var _blackText:TextFormat;
      
      public function WatchEntry(param1:Number, param2:Number, param3:Number, param4:Object, param5:String, param6:String = null)
      {
         super();
         editing = false;
         object = param4;
         field = param5;
         custom = param6;
         _whiteText = new TextFormat("Courier",12,16777215);
         _blackText = new TextFormat("Courier",12,0);
         nameDisplay = new TextField();
         nameDisplay.y = param1;
         nameDisplay.multiline = false;
         nameDisplay.selectable = true;
         nameDisplay.defaultTextFormat = _whiteText;
         valueDisplay = new TextField();
         valueDisplay.y = param1;
         valueDisplay.height = 15;
         valueDisplay.multiline = false;
         valueDisplay.selectable = true;
         valueDisplay.doubleClickEnabled = true;
         valueDisplay.addEventListener("keyUp",onKeyUp);
         valueDisplay.addEventListener("mouseUp",onMouseUp);
         valueDisplay.background = false;
         valueDisplay.backgroundColor = 16777215;
         valueDisplay.defaultTextFormat = _whiteText;
         updateWidth(param2,param3);
      }
      
      public function destroy() : void
      {
         object = null;
         oldValue = null;
         nameDisplay = null;
         field = null;
         custom = null;
         valueDisplay.removeEventListener("mouseUp",onMouseUp);
         valueDisplay.removeEventListener("keyUp",onKeyUp);
         valueDisplay = null;
      }
      
      public function setY(param1:Number) : void
      {
         nameDisplay.y = param1;
         valueDisplay.y = param1;
      }
      
      public function updateWidth(param1:Number, param2:Number) : void
      {
         nameDisplay.width = param1;
         valueDisplay.width = param2;
         if(custom != null)
         {
            nameDisplay.text = custom;
         }
         else
         {
            nameDisplay.text = "";
            if(param1 > 120)
            {
               nameDisplay.appendText(FlxU.getClassName(object,param1 < 240) + ".");
            }
            nameDisplay.appendText(field);
         }
      }
      
      public function updateValue() : Boolean
      {
         if(editing)
         {
            return false;
         }
         valueDisplay.text = object[field].toString();
         return true;
      }
      
      public function onMouseUp(param1:MouseEvent) : void
      {
         editing = true;
         oldValue = object[field];
         valueDisplay.type = "input";
         valueDisplay.setTextFormat(_blackText);
         valueDisplay.background = true;
      }
      
      public function onKeyUp(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 13 || param1.keyCode == 9 || param1.keyCode == 27)
         {
            if(param1.keyCode == 27)
            {
               cancel();
            }
            else
            {
               submit();
            }
         }
      }
      
      public function cancel() : void
      {
         valueDisplay.text = oldValue.toString();
         doneEditing();
      }
      
      public function submit() : void
      {
         object[field] = valueDisplay.text;
         doneEditing();
      }
      
      protected function doneEditing() : void
      {
         valueDisplay.type = "dynamic";
         valueDisplay.setTextFormat(_whiteText);
         valueDisplay.defaultTextFormat = _whiteText;
         valueDisplay.background = false;
         editing = false;
      }
   }
}
