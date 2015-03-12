//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Ryan on 2015/3/12.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

import Foundation

class CalculatorBrain
{
  //Add Printable protocol  (this protocol happens to just be one computer property called Description that returns the string )
  private enum Op: Printable {
    
    case Operand(Double)
    case UnaryOperation(String, Double -> Double)
    case BinaryOperation(String, (Double, Double) -> Double)
    
    // Implement Printable protocol for printing the readable enum variable
    var description: String {
      get {
        switch self {
        case .Operand(let operand):
          return "\(operand)"
        case .UnaryOperation(let symbol, _):
          return symbol
        case .BinaryOperation(let symbol, _):
          return symbol
        }
      }
    }
  }
  
  
  // var opStack = Array<Op>()
  private var opStack = [Op]()
  
  // var knownOpa = Dictionary<String, Op>()
  private var knownOps = [String:Op]()
  
  init() {
    
    // this function just can be used in init()
    func learnOp (op: Op) {
      knownOps[op.description] = op
    }
    
    // knowOps["×"] = Op.BinaryOperation("×") { $0 * $1}
    // knowOps["×"] = Op.BonaryOperation("×", *)
    learnOp(Op.BinaryOperation("×", *))
    // knownOps["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
    learnOp(Op.BinaryOperation("÷") { $1 / $0 } )
    // knownOps["+"] = Op.BinaryOperation("+") { $0 + $1 }
    // knownOps["+"] = Op.BinaryOperation("+", +)
    learnOp(Op.BinaryOperation("+", +))
    // knownOps["−"] = Op.BinaryOperation("−") { $1 - $0 }
    learnOp(Op.BinaryOperation("−") { $1 - $0} )
    // knownOps["√"] = Op.UnaryOperation("√") { sqrt($0) }
    // knownOps["√"] = Op.UnaryOperation("√", sqrt)
    learnOp(Op.UnaryOperation("√", sqrt))
    learnOp(Op.UnaryOperation("Sin", sin))
    learnOp(Op.UnaryOperation("Cos", cos))
    //learnOp(Op.UnaryOperation("π") { $0 * M_PI } )
    
  }
  
  // There is an implicit let in front of all things you pass (read-only)
  private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
    if !ops.isEmpty {
      var remainingOps = ops
      let op = remainingOps.removeLast()
      
      switch op {
      case .Operand(let operand):
        return (operand, remainingOps)
      
      case .UnaryOperation(_, let operation):
        let operandEvaluation = evaluate(remainingOps)
        if let operand = operandEvaluation.result {
          return (operation(operand), operandEvaluation.remainingOps)
        }
        
      case .BinaryOperation(_, let operation):
        let op1Evaluation = evaluate(remainingOps)
        if let operand1 = op1Evaluation.result {
          let op2Evaluation = evaluate(op1Evaluation.remainingOps)
          if let operand2 = op2Evaluation.result {
            return (operation(operand1, operand2), op2Evaluation.remainingOps)
          }
        }
        
        
      }
    }
    
    return (nil, ops)
  
  }

  
  /*
  private func evaluate(ops: [Op]) -> Double? {
    if !ops.isEmpty {
      var remainingOps = ops
      let op = remainingOps.removeLast()
      
      switch op {
      case .Operand(let operand):
        return operand
        
      case .UnaryOperation(_, let operation):
        let operandEvaluation = evaluate(remainingOps)
        if let operand = operandEvaluation {
          return (operation(operand))
        }
        
        
        
      case .BinaryOperation(_, let operation):
        
        var splitPoint: Int? = nil
        var breakPoint = false
        for (index, item) in enumerate(remainingOps) {
          println("index: \(index)")
          switch item {
          case .Operand(_):
            splitPoint = index
            breakPoint = true
          default:
            continue
          }
        
          if breakPoint {
            break
          }
        }
        
        if splitPoint != nil && splitPoint!+1 <= remainingOps.count-1{
          let ops1 = Array(remainingOps[0...splitPoint!]) //as [CalculatorBrain.Op]
          let ops2 = Array(remainingOps[(splitPoint!+1)...(remainingOps.count-1)]) //as [CalculatorBrain.Op]
        
        
          if let operand1 = evaluate(ops1) {
            if let operand2 = evaluate(ops2) {
              return (operation(operand1, operand2))
            }
          }
        } else {
          return nil
        }
    
      }
     
    }
    
    return nil
  }
  */
  
  func evaluate() -> Double? {
    let (result, remainder) = evaluate(opStack)
    //let result = evaluate(opStack)
    println("\(self.opStack) = \(result) with \(remainder) left over")
    //println("\(self.opStack) = \(result) with")
    return result
  }
  
  func pushOperand(operand: Double) -> Double? {
    
    println("in pushoperand: \(operand)")
    opStack.append(Op.Operand(operand))
    return evaluate()
  }
  
  func performOperation(symbol: String) -> Double? {
    if let operation = knownOps[symbol] {
      opStack.append(operation);
    }
    return evaluate()
  }
  
}
