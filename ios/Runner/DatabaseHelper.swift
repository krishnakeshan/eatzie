//
//  DatabaseHelper.swift
//  This class is meant to help platform channel methods invoked on AppDelegate.swift to deal with Parse Server.
//  Runner
//
//  Created by Krishna Keshan on 04/02/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation
import Flutter
import Parse

class DatabaseHelper {
    //Properties
    let objConverter = ObjectConverter();
    
    //Methods
    //method to get locations for the user
    func getLocations(flutterResult: @escaping FlutterResult) {
        let locationsQuery = PFQuery(className: "Location")
        locationsQuery.findObjectsInBackground { (locationObjects, error) in
            //got location objects, now return to flutter
            if error == nil && locationObjects != nil {
                //create an array into which compatible repre. will be loaded
                var locationsArray: [Any] = []
                
                for locationObject in locationObjects! {
                    locationsArray.append(self.objConverter.parseObjectToMap(parseObject: locationObject))
                }
                
                flutterResult(locationsArray)
            }
        }
    }
    
    //method to get Item objects for a location
    func getItemsForLocation(locationId: String, flutterResult: @escaping FlutterResult) {
        let itemsQuery = PFQuery(className: "Item")
        itemsQuery.whereKey("location", equalTo: locationId)
        itemsQuery.findObjectsInBackground { (itemObjects, error) in
            if error == nil && itemObjects != nil {
                //create an array into which compatible repre. will be loaded
                var itemsArray: [Any] = []
                
                for itemObject in itemObjects! {
                    itemsArray.append(self.objConverter.parseObjectToMap(parseObject: itemObject))
                }
                
                //return list to Flutter
                flutterResult(itemsArray)
            }
        }
    }
    
    //method to get Cart object for a location
    func getCartForLocation(locationId: String, flutterResult: @escaping FlutterResult) {
        let cartQuery = PFQuery(className: "Cart")
        cartQuery.whereKey("user", equalTo: PFUser.current()!.objectId!)
        cartQuery.whereKey("location", equalTo: locationId)
        cartQuery.getFirstObjectInBackground { (cartObject, error) in
            if error == nil {
                //cart query completed, a cart may or may not exist
                if cartObject != nil {
                    //cart object exists, encode it and send on flutterResult
                    flutterResult(self.objConverter.parseObjectToMap(parseObject: cartObject!))
                } else {
                    //cart object doesn't exist, send false on flutterResult
                    flutterResult(false)
                }
            }
        }
    }
    
    //Methods to get raw items
    //method to get a Location object
    func getLocationObject(locationId: String, flutterResult: @escaping FlutterResult) {
        let locationQuery = PFQuery(className: "Location")
        locationQuery.getObjectInBackground(withId: locationId) { (locationObject, error) in
            if error == nil && locationObject != nil {
                flutterResult(self.objConverter.parseObjectToMap(parseObject: locationObject!))
            }
        }
    }
    
    //method to get an Item object
    func getItemObject(itemId: String, flutterResult: @escaping FlutterResult) {
        let itemQuery = PFQuery(className: "Item")
        itemQuery.getObjectInBackground(withId: itemId) { (itemObject, error) in
            if error == nil && itemObject != nil {
                flutterResult(self.objConverter.parseObjectToMap(parseObject: itemObject!))
            }
        }
    }
}
