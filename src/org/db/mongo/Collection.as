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
	import flash.events.IOErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	import org.db.mongo.mwp.OpDelete;
	import org.db.mongo.mwp.OpInsert;
	import org.db.mongo.mwp.OpQuery;
	import org.db.mongo.mwp.OpUpdate;

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
		
		public function find( query : Document, returnFieldSelector : Document = null, readAll : Function = null, numberToSkip : int = 0, numberToReturn : int = 0 ) : Cursor {
			var queryID : int = mongo.getUniqueID();
			var opquery : OpQuery = new OpQuery( queryID, 0, dbName + "." + collName, numberToSkip, numberToReturn, query, returnFieldSelector );
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

		public function insert(documents:Array, returnFieldSelector:Object = null, readAll:Function = null):void {
			var insertID:int = mongo.getUniqueID();
			var opinsert:OpInsert = new OpInsert(insertID, dbName + "." + collName, documents);
			
			var insertDoc:InsertDocument = new InsertDocument(opinsert);
			
			insertDoc.insertDocument(socket);
		}
		
		public function deleteDoc(documents:Array, returnFieldSelector:Object = null, readAll:Function = null):void {
			var deleteID:int = mongo.getUniqueID();
			var opDelete:OpDelete = new OpDelete(deleteID, dbName + "." + collName, 0, documents[0] as Document);
			
			var deleteDoc:DeleteDocument = new DeleteDocument(opDelete);
			
			deleteDoc.deleteDocument(socket);
		}
		
		
		public function update(documents:Array, returnFieldSelector:Object = null, readAll:Function = null):void {
			var requestID:int = mongo.getUniqueID();
			
			var doc:Document = documents[0];
			var updateId:Document = new Document();
			var updateQuery:Document = new Document();
			
			for ( var i:int=0;i< doc.FieldsCount ; i++)
			{
				if(doc.getKeyAt(i)=="_id")
					updateId.put(doc.getKeyAt(i),doc.getValueAt(i));
				else
					updateQuery.put(doc.getKeyAt(i),doc.getValueAt(i));
			}
			var opUpdate:OpUpdate = new OpUpdate(requestID, dbName + "." + collName, 0, updateId,updateQuery);
			
			var updateDoc:UpdateDocument = new UpdateDocument(opUpdate);
			
			updateDoc.updateDocument(socket);
		}
	}
}