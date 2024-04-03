//
//  ViewController.swift
//  caculette
//
//  Created by Georges Gaetan Tatchum Fotso on 03/04/2024.
//

import UIKit

class ViewController: UIViewController {
    
    var valeurs: [String] = []

    @IBAction func resultat(_ sender: Any) {
        //TODO
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func saisie_nombre(_ sender: UIButton) {
        print("la valeur saisie est : \(sender.titleLabel!.text!)")
        valeurs.append(sender.titleLabel!.text!)
        saisie.text += sender.titleLabel!.text!
    }
    @IBAction func reset(_ sender: Any) {
        saisie.text = "0"
    }
    
    @IBAction func saisie_operateur(_ sender: UIButton) {
        print("l'operateur saisie est : \(sender.titleLabel!.text!)")
        valeurs.append(sender.titleLabel!.text!)
        saisie.text += sender.titleLabel!.text!
    }
    
    @IBOutlet weak var saisie: UITextView!
}

