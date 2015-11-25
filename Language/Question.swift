//
//  Question.swift
//  Language
//
//  Created by Daniel Li on 11/14/15.
//  Copyright © 2015 Dannical. All rights reserved.
//

import Foundation

enum QuestionType {
    case Typing
    case Matching
    case MultipleChoice
}

class Question: NSObject {
    
    private var _question: String!
    var question: String {
        return _question
    }
    
    private var _answer: String!
    var answer: String! {
        return _answer
    }
    
    private var _response: String?
    var response: String? {
        get {
            return _response
        }
        set {
            _response = newValue
        }
    }
    private var _questionType: QuestionType!
    var questionType: QuestionType {
        return _questionType
    }
    
    init(ofType type: QuestionType, q: String, a: String, r: String?) {
        _question = q
        _answer = a
        _questionType = type
        _response = r
    }
}