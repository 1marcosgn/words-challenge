//
//  DUOErrorHandler.swift
//  DuolingoApp
//
//  Created by Marcos Garcia on 12/20/18.
//  Copyright © 2018 Marcos Garcia. All rights reserved.
//

import Foundation
import UIKit

enum ErrorType: String {
    case load = "loadChallenges"
    case reload = "reloadChallenge"
}
public class DUOErrorHandler {
    
    /// Handle errors related with challenges
    class func handleChallengesErrorFor(_ errorType: ErrorType) {
        switch errorType {
        case .load: // TODO: repot this
            print("error loading challenges for the first tine")
        case .reload: // TODO: repot this
            print("error trying to fetch more challenges")
        }
    }
}
