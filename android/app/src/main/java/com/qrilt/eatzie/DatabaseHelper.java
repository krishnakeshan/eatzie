package com.qrilt.eatzie;

import com.parse.ParseGeoPoint;
import com.parse.ParseObject;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

public class DatabaseHelper {
    //methods
    //method to create a map from a ParseObject
    HashMap<String, Object> parseObjectToMap(ParseObject parseObject) {
        HashMap<String, Object> result = new HashMap<>();

        //assign basic properties
        result.put("objectId", parseObject.getObjectId());
        result.put("createdAt", parseObject.getCreatedAt());

        //put all fields in the map (except ACL)
        for (String key : parseObject.keySet()) {
            if (!key.equals("ACL")) {
                result.put(key, getSimpleRepresentation(parseObject.get(key)));
            }
        }

        return result;
    }

    //method to convert a list of Parse objects to list of HashMaps
    List<HashMap<String, Object>> parseObjectsToMaps(List<ParseObject> parseObjects) {
        List<HashMap<String, Object>> maps = new ArrayList<>();
        for (ParseObject parseObject : parseObjects) {
            maps.add(parseObjectToMap(parseObject));
        }
        return maps;
    }

    //method to get a compatible representation for a value
    Object getSimpleRepresentation(Object value) {
        //convert Date type to String
        if (value instanceof Date) {
            return value.toString();
        }

        //convert Parse GeoPoint to map of doubles
        else if (value instanceof ParseGeoPoint) {
            HashMap<String, Double> pointMap = new HashMap<>();
            pointMap.put("lat", ((ParseGeoPoint) value).getLatitude());
            pointMap.put("lon", ((ParseGeoPoint) value).getLongitude());
            return pointMap;
        }

        //else return the object itself, cause it works fine
        return value;
    }
}
