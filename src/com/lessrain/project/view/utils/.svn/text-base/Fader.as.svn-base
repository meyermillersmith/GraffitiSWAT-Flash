package com.lessrain.project.view.utils {
	import com.greensock.TweenLite;
	import com.greensock.easing.Sine;

	import flash.display.DisplayObject;

	/**
	 * @author lessintern
	 */
	public class Fader {

		public static const IN : String = 'fadeIn';
		public static const OUT : String = 'fadeOut';

		public static function fade(type : String, target : DisplayObject, onComplete_ : Function = null, time : Number = .2) : void {
			target.alpha = type == IN ? 0 : 1;
			TweenLite.killTweensOf(target);
			TweenLite.to(target, time, {alpha : type == IN ? 1 : 0, ease : type == IN ? Sine.easeIn : Sine.easeOut, onComplete : onComplete_});
		}
		
		public static function fadeIn(target : DisplayObject, onComplete_ : Function = null, time : Number = .2) : void {
			fade(IN, target, onComplete_, time);
		}
		
		public static function fadeOut(target : DisplayObject, onComplete_ : Function = null, time : Number = .2) : void {
			fade(OUT, target, onComplete_, time);
		}
	}
}
