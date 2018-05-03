//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Lasse Silkoset on 09.12.2017.
//  Copyright © 2017 Lasse Silkoset. All rights reserved.
//

import Foundation

//Struct is a 1st class citizen in SWIFT
//String, Double, Array and Dictionary are structs.
//Structs does not have inheritance
//Do not live in the heap. Are passed around by copying them. (Value-types).
//passed around, and copied on write, no copy is made if not written to.
//No other entities needs access, so it is okay for this to be a struct.
struct CalculatorBrain {
    
    //Needs to be able to be set to nil so it can operate as the secondOperand, at a later stage, to do equals operation.
    private var accumulator: Double?
    
    //Needed to create an enum so I could put different types in my operations dictionary.
    // enums can have associated values, like below. Just like optionals are an enum, with two cases. set and not set. The
    //difference is that optionals have different types of associated values, so that is also possible.
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        //Since this case knows it takes two doubles and returns a double, SWIFT can infer the types in the closures
        //below.
        case binaryOperation((Double, Double) -> Double)
        case equals
    }

    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "±" : Operation.unaryOperation({ -$0 }),
        //See case binaryOperation. $0 is for argument one, &1 for two, and so on.
        "×" : Operation.binaryOperation({ $0 * $1 }),
        "÷" : Operation.binaryOperation({ $0 / $1 }),
        "+" : Operation.binaryOperation({ $0 + $1 }),
        "-" : Operation.binaryOperation({ $0 - $1 }),
        "=" : Operation.equals

    ]

    //Is mutating because it changes the value of the accumulator in this struct. 
    mutating func performOperation(_ symbol: String) {
        //If let in case dicitonary does not contain symbol
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                //Ignores this case if accumulator is nil and for example a binaryOperation is pressed.
                if accumulator != nil {
                accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }

   mutating private func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
           accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }

    private var pendingBinaryOperation: PendingBinaryOperation?

    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double

        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }

    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }

    var result: Double? {
        get {
            return accumulator
        }
    }

}


