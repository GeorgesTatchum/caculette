//
//  ViewController.swift
//  caculette
//
//  Created by Georges Gaetan Tatchum Fotso on 03/04/2024.
//

import UIKit

class ViewController: UIViewController {
    
    let operateurs: [String: Int] = ["-": 1, "+": 1, "/": 2, "%": 2, "+/-": 1, "x": 2]
    
    func pretraitement(mot: String) -> [String] {
        var inter = [String]()
        var currentnumber = ""
        //se rassurer qu'il n'y ait pas d'espace vide dans la chaine
        let motP = mot.trimmingCharacters (in: .whitespacesAndNewlines)
        for char in motP {
            if char.isNumber {
                currentnumber.append(String(char))
            }
            else if (operateurs.keys.contains(String(char))) {
                inter.append(String(currentnumber))
                inter.append(String(char))
                currentnumber = ""
            }
            print(currentnumber)
        }
        
        if !currentnumber.isEmpty {
        inter.append(String(currentnumber))
        }
        return inter;
    }
    
    func executOperation(_ expression: [String]) -> Int? {
        var stack = [Int]()
        var currentOperator = ""
        for el in expression {
            if let number = Int(el) {
                print("le nombre : \(number)")
                //empiler l'élément si c'est un nombre
                stack.append(number)
            }
            else if operateurs.keys.contains(el){
                currentOperator = el
            } else {
                continue
            }
            if stack.count >= 2 {
                let a = stack.removeLast()
                let b = stack.removeLast()
                switch currentOperator {
                case "+":
                    stack.append(a + b)
                case "-":
                    stack.append(b - a)
                case "x":
                    stack.append(a * b)
                case "/":
                    stack.append(b / a)
                case "%":
                    stack.append(a % b)
                case "+/-":
                    stack.append(a % b)
                default:
                    break
                }
                currentOperator = ""
            } else {
                continue
            }
        }
        
        return stack.count == 1 ? stack.first : nil
    }
    
    @IBAction func effacer(_ sender: Any) {
        saisie.text.removeLast()
    }
    
    @IBAction func resultat(_ sender: Any) {
        let expression = pretraitement(mot: saisie.text)
        print("result: \(executOperation(expression)!)")
        historyText.text = String(expression.joined(separator: "")) + "=" + String(executOperation(expression)!) + "\n" + historyText.text
        saisie.text = "0"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func saisie_nombre(_ sender: UIButton) {
        print("la valeur saisie est : \(sender.titleLabel!.text!)")
        if saisie.text.count == 1 && saisie.text == "0"{
            saisie.text = ""
        }
        saisie.text += sender.titleLabel!.text!
    }
    @IBAction func reset(_ sender: Any) {
        saisie.text = "0"
        historyText.text = ""
    }
    
    @IBAction func saisie_operateur(_ sender: UIButton) {
        print("l'operateur saisie est : \(sender.titleLabel!.text!)")
        if operateurs.keys.contains(String(saisie.text.last!)) {
            saisie.text.removeLast()
        }
        saisie.text += sender.titleLabel!.text!
    }
    
    @IBOutlet weak var saisie: UITextView!
    @IBOutlet weak var historyText: UITextView!
}

