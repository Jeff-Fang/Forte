//
//  ForteTests.swift
//  ForteTests
//
//  Created by Jeff Fang on 12/31/16.
//  Copyright © 2016 swordx. All rights reserved.
//

import XCTest
@testable import Forte 

class ForteTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testContentsPreloadingTime() {
        let pld = Preloader()
        pld.coreDataStack = CoreDataStack()
        self.measure {
            pld.preloadData()
        }
    }
}
