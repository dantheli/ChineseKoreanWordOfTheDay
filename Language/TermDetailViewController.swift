//
//  TermDetailViewController.swift
//  Language
//
//  Created by Daniel Li on 11/5/15.
//  Copyright © 2015 Dannical. All rights reserved.
//

import UIKit

class TermDetailViewController: UIViewController {

    @IBOutlet weak var formalityLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var romanizationLabel: UILabel!
    @IBOutlet weak var englishLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
