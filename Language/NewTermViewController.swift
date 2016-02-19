//
//  NewTermViewController.swift
//  Language
//
//  Created by Daniel Li on 11/6/15.
//  Copyright © 2015 Dannical. All rights reserved.
//

import UIKit
import RealmSwift

class NewTermViewController: UITableViewController {

    var language: String!
    let term = Term()
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBAction func addButton(sender: UIBarButtonItem) {
        addButton.enabled = false
        if language == "Chinese" {
            term.language = "chinese"
            term.chinese = asianTextField.text!
        } else {
            term.language = "korean"
            term.korean = asianTextField.text!
        }
        term.formality = formalityTextField.text!
        term.romanization = romanizationTextField.text!
        term.english = englishTextField.text!
        term.termDate = datePicker.date
        
        TermManager.getNewTerms({ (error) in
            if error != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    self.alertNetworkError(error!.code)
                }
                return
            }
            
            // Post term
            TermManager.postTerm(self.term, completionHandler: { (error) in
                if error != nil {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.alertNetworkError(error!.code)
                    }
                    return
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("addedNewTerm", sender: self)
                }
            })
        })
    }
    
    @IBAction func cancelButton(sender: UIBarButtonItem) {
        
    }
    
    var requiredTextFields = [UITextField]()
    
    @IBOutlet weak var asianTextField: UITextField!
    @IBAction func asianTextField(sender: UITextField) {
        checkAddButton()
    }

    @IBOutlet weak var romanizationTextField: UITextField!
    @IBAction func romanizationTextField(sender: UITextField) {
        checkAddButton()
    }
    @IBOutlet weak var englishTextField: UITextField!
    @IBAction func englishTextField(sender: UITextField) {
        checkAddButton()
    }
    @IBOutlet weak var formalityTextField: UITextField!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBAction func datePicker(sender: UIDatePicker) {
        if NSCalendar.currentCalendar().isDateInToday(sender.date) {
            dateLabel.text = "Today"
        } else if NSCalendar.currentCalendar().isDateInYesterday(sender.date) {
            dateLabel.text = "Yesterday"
        } else {
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            dateLabel.text = formatter.stringFromDate(sender.date)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        asianTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton.enabled = false
        requiredTextFields.append(asianTextField)
        requiredTextFields.append(romanizationTextField)
        requiredTextFields.append(englishTextField)
        
        datePicker.date = NSDate()
        
        if language == "Korean" {
            asianTextField.placeholder = "워드"
        } else {
            asianTextField.placeholder = "字母"
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 3 && indexPath.row == 0 {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                tableView.scrollRectToVisible(self.datePicker.frame, animated: true)
            })
            tableView.beginUpdates()
            tableView.endUpdates()
            CATransaction.commit()
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return language
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 3 && indexPath.row == 1 {
            return 180
        }
        return 44
    }
    
    func checkAddButton() {
        var addable = true
        
        for textField in requiredTextFields {
            if textField.text == "" {
                addable = false
            }
        }
        
        if addable {
            addButton.enabled = true
        } else {
            addButton.enabled = false
        }
    }
    
    func alertNetworkError(code: Int) {
        
        var title = ""
        var message = "code: \(code)"
        
        switch code {
        case -1009:
            title = "Unable to Reach Server"
            message = "Check your internet connection"
        case 500:
            title = "Server Error"
            break
        default:
            title = "Unknown Error"
        }
        
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { Void in
            self.addButton.enabled = true
        }
        alertController.addAction(OKAction)
        
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
