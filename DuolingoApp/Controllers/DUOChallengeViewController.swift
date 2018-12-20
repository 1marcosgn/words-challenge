//
//  DUOChallengeViewController.swift
//  DuolingoApp
//
//  Created by Marcos Garcia on 12/13/18.
//  Copyright © 2018 Marcos Garcia. All rights reserved.
//

import UIKit
import AVFoundation

struct ConstantsVC {
    static let duoCollectionNibName = "DUOCollectionViewCell"
    static let duoCellID = "DOUCellWord"
}

class DUOChallengeViewController: UIViewController {
    @IBOutlet weak var duoCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var targetWordLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var alertViewContainer: UIView!
    @IBOutlet weak var alertHeight: NSLayoutConstraint!
    @IBOutlet weak var continueButton: UIButton!
    
    public var theCurrentChallenge: DUOChallenge?
    public var items = [String]()
    public var arrayOfSections = [[String]]()
    public var arrayOfLocations = [[Int]]()
    public var theInteractor = DUOChallengeInteractor()
    public var arrayOfIndexPaths = [IndexPath?]()
    public var totalChallenges = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Initialize the properties for the collection view
        self.configureCollectionView()
        
        /// Set up challenges using the interactor
        self.setUpChallenges()
        
        /// Set up the global interactor
        self.setUpInteractor()
        
        /// Set up view container
        self.setUpContainer()
    }
    
    @IBAction func goToNextChallenge(_ sender: Any) {
        self.refreshChallenge()
        self.showInView(false)
    }
}

/// Collection View Related Stuff
extension DUOChallengeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    /// This method does the configuration of the collection view, adds the gesture recognizer and reusable cell identifier
    func configureCollectionView() {
        self.duoCollectionView.register(UINib(nibName: ConstantsVC.duoCollectionNibName, bundle: .main), forCellWithReuseIdentifier: ConstantsVC.duoCellID)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(DUOChallengeViewController.didPanToSelectCells))
        self.duoCollectionView.addGestureRecognizer(panGesture)
    }
    
    /// Use this method to reload the collection view with the updated information
    func reloadCollectionViewData() {
        self.duoCollectionView.reloadData()
    }
    
    /// Returns the number of items for each section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    /// Configures each cell with the String to display
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.duoCollectionView.dequeueReusableCell(withReuseIdentifier: "DOUCellWord", for: indexPath) as! DUOCollectionViewCell
        cell.wordLabel.text = items[indexPath.item]
        cell.backgroundColor = UIColor.white
        
        // Set up rounded format for cell
        cell.contentView.layer.cornerRadius = 2.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        return cell
    }
    
    /// Gets invoked when the user slides the finger through the cell, it recognizes 3 different states: .began, .changed, .ended
    @objc func didPanToSelectCells(panGesture: UIPanGestureRecognizer) {
        
        // This is the initial state, when the user begins the interaction with the cell, interaction and scroll features are disabled to avoid UI collisions
        if panGesture.state == .began {
            
            self.duoCollectionView.isUserInteractionEnabled = false
            self.duoCollectionView.isScrollEnabled = false
            
        } else if panGesture.state == .changed { // Second state, when the position of the user selection gets updated, this is used to determine the exactly position and based on that update the correct DUOCollectionViewCell
            
            let location = panGesture.location(in: self.duoCollectionView)
            let indexPath = self.duoCollectionView.indexPathForItem(at: location)
            
            if indexPath?.item != nil {
                if let selection = indexPath?.item {
                    self.theInteractor.updateSelectedElementsWith(selection)
                    self.highLightCellAt(indexPath, withColor: UIColor.init(red: 228.0/255.0, green: 228.0/255.0, blue: 228.0/255.0, alpha: 1.0))
                    self.arrayOfIndexPaths.append(indexPath)
                }
            }
        } else if panGesture.state == .ended {
            // Third state, once the interaction is done enable again the scroll and user interaction features to reset to original uicollectionview properties
            self.duoCollectionView.isScrollEnabled = true
            self.duoCollectionView.isUserInteractionEnabled = true
            
            // Use interactor to parse Selected Elements
            guard let locationSelected = self.theInteractor.getDuoLocationFrom(self.arrayOfLocations) else {
                return
            }
            
            ///Use this to reset the selected elements
            self.theInteractor.initializeSelectedElements()
            
            ///if selection matches then update the color of the selected cells with light green
            if self.theInteractor.evaluateSelection(locationSelected) {
                self.highLightValidOrNotMatchIn(arrayOfIndexPaths, valid: true)
                self.arrayOfIndexPaths = [IndexPath?]()
                
                guard let theWord = self.theCurrentChallenge?.word else {
                    return
                }
                
                AudioServicesPlayAlertSound(SystemSoundID(1322))
                self.targetWordLabel.text = "👏" + " " + theWord
                
                if DUOChallengeManager.sharedInstance.allMatchesFound() {
                    self.targetWordLabel.text = "✅" + " " + theWord
                    self.showInView(true)
                }
            } else {
                ///if selection does not match then update the color of the selected cells to the original value
                self.highLightValidOrNotMatchIn(arrayOfIndexPaths, valid: false)
                self.arrayOfIndexPaths = [IndexPath?]()
            }
        }
    }
    
    /**
     This method updates the background color of the cell if matches or not
     - parameter matches: Array of index paths that represent the user selection
     - parameter valid: This value determines if a match was positive or not
     */
    func highLightValidOrNotMatchIn( _ matches: [IndexPath?], valid: Bool) {
        let color = valid ? UIColor.init(red: 200.0/255.0, green: 239.0/255.0, blue: 159.0/255.0, alpha: 1.0) : UIColor.white
        for matchedPath in matches {
            self.highLightCellAt(matchedPath, withColor: color)
        }
    }
    
    /**
     Updates the background color of an specific cell
     - parameter indexPath: The path of the cell to update
     - parameter withColor: color to be used to display into the cell
     */
    func highLightCellAt(_ indexPath: IndexPath?, withColor: UIColor) {
        let cell = self.duoCollectionView.cellForItem(at: indexPath!) as? DUOCollectionViewCell
        cell?.backgroundColor = withColor
    }
}


