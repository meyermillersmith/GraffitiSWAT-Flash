package com.lessrain.project.view.utils {
	/**
	 * @author lessintern
	 */
	public class LessMath {
		public static function pow2(n:Number):Number{
			return Math.pow(n,2);
		}
		public static function pow4(n:Number):Number{
			return Math.pow(n,4);
		}
		public static function rand(min:int, max:int):Number{
			return min + Math.floor(Math.random()*(1+max-min));
		}
	}
}
