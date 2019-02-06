class Location {
  String _objectId;
  DateTime _createdAt;

  String _imageURL;
  String _name;
  String _address;

  //getters
  String getObjectId() => _objectId;
  DateTime getCreatedAt() => _createdAt;
  String getImageURL() => _imageURL;
  String getName() => _name;
  String getAddress() => _address;

  //setters
  void setObjectId(String objectId) {
    this._objectId = objectId;
  }

  void setCreatedAt(String dateString) {
    this._createdAt = DateTime.parse(dateString);
  }

  void setImageURL(String imageURL) {
    this._imageURL = imageURL;
  }

  void setName(String name) {
    this._name = name;
  }

  void setAddress(String address) {
    this._address = address;
  }
}
