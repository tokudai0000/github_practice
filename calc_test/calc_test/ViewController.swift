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

// 数式 ⇒ 逆ポーランド記法(Reverse Polish Notation) ⇒ 答え

import UIKit
class ViewController: UIViewController {
    var formulas:[String] = [] //計算式　  例えとして　"1+2-3*4/5" を使用
                             //formulas = ["1","+","2","-","3","*","4","/","5"]
    var stacks:[String] = [] //逆ポーランドへ変換する際に一時的に四則記号を保持する
                             //stacks = ["+","-","*","/"]  ##最終的には空のリストとなる
    var buffa:[String] = [] //逆ポーランドへ変換した式を保持　[]
                              //buffa = ["1","2","3","4","*","5","/","-","+"]
    var num:String = ""     //formulas[?]を保持
    var formulas_num:String = "" //formulasへ追加する前に数字を組み合わせるための変数
                                  //例えば formulas_num = "1" + "0" →　formulas_num = "10"
    var only_formulas:String = "" //式を画面に（Fotmulas.text）に計算式として表示　それ以外の機能は持たない
    
    var nums:Int = 0
    var signal_TF = true
    //numが数値かどうかを判断する　これはnumが　num = "1" や "(",
    //"+"を保持している可能性があるため　*引用元　https://teratail.com/questions/54252
    func isOnlyNumber(_ str:String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES '\\\\d+'")
        return predicate.evaluate(with: str)
    }
    
    //数式 ⇒ 逆ポーランド記法(Reverse Polish Notation) へ変換
    func Formula_To_Polish(){
        for i in 0..<formulas.count{
            num = formulas[i]
            
            var Recu = true
            
            if isOnlyNumber(num) {              // numが数字ならばbuffaに追加する
                buffa.append(num)
                
            }else if num == ")"{                // numが　”)” かどうかを判断
                
                for _ in 0 ..< stacks.firstIndex(of: "(")!{
                    print(stacks.firstIndex(of: "(")!)
                    print("a")
                    print(stacks)
                    print(buffa)
                    print("b")
                    buffa.append(stacks[0])
                    stacks.removeFirst()

//                    if stacks[0] == "(" || stacks[0] == ""{
//                        stacks.removeFirst()
//                    }else{
//                            buffa.append(stacks[0])
//                            stacks.removeFirst() //buffaに追加した四則演算記号をstacksから消去
//                    }
                    }
            }else if num == "("{
                stacks.insert("(", at:0)
            }else{
                while Recu == true{      //stacksが空になるまでループする。
                                         //Recu == true はstacksの中に要素が存在することを指している。
                    if stacks.isEmpty{
                        Recu = false
                        stacks.insert(num, at: 0)
                    }else{               //四則演算の優先順位を検査する。　"/" > "*" > "+" = "-"
                        if num == "+" || num == "-"{    //numが"+"か"-"の時、stacksの一番上にある記号をbuffaに追加する。
                                    
                            if stacks[0] == "(" || stacks[0] == ""{
                                Recu = false
                                stacks.insert(num, at: 0)
                            }else{
                                buffa.append(stacks[0])
                                stacks.removeFirst()
                            }
                        }else if num == "*"{
                            if stacks[0] == "/"{
                                buffa.append(stacks[0])
                                stacks.removeFirst()
                            }else{
                                Recu = false
                                stacks.insert(num, at: 0)
                            }
                        }else{               //numが"/"の時ここを通る。
                            Recu = false
                            stacks.insert(num, at: 0)
                        }
                    }   // stacksに追加する積み木のように上からstacksに入れていき、上から取り出していく
                }
            }
        }
        for i in 0 ..< stacks.count{
            if stacks[i] == "(" || stacks[i] == ""{
                
            }else{
                buffa.append(stacks[i])
            }
        }
    }
    
            
    //逆ポーランド記法(Reverse Polish Notation) ⇒ 答え へ変換
    func Polish_To_Answer(){
        print("c")
        print(buffa)
        print("d")
        stacks.removeAll()
        for i in 0 ..< buffa.count{
            if buffa[i] == "+" || buffa[i] == "-" || buffa[i] == "*" || buffa[i] == "/"{
                switch buffa[i]{
                case "+":
                    num = String(Int(stacks[1])! + Int(stacks[0])!)
                    stacks.remove(at:1)
                    stacks.remove(at:0)
                    stacks.insert(num, at: 0)
                case "-":
                    num = String(Int(stacks[1])! - Int(stacks[0])!)
                    stacks.remove(at:1)
                    stacks.remove(at:0)
                    stacks.insert(num, at: 0)
                case "*":
                    num = String(Int(stacks[1])! * Int(stacks[0])!)
                    stacks.remove(at:1)
                    stacks.remove(at:0)
                    stacks.insert(num, at: 0)
                case "/":
                    num = String(Int(stacks[1])! / Int(stacks[0])!)
                    stacks.remove(at:1)
                    stacks.remove(at:0)
                    stacks.insert(num, at: 0)
                default:
                    only_formulas = "ERROR"
                    print("error")
                    
                }
                
            }else{
                stacks.insert(buffa[i], at: 0)
            }
            
        }
        Ans.text = stacks[0]
    }
    @IBAction func ButtonZero(_ sender: Any) {
        if formulas_num == ""{
            // など最初に０が来るのを防ぐ　例えば　0+02-0332*01＝？？　など
        }else{
            formulas_num += "0" //"10"や"1000"など数字の組み合わせに対応する
            only_formulas += "0" //計算式を表示するだけ
            Formula.text = only_formulas
        }
    }
    
    
    @IBAction func Button(_ sender: UIButton) {  // "1" = tag 1 , "2" = tag 2 , ....., "9" = tag 9
        formulas_num += String(sender.tag) //"10"や"1000"など数字の組み合わせに対応する
        only_formulas += String(sender.tag) //計算式を表示するだけ
        Formula.text = only_formulas        //計算式を画面に表示
        signal_TF = true
    }
    
    @IBAction func Signal(_ sender: UIButton) {  // "+" = tag 100 , "-" = tag 101 , "*" = tag 102 , "/" = tag 103
        if signal_TF == true{ //記号の重複に対応　　例えば　10++2+*-7 =  str = "abcd" str[0:1] = a
            signal_TF = false
            formulas.append(formulas_num) //数値を追加
            formulas_num = ""
        }else{
            formulas.removeLast()
            
            
            
//*--------------ここにonly_formulas（式だけを画面に表示する変数）の後ろの文字を消して新しい記号を入れる
// 例えば 1+2+3+ → 1+3+3 → 1+2+3-  プラスからマイナスに変更する
//
            
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
            only_formulas = "ERROR"
            print("error")
        }
        //print(only_formulas)
        Formula.text = only_formulas
            
    }
           
    @IBAction func parentheses(_ sender: UIButton) {//"(" = tag 104 , ")" = tag 105
        if formulas_num == ""{
            
        }else{
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
                only_formulas = "ERROR"
                print("error")
        }
        Formula.text = only_formulas
    }
    
    
    
    @IBAction func Equal(_ sender: Any) {
        if formulas_num == ""{
            
        }else{
            formulas.append(formulas_num)
            formulas_num = ""
        }
        print(formulas)
        Formula_To_Polish()//計算式から逆ポーランドへ変換する関数
        Polish_To_Answer()
        for i in 0 ..< buffa.count{
            formulas_num += buffa[i]
        }
        print("計算式" + String(only_formulas))
        print("逆ポーランド式" + String(formulas_num))
    }
    
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

    @IBOutlet weak var Formula: UILabel!
    @IBOutlet weak var Ans: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}
