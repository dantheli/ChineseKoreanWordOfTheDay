//
//  TermViewController.swift
//  Language
//
//  Created by Daniel Li on 2/13/16.
//  Copyright © 2016 Dannical. All rights reserved.
//

import UIKit
import RealmSwift

class TermViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIViewControllerPreviewingDelegate {
    
    var currentLanguage: String!
    
    var terms = [Term]()
    
    var realmTerms: [Term] {
        return try! Realm().objects(Term).filter( { $0.language == currentLanguage.lowercaseString }).sort({ $0.termDate > $1.termDate })
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    var tableViewBackground: UIView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Remove empty cell separators
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100.0
        
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        
        // Verify 3D Touch
        if traitCollection.forceTouchCapability == .Available {
            registerForPreviewingWithDelegate(self, sourceView: view)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        if currentLanguage == nil {
            let defaults = NSUserDefaults.standardUserDefaults()
            if let language = defaults.stringForKey("languageKey") {
                currentLanguage = language
            } else {
                currentLanguage = languageKeys[0]
                defaults.setObject(languageKeys[0], forKey: "languageKey")
            }
        }
        
        terms = realmTerms
        
        title = currentLanguage
        
        navigationController!.view.addGestureRecognizer(slidingViewController().panGesture)
        slidingViewController().topViewAnchoredGesture = [.Tapping, .Panning]
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
    }
    
    // Data
    
    func checkEmpty() {
        if terms.isEmpty {
            tableViewBackground = UIView()
            tableViewBackground!.backgroundColor = UIColor(white: 0.8, alpha: 1)
            
            let emptyLabel = UILabel()
            emptyLabel.text = "No Terms Yet!"
            emptyLabel.textColor = UIColor(white: 0.5, alpha: 1)
            emptyLabel.numberOfLines = 0
            emptyLabel.font = UIFont.boldSystemFontOfSize(24)
            emptyLabel.textAlignment = .Center
            emptyLabel.sizeToFit()
            emptyLabel.translatesAutoresizingMaskIntoConstraints = false
            tableViewBackground!.addSubview(emptyLabel)
            let centerXConstraint = NSLayoutConstraint(item: emptyLabel, attribute: .CenterX, relatedBy: .Equal, toItem: tableViewBackground, attribute: .CenterX, multiplier: 1, constant: 0)
            let centerYConstraint = NSLayoutConstraint(item: emptyLabel, attribute: .CenterY, relatedBy: .Equal, toItem: tableViewBackground, attribute: .CenterY, multiplier: 1, constant: -(navigationController?.navigationBar.frame.height)!)
            
            tableViewBackground!.addConstraints([centerXConstraint, centerYConstraint])
            tableViewBackground!.frame = tableView.frame
            
            tableView.addSubview(tableViewBackground!)
            tableView.sendSubviewToBack(tableViewBackground!)
        } else {
            tableViewBackground?.removeFromSuperview()
        }
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        getTerms()
    }
    
    func getTerms() {
        TermManager.getNewTerms({ (error) in
            if error != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    if error!.code == -100 {
                        self.alertJSONError()
                    } else {
                        self.alertConnectionError(error!.code)
                    }
                    self.refreshControl?.endRefreshing()
                }
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.addTermsToTable()
            }
        })
    }
    
    func addTermsToTable() {
        
        let newTerms = realmTerms
        var indexPaths = [NSIndexPath]()
        for term in newTerms {
            if !terms.contains( { $0.id == term.id } ) {
                if let index = newTerms.indexOf({ $0.id == term.id! }) {
                    indexPaths.append(NSIndexPath(forRow: index, inSection: 0))
                }
            }
        }
        terms = newTerms
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        
        self.refreshControl?.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return terms.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("termCell", forIndexPath: indexPath) as! TermCell
        if currentLanguage == "Chinese" {
            cell.languageLabel.text = terms[indexPath.row].chinese
        } else {
            cell.languageLabel.text = terms[indexPath.row].korean
        }
        cell.romanizationLabel.text = terms[indexPath.row].romanization
        
        cell.englishLabel.text = terms[indexPath.row].english
        cell.formalityLabel.text = terms[indexPath.row].formality
        
        if NSCalendar.currentCalendar().isDateInToday(terms[indexPath.row].termDate) {
            cell.dateLabel.text = "Today"
        } else if NSCalendar.currentCalendar().isDateInYesterday(terms[indexPath.row].termDate) {
            cell.dateLabel.text = "Yesterday"
        } else {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "MMM d"
            
            cell.dateLabel.text = formatter.stringFromDate(terms[indexPath.row].termDate)
        }
        
        return cell
    }
    
    // Error Messages
    
    func alertJSONError() {
        let alertController = UIAlertController(title: "A JSON Error Occurred", message: "Please pray for a fix.", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(OKAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func alertConnectionError(code: Int) {
        let alertController = UIAlertController(title: "Unable to Reach Server", message: "Error code: \(code).", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(OKAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // 3D Touch methods
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let tableViewPoint = view.convertPoint(location, toView: tableView)
        
        guard let indexPath = tableView.indexPathForRowAtPoint(tableViewPoint),
            cell = tableView.cellForRowAtIndexPath(indexPath) else { return nil }
        
        guard let peekViewController = storyboard?.instantiateViewControllerWithIdentifier("TermDetailViewController") as? TermDetailViewController else { return nil }
        
        peekViewController.term = terms[indexPath.row]
        
        peekViewController.preferredContentSize = CGSize(width: 0.0, height: 0.0)
        
        let tableViewFrame = view.convertRect(cell.frame, fromView: tableView)
        previewingContext.sourceRect = tableViewFrame
        
        return peekViewController
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        showViewController(viewControllerToCommit, sender: self)
    }
    
    // MARK: - Navigation
    
    @IBAction func addedNewTerm(segue: UIStoryboardSegue) {
        if segue.identifier == "addedNewTerm" {
            self.addTermsToTable()
        }
    }
    
    @IBAction func cancelledNewTerm(segue: UIStoryboardSegue) {    }
    
    @IBAction func deletedTerm(segue: UIStoryboardSegue) {
        if let index = terms.indexOf({ $0.invalidated }) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            terms = realmTerms
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let destination = segue.destinationViewController as? TermDetailViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    destination.term = terms[indexPath.row]
                }
            }
        }
        if segue.identifier == "newTerm" {
            if let destination = (segue.destinationViewController as! UINavigationController).topViewController as? NewTermViewController {
                destination.language = currentLanguage
            }
        }
    }
}
