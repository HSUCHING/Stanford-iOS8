//
//  CalculatorBrain.swift
//  CalculatorMVC
//
//  Created by Hsuching on 15/4/12.
//  Copyright (c) 2015年 Stanford. All rights reserved.
//

import Foundation

class CalculatorBrain
{
//    op可能是操作数或者操作符.
    
//    枚举
//    Printable是协议
    private enum Op:Printable{
        case Operand(Double)
        case UnaryOperation(String,Double->Double)
        case BinaryOperation(String,(Double,Double)->Double)
        
        var description: String{
            get{
                switch self{
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
    
//    数组栈的创建.用括号调用了数组的 initializer,初始化数组
    private var opStack=Array<Op>()
//    var opStack=[Op]()
    //    已知的运算符字典,键为运算符,值为 Op 里面的运算方法,用括号调用了字典的 initializer
    private var knownOps=Dictionary<String,Op>()
    //    var knownOps=[String,Op]()
    

//    初始化方法:
    init(){
//        闭包
//        knownOps["×"]=Op.BinaryOperation("×", {$0*$1})
        knownOps["×"]=Op.BinaryOperation("×", *)
        knownOps["−"]=Op.BinaryOperation("−"){$1-$0}
//        knownOps["+"]=Op.BinaryOperation("+"){$0+$1}
        knownOps["+"]=Op.BinaryOperation("+",+)
        knownOps["÷"]=Op.BinaryOperation("÷"){$1/$0}
//        knownOps["√"]=Op.UnaryOperation("√"){sqrt($0)}
//        这里可以传入一个函数,当然可以是一个被命名的函数
        knownOps["√"]=Op.UnaryOperation("√",sqrt)
    }
    
////    初始化方法:
//    init(){
////        内部函数
//        func learnOp(op: Op){
//            knownOps[op.description] = op
//        }
//        learnOp(Op.BinaryOperation("×", *))
//        learnOp(Op.BinaryOperation("−"){$1-$0})
//        learnOp(Op.BinaryOperation("+",+))
//        learnOp(Op.BinaryOperation("÷"){$1/$0})
//        learnOp(Op.UnaryOperation("√",sqrt))
//
//    }
    
    
    
//    将操作符和运算压入数组栈中
    func pushOperand(operand:Double) -> Double?{
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    
//    递归函数,输入opStack,返回一个求值结果和剩余的opStack栈.
    private func evaluate(ops:[Op])->(result:Double?,remainingOps:[Op]){
        if(!ops.isEmpty){
//            ops是常量(等同let赋值),因此不能改变,结构体的赋值是值传递.
            var remainingOps = ops
            let op=remainingOps.removeLast()
//            关联变量,取出枚举
            switch op{
//                这里的 operand 就会获得枚举op里面的关联变量Double.
            case .Operand(let operand):
                return (operand,remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result{
                    return (operation(operand),operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result{
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result{
                        return (operation(operand1,operand2),op2Evaluation.remainingOps)
                    }
                }
                
            }
        }
        return (nil,ops)
    }
    
//    对栈: opStack 进行求值
    func evaluate()->Double?{
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) =  \(result) with \(remainder) left over")
        return result
    }
    

    
    
//    运算符操作,每次执行此方法时,需要到 knownOps 里面去找已知的运算,然后把这个运算压入 opStack 里面.
    func performOperation(symbol:String) -> Double?{
//        operation是一个 optional类型
        if let operation=knownOps[symbol]{
            opStack.append(operation)
        }
        return evaluate()
    }
    
    
    
}