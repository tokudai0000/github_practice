//
//  ViewController.swift
//  calc_test
//
//  Created by USER on 2019/11/19.
//  Copyright © 2019 Akidon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var Formula: UILabel!
    @IBOutlet weak var Ans: UILabel!
    
    let calc = Calc()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func ButtonZero(_ sender: Any) {
        Formula.text = calc.ButtonZero()
    }
    
    // "1" = tag 1 , "2" = tag 2 , ....., "9" = tag 9
    @IBAction func Button(_ sender: UIButton) {
        Formula.text = calc.Button(arg: String(sender.tag))
    }
    
    // "+" = tag 100 , "-" = tag 101 , "*" = tag 102 , "/" = tag 103
    @IBAction func Signal(_ sender: UIButton) {
        Formula.text = calc.Signal(arg: String(sender.tag))
    }

    // "(" = tag 104 ,    ")" = tag 105
    @IBAction func Parentheses(_ sender: UIButton) {
        Formula.text = calc.Parentheses(arg: String(sender.tag))
    }

    @IBAction func Equal(_ sender: Any) {
        Ans.text = calc.Equal()
    }
    
    @IBAction func AllClear(_ sender: Any) {
        calc.AllClear()
        Formula.text = ""
        Ans.text = "0"
    }
}
