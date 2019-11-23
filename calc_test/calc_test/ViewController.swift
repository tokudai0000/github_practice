//
//  ViewController.swift
//  calc_test
//
//  Created by USER on 2019/11/19.
//  Copyright © 2019 Akidon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    /// Outlet
    @IBOutlet weak var formula: UILabel!
    @IBOutlet weak var ans: UILabel!
    
    /// Private
    // 計算機クラスから計算機インスタンスを生成
    private let calclator = Calculator()

    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func Button(_ sender: UIButton) {  // "1" = tag 1 , "2" = tag 2 , ....., "9" = tag 9
        calclator.formulas_num += String(sender.tag) //"10"や"1000"など数字の組み合わせに対応する
        calclator.only_formulas += String(sender.tag) //計算式を表示するだけ
        formula.text = calclator.only_formulas        //計算式を画面に表示
    }
    
    @IBAction func Signal(_ sender: UIButton) {  // "+" = tag 100 , "-" = tag 101 , "*" = tag 102 , "/" = tag 103
        calclator.formulas.append(calclator.formulas_num) //数値を追加
        calclator.formulas_num = ""
        
        switch String(sender.tag){
        case "100":
            calclator.only_formulas += "+"
            calclator.formulas.append("+")
        case "101":
            calclator.only_formulas += "-"
            calclator.formulas.append("-")
        case "102":
            calclator.only_formulas += "*"
            calclator.formulas.append("*")
        case "103":
            calclator.only_formulas += "/"
            calclator.formulas.append("/")
        default:
            calclator.only_formulas = "ERROR"
            print("error")
        }
        formula.text = calclator.only_formulas
    }
    
    @IBAction func Equal(_ sender: Any) {
        calclator.formulas.append(calclator.formulas_num)
        calclator.formulas_num = ""
        // 計算式から逆ポーランドへ変換する
        calclator.Formula_To_Polish()
        // 逆ポーランド計算式を計算する
        ans.text = calclator.Polish_To_Answer()

        for i in 0 ..< calclator.buffa.count{
            calclator.formulas_num += calclator.buffa[i]
        }
        print("計算式" + String(calclator.only_formulas))
        print("逆ポーランド式" + String(calclator.formulas_num))
        print("")
        //Ans.text = formulas_num
    }
    @IBAction func AllClear(_ sender: Any) {
        calclator.formulas.removeAll()
        calclator.stacks.removeAll()
        calclator.buffa.removeAll()
        calclator.num = ""
        calclator.formulas_num = ""
        calclator.only_formulas = ""
        formula.text = ""
        ans.text = "0"
    }
    
}
