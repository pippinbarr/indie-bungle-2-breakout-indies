package org.flixel
{
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.net.URLRequest;
   import flash.events.Event;
   
   public class FlxSound extends FlxBasic
   {
       
      public var x:Number;
      
      public var y:Number;
      
      public var survive:Boolean;
      
      public var name:String;
      
      public var artist:String;
      
      public var amplitude:Number;
      
      public var amplitudeLeft:Number;
      
      public var amplitudeRight:Number;
      
      public var autoDestroy:Boolean;
      
      protected var _sound:Sound;
      
      protected var _channel:SoundChannel;
      
      protected var _transform:SoundTransform;
      
      protected var _position:Number;
      
      protected var _volume:Number;
      
      protected var _volumeAdjust:Number;
      
      protected var _looped:Boolean;
      
      protected var _target:org.flixel.FlxObject;
      
      protected var _radius:Number;
      
      protected var _pan:Boolean;
      
      protected var _fadeOutTimer:Number;
      
      protected var _fadeOutTotal:Number;
      
      protected var _pauseOnFadeOut:Boolean;
      
      protected var _fadeInTimer:Number;
      
      protected var _fadeInTotal:Number;
      
      public function FlxSound()
      {
         super();
         createSound();
      }
      
      protected function createSound() : void
      {
         destroy();
         x = 0;
         y = 0;
         if(_transform == null)
         {
            _transform = new SoundTransform();
         }
         _transform.pan = 0;
         _sound = null;
         _position = 0;
         _volume = 1;
         _volumeAdjust = 1;
         _looped = false;
         _target = null;
         _radius = 0;
         _pan = false;
         _fadeOutTimer = 0;
         _fadeOutTotal = 0;
         _pauseOnFadeOut = false;
         _fadeInTimer = 0;
         _fadeInTotal = 0;
         exists = false;
         active = false;
         visible = false;
         name = null;
         artist = null;
         amplitude = 0;
         amplitudeLeft = 0;
         amplitudeRight = 0;
         autoDestroy = false;
      }
      
      override public function destroy() : void
      {
         kill();
         _transform = null;
         _sound = null;
         _channel = null;
         _target = null;
         name = null;
         artist = null;
         super.destroy();
      }
      
      override public function update() : void
      {
         var _loc3_:* = NaN;
         if(_position != 0)
         {
            return;
         }
         var _loc1_:* = 1.0;
         var _loc2_:* = 1.0;
         if(_target != null)
         {
            _loc1_ = FlxU.getDistance(new FlxPoint(_target.x,_target.y),new FlxPoint(x,y)) / _radius;
            if(_loc1_ < 0)
            {
               _loc1_ = 0.0;
            }
            if(_loc1_ > 1)
            {
               _loc1_ = 1.0;
            }
            if(_pan)
            {
               _loc3_ = (_target.x - x) / _radius;
               if(_loc3_ < -1)
               {
                  _loc3_ = -1.0;
               }
               else if(_loc3_ > 1)
               {
                  _loc3_ = 1.0;
               }
               _transform.pan = _loc3_;
            }
         }
         if(_fadeOutTimer > 0)
         {
            _fadeOutTimer = §§dup()._fadeOutTimer - FlxG.elapsed;
            if(_fadeOutTimer <= 0)
            {
               if(_pauseOnFadeOut)
               {
                  pause();
               }
               else
               {
                  stop();
               }
            }
            _loc2_ = _fadeOutTimer / _fadeOutTotal;
            if(_loc2_ < 0)
            {
               _loc2_ = 0.0;
            }
         }
         else if(_fadeInTimer > 0)
         {
            _fadeInTimer = §§dup()._fadeInTimer - FlxG.elapsed;
            _loc2_ = _fadeInTimer / _fadeInTotal;
            if(_loc2_ < 0)
            {
               _loc2_ = 0.0;
            }
            _loc2_ = 1 - _loc2_;
         }
         _volumeAdjust = _loc1_ * _loc2_;
         updateTransform();
         if(_transform.volume > 0 && _channel != null)
         {
            amplitudeLeft = _channel.leftPeak / _transform.volume;
            amplitudeRight = _channel.rightPeak / _transform.volume;
            amplitude = (amplitudeLeft + amplitudeRight) * 0.5;
         }
      }
      
      override public function kill() : void
      {
         super.kill();
         if(_channel != null)
         {
            stop();
         }
      }
      
      public function loadEmbedded(param1:Class, param2:Boolean = false, param3:Boolean = false) : FlxSound
      {
         stop();
         createSound();
         _sound = new param1();
         _looped = param2;
         updateTransform();
         exists = true;
         return this;
      }
      
      public function loadStream(param1:String, param2:Boolean = false, param3:Boolean = false) : FlxSound
      {
         stop();
         createSound();
         _sound = new Sound();
         _sound.addEventListener("id3",gotID3);
         _sound.load(new URLRequest(param1));
         _looped = param2;
         updateTransform();
         exists = true;
         return this;
      }
      
      public function proximity(param1:Number, param2:Number, param3:org.flixel.FlxObject, param4:Number, param5:Boolean = true) : FlxSound
      {
         x = param1;
         y = param2;
         _target = param3;
         _radius = param4;
         _pan = param5;
         return this;
      }
      
      public function play(param1:Boolean = false) : void
      {
         var _loc2_:* = false;
         if(_position < 0)
         {
            return;
         }
         if(param1)
         {
            _loc2_ = autoDestroy;
            autoDestroy = false;
            stop();
            autoDestroy = _loc2_;
         }
         if(_looped)
         {
            if(_position == 0)
            {
               if(_channel == null)
               {
                  _channel = _sound.play(0,9999,_transform);
               }
               if(_channel == null)
               {
                  exists = false;
               }
            }
            else
            {
               _channel = _sound.play(_position,0,_transform);
               if(_channel == null)
               {
                  exists = false;
               }
               else
               {
                  _channel.addEventListener("soundComplete",looped);
               }
            }
         }
         else if(_position == 0)
         {
            if(_channel == null)
            {
               _channel = _sound.play(0,0,_transform);
               if(_channel == null)
               {
                  exists = false;
               }
               else
               {
                  _channel.addEventListener("soundComplete",stopped);
               }
            }
         }
         else
         {
            _channel = _sound.play(_position,0,_transform);
            if(_channel == null)
            {
               exists = false;
            }
         }
         active = _channel != null;
         _position = 0;
      }
      
      public function resume() : void
      {
         if(_position <= 0)
         {
            return;
         }
         if(_looped)
         {
            _channel = _sound.play(_position,0,_transform);
            if(_channel == null)
            {
               exists = false;
            }
            else
            {
               _channel.addEventListener("soundComplete",looped);
            }
         }
         else
         {
            _channel = _sound.play(_position,0,_transform);
            if(_channel == null)
            {
               exists = false;
            }
         }
         active = _channel != null;
      }
      
      public function pause() : void
      {
         if(_channel == null)
         {
            _position = -1;
            return;
         }
         _position = _channel.position;
         _channel.stop();
         if(_looped)
         {
            while(_position >= _sound.length)
            {
               _position = §§dup()._position - _sound.length;
            }
         }
         if(_position <= 0)
         {
            _position = 1;
         }
         _channel = null;
         active = false;
      }
      
      public function stop() : void
      {
         _position = 0;
         if(_channel != null)
         {
            _channel.stop();
            stopped();
         }
      }
      
      public function fadeOut(param1:Number, param2:Boolean = false) : void
      {
         _pauseOnFadeOut = param2;
         _fadeInTimer = 0;
         _fadeOutTimer = param1;
         _fadeOutTotal = _fadeOutTimer;
      }
      
      public function fadeIn(param1:Number) : void
      {
         _fadeOutTimer = 0;
         _fadeInTimer = param1;
         _fadeInTotal = _fadeInTimer;
         play();
      }
      
      public function get volume() : Number
      {
         return _volume;
      }
      
      public function set volume(param1:Number) : void
      {
         _volume = param1;
         if(_volume < 0)
         {
            _volume = 0;
         }
         else if(_volume > 1)
         {
            _volume = 1;
         }
         updateTransform();
      }
      
      public function getActualVolume() : Number
      {
         return _volume * _volumeAdjust;
      }
      
      function updateTransform() : void
      {
         _transform.volume = (FlxG.mute?0:1.0) * FlxG.volume * _volume * _volumeAdjust;
         if(_channel != null)
         {
            _channel.soundTransform = _transform;
         }
      }
      
      protected function looped(param1:Event = null) : void
      {
         if(_channel == null)
         {
            return;
         }
         _channel.removeEventListener("soundComplete",looped);
         _channel = null;
         play();
      }
      
      protected function stopped(param1:Event = null) : void
      {
         if(!_looped)
         {
            _channel.removeEventListener("soundComplete",stopped);
         }
         else
         {
            _channel.removeEventListener("soundComplete",looped);
         }
         _channel = null;
         active = false;
         if(autoDestroy)
         {
            destroy();
         }
      }
      
      protected function gotID3(param1:Event = null) : void
      {
         FlxG.log("got ID3 info!");
         if(_sound.id3.songName.length > 0)
         {
            name = _sound.id3.songName;
         }
         if(_sound.id3.artist.length > 0)
         {
            artist = _sound.id3.artist;
         }
         _sound.removeEventListener("id3",gotID3);
      }
   }
}
