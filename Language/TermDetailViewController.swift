//
//  TermDetailViewController.swift
//  Language
//
//  Created by Daniel Li on 11/5/15.
//  Copyright © 2015 Dannical. All rights reserved.
//

import UIKit
import RealmSwift

class TermDetailViewController: UIViewController {

    @IBOutlet weak var formalityLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var romanizationLabel: UILabel!
    @IBOutlet weak var englishLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBAction func deleteButton(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete Term", style: .Destructive) { Void in
            NetworkManager.deleteTerm(self.term) { (data, response, error) in
                if error != nil {
                    self.alertDeletionFail()
                }
                if let data = data {
                    do {
                        if let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String : Int] {
                            if json["status"] == 1 {
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.performSegueWithIdentifier("deletedTerm", sender: self)
                                }
                            } else {
                                self.alertDeletionFail()
                            }
                        } else {
                            print("json couldn't read")
                        }
                    } catch {
                        
                    }
                }
            }
        }
        alertController.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    var term: Term!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationItem.backBarButtonItem?.tintColor = UIColor.whiteColor()
        
        formalityLabel.text = term.formality
        if term.language == "chinese" {
            languageLabel.text = term.chinese
        } else {
            languageLabel.text = term.korean
        }
        romanizationLabel.text = term.romanization
        englishLabel.text = term.english
        let formatter = NSDateFormatter()
        formatter.dateStyle = .LongStyle
        dateLabel.text = formatter.stringFromDate(term.termDate)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func alertDeletionFail() {
        let alertController = UIAlertController(title: "Could not delete Term", message: nil, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(okAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
