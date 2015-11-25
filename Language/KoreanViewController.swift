//
//  KoreanViewController.swift
//  Language
//
//  Created by Daniel Li on 11/5/15.
//  Copyright © 2015 Dannical. All rights reserved.
//

import UIKit
import RealmSwift

class KoreanViewController: UITableViewController {
    
    var terms = [Term]()
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    var tableViewBackground: UIView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Remove empty cell separators
        tableView.tableFooterView = UIView(frame: CGRectZero)
        refreshControl?.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: .ValueChanged)
        
        realmToModel()
        checkEmpty()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
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
        NetworkManager.getNewTerms({ (data, error) in
            
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), {
                    self.alertConnectionError(error!.code)
                    self.refreshControl?.endRefreshing()
                })
            }
            
            if let dataFromNetworking = data {
                do {
                    let jsonArray = try NSJSONSerialization.JSONObjectWithData(dataFromNetworking, options: []) as! [NSDictionary]
                    dispatch_async(dispatch_get_main_queue(), {
                        let realm = try! Realm()
                        try! realm.write({
                            for json in jsonArray {
                                let term = realm.create(Term.self, value: json, update: true)
                                let termDateJSON = json["termDateJSON"] as? String
                                let creationDateJSON = json["created_at"] as? String
                                let formatter = NSDateFormatter()
                                formatter.dateFormat = DateStringFormat
                                formatter.locale = NSLocale.currentLocale()
                                term.termDate = formatter.dateFromString(termDateJSON!)!
                                term.creationDate = formatter.dateFromString(creationDateJSON!)!
                                
                                self.realmToModel()
                                if let index = self.terms.indexOf({ $0.id == term.id! }) {
                                    self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .Top)
                                }
                            }
                        })
                        self.refreshControl?.endRefreshing()
                        self.checkEmpty()
                    })
                } catch {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.alertJSONError()
                        self.refreshControl?.endRefreshing()
                    })
                }
            }
        })
    }
    
    func realmToModel() {
        let realm = try! Realm()
        terms = realm.objects(Term).filter( { $0.language == "korean" }).sort({ $0.termDate > $1.termDate })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return terms.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("termCell", forIndexPath: indexPath) as! TermCell
        cell.languageLabel.text = terms[indexPath.row].korean
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
    
    // MARK: - Navigation
    
    @IBAction func addedNewTerm(segue: UIStoryboardSegue) {
        if let source = segue.sourceViewController as? NewTermViewController {
            realmToModel()
            
            let id = source.term.id
            let index = terms.indexOf({ $0.id == id })
            
            tableView.beginUpdates()
            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: index!, inSection: 0)], withRowAnimation: .Top)
            tableView.endUpdates()
        }
    }
    
    @IBAction func cancelledNewTerm(segue: UIStoryboardSegue) {    }
    
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
                destination.language = "Korean"
            }
        }
    }
    
}
