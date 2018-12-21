//
//  DUOServicesImplementer.swift
//  DuolingoApp
//
//  Class to manage the interaction with Remote Services, download and
//  parse the information coming from the Challenges API and returns it
//  into a format that the app can manage.
//
//  Created by Marcos Garcia on 12/15/18.
//  Copyright © 2018 Marcos Garcia. All rights reserved.
//

import UIKit

/// Struct to manage the endpoints of the App
private struct Services {
    static let find_challenges = "https://s3.amazonaws.com/duolingo-data/s3/js2/find_challenges.txt"
}

public class DUOServicesImplementer {
    /// Stores temporary the downloaded challenges
    public var duoChallenges: [[String: Any]]?
    
    
    /// Call Web Service to fetch data .. this should be an async task
    public func findChallenges(completion: @escaping (Bool) -> ()) {
        downloadFileFromURL { (success) -> Void in
            completion(success)
        }
    }
}

/// Extension to download and parse file with the challenges
internal extension DUOServicesImplementer {
    /**
     Simple method to download a file from external URL
     - parameter completion: The response of the opetarion
     */
    func downloadFileFromURL(completion: @escaping (Bool) -> ()) {
        DispatchQueue.global().async {
            guard let endpointURL = URL(string: Services.find_challenges) else {
                return
            }

            let response = try? String(contentsOf: endpointURL)
            if response != nil {
                self.setUpDUOChallengeArrayWith(self.parseResponse(response))
                if self.duoChallenges != nil {
                    completion(true)
                } else {
                    completion(false)
                }
            } else {
                /// Service response is wrong
                completion(false)
            }
        }
    }
    
    /**
     Parse the response into a valid format
     - parameter response: The response file from an external resource
     - returns: Dictionary with the information as 'key' and 'value'
     */
    func parseResponse(_ response: String?) -> [[String: Any]]? {
        
        var challenges = [[String: Any]]()
        
        guard let sentence = response else {
            return nil
        }
        
        var lines: [String] = []
        sentence.enumerateLines { line, _ in
            lines.append(line)
        }
    
        for line in lines {
            guard let dictionary = convertToDictionary(text: line) else {
                return nil
            }
            challenges.append(dictionary)
        }

        return challenges
    }
}

/// Helper Methods
internal extension DUOServicesImplementer {
    /**
     Updates the 'duoChallenge' dictionary with the content of an external resource
     - parameter content: The external dictionary with valid content
     */
    func setUpDUOChallengeArrayWith(_ content: [[String: Any]]?) {
        guard let theContent = content else {
            return
        }
        duoChallenges = theContent
    }
    
    /**
     Converts a String into a valid dictionary
     - parameter text: The string to be converted
     - returns: Dictionary with the information as 'key' and 'value'
     */
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}

extension String {
    /// This extension method splits a String by a new line '\n'
    var lines: [String] {
        var result: [String] = []
        enumerateLines { line, _ in result.append(line) }
        return result
    }
}

