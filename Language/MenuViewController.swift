//
//  MenuViewController.swift
//  Language
//
//  Created by Daniel Li on 11/5/15.
//  Copyright © 2015 Dannical. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {
    
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorInset = UIEdgeInsetsMake(0, 64, 0, 0)
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: "updatedDefaultLanguage:", name: "updatedDefaultLanguage", object: nil)
    }
    
    func updatedDefaultLanguage(notification: NSNotification) {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        selectedIndex = indexPath.row
        tableView.reloadData()
        performSegueWithIdentifier(titles[indexPath.row], sender: self)
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        return titles.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("menuCell", forIndexPath: indexPath) as! MenuCell
        
        let backgroundView = UIView(frame: cell.frame)
        backgroundView.backgroundColor = UIColor(white: 1, alpha: 0.2)
        cell.selectedBackgroundView = backgroundView
        cell.backgroundColor = UIColor.clearColor()
        cell.label.text = titles[indexPath.row]
        
        if indexPath.row == selectedIndex {
            cell.label.textColor = UIColor(red: 52/255, green: 111/255, blue: 199/255, alpha: 1.0)
            cell.iconImageView.image = images[indexPath.row]?.tintWithColor(UIColor(red: 52/255, green: 111/255, blue: 199/255, alpha: 1.0))
        } else {
            cell.label.textColor = UIColor(red: 212/255, green: 212/255, blue: 212/255, alpha: 1.0)
            cell.iconImageView.image = images[indexPath.row]?.tintWithColor(UIColor(red: 212/255, green: 212/255, blue: 212/255, alpha: 1.0))
        }
        
        return cell
    }
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }

}
