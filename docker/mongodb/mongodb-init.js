db = db.getSiblingDB('ocr');

db.createUser(
   {
      user: "python",
      pwd:  "python-pwd",
      roles: [ { role: "readWrite", db: "ocr" } ]
   }
);

db.createCollection( "ocr.ligue1",
{
   validator: { $jsonSchema: {
      bsonType: "object",
      required: [ "club", "mj", "g", "n", "p", "bp", "bc" ],
      properties: {
         club: {  bsonType : "string",  description: "must be a string and is required"   },
         mj:   {  bsonType : "double",  description: "must be an integer and is required" },
         g:    {  bsonType : "double",  description: "must be an integer and is required" },
         n:    {  bsonType : "double",  description: "must be an integer and is required" },
         p:    {  bsonType : "double",  description: "must be an integer and is required" }
      }
   } }
} );

db.ocr.ligue1.insert({"club": "Paris-SG",   "mj": 17, "g": 13, "n": 3, "p": 1, "bp": 36, "bc": 16});
db.ocr.ligue1.insert({"club": "Rennes",     "mj": 17, "g":  9, "n": 4, "p": 4, "bp": 32, "bc": 14});
db.ocr.ligue1.insert({"club": "Marseille",  "mj": 16, "g":  8, "n": 5, "p": 3, "bp": 23, "bc": 14});
db.ocr.ligue1.insert({"club": "Nice",       "mj": 17, "g":  8, "n": 4, "p": 5, "bp": 25, "bc": 15});
db.ocr.ligue1.insert({"club": "Lens",       "mj": 17, "g":  7, "n": 6, "p": 4, "bp": 30, "bc": 23});
db.ocr.ligue1.insert({"club": "Strasbourg", "mj": 17, "g":  7, "n": 5, "p": 5, "bp": 34, "bc": 22});
db.ocr.ligue1.insert({"club": "Monaco",     "mj": 17, "g":  7, "n": 5, "p": 5, "bp": 27, "bc": 20});
db.ocr.ligue1.insert({"club": "Angers",     "mj": 17, "g":  6, "n": 7, "p": 4, "bp": 25, "bc": 22});
db.ocr.ligue1.insert({"club": "Montpellier","mj": 17, "g":  7, "n": 4, "p": 6, "bp": 25, "bc": 23});
db.ocr.ligue1.insert({"club": "Brest",      "mj": 17, "g":  6, "n": 6, "p": 5, "bp": 25, "bc": 23});
db.ocr.ligue1.insert({"club": "Lille",      "mj": 17, "g":  6, "n": 6, "p": 5, "bp": 23, "bc": 24});
db.ocr.ligue1.insert({"club": "Lyon",       "mj": 16, "g":  6, "n": 5, "p": 5, "bp": 25, "bc": 25});
db.ocr.ligue1.insert({"club": "Nantes",     "mj": 17, "g":  6, "n": 4, "p": 7, "bp": 21, "bc": 21});
db.ocr.ligue1.insert({"club": "Reims",      "mj": 17, "g":  4, "n": 7, "p": 6, "bp": 19, "bc": 21});
db.ocr.ligue1.insert({"club": "Troyes",     "mj": 17, "g":  4, "n": 4, "p": 9, "bp": 16, "bc": 25});
db.ocr.ligue1.insert({"club": "Lorient",    "mj": 17, "g":  3, "n": 6, "p": 8, "bp": 13, "bc": 26});
db.ocr.ligue1.insert({"club": "Bordeaux",   "mj": 17, "g":  2, "n": 8, "p": 7, "bp": 26, "bc": 39});
db.ocr.ligue1.insert({"club": "Clermont",   "mj": 17, "g":  3, "n": 5, "p": 9, "bp": 19, "bc": 32});
db.ocr.ligue1.insert({"club": "Metz",       "mj": 17, "g":  2, "n": 6, "p": 9, "bp": 18, "bc": 37});
db.ocr.ligue1.insert({"club": "St-Etienne", "mj": 17, "g":  2, "n": 6, "p": 9, "bp": 17, "bc": 37});
