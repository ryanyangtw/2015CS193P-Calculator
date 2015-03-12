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
  
  var userIsInTheMiddleOfTypingANumber = false
  
  // connact to model
  var brain = CalculatorBrain()
  
  
  @IBAction func appendDigit(sender: UIButton) {
    // digit is a optional that can be string
    let digit = sender.currentTitle!
    //println("digit = \(digit)")
    //println("digit = \(digit!)")
    

    if userIsInTheMiddleOfTypingANumber {
      
      println("In userIsInTheMiddleOfTypingANumber")
      if digit == "." {
        if self.display.text!.rangeOfString(".") == nil {
          self.display.text = self.display.text! + digit
        }
      } else if digit == "π" {
        enter()
        self.display.text = "\(M_PI)"
        enter()
      } else {
        self.display.text = self.display.text! + digit
      }
      
    } else {
      
      userIsInTheMiddleOfTypingANumber = true
      
      if digit == "." {
        self.display.text = "0."
      } else if digit == "π" {
        self.display.text = "\(M_PI)"
        // userIsInTheMiddleOfTypingANumber will be modified to false in the enter()
        enter()
      } else {
        self.display.text = digit
      }
    
      
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
    if let result = brain.pushOperand(displayValue) {
      displayValue = result
    } else {
      // error
      displayValue = 0
    }
  }
  
  // Computed property
  var displayValue: Double {
    get {
      return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
    }
    set {
      // newValue means set value
      self.display.text = "\(newValue)"
      userIsInTheMiddleOfTypingANumber = false
    }
  }
  
  

}

