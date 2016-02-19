//
//  TermManager.swift
//  Language
//
//  Created by Daniel Li on 11/6/15.
//  Copyright © 2015 Dannical. All rights reserved.
//

import Foundation
import RealmSwift

// Date format when parsing JSON and posting parameters
let DateStringFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSS'Z'"

// HTTP REST API URLs
let Domain = "http://ckwordoftheday.njay.net/"
let GetTermsURL = "words/fetch_new/"
let PostTermURL = "words.json"
let DeleteTermURL = "words/"

class TermManager {
    /** Gets all Terms added to the server after the last Term on device was added to the server and stores in Realm. */
    class func getNewTerms(completionHandler: (error: NSError?) -> Void) {
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForResource = 10.0
        
        let session = NSURLSession(configuration: configuration)
        
        let realm = try! Realm()
        let id: String!
        
        if let lastTermID = realm.objects(Term).sort({ $0.creationDate < $1.creationDate }).last?.id {
            id = lastTermID
        } else {
            id = "-1"
        }
        
        let request = NSMutableURLRequest(URL: NSURL(string: Domain + GetTermsURL + id)!)
        request.HTTPMethod = "GET"
        
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                completionHandler(error: error)
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
                            }
                        })
                    })
                } catch {
                    dispatch_async(dispatch_get_main_queue(), {
                        let JSONError = NSError(domain: "JSON", code: -200, userInfo: nil)
                        completionHandler(error: JSONError)
                    })
                }
            }
            completionHandler(error: nil)
        })
        dataTask.resume()
    }
    
    class func postTerm(termToPost: Term, completionHandler: (error: NSError?) -> Void) {
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForResource = 5.0
        
        let session = NSURLSession(configuration: configuration)
        
        let request = NSMutableURLRequest(URL: NSURL(string: Domain + PostTermURL)!)
        request.HTTPMethod = "POST"
        
        var bodyData = "word[language]=" + termToPost.language
        bodyData += "&word[chinese]=" + termToPost.chinese
        bodyData += "&word[korean]=" + termToPost.korean
        bodyData += "&word[formality]=" + termToPost.formality
        bodyData += "&word[romanization]=" + termToPost.romanization
        bodyData += "&word[english]=" + termToPost.english
        bodyData += "&word[termDateJSON]=" + termToPost.termDateString
        print("Posting parameters: " + bodyData)
        
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
        
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                completionHandler(error: error)
            }
            if let dataFromNetworking = data {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(dataFromNetworking, options: []) as! [String]
                    termToPost.id = json[0]
                    let formatter = NSDateFormatter()
                    formatter.dateFormat = DateStringFormat
                    termToPost.creationDate = formatter.dateFromString(json[1])!
                    dispatch_async(dispatch_get_main_queue(), {
                        let realm = try! Realm()
                        try! realm.write {
                            realm.add(termToPost)
                        }
                    })
                } catch {
                    // Implement me!
                }
            }
            completionHandler(error: nil)
        })
        dataTask.resume()
    }
    
    class func deleteTerm(termToDelete: Term, completionHandler: (error: NSError?) -> Void) {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForResource = 3.0
        
        let session = NSURLSession(configuration: configuration)
        
        let requestURL = NSURL(string: Domain + DeleteTermURL + termToDelete.id! + ".json")!
        let request = NSMutableURLRequest(URL: requestURL)
        request.HTTPMethod = "DELETE"
        
        let dataTask = session.dataTaskWithRequest(request) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            if let data = data {
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String : Int] {
                        if json["status"] == 1 {
                            dispatch_async(dispatch_get_main_queue()) {
                                let realm = try! Realm()
                                try! realm.write {
                                    realm.delete(termToDelete)
                                }
                            }
                        } else {
                            let error = NSError(domain: "Deletion Error", code: -101, userInfo: nil)
                            completionHandler(error: error)
                        }
                    } else {
                        print("json couldn't read")
                    }
                } catch {
                    // Implement me!
                }
            }
            completionHandler(error: error)
        }
        dataTask.resume()
    }
}