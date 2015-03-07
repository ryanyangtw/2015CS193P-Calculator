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
  
  
  @IBAction func appendDigit(sender: UIButton) {
    // digit is a optional that can be string
    let digit = sender.currentTitle!
    //println("digit = \(digit)")
    //println("digit = \(digit!)")
    if userIsInTheMiddleOfTypingANumber {
      self.display.text = self.display.text! + digit
    } else {
      self.display.text = digit
      userIsInTheMiddleOfTypingANumber = true
    }
  }

  
  
  @IBAction func operate(sender: UIButton) {
    let operation = sender.currentTitle!
    
    if userIsInTheMiddleOfTypingANumber {
      enter()
    }
    
    switch operation {
    // It shows different way to send the closure to anotehr methos
    case "×": performOperation() {
      (op1: Double, op2: Double) -> Double in
        return op1 * op2
    }
    case "÷": performOperation() { (op1, op2) in return op2/op1 }
    case "+": performOperation() { (op1, op2) in op1 + op2 }
    case "−": performOperation { $1 - $0}
    case "√": performOperation { sqrt($0) }
    default : break
    }
    
    
  }
  
  func performOperation(operation: (Double, Double) -> Double) {
    if operandStack.count >= 2 {
      displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
      enter()
    }
  }
  
  func performOperation(operation: Double -> Double) {
    if operandStack.count >= 1 {
      displayValue = operation(operandStack.removeLast())
      enter()
    }
  }
  
  
  
  
  var operandStack = Array<Double>()
  @IBAction func enter() {
    userIsInTheMiddleOfTypingANumber = false
    operandStack.append(displayValue)
    println("operand = \(operandStack)")
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

