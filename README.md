ActionMongo
===
 
Requirements:
---
 - [MongoDB Installed - Local or remote] (http://www.mongodb.org/display/DOCS/Quickstart)
 - [ActionBSON] (https://github.com/argoncloud/ActionBSON)
 
Add the classes to your projects src folder.
 
[Sample Adobe Air Project] (https://github.com/crosbymichael/ActionMongoDB-example-project)
 
Using ActionMongo
---
 
Connect to server:
	
    var mongo:Mongo = new Mongo("localhost");
 
Specify DB in server:
 
    var db:DB = mongo.getDB("database-name");
 
Specify Collection in database:
	
    var collection:Collection = db.getCollection("collection-name");
 
Create query:
	
    var query:Object = {}; //Return all documents from query
    var result:Object = null; //Do not filter any field results
 
Create cursor obj outside any functions:
	
    private var cursor:Cursor;
 
Assign cursor the results of the query.  Pass the query and results objs.  Also add getResults function for when the query is complete:
	
    cursor = collection.find(query, results, getResult);
 
Create function getResult():
	
    private function getResult():void { }
 
Itterate over the OpReply objects in cursor.replies(this is an array) inside the getResult func, assign results to an array collection:
	
    var documents:ArrayCollection = new ArrayCollection();
 
    for each (var reply:OpReply in cursor.replies) {
    documents.addAll(new ArrayCollection(reply.documents)); }
Inserting documents to mongo
---
In this fork I have added insert capabilities to the lib.  
To insert data into mongo, follow the directions above for connecting to the server > database > then collection.  
Insert is a method of Collection just as find is.
You need an array of one or more objects as the documents to insert.
 
    var documents:Array = [{"name": "value"}, {"name": "value"}];
 
Now pass the documents array to the insert method.
 
    collection.insert(documents);
 
The documents are now added to the collection in the mongo database. 
 
 
For a more in-depth tutorial go to:
 - [ActionScript3 and MongoDB] (http://www.crosbymichael.com/?p=66)