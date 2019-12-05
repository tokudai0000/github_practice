//
//  ViewController.swift
//  calc_test
//
//  Created by USER on 2019/11/19.
//  Copyright © 2019 Akidon. All rights reserved.
//

/*
数式 ⇒ 逆ポーランド記法(Reverse Polish Notation)
"5 + 4 - 3"    ⇒ "5 4 3 - +"
"5 + 4 * 3 + 2 / 6" ⇒ "5 4 3 * 2 6 / + +"
"(1 + 4) * (3 + 7) / 5" ⇒ "1 4 + 3 7 + 5 * /" OR "1 4 + 3 7 + * 5 /"
"T ( 5 + 2 )" ⇒ "5 2 + T"

"1000 + 5%" ⇒ "1000 * (100 + 5) / 100"    ＜＜1000の5%増：税込み＞＞　シャープ式
"1000 - 5%" ⇒ "1000 * 100 / (100 + 5)"    ＜＜1000の5%減：税抜き＞＞　シャープ式

"1000 * √2" ⇒ "1000 * (√2)" ⇒ "1000 1.4142 *"        ＜＜ルート対応
*/
//参考フローチャート　https://images.app.goo.gl/chKZHfKrDXzptg5i6

// 数式 ⇒ 逆ポーランド記法(Reverse Polish Notation) ⇒ 答え

import UIKit
class ViewController: UIViewController {
    var formulas:[String] = []  //計算式　  例えとして　"1+2-3*4/5" を使用
                             //formulas = ["1","+","2","-","3","*","4","/","5"]
    var stacks:[String] = [] //逆ポーランドへ変換する際に一時的に四則記号を保持する
                             //stacks = ["+","-","*","/"]  ##最終的には空のリストとなる
    var buffa:[String] = [] //逆ポーランドへ変換した式を保持
                              //buffa = ["1","2","3","4","*","5","/","-","+"]
    var num:String = ""     //formulas[num]を保持
    var formulas_num:String = "" //formulasへ追加する前に数字を組み合わせるための変数
                                  //例えば formulas_num = "1" + "0" →　formulas_num = "10"
    var only_formulas:String = "" //式を画面に（Fotmulas.text）に計算式として表示　それ以外の機能は持たない
    
