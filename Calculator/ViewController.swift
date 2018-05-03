//
//  ViewController.swift
//  Calculator
//
//  Created by Lasse Silkoset on 08.12.2017.
//  Copyright © 2017 Lasse Silkoset. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var display: UILabel!
    
    //inTheMiddleOfTyping is created to make sure the numbers does not append to each other when we do not want them to.
    var inTheMiddleOfTyping = false
    var textCurrentlyInDisplay = ""
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        textCurrentlyInDisplay = display.text!
        if inTheMiddleOfTyping {
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
            inTheMiddleOfTyping = true
        }
        
    }


    
//    @IBAction func touchDigit(_ sender: UIButton) {
    
    //Computing the var displayValue so i do not have to convert each time i need to set and get the textfield.
    var displayValue: Double {
        get {
            //Unwrapping, and therefore assuming nothing that cannot be converted to a Double is in the display.text. CAREFUL.
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    //Making a "connection" to the model, to do calculations there. The controller is a UI "guy", and should not handle
    //calculations. Model is almost always private to the controller.
    private var brain = CalculatorBrain()

    @IBAction func performOperation(_ sender: UIButton) {
        if inTheMiddleOfTyping {
            brain.setOperand(displayValue)
            inTheMiddleOfTyping = false
        }
        
        inTheMiddleOfTyping = false
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = result
          
        }
    }

    
}

