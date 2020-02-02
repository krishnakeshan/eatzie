class Location {
  String _objectId;
  DateTime _createdAt;

  String _imageURL;
  String _name;
  String _description;
  String _address;

  //Constructors
  //default empty constructor
  Location();

  //constructor to make Location from map
  Location.fromMap(var map) {
    this.setObjectId(map["objectId"]);
    this.setCreatedAt(map["createdAt"]);
    this.setImageURL(map["imageURL"]);
    this.setName(map["name"]);
    this.setDescription(map["description"]);
    this.setAddress(map["address"]);
  }

  //getters
  String getObjectId() => _objectId;
  DateTime getCreatedAt() => _createdAt;
  String getImageURL() => _imageURL;
  String getName() => _name;
  String getDescription() => _description;
  String getAddress() => _address;

  //setters
  void setObjectId(String objectId) {
    this._objectId = objectId;
  }

  void setCreatedAt(num dateString) {
    this._createdAt = DateTime.fromMillisecondsSinceEpoch(dateString);
  }

  void setImageURL(String imageURL) {
    this._imageURL = imageURL;
  }

  void setName(String name) {
    this._name = name;
  }

  void setDescription(String description) {
    this._description = description;
  }

  void setAddress(String address) {
    this._address = address;
  }
}
