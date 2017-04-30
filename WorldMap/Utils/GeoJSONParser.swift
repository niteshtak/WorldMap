//
//  GEOJSONParser.swift
//  WorldMap
//
//  Created by NiteshTak on 30/4/17.
//  Copyright © 2017 NiteshTak. All rights reserved.
//

import UIKit

class GeoJSONParser {
    
    static let sharedInstance = GeoJSONParser()
    
    private init() {}
    
    func parseGeoJSONFile(filename: String) -> [String: AnyObject]? {
        let fileURL = Bundle.main.url(forResource: filename, withExtension: "geojson")
        guard let url = fileURL else {
            print("File not found")
            return nil
        }
        let data = NSData(contentsOf: url)
        
        do {
            let json: [String: AnyObject] = try JSONSerialization
                .jsonObject(with: data! as Data, options: .allowFragments) as! [String: AnyObject]
            return json
            
        } catch _ {
            print("Error parsing GEOJSON File")
        }
        
        return nil
    }
}

