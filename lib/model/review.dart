class Review {
  //Properties
  String objectId;
  DateTime createdAt;

  String review;
  String reviewType;
  num rating;
  String forId;
  String fromId;

  //Constructors
  Review();

  //Review from Map
  Review.fromMap(var map) {
    objectId = map["objectId"];
    createdAt = DateTime.fromMillisecondsSinceEpoch(map["createdAt"]);

    review = map["review"];
    reviewType = map["reviewType"];
    rating = map["rating"];
    forId = map["forId"];
    fromId = map["fromId"];
  }
}
