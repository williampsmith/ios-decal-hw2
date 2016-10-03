//
//  ViewController.swift
//  SwiftCalc
//
//  Created by Zach Zeleznick on 9/20/16.
//  Copyright © 2016 zzeleznick. All rights reserved.
//

import UIKit

class Display {
    var initialDisplay = true
    var newOperand = false
    var resultString : String? = "0"
    var resultNum : Double = 0
    var firstOperand : Double? = 0
    var secondOperand : Double? = 0
    var operation : String? = nil
    var decimal = false
    
    func reset() {
        self.initialDisplay = true
        self.newOperand = false
        self.resultString = "0"
        self.resultNum = 0
        self.firstOperand = 0
        self.secondOperand = 0
        self.operation = nil
        self.decimal = false
    }
}

class ViewController: UIViewController {
    // MARK: Width and Height of Screen for Layout
    var w: CGFloat!
    var h: CGFloat!
    

    // IMPORTANT: Do NOT modify the name or class of resultLabel.
    //            We will be using the result label to run autograded tests.
    // MARK: The label to display our calculations
    var resultLabel = UILabel()
    
    // TODO: This looks like a good place to add some data structures.
    //       One data structure is initialized below for reference.
    var display = Display() // custom struct defined above
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        w = view.bounds.size.width
        h = view.bounds.size.height
        navigationItem.title = "Calculator"
        // IMPORTANT: Do NOT modify the accessibilityValue of resultLabel.
        //            We will be using the result label to run autograded tests.
        resultLabel.accessibilityValue = "resultLabel"
        makeButtons()
        // Do any additional setup here.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TODO: A method to update your data structure(s) would be nice.
    //       Modify this one or create your own.
    func updateSomeDataStructure(_ content: String) {
        print("Update me like one of those PCs")
    }
    
    // TODO: Ensure that resultLabel gets updated.
    //       Modify this one or create your own.
    func updateResultLabel(_ content: String) {
        print("Update me like one of those PCs")
    }
    
    
    // TODO: A calculate method with no parameters, scary!
    //       Modify this one or create your own.
    func calculate() -> String {
        return "0"
    }
    
    // TODO: A simple calculate method for integers.
    //       Modify this one or create your own.
    func intCalculate(a: Int, b:Int, operation: String) -> Int {
        print("Calculation requested for \(a) \(operation) \(b)")
        return 0
    }
    
    // TODO: A general calculate method for doubles
    //       Modify this one or create your own.
    func calculate(a: String, b:String, operation: String) -> Double {
        print("Calculation requested for \(a) \(operation) \(b)")
        return 0.0
    }
    
    // REQUIRED: The responder to a number button being pressed.
    func numberPressed(_ sender: CustomButton) {
        guard Int(sender.content) != nil else { return }
        print("The number \(sender.content) was pressed")
        
        guard resultLabel.text!.characters.count < 7 else {
            print("Display too long.")
            return
        }
        
        if display.initialDisplay { //initially display 0, reset when clear pressed
            print("in the initialDisplay block")
            display.resultString = sender.content
            display.firstOperand = Double(sender.content)!
            display.resultNum = Double(sender.content)!
            display.initialDisplay = false
        }
        else if display.newOperand {
            print("in the newOperand block")
            display.resultString = sender.content
            display.resultNum = Double(sender.content)!
            display.newOperand = false
            display.secondOperand = Double(sender.content)!
        }
        else { // alredy text on screen
            print("text on screen block")
            display.resultString! += sender.content
            display.resultNum = Double(display.resultString!)!
            
            if display.firstOperand != nil {
                display.secondOperand = display.resultNum
            }
        }
        
        updateLabel(newLabel: display.resultString)
    }
    
    func updateLabel(newLabel : String?) {
        if let temp = Double(newLabel!) {
            let decimal = temp.truncatingRemainder(dividingBy: 1)
            if decimal == 0 {
                let newDisplay = Int(temp)
                resultLabel.text = String(newDisplay)
            }
            else {
                resultLabel.text = newLabel
            }
        }
        else {
            resultLabel.text = newLabel
        }
    }
    
    // REQUIRED: The responder to an operator button being pressed.
    func operatorPressed(_ sender: CustomButton) {
        print("The operator \(sender.content) was pressed")
        if sender.content == "C" || sender.content == "c" {
            display.reset()
            updateLabel(newLabel: display.resultString)
            return
        }
        
        if sender.content == "+/-" {
            if display.resultString != "0" { // don't negate 0
                display.resultNum *= -1
                display.resultString = String(display.resultNum)
                display.secondOperand = display.resultNum
                updateLabel(newLabel: display.resultString)
                return
            }
        }
        
        display.newOperand = true
        
        if display.initialDisplay { //initially display 0, reset when clear pressed
            display.operation = sender.content
            display.firstOperand = display.resultNum
            display.initialDisplay = false
            display.decimal = false
        }
        else if display.operation == nil { // first operation
            display.operation = sender.content
            display.firstOperand = display.resultNum
            display.decimal = false
        }
        else if display.firstOperand != nil && display.secondOperand != nil {
            if let val = evaluate(display: display) { // attempt to evaluate
                display.firstOperand = val
                display.resultNum = val
                display.resultString = String(val)
            }
            else {
                print("Error occured in evaluating fucntion")
                return
            }
            
            if sender.content != "=" { // = is a special case and doesn't need to be saved
                display.operation = sender.content
            }
            else {
                display.operation = nil
                display.firstOperand = display.resultNum
            }
            
            display.decimal = false
        }
        
        updateLabel(newLabel: display.resultString)
    }
    
