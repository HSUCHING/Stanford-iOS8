//
//  ViewController.swift
//  Calculator
//
//  Created by Hsuching on 15/3/30.
//  Copyright (c) 2015年 Stanford. All rights reserved.
//

import UIKit

class ViewController : UIViewController {
//定义实例变量:property,它是指向对象的指针.

	@IBOutlet weak var display : UILabel!

	var userIsInTheMiddleOfTypingANumber = false

    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber{
            enter()
        }
        switch operation{
//          闭包
            case "+":performOperation({(op1:Double,op2:Double) ->Double in
                    return op1 + op2
                })
//          不需要指定类型,靠Swift的类型推断
            case "−":performOperation({(op1,op2) in op1 - op2})
            case "×":performOperation(multiply)
//Swift不强制要求给两个参数命名,如果不制定参数,函数将会给参数自动命名为$0,$1,$2
            case "÷":performOperation({$0 / $1})
            
//Swift中方法的最后一个参数可以放到括号外面来,如果只有一个参数,可以去掉方法的括号.
//            case "÷":performOperation{$0 / $1}
            case "√":performOperation{sqrt($0)}
            default:break
        }
    }
    
	func performOperation(operation : (Double, Double)->Double) {
		if (operandStack.count >= 2) {
			displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
		}
	}

	func performOperation(operation : (Double)->Double) {
		if (operandStack.count >= 1) {
			displayValue = operation(operandStack.removeLast())
            enter()
		}
	}

	func multiply(op1 : Double, op2 : Double)->Double {
		return op1 * op2
	}
    
//定义消息方法
    @IBAction func appendDigit(sender : UIButton) {
		let digit = sender.currentTitle!
//        display.text=nil;
        if (userIsInTheMiddleOfTypingANumber) {
			display.text = display.text!+digit
		}
		else {
			display.text = digit
            userIsInTheMiddleOfTypingANumber = true
		}
		println("digit = \(digit)")
	}
    
	var operandStack = Array < Double > ()

    @IBAction func enter() {
		userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        println("operandStack=\(operandStack)")
	}
    
    var displayValue:Double{
		get {
			return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
		}
		set {
			display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
		}
    }
}
