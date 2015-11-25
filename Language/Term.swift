//
//  Term.swift
//  Language
//
//  Created by Daniel Li on 11/5/15.
//  Copyright © 2015 Dannical. All rights reserved.
//

import Foundation
import RealmSwift

class Term: Object {
    dynamic var id: String? = nil // Uncomment when implement sync
//    dynamic var id = NSUUID().UUIDString
    dynamic var language: String = ""
    dynamic var chinese: String = ""
    dynamic var korean: String = ""
    dynamic var formality: String = ""
    dynamic var romanization: String = ""
    dynamic var english: String = ""
    dynamic var termDate: NSDate = NSDate()
    dynamic var termDateString: String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = DateStringFormat
        return formatter.stringFromDate(termDate)
    }
    dynamic var creationDate: NSDate? = nil
    
    override dynamic var description: String {
        return "[\(language) Term meaning '\(english)' at date \(termDate) with id \(id)]"
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}