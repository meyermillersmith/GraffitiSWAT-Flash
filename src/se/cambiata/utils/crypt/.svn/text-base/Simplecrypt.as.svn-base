package se.cambiata.utils.crypt {
	
	// The Base64 class is developed by Sven Dens, and can be found here: 
	// http://labs.boulevart.be/index.php/2007/05/23/encryption-in-as2-and-as3/
	import be.boulevart.as3.security.Base64;
	
	public class Simplecrypt {
		static public function encrypt(str:String, key:String = '%key&'):String {
			var result:String = '';
			for (var i:int = 0; i < str.length; i++) {
				var char:String = str.substr(i, 1);
				var keychar:String = key.substr((i % key.length) - 1, 1);
				var ordChar:int = char.charCodeAt(0);
				var ordKeychar:int = keychar.charCodeAt(0);
				var sum:int = ordChar + ordKeychar;
				char = String.fromCharCode(sum);
				result = result + char;
			}
			return Base64.encode(result);
		}

		static public function decrypt(str:String, key:String = '%key&'):String {
			var result:String = '';
			var str:String = Base64.decode(str);
			
			for (var i:int = 0; i < str.length; i++) {
				var char:String = str.substr(i, 1);
				var keychar:String = key.substr((i % key.length) - 1, 1);
				var ordChar:int = char.charCodeAt(0);
				var ordKeychar:int = keychar.charCodeAt(0);
				var sum:int = ordChar - ordKeychar;
				char = String.fromCharCode(sum);
				result = result + char;
			}
			return result;
		}
	}
}
