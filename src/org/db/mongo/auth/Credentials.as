package org.db.mongo.auth
{		
	import com.adobe.crypto.MD5;

	[Bindable]
	public class Credentials
	{
		private var username:String;
		private var password:String;
		
		public function Credentials(username:String, password:String)
		{
			this.username = username;
			this.password = password;
		}
		
		public function get UserName():String {
			return username;
		}
		
		public function getCredentialsHash():String
		{
			const preHash:String = username + ":mongo:" + password;
			
			return MD5.hash(preHash);
		}
		
		public function getAuthenticationDigest(nonce:String):String
		{						
			var hash:String = nonce + username + getCredentialsHash();
			return MD5.hash(hash);
		}
	}
}