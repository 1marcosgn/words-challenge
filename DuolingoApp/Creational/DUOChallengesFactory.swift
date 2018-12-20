//
//  DUOChallengesFactory.swift
//  DuolingoApp
//
//  Factory class to create DUOChallenge objects based on an Array of Dictionaries with
//  the challenges information, use this class to generete new challenges when the app is
//  launched for the first time or when all challenges are completed and no more are available
//
//  Created by Marcos Garcia on 12/15/18.
//  Copyright © 2018 Marcos Garcia. All rights reserved.
//

import UIKit

public class DUOChallengesFactory: NSObject {
    
    private static var sharedDUOChallengesFactory = DUOChallengesFactory()
    
    /// Single instance of DUOChallengesFactory
    class func shared() -> DUOChallengesFactory {
        return sharedDUOChallengesFactory
    }
    
    /**
     Creates and returns DUOChallenges based on a Dictionary with the challenges information
     - parameter duoChallenges: Array of Dictionaries with information required to build a challenge
     - returns: Array of DUOChallenges
     */
    public func getChallenges(duoChallenges: [[String: Any]]?) -> [DUOChallenge]? {
        var availableChallenges = [DUOChallenge]()
        
        guard let challenges = duoChallenges as [[String: Any]]? else {
            return nil
        }
        
        for challenge in challenges {
            availableChallenges.append(DUOChallenge.init(challenge: challenge))
        }
        
        return availableChallenges
    }
}

