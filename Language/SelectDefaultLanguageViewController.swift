//
//  SelectDefaultLanguageViewController.swift
//  Language
//
//  Created by Daniel Li on 11/7/15.
//  Copyright © 2015 Dannical. All rights reserved.
//

import UIKit

class SelectDefaultLanguageViewController: UITableViewController {

    var selectedIndex: Int!
    let languages = ["Chinese", "Korean"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = NSUserDefaults.standardUserDefaults()
        if let identifier = defaults.objectForKey("topIdentifier") as? String {
            if identifier == identifiers[1] {
                selectedIndex = 1
            } else {
                selectedIndex = 0
            }
        } else {
            selectedIndex = 0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("languageCell", forIndexPath: indexPath)

        cell.textLabel?.text = languages[indexPath.row]
        if indexPath.row == selectedIndex {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath != selectedIndex {
            swap(&titles[0], &titles[1])
            swap(&images[0], &images[1])
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(identifiers[indexPath.row], forKey: "topIdentifier")
        
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: selectedIndex, inSection: 0))
        cell?.accessoryType = .None
        
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)
        currentCell?.accessoryType = .Checkmark
        
        selectedIndex = indexPath.row
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.postNotificationName("updatedDefaultLanguage", object: self)
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
