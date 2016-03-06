//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by andy on 16-3-6.
//  Copyright (c) 2016年 andy. All rights reserved.
//

import Foundation
class CalculatorBrain
{
    private enum op{
        case operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
    }
    
    private var opStack = [op]()
    
    private var knownOps = [String:op]()
    
    init(){
        knownOps["×"] = op.BinaryOperation("×", *)
        knownOps["−"] = op.BinaryOperation("−"){ $1 - $0 }
        knownOps["+"] = op.BinaryOperation("+", +)
        knownOps["÷"] = op.BinaryOperation("÷"){ $1 / $0 }
        knownOps["√"] = op.UnaryOperation("√", sqrt)
    }
    private func evaluate(ops:[op])->(result:Double?,remainingOps:[op]){
        if(!ops.isEmpty){
            var remainingOps=ops
            let op=remainingOps.removeLast() //
            switch op{
            case .operand(let operand):
                return(operand,remainingOps)
            case .UnaryOperation(_,let operation):
                let operandEvaluation=evaluate(remainingOps)
                if let result=operandEvaluation.result{
                    return(operation(result),operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let operandEvaluation1 = evaluate(remainingOps) //tuple [4,5]
                if let result = operandEvaluation1.result{
                    let operandEvaluation2 = evaluate(operandEvaluation1.remainingOps) //[4]
                    if let result2 = operandEvaluation2.result{
                        return (operation(result,result2),operandEvaluation2.remainingOps)
                    }
                }
            }
        }
            return(nil,ops)
            
        }
    
    func evaluate() -> Double?{
        let (result, _ ) = evaluate(opStack)
        return result
    }
    
    func pushOperand(operand: Double) {
        opStack.append(op.operand(operand))
    }
    
    func performOperation(symbol:String) {
        if let operation = knownOps[symbol]{
            opStack.append(operation)
        }
    }

}