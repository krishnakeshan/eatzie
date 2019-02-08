//
//  ObjectConverter.swift
//  Runner
//
//  This class is responsible for converting various representations of objects to various other representations
//
//  Created by Krishna Keshan on 07/02/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation
import Parse

class ObjectConverter {
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
