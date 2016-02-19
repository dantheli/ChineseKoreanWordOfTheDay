//
//  SettingsViewController.swift
//  Language
//
//  Created by Daniel Li on 11/5/15.
//  Copyright © 2015 Dannical. All rights reserved.
//

import UIKit
import RealmSwift
import ECSlidingViewController

class SettingsViewController: UITableViewController {

    @IBOutlet weak var deleteLabel: UILabel!
    @IBOutlet weak var deleteCell: UITableViewCell!
    
    @IBOutlet weak var languageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDeleteCell()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        navigationController!.view.addGestureRecognizer(slidingViewController().panGesture)
        slidingViewController().topViewAnchoredGesture = [.Tapping, .Panning]
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let languageKey = defaults.objectForKey("languageKey") as? String {
            if languageKey == "Chinese" {
                languageLabel.text = "Chinese"
            } else {
                languageLabel.text = "Korean"
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 1 {
            confirmDeleteAllTerms()
        }
    }

    func confirmDeleteAllTerms() {
        let alertController = UIAlertController(title: "Really delete all terms?", message: "", preferredStyle: .ActionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: { Void in
            let realm = try! Realm()
            try! realm.write {
                realm.deleteAll()
            }
            self.updateDeleteCell()
        })
        alertController.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func updateDeleteCell() {
        let realm = try! Realm()
        if realm.isEmpty {
            deleteCell.userInteractionEnabled = false
            deleteLabel.textColor = UIColor.lightGrayColor()
        } else {
            deleteCell.userInteractionEnabled = true
            deleteLabel.textColor = UIColor(red: 249/255, green: 0, blue: 41/255, alpha: 1)
        }
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return "Select language to show on app launch and at the top of the side menu."
        }
        if section == 1 {
            return "Terms stored in the cloud will be unaffected."
        }
        if section == 2 {
            if let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String {
                return "Version \(version)"
            }
        }
        return nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
