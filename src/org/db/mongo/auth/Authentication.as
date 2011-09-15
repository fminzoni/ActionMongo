package org.db.mongo.auth
{
	import mx.collections.ArrayCollection;
	import mx.utils.ObjectUtil;
	
	import org.db.mongo.Collection;
	import org.db.mongo.Cursor;
	import org.db.mongo.DB;
	import org.db.mongo.Document;
	import org.db.mongo.mwp.OpReply;

	public class Authentication
	{
		
		private var db:DB;
		private var cmdColl:Collection;
		private var nonceCursor:Cursor;
		private var authCursor:Cursor;
		private var credentials:Credentials;
		private var functionHandler : Function;

		public function Authentication(db:DB,credentials:Credentials)
		{
			this.db = db;
			this.credentials = credentials;			
		}
		
		public function login(functionHandler: Function):void
		{
			this.functionHandler=functionHandler;
			getNonce();
		}

		private function getNonce():void
		{
			// query("getnonce:1");			
			nonceCursor = db.getNonce(getNonceHandler);			
		}
		
		private function getNonceHandler():void
		{			
			var documents : ArrayCollection = new ArrayCollection();
			for each( var reply : OpReply in nonceCursor.replies ) {
				documents.addAll( new ArrayCollection( reply.documents ) );
			}
			if (documents.length == 1 && documents[0].ok == 1)
				if (documents[0].nonce != null)
					authenticate(documents[0].nonce);								
		}
			
		private function authenticate(Nonce:String):void
		{
			var digest:String = credentials.getAuthenticationDigest(Nonce);
			var authCmd:Document = new Document();
			authCmd.put("authenticate", "1");
			authCmd.put("user", credentials.UserName);
			authCmd.put("nonce", Nonce);			
			authCmd.put("key", digest);
			authCursor = db.runCommand(authCmd, getAuthenticateHandler);	
		}	
		
		private function getAuthenticateHandler():void
		{
			var logged:Boolean=false
			var documents : ArrayCollection = new ArrayCollection();
			for each( var reply : OpReply in authCursor.replies ) {
				documents.addAll( new ArrayCollection( reply.documents ) );
			}
			if (documents.length == 1 && documents[0].ok == 1)
			{
				trace("auth ok");
				logged=true;
			}
				
			functionHandler(logged);
		}
	}
}
