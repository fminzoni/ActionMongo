ActionMongo
===

Requirements:
---
 - [MongoDB Installed - Locall or remote] (http://www.mongodb.org/display/DOCS/Quickstart)
 - [ActionBSON] (https://github.com/argoncloud/ActionBSON)
 - [OSMF] (http://sourceforge.net/projects/osmf.adobe/files/OSMF%201.6%20-%20Sprint%205%20%28pre-release%20source%2C%20documentation%20and%20release%20notes%29/OSMF.swc/download)
 - [AbsoluteLayoutFacet] (http://dev.crosbymichael.com/downloads/?file=AbsoluteLayoutFacet.zip)

Libs:
Make sure you add the OSMF.swc to your project's properties.  Add ActionMongo, ActionBSON, and AbsoluteLayoutFacet to your project's src folder. These will go under org package.
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

Assign cursor the results of the query.  Pass the query and results objs.  Also a getResults function for when the query is complete:
	
    cursor = collection.find(query, results, getResult);

Create function getResult():
	
    private function getResult():void { }

Itterate over the OpReply objects in cursor.replies(this is an array) inside the getResult func, assign results to an array collection:
	
    var documents:ArrayCollection = new ArrayCollection();

    for each (var reply:OpReply in cursor.replies) {
    documents.addAll(new ArrayCollection(reply.documents)); }

For a more in-depth tutorial go to:
 - [ActionScript3 and MongoDB] (http://www.crosbymichael.com/?p=66)
