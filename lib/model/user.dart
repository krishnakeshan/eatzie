class User {
  //Properties
  String objectId;
  String name;

  //Constructors
  User.fromMap(var map) {
    objectId = map["objectId"];
    name = map["name"];
  }
}
