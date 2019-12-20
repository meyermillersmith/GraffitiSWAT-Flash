package com.lessrain.project.view.utils {
	/**
	 * @author lessintern
	 */
	public class Encrypt {
		public static function createRandomKey(amount : int) : String {
			var keyset : String = "abcdefghijklmABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
			var randkey : String = "";
			for (var i:int = 0; i < amount; i++) {
				randkey += keyset.substr(LessMath.rand(0, keyset.length - 1), 1);
			}
			return randkey;
		}
	}
}
