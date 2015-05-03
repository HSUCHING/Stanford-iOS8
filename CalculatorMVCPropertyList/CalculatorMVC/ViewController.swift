//
//  ViewController.swift
//  CalculatorMVC
//
//  Created by Hsuching on 15/4/12.
//  Copyright (c) 2015年 Stanford. All rights reserved.
//

import UIKit

class ViewController : UIViewController {
    //定义实例变量:property,它是指向对象的指针.
    
    @IBOutlet weak var display : UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    
    var brain = CalculatorBrain()
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber{
            enter()
        }
        if let operation = sender.currentTitle{
            if let result = brain.performOperation(operation){
                displayValue = result
            }else{
                displayValue = 0
            }
        }
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
        if let result = brain.pushOperand(displayValue){
            displayValue = result
        }else{
            displayValue = 0
        }
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