    func evaluate(display : Display) -> Double? {
        switch display.operation! {
        case "/":
            return display.firstOperand! / display.secondOperand!
        case "*":
            return display.firstOperand! * display.secondOperand!
        case "-":
            return display.firstOperand! - display.secondOperand!
        case "+":
            return display.firstOperand! + display.secondOperand!
        default:
            return nil
        }
    }
    
    // REQUIRED: The responder to a number or operator button being pressed.
    func buttonPressed(_ sender: CustomButton) {
        print("The button \(sender.content) was pressed")
        
        if sender.content == "0" && display.resultString != "0" { // ensure 0 not already displayed
            if display.newOperand {
                display.resultString = sender.content
                display.resultNum = Double(sender.content)!
                display.newOperand = false
                display.secondOperand = Double(sender.content)!
            }
            else {
                display.resultString! += sender.content
                display.resultNum = Double(display.resultString!)!
                display.secondOperand = display.resultNum
            }
            
            updateLabel(newLabel: display.resultString)
        }
        else if sender.content == "." && !display.decimal {
            display.initialDisplay = false
            if display.newOperand {
                print("here")
                display.resultString = "0" + sender.content
                display.resultNum = Double(display.resultString! + "0")!
                display.newOperand = false
            }
            else {
                display.resultString! += sender.content
                display.resultNum = Double(display.resultString! + "0")!
            }
            
            if display.firstOperand != nil {
                display.secondOperand = display.resultNum
            }
            
            display.decimal = true // NOTE: FIGURE OUT WHICH FUNCTIONS NEED TO RESET THIS!
            updateLabel(newLabel: display.resultString) // testing
        }
    }
    
    
    // IMPORTANT: Do NOT change any of the code below.
    //            We will be using these buttons to run autograded tests.
    
    func makeButtons() {
        // MARK: Adds buttons
        let digits = (1..<10).map({
            return String($0)
        })
        let operators = ["/", "*", "-", "+", "="]
        let others = ["C", "+/-", "%"]
        let special = ["0", "."]
        
        let displayContainer = UIView()
        view.addUIElement(displayContainer, frame: CGRect(x: 0, y: 0, width: w, height: 160)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.black
        }
        displayContainer.addUIElement(resultLabel, text: "0", frame: CGRect(x: 70, y: 70, width: w-70, height: 90)) {
            element in
            guard let label = element as? UILabel else { return }
            label.textColor = UIColor.white
            label.font = UIFont(name: label.font.fontName, size: 60)
            label.textAlignment = NSTextAlignment.right
        }
        
        let calcContainer = UIView()
        view.addUIElement(calcContainer, frame: CGRect(x: 0, y: 160, width: w, height: h-160)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.black
        }

        let margin: CGFloat = 1.0
        let buttonWidth: CGFloat = w / 4.0
        let buttonHeight: CGFloat = 100.0
        
        // MARK: Top Row
        for (i, el) in others.enumerated() {
            let x = (CGFloat(i%3) + 1.0) * margin + (CGFloat(i%3) * buttonWidth)
            let y = (CGFloat(i/3) + 1.0) * margin + (CGFloat(i/3) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(operatorPressed), for: .touchUpInside)
            }
        }
        // MARK: Second Row 3x3
        for (i, digit) in digits.enumerated() {
            let x = (CGFloat(i%3) + 1.0) * margin + (CGFloat(i%3) * buttonWidth)
            let y = (CGFloat(i/3) + 1.0) * margin + (CGFloat(i/3) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: digit), text: digit,
            frame: CGRect(x: x, y: y+101.0, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(numberPressed), for: .touchUpInside)
            }
        }
        // MARK: Vertical Column of Operators
        for (i, el) in operators.enumerated() {
            let x = (CGFloat(3) + 1.0) * margin + (CGFloat(3) * buttonWidth)
            let y = (CGFloat(i) + 1.0) * margin + (CGFloat(i) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.backgroundColor = UIColor.orange
                button.setTitleColor(UIColor.white, for: .normal)
                button.addTarget(self, action: #selector(operatorPressed), for: .touchUpInside)
            }
        }
        // MARK: Last Row for big 0 and .
        for (i, el) in special.enumerated() {
            let myWidth = buttonWidth * (CGFloat((i+1)%2) + 1.0) + margin * (CGFloat((i+1)%2))
            let x = (CGFloat(2*i) + 1.0) * margin + buttonWidth * (CGFloat(i*2))
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: 405, width: myWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            }
        }
    }

}

