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
      if (digit == "0") && (self.display.text == "0") { return }
      if (digit != ".") && (self.display.text == "0") {
        self.display.text = digit
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
    
      
    }
  }

  
  
  @IBAction func operate(sender: UIButton) {
    
    if userIsInTheMiddleOfTypingANumber {
      enter()
    }
    
    if let operation = sender.currentTitle {
      if let result = brain.performOperation(operation) {
        displayValue = result
      } else {
        // error
        displayValue = 0
      }
    }
    
  }

  
  
  @IBAction func enter() {
    userIsInTheMiddleOfTypingANumber = false
    if let result = brain.pushOperand(displayValue!) {
      displayValue = result
    } else {
      // error
      displayValue = nil
    }
  }
  
  @IBAction func clear() {
    self.brain = CalculatorBrain()
    self.displayValue = nil
    self.history.text = ""
  }
  
  
  @IBAction func undo() {
    
    let str = self.display.text!
    
    if (str == "0") {
      return
    } else if (countElements(str) == 1) {
      self.display.text = "0"
    } else {
      self.display.text = dropLast(str)
      //self.displayValue = NSNumberFormatter().numberFromString(dropLast(str))!.doubleValue
    }
    
  }
  
  
  
  // Computed property
  var displayValue: Double? {
    get {
      return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
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
    }
  }
  
  
  
  
  

}

