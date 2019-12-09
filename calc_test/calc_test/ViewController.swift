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
    
    private let calc = Calc()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }



    @IBAction func ButtonZero(_ sender: Any) {
        if calc.formulas_num == "" {
            // など最初に０が来るのを防ぐ　例えば　0+02-0332*01＝？？　など
        }else{
            calc.formulas_num += "0" //"10"や"1000"など数字の組み合わせに対応する
            calc.only_formulas += "0" //計算式を表示するだけ
            Formula.text = calc.only_formulas
        }
    }
    
    
    @IBAction func Button(_ sender: UIButton) {  // "1" = tag 1 , "2" = tag 2 , ....., "9" = tag 9
        calc.formulas_num += String(sender.tag) //"10"や"1000"など数字の組み合わせに対応する
        calc.only_formulas += String(sender.tag) //計算式を表示するだけ
        Formula.text = calc.only_formulas        //計算式を画面に表示
        calc.signal_TF = true
    }
    
    @IBAction func Signal(_ sender: UIButton) {  // "+" = tag 100 , "-" = tag 101 , "*" = tag 102 , "/" = tag 103
        if calc.signal_TF == true{ //記号の重複に対応　　例えば　10++2+*-7 =
            calc.signal_TF = false
            calc.formulas.append(calc.formulas_num) //数値を追加
            calc.formulas_num = ""
        }else{
            calc.formulas.removeLast()
            
            
            
            //
            //*--------------ここにonly_formulas（式だけを画面に表示する変数）の後ろの文字を消して新しい記号を入れる
            // 例えば 1+2+3+ → 1+3+3 → 1+2+3-  プラスからマイナスに変更する
            //
            
            
        }
        
        switch String(sender.tag){
        case "100":
            calc.only_formulas += "+"
            calc.formulas.append("+")
        case "101":
            calc.only_formulas += "-"
            calc.formulas.append("-")
        case "102":
            calc.only_formulas += "*"
            calc.formulas.append("*")
        case "103":
            calc.only_formulas += "/"
            calc.formulas.append("/")
        default:
            calc.only_formulas = "ERROR"
            print("error")
        }
        print(calc.only_formulas)
        Formula.text = calc.only_formulas
            
    }
            
    @IBAction func Equal(_ sender: Any) {
        calc.formulas.append(calc.formulas_num)
        calc.formulas_num = ""
        calc.Formula_To_Polish()//計算式から逆ポーランドへ変換する関数
        Ans.text = calc.Polish_To_Answer()
        for i in 0 ..< calc.buffa.count{
            calc.formulas_num += calc.buffa[i]
        }
        print("計算式" + String(calc.only_formulas))
        print("逆ポーランド式" + String(calc.formulas_num))
        print("")
        //Ans.text = formulas_num
    }
    
    @IBAction func AllClear(_ sender: Any) {
        calc.formulas.removeAll()
        calc.stacks.removeAll()
        calc.buffa.removeAll()
        calc.num = ""
        calc.formulas_num = ""
        calc.only_formulas = ""
        Formula.text = ""
        Ans.text = "0"
    }

}
