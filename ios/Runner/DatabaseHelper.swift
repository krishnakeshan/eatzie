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
    
    //Methods to get raw items
    //method to get an object by id
    func getObjectWithId(className: String, objectId: String, flutterResult: @escaping FlutterResult) {
        //create query
        let objectQuery = PFQuery(className: className)
        objectQuery.getObjectInBackground(withId: objectId, block: {(object, error) in
            if error == nil && object != nil {
                //convert object and send
                flutterResult(self.objConverter.parseObjectToMap(parseObject: object!))
            } else {
                flutterResult(nil)
            }
        })
    }
    
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
