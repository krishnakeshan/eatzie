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
                    locationsArray.append(self.parseObjectToMap(parseObject: locationObject))
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
                    itemsArray.append(self.parseObjectToMap(parseObject: itemObject))
                }
                
                //return list to Flutter
                flutterResult(itemsArray)
            }
        }
    }
    
    //method to convert a Parse object to a map
    func parseObjectToMap(parseObject: PFObject) -> [String : Any] {
        var resultMap: [String : Any] = [:]
        
        //first assign basic properties
        resultMap["objectId"] = parseObject.objectId!
        resultMap["createdAt"] = parseObject.createdAt!.description
        
        //convert the rest of the attributes
        for key in parseObject.allKeys {
            let attribute = parseObject[key]!
            
            //get the correct representation of this attribute and put it into resultMap
            resultMap[key] = getCompatibleRepresentation(obj: attribute)
        }
        
        return resultMap;
    }
    
    //method to get a compatible representation of a value
    func getCompatibleRepresentation(obj: Any) -> Any {
        //attribute is of type string, simply put it into the map
        if obj is String {
            return (obj as! String)
        }
            
            //attribute is of numeric type
        else if obj is NSNumber {
            return (obj as! NSNumber)
        }
            
            //attribute is of type bool
        else if obj is Bool {
            return (obj as! Bool)
        }
            
            //attribute is of type Date
        else if obj is Date {
            return (obj as! Date).description
        }
            
            //attribute is of type PFGeoPoint
        else if obj is PFGeoPoint {
            //create a map containing the lat and long
            var pointMap: [String : Double] = [:]
            pointMap["lat"] = (obj as! PFGeoPoint).latitude
            pointMap["lon"] = (obj as! PFGeoPoint).longitude
            return pointMap
        }
            
            //atribute is of type array
        else if obj is NSArray {
            //determine type of array. they can mainly be of only [String] or [NSNumber]
            var newArray: [Any] = []
            if obj is [NSNumber] {
                //encode all values to NSNumber type
                newArray = obj as! [NSNumber]
            } else if obj is [String] {
                //encode all values to NSString type
                newArray = obj as! [String]
            } else if obj is [Bool] {
                //encode all values to Bool type
                newArray = obj as! [Bool]
            } else if obj is [NSDictionary] {
                //encode all values using this method
                for element in (obj as! [NSDictionary]) {
                    newArray.append(self.getCompatibleRepresentation(obj: element))
                }
            }
            
            //put array in resultMap
            return newArray
        }
            
            //attribute is of type Object (represented as NSDictionary in Swift)
        else if obj is NSDictionary {
            
            //create a resultMap to which contents of obj NSDict will be transferred
            var resultMap: [String : Any] = [:]
            
            //get compatible values of this dict using this function itself
            for key in (obj as! NSDictionary).allKeys {
                let attribute = (obj as! NSDictionary)[key]!
                
                resultMap[key as! String] = self.getCompatibleRepresentation(obj: attribute)
            }
            
            return resultMap
        }
        
        //no matching cases, return obj itself
        return obj
    }
}
