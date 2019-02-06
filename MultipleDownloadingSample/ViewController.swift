//
//  ViewController.swift
//  MultipleDownloadSample
//
//  Created by CompIndia on 28/12/18.
//  Copyright © 2018 joprithivi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var captchaTextfield: UITextField!
    @IBOutlet weak var captchaLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func reload(_ sender: Any) {
        let digit = Int.random(in: 1000..<9999)
        captchaLbl.text = String(digit)
    }
    
    @IBAction func submit(_ sender: Any) {
        self.performSegue(withIdentifier: "ListViewSegue", sender: nil)
        if usernameTextField.text!.isEmpty || captchaTextfield.text!.isEmpty {
            print("Please enter the username and captcha")
        }
        else {
            if usernameTextField.text == "admin" && captchaTextfield.text == captchaLbl.text {
                self.performSegue(withIdentifier: "ListViewSegue", sender: nil)
            }
            else {
                print("Incorrect details")
            }
        }
    }
}

