//
//  DUOChallengeInteractorTests.swift
//  DuolingoAppTests
//
//  Created by Marcos Garcia on 12/15/18.
//  Copyright © 2018 Marcos Garcia. All rights reserved.
//

import XCTest

class DUOChallengeInteractorTests: XCTestCase {

    func test_requestChallenges_Should_Load_AvailableChallenges() {
        /// Given
        let sut = DUOChallengeInteractor.init()
        let expectation = XCTestExpectation(description: "Call should be successfully completed")
        
        /// When
        sut.requestChallenges { (success) in
            if success {
                expectation.fulfill()
            }
        }
        
        /// Then
        wait(for: [expectation], timeout: 10.0)
        XCTAssertNotNil(sut.availableChallenges, "After fetching from API the available challenges should not be nil")
        XCTAssertNotNil(DUOChallengeManager.sharedInstance.theCurrentChallenge, "Current challenge should not be nil")
    }
    
    func test_makeChallengesWith_ValidInformation_ShouldUpdate_AvailableChallenges() {
        /// Given
        let sut = DUOChallengeInteractor.init()
        let mockArray = [DUOChallengeTests.init().getMockDictionary(), DUOChallengeTests.init().getMockDictionary()]
        
        /// When
        sut.makeChallengesWith(mockArray)
        
        /// Then
        XCTAssertNotNil(sut.availableChallenges, "Available challenges should not be nil")
        XCTAssertEqual(sut.availableChallenges?.count, 2, "Available challenges array should contain 2 elements")
        XCTAssertNotNil(DUOChallengeManager.sharedInstance.theCurrentChallenge, "Current challenge should not be nil")
    }
    
    func test_evaluateSelection_WhenSelection_MATCHES_ChallengeLocation_AvailableChallenges_ShouldBeUpdated() {
        /// Given
        let sut = DUOChallengeInteractor.init()
        let mockArray = [DUOChallengeTests.init().getMockDictionary(), DUOChallengeTests.init().getMockDictionary(), DUOChallengeTests.init().getMockDictionary()]
        let mockLocation = DUOLocation.init(word_locations: [["0,2,0,3,0,4": "soy"]])
        
        /// When
        sut.makeChallengesWith(mockArray)
        let match = sut.evaluateSelection(mockLocation)
        
        /// Then
        XCTAssertNotNil(sut.availableChallenges, "The available challenges should not be nil")
        XCTAssertEqual(sut.availableChallenges?.count, 2, "After matching one of the challenges the number of Available challenges should be 2")
        XCTAssertTrue(match, "The location should match")
    }
    
    func test_evaluateSelection_WhenSelection_DOES_NOT_MATCH_ChallengeLocation_AvailableChallenges_ShouldBeUpdated() {
        /// Given
        let sut = DUOChallengeInteractor.init()
        let mockArray = [DUOChallengeTests.init().getMockDictionary(), DUOChallengeTests.init().getMockDictionary(), DUOChallengeTests.init().getMockDictionary()]
        let mockLocation = DUOLocation.init(word_locations: [["1,2,1,3,1,4": "hoy"]])
        
        /// When
        sut.makeChallengesWith(mockArray)
        let match = sut.evaluateSelection(mockLocation)
        
        /// Then
        XCTAssertNotNil(sut.availableChallenges, "The available challenges should not be nil")
        XCTAssertEqual(sut.availableChallenges?.count, 3, "After matching one of the challenges the number of Available challenges should be 2")
        XCTAssertNotNil(match, "Locations shold match")
    }
    
