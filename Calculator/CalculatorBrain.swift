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
    case NullaryOperation(String, () -> Double)
    case Variable(String)
    
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
        case .NullaryOperation(let symbol, _):
          return symbol
        case .Variable(let symbol):
          return symbol
        }
      }
    }
  }
  
  
  // var opStack = Array<Op>()
  private var opStack = [Op]()
  
  // var knownOpa = Dictionary<String, Op>()
  private var knownOps = [String:Op]()
  
  var variableValues = [String: Double]()
  
  var description: String {
    
    get {
      var (result, ops) = ("", opStack)
      do {
        var current: String?
        (current, ops) = description(ops)
        result = result == "" ? current! : "\(current!), \(result)"
      } while ops.count > 0

      return result
    }
    
    /*
    var evaluateResult: (result: Double?, remainingOps: [Op], resultString: String?)
    var remainingOps: [Op]
    var str = ""
    
    evaluateResult  = describeOps(opStack)
    remainingOps = evaluateResult.remainingOps
    if evaluateResult.resultString != nil {
      str = evaluateResult.resultString!
    }
    
    
    while remainingOps.count != 0 {
      println("remainingOps.count != 0")
      evaluateResult  = describeOps(remainingOps)
      remainingOps = evaluateResult.remainingOps
      if evaluateResult.resultString != nil {
        str = evaluateResult.resultString! + "," + str
      }
    
    }
  
    return str
    */
  }
  
  private func description(ops: [Op]) -> (result: String?, remainingOps: [Op]) {
    if !ops.isEmpty {
      var remainingOps = ops
      let op = remainingOps.removeLast()
      switch op {
      case .Operand(let operand):
        // %g 可以用來消除 .0
        return (String(format: "%g", operand) , remainingOps)
      case .NullaryOperation(let symbol, _):
        return (symbol, remainingOps);
      case .UnaryOperation(let symbol, _):
        let operandEvaluation = description(remainingOps)
        if let operand = operandEvaluation.result {
          return ("\(symbol)(\(operand))", operandEvaluation.remainingOps)
        }
      case .BinaryOperation(let symbol, _):
        let op1Evaluation = description(remainingOps)
        if var operand1 = op1Evaluation.result {
          if remainingOps.count - op1Evaluation.remainingOps.count > 2 {
            operand1 = "(\(operand1))"
          }
          let op2Evaluation = description(op1Evaluation.remainingOps)
          if let operand2 = op2Evaluation.result {
            return ("\(operand2) \(symbol) \(operand1)", op2Evaluation.remainingOps)
          }
        }
      case .Variable(let symbol):
        return (symbol, remainingOps)
      }
    }
    return ("?", ops)
  }
  /*
  private func describeOps(ops: [Op]) -> (result: Double?, remainingOps: [Op], resultString: String?) {
    if !ops.isEmpty{
      var remainingOps = ops
      let op = remainingOps.removeLast()
  
      switch op {
      case .Operand(let operand):
        return (operand, remainingOps, "\(operand)")
        
      case .UnaryOperation(let symbol, let operation):
        let operandEvaluation = describeOps(remainingOps)
        if let operand = operandEvaluation.result {
          return (operation(operand), operandEvaluation.remainingOps, "\(symbol)(\(operandEvaluation.resultString!))")
        }
      case .BinaryOperation(let symbol, let operation):
        let op1Evaluation = describeOps(remainingOps)
        if let operand1 = op1Evaluation.result {
          let op2Evaluation = describeOps(op1Evaluation.remainingOps)
          if let operand2 = op2Evaluation.result {
            return (operation(operand1, operand2), op2Evaluation.remainingOps, "(\(op2Evaluation.resultString!)\(symbol)\(op1Evaluation.resultString!))")
          } else {
            return (nil, ops, "(?\(symbol)\(op1Evaluation.resultString!))")
          }
        }
      case .NullaryOperation(let symbol, let operation):
        return (operation(), remainingOps, "\(symbol)")
      case .Variable(let symbol):
        return (variableValues[symbol], remainingOps, "\(symbol)")
      }
      
    }
    return (nil, ops, nil)
  }
  */

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
    //learnOp(Op.CancelOperation("C"))
    learnOp(Op.NullaryOperation("π") { M_PI } )
    learnOp(Op.UnaryOperation("±") { -1 * $0 } )  // -$0
    
  }
  
  
  typealias PropertyList = AnyObject
  var program: PropertyList { //guaranteed to be a PropertyList
    get {
      return opStack.map { $0.description }
      
      /*
      var returnValue = Array<String>()
      for op in opStack {
        returnValue.append(op.description)
      }
      return returnValue
      */
    }
    set {
      if let opSymbols = newValue as? Array<String> {
        var newOpStack = [Op]()
        for opSymbol in opSymbols {
          if let op = knownOps[opSymbol] {
            newOpStack.append(op)
          } else if let operand =
            NSNumberFormatter().numberFromString(opSymbol)?.doubleValue {
            newOpStack.append(.Operand(operand))
          }
          opStack = newOpStack
        }
        
      }
    }
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
      case .NullaryOperation(_, let operation):
        return (operation(), remainingOps)
      case .Variable(let symbol):
        return (variableValues[symbol], remainingOps)
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
    
    //println("in pushoperand: \(operand)")
    opStack.append(Op.Operand(operand))
    return evaluate()
  }
  
  func pushOperand(symbol: String) -> Double? {
    opStack.append(Op.Variable(symbol))
    return evaluate()
  }
  
  func performOperation(symbol: String) -> Double? {
    if let operation = knownOps[symbol] {
      opStack.append(operation);
    }
    return evaluate()
  }
  
  func displayHistory() -> String? {
    return " ".join(self.opStack.map{ "\($0)" })
  }
  
  
}
