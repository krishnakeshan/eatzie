/*
Class representing an Item. An Item is a food product offered by a Location.
*/

class Item {
  String objectId;
  DateTime createdAt;

  String imageURL;
  String name;
  String description;
  double ppu;

  //Constructors
  //empty default constructor
  Item();

  //constructor to build an item from a map
  Item.fromMap({var map}) {
    this.objectId = map["objectId"];
    this.setCreatedAt(map["createdAt"]);
    this.imageURL = map["imageURL"];
    this.name = map["name"];
    this.description = map["description"];
    this.ppu = map["ppu"].toDouble();
  }

  //setters
  void setCreatedAt(String dateString) {
    createdAt = DateTime.parse(dateString);
  }
}
