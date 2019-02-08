//
//  CartHelper.swift
//  Runner
//
//  Created by Krishna Keshan on 07/02/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation
import Flutter
import Parse

class CartHelper {
    //Properties
    let objConverter = ObjectConverter()
    
    //Methods
    //method to get all cart objects for a user
    func getUserCartObjects(flutterResult: @escaping FlutterResult) {
        let cartsQuery = PFQuery(className: "Cart")
        cartsQuery.whereKey("user", equalTo: PFUser.current()!.objectId!)
        cartsQuery.findObjectsInBackground { (cartObjects, error) in
            if error == nil {
                //query ran, return result
                var newArray: [Any] = []
                
                //convert each Cart object to a map
                for cartObject in cartObjects! {
                    newArray.append(self.objConverter.parseObjectToMap(parseObject: cartObject))
                }
                
                //return result
                flutterResult(newArray)
            }
        }
    }
    
    //method to add an item to cart
    func addItemToCart(itemId: String, flutterResult: @escaping FlutterResult) {
        let params: [String : Any] = [
            "itemId": itemId,
            "userId": PFUser.current()!.objectId!
        ]
        
        //call cloud function
        PFCloud.callFunction(inBackground: "addItemToCart", withParameters: params) { (result, error) in
            //cloud function returns objectId of the cart
            if error == nil {
                flutterResult(true)
            }
        }
    }
    
    //method to check if a cart exists for a given location
    func doesCartExist(locationId: String, flutterResult: @escaping FlutterResult) {
        let cartQuery = PFQuery(className: "Cart")
        cartQuery.whereKey("location", equalTo: locationId)
        cartQuery.whereKey("user", equalTo: PFUser.current()!.objectId!)
        cartQuery.selectKeys(["items"])
        cartQuery.getFirstObjectInBackground { (cartObject, error) in
            if error == nil {
                //return true if cart exists and isn't empty
                if cartObject != nil && !(cartObject!["items"] as! [NSDictionary]).isEmpty {
                    flutterResult(true)
                }
                
                    //cart doesn't exist, is empty, or both. return false
                else {
                    flutterResult(false)
                }
            }
        }
    }
}
