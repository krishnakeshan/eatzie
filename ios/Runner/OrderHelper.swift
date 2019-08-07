//
//  OrderHelper.swift
//  Runner
//
//  Created by Krishna Keshan on 07/08/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation
import Flutter
import Parse

class OrderHelper {
    //MARK: Properties
    let objConverter = ObjectConverter()
    
    //MARK: Methods
    //method to get user's orders
    func getUserOrders(flutterResult: @escaping FlutterResult) {
        //create query
        let ordersQuery = PFQuery(className: "Order")
        ordersQuery.whereKey("user", equalTo: PFUser.current()!.objectId!)
        ordersQuery.findObjectsInBackground { (orderObjects, error) in
            if error == nil {
                //create list and send back
                flutterResult(self.objConverter.createMapsFromObjects(parseObjects: orderObjects!))
            }
        }
    }
    
    //method to get user's active orders
    func getUserActiveOrders(flutterResult: @escaping FlutterResult) {
        //create query
        let ordersQuery = PFQuery(className: "Order")
        ordersQuery.whereKey("user", equalTo: PFUser.current()!.objectId!)
        ordersQuery.whereKey("status", notEqualTo: Constants.orderStatusCompleteCode)
        ordersQuery.findObjectsInBackground { (activeOrders, error) in
            if error == nil {
                flutterResult(self.objConverter.createMapsFromObjects(parseObjects: activeOrders!))
            }
        }
    }
    
    //method to get users's past orders
    func getUserPastOrders(flutterResult: @escaping FlutterResult) {
        //create query
        let ordersQuery = PFQuery(className: "Order")
        ordersQuery.whereKey("user", equalTo: PFUser.current()!.objectId!)
        ordersQuery.whereKey("status", equalTo: Constants.orderStatusCompleteCode)
        ordersQuery.findObjectsInBackground { (activeOrders, error) in
            if error == nil {
                flutterResult(self.objConverter.createMapsFromObjects(parseObjects: activeOrders!))
            }
        }
    }
}
