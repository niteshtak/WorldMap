//
//  WorldMapTests.swift
//  WorldMapTests
//
//  Created by NiteshTak on 30/4/17.
//  Copyright © 2017 NiteshTak. All rights reserved.
//

import XCTest
@testable import WorldMap

class WorldMapTests: XCTestCase {
    
    var vc: WorldMapVC!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        vc = storyboard.instantiateInitialViewController() as! WorldMapVC
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParser() {
        let validJson = GeoJSONParser.sharedInstance.parseGeoJSONFile(filename: "countries_small")
        XCTAssert(validJson != nil)
        
        let invalidJson = GeoJSONParser.sharedInstance.parseGeoJSONFile(filename: "invalid_countries")
        XCTAssert(invalidJson == nil)
        
    }
    
    func testNumberOfPolygons() {
        vc.configureUI()
        XCTAssert(vc.polygons.count == 462)
    }
    
    func testSetupScrollView() {
        vc.setupScrollView()
        XCTAssert(vc.scrollView != nil)
    }
    
    func testSetupMapView() {
        vc.configureUI()
        XCTAssert(vc.mapView != nil)
    }
    
}
