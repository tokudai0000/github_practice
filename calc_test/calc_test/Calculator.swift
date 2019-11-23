//
//  Calculator.swift
//  calc_test
//
//  Created by masa on 2019/11/23.
//  Copyright © 2019 Akidon. All rights reserved.
//

import UIKit

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

/// 計算機クラス
class Calculator: NSObject {

    var formulas:[String] = [] //計算式　  例えとして　"1+2-3*4/5" を使用　       formulas = ["1","+","2","-","3","*","4","/","5"]
    var stacks:[String] = [] //逆ポーランドへ変換する際に一時的に四則記号を保持する    stacks = ["+","-","*","/"]  ##最終的には空のリストとなる
    var buffa:[String] = [] //逆ポーランドへ変換した式を保持　[]                   buffa = ["1","2","3","4","*","5","/","-","+"]
    var num:String = "" //formulas[?]を保持
    var formulas_num:String = "" //formulasへ追加する前に数字を組み合わせるための変数　例えば formulas_num = "1" + "0" →　formulas_num = "10"
    var only_formulas:String = "" //式を画面に（Fotmulas.text）に計算式として表示　それ以外の機能は持たない
    var nums:Int = 0
    //numが数値かどうかを判断する　これはnumが　num = "1" や num = "+" を保持している可能性があるため　*引用元　https://teratail.com/questions/54252
    func isOnlyNumber(_ str:String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES '\\\\d+'")
        return predicate.evaluate(with: str)
    }
    
    //数式 ⇒ 逆ポーランド記法(Reverse Polish Notation) へ変換
    func Formula_To_Polish(){
        for i in 0..<formulas.count{
            num = formulas[i]
            var Recu = true
            if isOnlyNumber(num) {      // numが数字ならばbuffaに追加する
                buffa.append(num)
            } else {
                if num == ")"{          // numが　”)” かどうかを判断
                    //コード追加
                }else{
                    if num == "("{      // numが　"(" ならばstacksに追加
                        stacks.append(num)
                    }else{
                                        //stacksが空になるまでループする。　Recu == true はstacksの中に要素が存在することを指している。
                        while Recu == true{
                            if stacks.isEmpty{
                                Recu = false
                            }else{      //四則演算の優先順位を検査する。　"/" > "*" > "+" = "-"   ()は導入予定
                                if num == "+" || num == "-"{
                                    if stacks[0] == "*" || stacks[0] == "/"{
                                        //numが"+"か"-"の時、stacksの一番上にある記号が"*"または"/"の時、その"*"または"/"をbuffaに追加する。
                                        buffa.append(stacks[0])
                                        stacks.removeFirst()
                                    }else{
                                        Recu = false
                                        //何もしない　ループの最後にstacksに追加するコードをかいた。
                                    }
                                    
                                }else if num == "*"{
                                    if stacks[0] == "/"{
                                        buffa.append(stacks[0])
                                        stacks.removeFirst()
                                    }else{
                                        Recu = false
                                        //何もしない
                                    }
                                }else{   //numが"/"の時ここを通る。
                                    Recu = false
                                    //何もしない
                                }
                            }
                        }
                        //print("Recu_End")
                        // stacksに追加する
                        stacks.insert(num, at: 0)
                        
                    }
                }
            }
        }
        for i in 0 ..< stacks.count{
            buffa.append(stacks[i])
        }
    }
    //逆ポーランド記法(Reverse Polish Notation) ⇒ 答え へ変換
    func Polish_To_Answer() -> String {
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
        return stacks[0]
    }

}
