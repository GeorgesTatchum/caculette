//
//  ViewController.swift
//  caculette
//
//  Created by Georges Gaetan Tatchum Fotso on 03/04/2024.
//

import UIKit

class ViewController: UIViewController {
    
    let operateurs: [String: Int] = ["-": 1, "+": 1, "/": 2, "%": 3, "+/-": 1, "x": 2]
    
    func pretraitement(mot: String) -> [String] {
        var inter = [String]()
        var currentnumber = ""
        var lastOperator = ""
        //se rassurer qu'il n'y ait pas d'espace vide dans la chaine
        let motP = mot.trimmingCharacters (in: .whitespacesAndNewlines)
        for char in motP {
            if char.isNumber {
                if lastOperator == "-" && inter[inter.count-1] == lastOperator {
                    inter.removeLast()
                    currentnumber.append(lastOperator + String(char))
                }else {currentnumber.append(String(char))}
                lastOperator = ""
            }
            else if (operateurs.keys.contains(String(char))) {
                if char == "-" && operateurs.keys.contains(lastOperator) {
                    // Si le dernier caractère est un opérateur et que le dernier charactère précédent était pas un opérateur,
                    // ajoutez un signe moins ("-") au nombre
                    currentnumber.append(String(char))
                    lastOperator = ""
                } else {
                    if(currentnumber != ""){
                        inter.append(String(currentnumber))
                    }
                    inter.append(String(char))
                    lastOperator = String(char)
                    if(lastOperator != "") {currentnumber = ""}
                    
                }
                            
            }
            print(currentnumber)
        }
        
        if !currentnumber.isEmpty {
        inter.append(String(currentnumber))
        }
        return inter;
    }
    
    func performOperation(_ operatorSymbol: String, _ a: Float, _ b: Float) -> Float {
        switch operatorSymbol {
        case "+":
            return a + b
        case "-":
            return a - b
        case "x":
            return a * b
        case "/":
            return a / b
        case "%":
            return (a * b) / 100
        case "+/-":
            return -a
        default:
            fatalError("Unknown operator")
        }
    }
    
    func executOperation(_ expression: [String]) -> Float? {
        var stack = [Float]()
        var operatorStack = [String]()

        for element in expression {
            if let number = Float(element) {
                stack.append(number)
            } else if let precedence = operateurs[element] {
                while !operatorStack.isEmpty && operateurs[operatorStack.last!]! >= precedence {
                    if let op = operatorStack.popLast(), let b = stack.popLast(), let a = stack.popLast() {
                        let result = performOperation(op, a, b)
                        stack.append(result)
                    }
                }
                operatorStack.append(element)
            }
        }

        while let op = operatorStack.popLast(), let b = stack.popLast(), let a = stack.popLast() {
            let result = performOperation(op, a, b)
            stack.append(result)
        }

        return stack.first
    }

    
    @IBAction func effacer(_ sender: Any) {
        if (saisie.text.isEmpty || saisie.text != "0") {
            saisie.text.removeLast()
        }
    }
    
    @IBAction func resultat(_ sender: Any) {
        let expression = pretraitement(mot: saisie.text)
        print(expression)
        // Exécuter l'opération et afficher le résultat
            if let result = executOperation(expression) {
                print("result: \(result)")
                historyText.text = String(expression.joined(separator: "")) + "=" + String(result) + "\n" + historyText.text
            } else {
                print("Une erreur s'est produite lors de l'évaluation de l'expression.")
            }
        saisie.text = "0"
    }
    override func viewDidLoad() {
        saisie.text = "0"
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
        if (saisie.text!.count > 1 || saisie.text! != "0"){
        // Vérifiez si l'opérateur est "+/-"
            if sender.titleLabel!.text! == "+/-" {
                // Vérifiez si le dernier caractère de la saisie est un nombre
                if let lastCharacter = saisie.text.last, lastCharacter.isNumber {
                    // Si c'est le cas, transformez le nombre en négatif ou en positif dépendemment de la dernière valeur
                    var text : [String] = pretraitement(mot: saisie.text)
                    if (!text[text.count - 1].contains("-")) {
                        text[text.count - 1] = "-" + text[text.count - 1]
                        
                    } else {
                        text[text.count - 1].removeFirst()
                    }
                    saisie.text = String(text.joined(separator:""))
                }
                else {
                    
                    // Si le dernier caractère n'est pas un nombre, remplacer l'operateur par -
                    saisie.text = String(saisie.text.dropLast()) + "-"
                }
            } else if sender.titleLabel!.text! == "%" && saisie.text.last == "%" {
                // ne rien faire
            }
            else {
                // Si ce n'est pas l'opérateur "+/-", traitez normalement
                if operateurs.keys.contains(String(saisie.text.last!)) && sender.titleLabel!.text! != "%" && saisie.text.last! != "%" {
                    // Si le dernier caractère est déjà un opérateur sauf %, supprimez-le avant d'ajouter le nouvel opérateur
                    saisie.text.removeLast()
                }
                saisie.text += sender.titleLabel!.text!
            }
        }
    }
    
    @IBOutlet weak var saisie: UITextView!
    @IBOutlet weak var historyText: UITextView!
}

