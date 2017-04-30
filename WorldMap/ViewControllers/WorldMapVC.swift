//
//  WorldMapVC.swift
//  WorldMap
//
//  Created by NiteshTak on 30/4/17.
//  Copyright © 2017 NiteshTak. All rights reserved.
//

import UIKit

enum ScalingFactor {
    static let scale: Float = 10000.0
}

class WorldMapVC: UIViewController {
    
    var polygons = [Polygon]()
    var scrollView: UIScrollView!
    var mapView: UIView!
    var xOffset: Float!
    var yOffset: Float!
    
    var mapViewWidth: Float!
    var mapViewHeight: Float!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.configureUI()
    }
    
    func configureUI() {
        
        self.setupScrollView()
        
        guard let json = GeoJSONParser.sharedInstance.parseGeoJSONFile(filename: "countries_small") else {
            print("Error parsing GEOJSON File")
            self.showAlertMessage(title: "Error", message: "Error parsing GEOJSON file")
            return
        }
        
        // Get the bounding box of the GEOJSON
        let boundaries = json["bbox"] as! [Float]
        
        // We need to scale down the values to see a small map on the screen.
        self.xOffset = (boundaries[0] * -1) / ScalingFactor.scale
        self.yOffset = (boundaries[1] * -1) / ScalingFactor.scale
        
        self.mapViewWidth = ((boundaries[0] * -1) + boundaries[2]) / ScalingFactor.scale
        self.mapViewHeight = ((boundaries[1] * -1) + boundaries[3]) / ScalingFactor.scale
        
        // Instanciate Polygons
        let features = json["features"] as! [AnyObject]
        for feature in features {
            let geometry = feature["geometry"] as! [String: AnyObject]
            let type = geometry["type"] as! String
            let coordinates = geometry["coordinates"] as! [AnyObject]
            
            switch type {
            case "Polygon":
                self.polygons.append(Polygon(coordinates: coordinates))
                break
            // Given that a MultiPolygon is just a collection of Polygons
            case "MultiPolygon":
                for coordinatesCollection in coordinates {
                    let nestedCoodinates = coordinatesCollection as! [AnyObject]
                    self.polygons.append(Polygon(coordinates: nestedCoodinates))
                }
                break
            default:
                print("There is no implementation for other geometry type")
            }
        }
        
        // Creates the map view based on the GEOJSON bbox values
        self.setupMapView()
        
        // Draws each polygon on the map view
        for polygon in self.polygons {
            self.drawPolygonOnMapView(polygon: polygon)
        }
        
        // A little animation to show the map
        UIView.animate(withDuration: 0.4) {
            self.mapView.layer.opacity = 1.0
        }
        
    }
    
    func setupScrollView() {
        // Setup the ScrollView
        self.scrollView = UIScrollView(frame: self.view.bounds)
        self.scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.scrollView.delegate = self
        self.scrollView.bounces = true
        self.scrollView.alwaysBounceHorizontal = true
        self.scrollView.minimumZoomScale = 0.19
        self.scrollView.maximumZoomScale = 3.0
        self.view.addSubview(self.scrollView)
    }
    
    func setupMapView() {
        let frame = CGRect(0, 0, CGFloat(self.mapViewWidth), CGFloat(self.mapViewHeight))
        self.mapView = UIView(frame: frame)
        self.scrollView.contentSize = self.mapView.bounds.size
        self.scrollView.addSubview(mapView)
        // Add an offset to see part of the map on startup
        self.scrollView.contentOffset = CGPoint(self.mapView.bounds.size.width/2, self.mapView.bounds.size.height/2)
        // Hide the map to show with a animation later
        self.mapView.layer.opacity = 0.0
    }
    
    func drawPolygonOnMapView(polygon: Polygon) {
        let shape = CAShapeLayer()
        shape.opacity = 0.9
        shape.lineWidth = 2
        shape.strokeColor = UIColor.white.cgColor
        shape.fillColor = UIColor.withRGB(red: 68, green: 68, blue: 68).cgColor
        
        let composablePath = UIBezierPath()
        
        for coordinatesCollection in polygon.coordinates {
            // Creates a path that will compose the country representation
            let path = UIBezierPath()
            for (index, coordinates) in coordinatesCollection.enumerated() {
                let x = CGFloat((coordinates.long / ScalingFactor.scale) + self.xOffset)
                // The iOS coordinate system has its origin at the upper left of the drawing area,
                // and positive values extend down and to the right from it.
                // Given that the GEOJSON Y axis is meant to be the other way around
                // we need to multiply by -1, otherwise the map will be upside down.
                let y = CGFloat(((coordinates.lat * -1) / ScalingFactor.scale) + self.yOffset)
                if index == 0 {
                    path.move(to: CGPoint(x, y))
                } else {
                    path.addLine(to: CGPoint(x, y))
                }
            }
            path.close()
            composablePath.append(path)
        }
        
        // Drawing the layer as a vector is expensive.
        // To improve performance, enable rasterization.
        // Rendering the layer as a bitmap.
        shape.shouldRasterize = true
        shape.rasterizationScale = 0.5
        shape.allowsEdgeAntialiasing = false
        
        composablePath.close()
        shape.path = composablePath.cgPath
        
        self.mapView.layer.addSublayer(shape)
    }
    
    func showAlertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}


// MARK: - UIScrollViewDelegate
/*
 Following the [Ray Wenderlich style guide](https://github.com/raywenderlich/swift-style-guide)
 Create an extension for protocol conformance
 */
extension WorldMapVC: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.mapView
    }
}
