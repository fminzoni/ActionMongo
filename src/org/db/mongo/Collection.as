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
	import flash.utils.ByteArray;
	
	import org.db.mongo.mwp.OpQuery;

	public class Collection
	{
		
		private var mongo : Mongo;
		private var dbName : String;
		private var collName : String;
		private var socket : Socket;
		private var cursor : Cursor;
		
		public function Collection( mongo : Mongo, dbName : String, collName : String, socket:Socket ) {
			this.mongo = mongo;
			this.dbName = dbName;
			this.collName = collName;
			this.cursor = cursor;
			this.socket = socket;
		}
		
		public function find( query : Document, returnFieldSelector : Document = null, readAll : Function = null ) : Cursor {
			var queryID : int = mongo.getUniqueID();
			var opquery : OpQuery = new OpQuery( queryID, 0, dbName + "." + collName, 0, 0, query, returnFieldSelector );
			var cursor : Cursor = new Cursor( dbName, collName, opquery, queryID, readAll );
			cursor.sendQuery(socket);			
			
			return cursor;
		}
		
		public function findOne( query : Document, returnFieldSelector : Document = null, readAll : Function = null ) : Cursor {
			var queryID : int = mongo.getUniqueID();
			var opquery : OpQuery = new OpQuery( queryID, 0, dbName + "." + collName, 0, 1, query, returnFieldSelector );
			var cursor : Cursor = new Cursor( dbName, collName, opquery, queryID, readAll );		
			cursor.sendQuery(socket);
						
			return cursor;
		}
		
		
	}
}