/// Extension to handle Interactor Operations
internal extension DUOChallengeViewController {
    
    /// Initializes the DUOChallenge Interactor
    func setUpInteractor() {
        self.theInteractor.initializeSelectedElements()
    }
    
    func setUpChallenges() {
        /// Activity indicator to indicate downloading is in progress
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidesWhenStopped = true

        /// Fetch available challenges
        self.theInteractor.requestChallenges { (succcess) in
            if succcess {
                self.theCurrentChallenge = DUOChallengeManager.sharedInstance.theCurrentChallenge
                guard let words = self.challengeViewModel()?.getArrayOfWordsFromatted() else {
                    return
                }
                self.items = words
                self.totalChallenges = self.theInteractor.availableChallenges?.count ?? 0
                
                /// Updates User Interface in the main thread
                DispatchQueue.main.async { [unowned self] in
                    self.activityIndicator.stopAnimating()
                    self.reloadCollectionViewData()
                    self.targetWordLabel.text = self.theCurrentChallenge?.word
                }
            } else {
                DispatchQueue.main.async { [unowned self] in
                    self.targetWordLabel.text = "Something went wrong 😵..."
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    func challengeViewModel() -> DUOChallengeViewModel? {
        guard let currentChallenge = theCurrentChallenge else {
            return nil
        }
        let model = DUOChallengeViewModel(challenge: currentChallenge)
        
        guard let sections = model.arrayOfSections else {
            return nil
        }
        
        guard let locations = model.arrayOfLocations else {
            return nil
        }
        
        self.arrayOfSections = sections
        self.arrayOfLocations = locations
        return model
    }
    
    func refreshChallenge() {
        self.theCurrentChallenge = DUOChallengeManager.sharedInstance.theCurrentChallenge
        DUOChallengeManager.sharedInstance.numberOfMatches = self.theCurrentChallenge?.word_locations?.count ?? 0
        guard let words = self.challengeViewModel()?.getArrayOfWordsFromatted() else {
            return
        }
        self.items = words
        
        self.reloadCollectionViewData()
        self.targetWordLabel.text = self.theCurrentChallenge?.word
        self.updateProgressBar()
    }
    
    func updateProgressBar() {
        let progressUp = 1.0 / Double(self.totalChallenges)
        let value = self.progressBar.progress + Float(progressUp)
        self.progressBar.setProgress(value, animated: true)
        
        if self.progressBar.progress == 1.0 {
            self.progressBar.setProgress(0.0, animated: true)
        }
    }
}

/// Extension to Set up Grid with words
extension DUOChallengeViewController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        var cellWidht = screenWidth / CGFloat(arrayOfSections.count)
        cellWidht -= 12.0
        let size = CGSize(width: cellWidht, height: 40.0)
        return size
    }
}


/// Extension to control the alert view container
extension DUOChallengeViewController {
    
    func setUpContainer() {
        self.alertViewContainer.layer.cornerRadius = 15.0
        self.continueButton.layer.cornerRadius = 10.0
        self.alertHeight.constant = 0.0
    }
    
    func showInView(_ show: Bool) {
        let constant = show ? 214.0 : 0.0
        self.alertHeight.constant = CGFloat(constant)
        if show {
            AudioServicesPlayAlertSound(SystemSoundID(1322))
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}
