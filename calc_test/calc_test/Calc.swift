//
//  Calc.swift
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

// import UIKit
import Foundation

class Calc {
    //計算式を１つずつ配列に追加
    var formulas:[String] = []
    //逆ポーランドへ変換する際に一時的に四則記号を保持する。最終的には空のリストとなる
    var stacks:[String] = []
    //逆ポーランドへ変換した式を保持
    var buffa:[String] = []
    //formulas[num]を保持
    var num:String = ""
    //formulasへ追加する前に数字を組み合わせるための変数
    var formulas_num:String = ""
    //答えの文字列を操作する変数
    var ans_operation:String = ""
    //式を画面に（Fotmulas.text）に計算式として表示
    var only_formulas:String = ""
    
    var signal_TF = true
    var arg:String = ""
    
    //numが数値かどうかを判断する*引用元　https://teratail.com/questions/54252
    func isOnlyNumber(_ str:String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES '\\\\d+'")
        return predicate.evaluate(with: str)
    }
    //only_formulas ⇨　数式　に変換
    func Only_formulasToFormula(){
        for i in only_formulas{
            num = String(i)
            if isOnlyNumber(num) {
                formulas_num += num
            }else if num == "."{
                formulas_num += num
            }else if num == ")" || num == "+" || num == "-" || num == "*" || num == "/"{
                if formulas.last == ")"{
                    formulas.append(num)
                }else{
                    formulas.append(formulas_num)
                    formulas_num = ""
                    formulas.append(num)
                }
            }else if num == "("{
                formulas.append(num)
            }else{
                print("error")
            }
        }
        if formulas_num != ""{
            formulas.append(num)
        }
    }
    
    
    //数式 ⇒ 逆ポーランド記法(Reverse Polish Notation) へ変換
    func Formula_To_Polish(){
        //formulas = ["1","+","2"] のリストの要素数分forで回す
        for i in 0..<formulas.count{
            num = formulas[i]
            if isOnlyNumber(num) {// numが数字ならばbuffaに追加する
                buffa.append(num)
            }else if num == ")"{// numが　”)” かどうかを判断
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
        //四則演算の優先順位を検査する。　"/" > "*" > "+" = "-" > "("
                    }else{
                        if num == "+" || num == "-"{
                    //stacksの一番上にある記号をbuffaに追加する。
                    //num == ")"の時にstacks内の "(" が使用される
                            if stacks[0] == "(" {
                                stacks.insert(num, at: 0)
                                break
                    //numよりstacksの最上位ある記号の方が優先順位が高い場合
                            }else{
                                buffa.append(stacks[0])
                                stacks.removeFirst()
                            }
                        }else if num == "*"{
                            if stacks[0] == "/"{  //   "/" > "*"
                                buffa.append(stacks[0])
                                stacks.removeFirst()
                    //stacks[0] == "*" or "+" or "-" の時
                            }else{
                                stacks.insert(num, at: 0)
                                break
                            }
                        }else{   //numが"/"の時ここを通る。
                            stacks.insert(num, at: 0)
                            break
                        }
            // stacksは積み木のように上からnumを入れていき、上から取り出していく
                    }
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
    
    //逆ポーランド記法(Reverse Polish Notation) ⇒ 答え へ変換
    func Polish_To_Answer() -> String{
        stacks.removeAll()
        //buffa=["1","2","+"]のリストの要素数分forで回す
        for i in 0 ..< buffa.count{
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
        return stacks[0] //答えを画面に表示
    }

    
    func ButtonZero() -> String {
        if formulas_num == "" {
            // など最初に０が来るのを防ぐ　例えば　0+02-0332*01＝？？　など
        }else{
            //formulas_num += "0" //"10"や"1000"など数字の組み合わせに対応する
            only_formulas += "0" //計算式を表示するだけ
        }
        return only_formulas
    }
    
    // "1" = tag 1 , "2" = tag 2 , ....., "9" = tag 9
    func Button(arg:String) -> String{
    //formulas_num += arg //"10"や"1000"など数字の組み合わせに対応する
    only_formulas += arg //計算式を表示するだけ
    signal_TF = true
    return only_formulas
    }
    
    func Signal(arg:String) -> String {  // "+" = tag 100 , "-" = tag 101 , "*" = tag 102 , "/" = tag 103
//         if signal_TF == true{ //記号の重複に対応　　例えば　10++2+*-7 =
//             signal_TF = false
//            if formulas.last == ")"{
//            }else{
//                formulas.append(formulas_num) //数値を追加
//                formulas_num = ""
//            }
//         }else{
//             formulas.removeLast()
//
//             //
//             //*--------------ここにonly_formulas（式だけを画面に表示する変数）の後ろの文字を消して新しい記号を入れる
//             // 例えば 1+2+3+ → 1+3+3 → 1+2+3-  プラスからマイナスに変更する
//             //
//
//         }
         switch arg{
         case "100":
             only_formulas += "+"
             //formulas.append("+")
         case "101":
             only_formulas += "-"
             //formulas.append("-")
         case "102":
             only_formulas += "*"
             //formulas.append("*")
         case "103":
             only_formulas += "/"
             //formulas.append("/")
         default:
             only_formulas = "ERROR"
             print("error")
         }
        return only_formulas
     }
    
    func Parentheses(arg:String) -> String{
        if formulas_num == ""{
        }else{//   (2+3) の時　3 を　formulasに追加するために通る
            //formulas.append(formulas_num)
            formulas_num = ""
        }
        switch arg{
            case "104":
                only_formulas += "("
                //formulas.append("(")
            case "105":
                only_formulas += ")"
                //formulas.append(")")
            default:
                break
        }
        return only_formulas
    }
    
    func Equal() -> String{
        Only_formulasToFormula()
//        if formulas.last! != ")"{ // formulas.lastが数値ではない時
//            formulas.append(formulas_num)
//        }
        formulas_num = ""
        Formula_To_Polish()//計算式から逆ポーランドへ変換する関数
        for i in 0 ..< buffa.count{
            formulas_num += buffa[i]
        }
        formulas_num = Polish_To_Answer()
        if formulas_num.count < 12{
            return formulas_num
        }else{
            ans_operation = String(formulas_num.prefix(11))
            for i in formulas_num{
                if i == "e"{
                    
                }else{
                
                }
            }
            //formulas.suffix(formulas_num.range(of: "e"))
            //for i in Int(formulas_num.range(of: "e"))! ..< formulas_num.count{
                
        }
           // ans_operation += String((formulas_num.rangeOfString("e") as AnyObject).location)
        
        
        return Polish_To_Answer()
    }
    func Delete() -> String{
        only_formulas.removeLast()
        return only_formulas
    }
    
    func AllClear() {
        formulas.removeAll()
        stacks.removeAll()
        buffa.removeAll()
        num = ""
        formulas_num = ""
        only_formulas = ""
        signal_TF = true
    }
}