    var signal_TF = true //記号の重複を防ぐ
    
    
//--numが数値かどうかを判断する------------------------------------
//*引用元　https://teratail.com/questions/54252
    func isOnlyNumber(_ str:String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES '\\\\d+'")
        return predicate.evaluate(with: str)
    }
    
//--数式 ⇒ 逆ポーランド記法(Reverse Polish Notation) へ変換--------
    func Formula_To_Polish(){
        for i in 0..<formulas.count{ //formulas = ["1","+","2"] のリストの要素数分forで回す
            num = formulas[i]

            if isOnlyNumber(num) {              // numが数字ならばbuffaに追加する
                buffa.append(num)
                
            }else if num == ")"{                // numが　”)” かどうかを判断
                for _ in 0 ..< stacks.firstIndex(of: "(")!{
                    buffa.append(stacks[0])
                    stacks.removeFirst()
                    }
                
            }else if num == "("{
                stacks.insert("(", at:0)  //stacksのIndex = 0 に追加
            }else{
//--------------stacksが空になるまでループする。------------------
                while true{
                    if stacks.isEmpty{   //stacksが空になったらbreak
                        stacks.insert(num, at: 0)
                        break
                    }else{     //四則演算の優先順位を検査する。　"/" > "*" > "+" = "-" > "("
                        
                        if num == "+" || num == "-"{
                                        //stacksの一番上にある記号をbuffaに追加する。
                            if stacks[0] == "(" { //num == ")"の時にstacks内の "(" が使用される
                                stacks.insert(num, at: 0)
                                break
                            }else{      //numよりstacksの最上位ある記号の方が優先順位が高い
                                buffa.append(stacks[0])
                                stacks.removeFirst()
                            }
                            
                        }else if num == "*"{
                            if stacks[0] == "/"{  //   "/" > "*"
                                buffa.append(stacks[0])
                                stacks.removeFirst()
                            }else{           //stacks[0] == "*" or "+" or "-" の時
                                stacks.insert(num, at: 0)
                                break
                            }
                            
                        }else{         //numが"/"の時ここを通る。
                            stacks.insert(num, at: 0)
                            break
                        }
                    }   // stacksは積み木のように上からnumを入れていき、上から取り出していく
                }
//--------------ループ区間ここまで----------------------
                
            }
        }//for i in 0..<formulas.count  終わり
        
        for i in 0 ..< stacks.count{
            if stacks[i] == "(" { //
            }else{
                buffa.append(stacks[i])
            }
        }
    }//func Formula_To_Polish() 終わり
    
            
//--逆ポーランド記法(Reverse Polish Notation) ⇒ 答え へ変換---------------
    func Polish_To_Answer(){
        stacks.removeAll()
        for i in 0 ..< buffa.count{ //buffa=["1","2","+"]のリストの要素数分forで回す
            if buffa[i] == "+" || buffa[i] == "-" || buffa[i] == "*" || buffa[i] == "/"{
                switch buffa[i]{ //ifより綺麗にコードを書ける
                case "+":
                    num = String(Double(stacks[1])! + Double(stacks[0])!)
                case "-":
                    num = String(Double(stacks[1])! - Double(stacks[0])!)
                case "*":
                    num = String(Double(stacks[1])! * Double(stacks[0])!)
                case "/":
                    num = String(Double(stacks[1])! / Double(stacks[0])!)
                default:
                    break
                }
                stacks.remove(at:1) //計算で使用した値を消去
                stacks.remove(at:0)
                stacks.insert(num, at: 0)//計算後の値を追加
            }else{       //数値はここを通る
                stacks.insert(buffa[i], at: 0)
            }
        }
        Ans.text = stacks[0] //答えを画面に表示
    }

// -数値を入力--------------------------------------------------------
// "1" = tag 1 , "2" = tag 2 , ....., "0" = tag 0
    @IBAction func Button(_ sender: UIButton) {
        if formulas_num == String(sender.tag) {  //"01"などを防ぐ
        }else{
            //"12340"など数字の組み合わせに対応する
            formulas_num += String(sender.tag)
            only_formulas += String(sender.tag) //計算式を表示するだけ
            Formula.text = only_formulas
            signal_TF = true   //新しい四則演算記号を入力できるようにする
        }
    }
    
// -四則演算記号を入力--------------------------------------------------
// "+" = tag 100 , "-" = tag 101 , "*" = tag 102 , "/" = tag 103
    @IBAction func Signal(_ sender: UIButton) {
        if signal_TF == true{ //記号の重複に対応 true = 新しい記号を追加できる、false = 追加済み
            signal_TF = false
            if formulas.last == ")"{
            }else{
                formulas.append(formulas_num) //数値を追加
                formulas_num = ""  //次に入力される数値を初期値に戻す
            }
        }else{
            formulas.removeLast() //前追加した演算記号を消去
        }
        
        switch String(sender.tag){
        case "100":
            only_formulas += "+"
            formulas.append("+")
        case "101":
            only_formulas += "-"
            formulas.append("-")
        case "102":
            only_formulas += "*"
            formulas.append("*")
        case "103":
            only_formulas += "/"
            formulas.append("/")
        default:
            break
        }
        Formula.text = only_formulas //式を表示
    }
// -括弧記号を入力----------------------------------------------------
// "(" = tag 104 ,    ")" = tag 105
    @IBAction func parentheses(_ sender: UIButton) {
        if formulas_num == ""{
        }else{//   (2+3) の時　3 を　formulasに追加するために通る
            formulas.append(formulas_num)
            formulas_num = ""
        }
        switch String(sender.tag){
            case "104":
                only_formulas += "("
                formulas.append("(")
            case "105":
                only_formulas += ")"
                formulas.append(")")
            default:
                break
        }
        Formula.text = only_formulas //式を表示
    }
    
//--イコールを入力された時-----------------------------
    @IBAction func Equal(_ sender: Any) {
        if formulas_num == ""{
        }else{
            formulas.append(formulas_num)
            formulas_num = ""
        }
        Formula_To_Polish()  //計算式から逆ポーランドへ変換する関数
        Polish_To_Answer()   //逆ポーランドから答えを表示する関数
        
        //for i in 0 ..< buffa.count{
          //  formulas_num += buffa[i]
        //}
    }
    
//--ACを入力された時---------------------------------
    @IBAction func AllClear(_ sender: Any) {
        formulas.removeAll()
        stacks.removeAll()
        buffa.removeAll()
        num = ""
        formulas_num = ""
        only_formulas = ""
        Formula.text = ""
        Ans.text = "0"
        signal_TF = true
    }
 
//--小数点を入力された時------------------------------
    @IBAction func decimal_point(_ sender: Any){
        if formulas_num.contains(".") == true{  //小数点の重複を防ぐ
        }else if formulas_num == ""{
            formulas_num = "0."
            only_formulas += "0."
        }else{
            formulas_num += "."
            only_formulas += "."
        }
        Formula.text = only_formulas
    }
    
    
    @IBOutlet weak var Formula: UILabel!
    @IBOutlet weak var Ans: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}