    func test_evaluateSelection_WhenSelection_MATCHES_ALL_ChallengeLocations_AvailableChallenges_ShouldBeUpdated() {
        /// Given
        let sut = DUOChallengeInteractor.init()
        let mockArray = [DUOChallengeTests.init().getMockDictionary(), DUOChallengeTests.init().getMockDictionary(), DUOChallengeTests.init().getMockDictionary()]
        let mockLocation = DUOLocation.init(word_locations: [["0,2,0,3,0,4": "soy"]])
        
        /// When
        sut.makeChallengesWith(mockArray)
        let match1 = sut.evaluateSelection(mockLocation)
        let match2 = sut.evaluateSelection(mockLocation)
        let match3 = sut.evaluateSelection(mockLocation)
        
        /// Then
        XCTAssertNotNil(sut.availableChallenges, "The available challenges should not be nil")
        XCTAssertEqual(sut.availableChallenges?.count, 2, "After matching one of the challenges the number of Available challenges should be 2")
        XCTAssertNil(sut.currentChallenge, "Current challenge should be nil if no challenges available")
        XCTAssertNotNil(match1, "Match should not be nil")
        XCTAssertNotNil(match2, "Match should not be nil")
        XCTAssertNotNil(match3, "Match should not be nil")
    }
    
    func test_initializeSelectedElements_Should_ReturnAnInitialized_Array() {
        /// Given
        let sut = DUOChallengeInteractor.init()
        
        /// When
        sut.initializeSelectedElements()
        
        /// Then
        XCTAssertEqual(sut.userSelectedElements.count, 0, "Elements shoyld be 0 for an empty Selected Elements Array")
    }
    
    func test_updateSelectedElements_Should_Return_ValidArray() {
        /// Given
        let sut = DUOChallengeInteractor.init()
        
        /// When
        sut.initializeSelectedElements()
        sut.updateSelectedElementsWith(4)
        sut.updateSelectedElementsWith(1)
        sut.updateSelectedElementsWith(2)
        sut.updateSelectedElementsWith(3)
        
        /// Then
        XCTAssertEqual(sut.userSelectedElements.count, 4, "Number of elements in the updated array should be 4")
        XCTAssertEqual(sut.userSelectedElements[0], 4, "Element in the position should match")
        XCTAssertEqual(sut.userSelectedElements[1], 1, "Element in the position should match")
        XCTAssertEqual(sut.userSelectedElements[2], 2, "Element in the position should match")
        XCTAssertEqual(sut.userSelectedElements[3], 3, "Element in the position should match")
    }
    
    func test_parseSelectedElements_ShouldReturn_Valid_Locations() {
        /// Given
        let sut = DUOChallengeInteractor.init()
        let arrayOfLocations = [[0, 0], [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0], [0, 1], [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1], [0, 2], [1, 2], [2, 2], [3, 2], [4, 2], [5, 2], [6, 2], [7, 2], [0, 3], [1, 3], [2, 3], [3, 3], [4, 3], [5, 3], [6, 3], [7, 3], [0, 4], [1, 4], [2, 4], [3, 4], [4, 4], [5, 4], [6, 4], [7, 4], [0, 5], [1, 5], [2, 5], [3, 5], [4, 5], [5, 5], [6, 5], [7, 5], [0, 6], [1, 6], [2, 6], [3, 6], [4, 6], [5, 6], [6, 6], [7, 6], [0, 7], [1, 7], [2, 7], [3, 7], [4, 7], [5, 7], [6, 7], [7, 7]]
        
        let mockLocation = DUOLocation.init(selected_locations: [[[4, 0], [1, 0], [2, 0], [3, 0]]])
        
        /// When
        sut.initializeSelectedElements()
        sut.updateSelectedElementsWith(4)
        sut.updateSelectedElementsWith(1)
        sut.updateSelectedElementsWith(1)
        sut.updateSelectedElementsWith(2)
        sut.updateSelectedElementsWith(3)
        sut.updateSelectedElementsWith(3)

        let location = sut.getDuoLocationFrom(arrayOfLocations)
        
        /// Then
        XCTAssertNotNil(location, "Generated locations should not be nil")
        XCTAssertEqual(location?.word_locations, mockLocation.word_locations, "Location should match")
    }
}

