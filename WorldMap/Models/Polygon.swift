//
//  Polygon.swift
//  WorldMap
//
//  Created by NiteshTak on 30/4/17.
//  Copyright © 2017 NiteshTak. All rights reserved.
//

struct Polygon {
    
    let coordinates: [[(long: Float, lat: Float)]]
}

extension Polygon: GeoCordinatesSerializable {
    
    init(coordinates: [AnyObject]) {
        
        var polygonCoordinates = [[(long: Float, lat: Float)]]()
        
        for coodinateArr in coordinates {
            let positionsArr = coodinateArr as! [AnyObject]
            var latLongCollection = [(long: Float, lat: Float)]()
            for tupleLikePositions in positionsArr {
                let floatValues = tupleLikePositions as! [Float]
                let point = (long: floatValues[0], lat: floatValues[1])
                latLongCollection.append(point)
            }
            polygonCoordinates.append(latLongCollection)
        }
        
        self.coordinates = polygonCoordinates
    }
}
