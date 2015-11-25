//
//  NetworkManager.swift
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
let DOMAIN = "http://www.somedomain.com"
let GETURL = "/words/fetch_new/"
let POSTURL = "/words.json"

class NetworkManager {
    class func getNewTerms(completionHandler: (data: NSData?, error: NSError?) -> Void) {
        
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
        let request = NSMutableURLRequest(URL: NSURL(string: DOMAIN + GETURL + id)!)
        request.HTTPMethod = "GET"
        
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                completionHandler(data: nil, error: error)
                return
            }
            completionHandler(data: data, error: nil)
        })
        dataTask.resume()
    }
    
    class func postNewTerm(termToPost: Term, completionHandler: (data: NSData?, error: NSError?) -> Void) {
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForResource = 3.0
        
        let session = NSURLSession(configuration: configuration)
        
        let request = NSMutableURLRequest(URL: NSURL(string: DOMAIN + POSTURL)!)
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
                completionHandler(data: nil, error: error)
                return
            }
            completionHandler(data: data, error: nil)
        })
        dataTask.resume()
    }
}