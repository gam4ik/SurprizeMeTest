//
//  ConfirmCodeViewController.swift
//  SurprizeMeTest
//
//  Created by Gamid on 09.06.2020.
//  Copyright © 2020 Gamid. All rights reserved.
//

import UIKit

class ConfirmCodeViewController: UIViewController {

    var userPhone = ""
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var firstCodeTF: UITextField!
    @IBOutlet weak var secondCodeTF: UITextField!
    @IBOutlet weak var thirdCodeTF: UITextField!
    @IBOutlet weak var fourthCodeTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneLabel.text = userPhone
        
        firstCodeTF.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        secondCodeTF.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        thirdCodeTF.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        fourthCodeTF.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
        firstCodeTF.becomeFirstResponder()
        
    }

    @IBAction func sendAgain() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension ConfirmCodeViewController {
    
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if  text?.count == 1 {
            switch textField{
            case firstCodeTF:
                secondCodeTF.becomeFirstResponder()
            case secondCodeTF:
                thirdCodeTF.becomeFirstResponder()
            case thirdCodeTF:
                fourthCodeTF.becomeFirstResponder()
            case fourthCodeTF:
                fourthCodeTF.resignFirstResponder()
            default:
                break
            }
        }
        if  text?.count == 0 {
            switch textField{
            case firstCodeTF:
                firstCodeTF.becomeFirstResponder()
            case secondCodeTF:
                firstCodeTF.becomeFirstResponder()
            case thirdCodeTF:
                secondCodeTF.becomeFirstResponder()
            case fourthCodeTF:
                thirdCodeTF.becomeFirstResponder()
            default:
                break
            }
        }
        if didCodeEntery() {
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func didCodeEntery() -> Bool {
        if (firstCodeTF.text != "")&&(secondCodeTF.text != "")&&(thirdCodeTF.text != "")&&(fourthCodeTF.text != "") {
            return true
        } else {
            return false
        }
    }
}
