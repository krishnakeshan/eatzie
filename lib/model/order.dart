class Order {
  //Properties
  String objectId;
  String createdAt;
  String user;
  String location;
  List<OrderItem> orderItems;
  double total;
  int statusCode;

  //Constructors
  //Empty constructor
  Order();

  //Map constructor
  Order.fromMap(var map) {
    objectId = map["objectId"];
    createdAt = map["createdAt"];
    user = map["user"];
    location = map["location"];
    orderItems = OrderItem.createListFromMaps(map["items"]);
    total = map["total"].toDouble();
    statusCode = map["statusCode"];
  }

  //Methods
  //method to create List from maps
  static List<Order> createListFromMaps(var maps) {
    //create List
    List<Order> orders = new List();
    for (var map in maps) {
      orders.add(Order.fromMap(map));
    }

    //return list of Orders
    return orders;
  }
}

class OrderItem {
  //Properties
  String itemId;
  int quantity;
  double ppu;

  //Constructors
  //Empty constructor
  OrderItem();

  //Map Constructor
  OrderItem.fromMap(var map) {
    itemId = map["itemId"];
    quantity = map["quantity"];
    ppu = map["ppu"].toDouble();
  }

  //Methods
  //method to create list of OrderItems
  static List<OrderItem> createListFromMaps(var maps) {
    //create list of OrderItems
    print("creating orderitems $maps");
    List<OrderItem> orderItems = new List();
    for (var map in maps) {
      orderItems.add(OrderItem.fromMap(map));
    }

    //return list of created OrderItems
    return orderItems;
  }
}
