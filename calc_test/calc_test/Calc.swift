//
//  Calc.swift
//
//  Created by USER on 2019/11/19.
//  Copyright © 2019 Akidon. All rights reserved.
//

/*
----- only_formulas ⇨ 数式 -----
 only_formulas = "12+3*456"
 ↓
 formulas = ["12","+","3","*","456"]
 
----- 数式 ⇒ 逆ポーランド記法(Reverse Polish Notation) -----
 1 + 2 ⇨ 1 2 +
 ( 1 + 2 ) * 3 ⇨ 1 2 + 3 *
 1 * ( 2 + 3 ) ⇨ 1 2 3 + *
 
 formulas = ["12","+","3","*","456"]
 ↓
 buffa = ["12","3","456","*","+"]
 
 ----- 逆ポーランド記法(Reverse Polish Notation) ⇒ 答え -----
 buffa = ["12","3","456","*","+"]
 ↓
 stack[0] = 1380 ←(計算結果)
*/

import Foundation

class Calc {
    //計算式を１つずつ配列に追加
    var formulas:[String] = []
    
    //逆ポーランドへ変換する際に一時的に四則記号を保持する。最終的には空のリストとなる
    //追加する時値はIndex[0]に追加、取り出す時もIndex[0]から取り出す
    var stacks:[String] = []
    
    //逆ポーランドへ変換した式を保持
    var buffa:[String] = []
    
    //一時的に値を保持
    var num:String = ""
    
    //formulasへ追加する前に数字を組み合わせるための変数
    var combination:String = ""
    
    //答えの文字列を操作する変数
    var ans_operation:String = ""
    
    //式を画面に（Fotmulas.text）に計算式として表示
    var only_formulas:String = ""
    
    var signal_TF = true
    
    var arg:String = ""
    
    /*
    numが数値かどうかを判断する*引用元　https://teratail.com/questions/54252
    */
    func isOnlyNumber(_ str:String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES '\\\\d+'")
        return predicate.evaluate(with: str)
    }
    
    /*
    only_formulas ⇨　数式　に変換
    */
    func Only_formulasToFormula(){
        for i in only_formulas{// only_formulas = "12+3*456"
            num = String(i)
            
            if isOnlyNumber(num) || num == "."{
                combination += num
                
            }else if num == ")" || num == "+" || num == "-" || num == "*" || num == "/"{
                if formulas.last != ")"{// ( 1 + 2 ) の時　) ここでは２だけを追加　最後に　)　を追加
                    formulas.append(combination)
                    combination = ""
                }
                formulas.append(num)
                
            }else if num == "("{
                formulas.append(num)
                
            }else{
                print("Only_formulasToFormula ⇨ ERROR")
            }
        }
        if combination != ""{ //1 + 2　で　num = ２　の時通る
            formulas.append(num)
        }
    }

    /*
    数式 ⇒ 逆ポーランド記法(Reverse Polish Notation) に変換
    */
    func Formula_To_Polish(){
        combination = ""
        for i in 0 ..< formulas.count{ //formulas = ["12","+","3","*","456"]
            num = formulas[i]
            if isOnlyNumber(num) { //numが数値かどうかを判断する
                buffa.append(num)
                
            }else if num == ")"{
                /*
                ( 1 + 2 )　で　num = ")"のとき stack = ["+","("]
                */
                for _ in 0 ..< stacks.firstIndex(of: "(")!{
                    buffa.append(stacks[0])
                    stacks.removeFirst()
                    }
                
            }else if num == "("{
                stacks.insert("(", at:0)  //stacksのIndex[0] に追加
                
            }else{ //四則演算記号はここを通る
                //--------------stacksが空になるまでループする。------------------
                while true{
                    if stacks.isEmpty{   //stacksが空になったらbreak
                        break
                        
                    }else if num == "+" || num == "-"{
                        /*
                         stacksの一番上にある記号をbuffaに追加する。
                         1 + 2 - 3 で　num = "-" の時
                         */
                        if stacks[0] == "(" {
                            break
                        //numよりstacks[0]にある記号の方が優先順位が高い場合
                        }else{
                            buffa.append(stacks[0])
                            stacks.removeFirst()
                        }
                    }else if num == "*"{
                        if stacks[0] == "/"{
                            buffa.append(stacks[0])
                            stacks.removeFirst()
                        //stacks[0] == "*" or "+" or "-" の時　ここを通る
                        }else{
                            break
                        }
                    }else if num == "/"{
                        break
                    }else{
                        print("Formula_To_Polish ⇨ EROOR")
                    
                    }
                    stacks.insert(num, at: 0)
                    //--------------ループ区間ここまで----------------------
                }
            }
        //for i in 0..<formulas.count  終わり
        }
        
        //forulasを全てfor文で回したので、stacksが空になるまで取り出し、それをbuffaへ
        for i in 0 ..< stacks.count{
            if stacks[i] == "(" {
            }else{
                buffa.append(stacks[i])
            }
        }
    //func Formula_To_Polish() 終わり
    }
    
    /*
     逆ポーランド記法(Reverse Polish Notation) ⇒ 答え へ変換
     */
    func Polish_To_Answer() -> String{
        stacks.removeAll()
        for i in 0 ..< buffa.count{ //buffaには逆ポーランドに変換された式が入っている
            /*
             1 + 2 で　buffa = ["2","1","+"]　、 buffa[i] = "+"　の時、stacks = ["2","1"]である
             num = 1 + 2
             removeよりstack = [] 空になり
             insertで　stacks = [3]となる。
             */
            if buffa[i] == "+" || buffa[i] == "-" || buffa[i] == "*" || buffa[i] == "/"{
                switch buffa[i]{
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
            }else{ //数値はここを通る
                stacks.insert(buffa[i], at: 0)
            }
        }
        return stacks[0] //答えを画面に表示
    }

    
    func ButtonZero() -> String {
        if combination != "" { // など最初に０が来るのを防ぐ　例えば　0+02-0332*01＝？？　など
            only_formulas += "0" //計算式を表示するだけ
        }
        return only_formulas
    }
    
    // "1" = tag 1 , "2" = tag 2 , ....., "9" = tag 9
    func Button(arg:String) -> String{
    only_formulas += arg
    return only_formulas
    }
    
    func Signal(arg:String) -> String {  // "+" = tag 100 , "-" = tag 101 , "*" = tag 102 , "/" = tag 103
         switch arg{
         case "100":
             only_formulas += "+"
         case "101":
             only_formulas += "-"
         case "102":
             only_formulas += "*"
         case "103":
             only_formulas += "/"
         default:
             print("Signal ⇨ ERROR")
         }
        return only_formulas
     }
    
    func Parentheses(arg:String) -> String{ // "(" = tag 104 , ")" = tag 105
        switch arg{
            case "104":
                only_formulas += "("
            case "105":
                only_formulas += ")"
            default:
                print("Parenthese ⇨ ERROR")
        }
        return only_formulas
    }
    
    func Equal() -> String{
        Only_formulasToFormula()  // only_formulas ⇨ 数式
        Formula_To_Polish()       // 数式 ⇨ 逆ポーランド
        return Polish_To_Answer() // 逆ポーランド ⇨ 答え
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
        combination = ""
        only_formulas = ""
    }
}
