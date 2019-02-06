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

  //setters
  void setCreatedAt(String dateString) {
    createdAt = DateTime.parse(dateString);
  }
}
