/*
 * Copyright (c) 2010 Claudio Alberto Andreoni.
 *	
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 	
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * 
 */

package org.db.mongo
{
	import flash.events.Event;
	import flash.net.Socket;
	
	import org.db.mongo.mwp.OpQuery;

	public class DB
	{
		
		private var mongo : Mongo;
		private var dbName : String;
		private var socket : Socket;
		private var cursor : Cursor;
		
		public function DB( mongo : Mongo, dbName : String ) {
			this.mongo = mongo;
			this.dbName = dbName;
		}
		
		/**
		 * @brief create the socket		
		 */
		public function connect():void {
			socket = new Socket();
			socket.connect( mongo.getCurrentHost(), mongo.getCurrentPort() );
		}
		
		/**
		 * @brief Get a collection from the database
		 * @return A collection from the database
		 */
		public function getCollection( collName : String ) : Collection {
			return new Collection( mongo, dbName, collName, socket );
		}
				
		public function getNonce( readAll : Function = null ) : Cursor {
			var query : Document = new Document();
			query.put("getnonce",1);
			var queryID : int = mongo.getUniqueID();
			var opquery : OpQuery = new OpQuery( queryID, 0, dbName + "." + "$cmd", 0, 1, query );
			cursor = new Cursor( dbName, "$cmd", opquery, queryID, readAll );
			cursor.sendQuery(socket);		
			return cursor;
		}
		
		public function runCommand( cmd : Document, readAll : Function = null ) : Cursor {
			var queryID : int = mongo.getUniqueID();
			var opquery : OpQuery = new OpQuery( queryID, 0, dbName + "." + "$cmd", 0, -1, cmd, null );
			cursor = new Cursor( dbName, "$cmd", opquery, queryID, readAll );				
			cursor.sendQuery(socket);			
			return cursor;
		}
				
		/*public function executeCommand() : Object {
			blah;
		}*/
		
		public function close():void
		{
			socket.close();
		}
	}
}