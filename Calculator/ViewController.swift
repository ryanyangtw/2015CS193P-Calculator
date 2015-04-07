//
//  ViewController.swift
//  Calculator
//
//  Created by Ryan on 2015/3/6.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var display: UILabel! // = nil  // implicitly  unwrap optional
  @IBOutlet weak var history: UILabel!
  
  var userIsInTheMiddleOfTypingANumber = false
  
  // connact to model
  var brain = CalculatorBrain()
  
  
  @IBAction func appendDigit(sender: UIButton) {
    // digit is a optional that can be string
    let digit = sender.currentTitle!
    //println("digit = \(digit)")
    //println("digit = \(digit!)")
    

    if userIsInTheMiddleOfTypingANumber {
      
      if (digit == ".") && (self.display.text!.rangeOfString(".") != nil) { return }
      if (digit == "0") && ((self.display.text == "0") || (display.text == "-0")) { return }
      if (digit != ".") && ((self.display.text == "0") || (display.text == "-0")) {
        
        if (self.display.text == "0") {
          self.display.text = digit
        } else {
          self.display.text = "-" + digit
        }

      } else {
        self.display.text = display.text! + digit
      }
      
    } else {
      
      if digit == "." {
        self.display.text = "0."
      } else {
        self.display.text = digit
      }
      
      userIsInTheMiddleOfTypingANumber = true
      displayHistoryWithEqual(false)

    }
  }

  
  
  @IBAction func operate(sender: UIButton) {
    
    if userIsInTheMiddleOfTypingANumber {
      if (sender.currentTitle == "±") {
        //self.display.text = "-" + self.display.text!
        reverseSign()
        return
      }
      enter()
    }
    
    if let operation = sender.currentTitle {
      if let result = brain.performOperation(operation) {
        displayValue = result
      } else {
        // error
        displayValue = nil
      }
    }
    println("brain.description: \(brain.description)")
    //displayHistoryWithEqual(true)
  }

  
  
  @IBAction func enter() {
    userIsInTheMiddleOfTypingANumber = false
    if displayValue != nil {
      if let result = brain.pushOperand(displayValue!) {
        displayValue = result
      } else {
        // error
        displayValue = nil
      }
    }
    
    println("brain.description: \(brain.description)")
    //displayHistoryWithEqual(true)
  }
  
  @IBAction func clear() {
    self.brain = CalculatorBrain()
    self.displayValue = nil
    self.history.text = ""
  }
  
  
  @IBAction func undo() {
    
    if userIsInTheMiddleOfTypingANumber {
      
      let displayText = self.display.text!
      
      if (countElements(displayText) > 1) {
        if (countElements(displayText) == 2 && self.display.text?.hasPrefix("-") != nil) {
          self.display.text = "-0"
        } else {
          // normal seneria
          self.display.text = dropLast(displayText)
        }
      } else {
        self.display.text = "0"
      }
    
    
    }
  }
  
  func displayHistoryWithEqual(shouldDisplay: Bool) {
    if shouldDisplay {
      self.history.text = self.history.text! + " ="
    } else {
      self.history.text = self.brain.displayHistory()
    }
  }
  
  func reverseSign() {
    let displayText = self.display.text!
    if (displayText.hasPrefix("-")) {
      self.display.text = dropFirst(displayText)
    } else {
      self.display.text = "-" + displayText
    }
  }
  
  
  
  // Computed property
  var displayValue: Double? {
    get {
      /*
      if let displayText = display.text {
        if let displayNumber = NSNumberFormatter().numberFromString(displayText) {
          return displayNumber.doubleValue
        }
      }
      return nil
      */
      return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
    }
    set {
      // newValue means set value

      if (newValue != nil) {
        self.display.text = "\(newValue!)"
        /*
        let checkValue = Double(Int(newValue!))
        if (checkValue == newValue!) {
          self.display.text = "\(Int(newValue!))"
        } else {
          self.display.text = "\(newValue!)"
        }
        */

      } else {
        self.display.text = "0"
      }
      self.history.text = self.brain.displayHistory()
      userIsInTheMiddleOfTypingANumber = false
      
      let string = self.brain.displayHistory()
      if !string!.isEmpty {
        displayHistoryWithEqual(true)
      }
    }
  }
  
  
  
  
  

}

