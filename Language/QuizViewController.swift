//
//  QuizViewController.swift
//  Language
//
//  Created by Daniel Li on 11/13/15.
//  Copyright © 2015 Dannical. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {

    @IBAction func quitButton(sender: UIButton) {
        
    }
    
    @IBOutlet weak var previousButton: UIButton!
    @IBAction func previousButton(sender: UIButton) {
        if currentQuestionIndex > 0 {
            prevQuestion()
        }
    }
    
    @IBOutlet weak var nextButton: UIButton!
    @IBAction func nextButton(sender: UIButton) {
        if currentQuestionIndex < questions.count - 1 {
            nextQuestion()
        }
    }
    
    
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var questionOutOfLabel: UILabel!
    
    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var romanizationLabel: UILabel!
    
    @IBOutlet weak var translateLabel: UILabel!
    
    @IBOutlet weak var answerTextField: UITextField!
    @IBAction func answerChanged(sender: UITextField) {
        question.response = answerTextField.text
    }
    
    
    
    
    
    
    var questions = [Question]()
    
    var currentQuestionIndex = 0
    
    var question: Question {
        return questions[currentQuestionIndex]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Generate questions
        
        questions.append(Question(ofType: QuestionType.Matching, q: "你好", a: "Hello", r: "Test"))
        questions.append(Question(ofType: QuestionType.Matching, q: "LOL", a: "Hello", r: "Test"))
        questions.append(Question(ofType: QuestionType.Matching, q: "Question", a: "Hello", r: "Test"))
        
        updateQuestionView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nextQuestion() {
        // Exit Animation
        currentQuestionIndex = currentQuestionIndex + 1
        updateQuestionView()
        // Enter Animation
    }
    
    func prevQuestion() {
        // EXIT animation
        currentQuestionIndex = currentQuestionIndex - 1
        updateQuestionView()
        // enter animation
    }
    
    func updateQuestionView() {
        
        if currentQuestionIndex == 0 {
            previousButton.enabled = false
        } else {
            previousButton.enabled = true
        }
        
        if currentQuestionIndex == questions.count - 1 {
            nextButton.setTitle("Submit", forState: .Normal)
            nextButton.titleLabel?.font = UIFont.boldSystemFontOfSize(15)
        } else {
            nextButton.setTitle("Next", forState: .Normal)
            nextButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        }
        
        
        questionNumberLabel.text = "Question \(currentQuestionIndex + 1)"
        questionOutOfLabel.text = "of \(questions.count)"
        
        termLabel.text = question.question
        answerTextField.text = question.response
        
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
