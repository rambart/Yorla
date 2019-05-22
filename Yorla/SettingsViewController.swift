//
//  SettingsViewController.swift
//  Yorla
//
//  Created by Tom on 4/11/19.
//  Copyright © 2019 Tom. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Attributes
    var currentField = UITextField()
    let ud = UserDefaults.standard
    
    // MARK: - Outlets
    @IBOutlet weak var bab: UITextField!
    @IBOutlet weak var dex: UITextField!
    @IBOutlet weak var SA: UITextField!
    @IBOutlet weak var FA: UITextField!
    @IBOutlet weak var ST: UITextField!
    @IBOutlet weak var miscA: UITextField!
    @IBOutlet weak var miscD: UITextField!
    @IBOutlet weak var numA: UITextField!
    @IBOutlet weak var autoA: UISwitch!
    @IBOutlet weak var autoD: UISwitch!
    
    
    
    
    // MARK: - VDL
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bab.delegate = self
        dex.delegate = self
        SA.delegate = self
        FA.delegate = self
        ST.delegate = self
        miscA.delegate = self
        miscD.delegate = self
        numA.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(displayP3Red: 0.16, green:0.51, blue:0.91, alpha:1.0)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissKeyboard))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        bab.inputAccessoryView = toolBar
        dex.inputAccessoryView = toolBar
        SA.inputAccessoryView = toolBar
        FA.inputAccessoryView = toolBar
        ST.inputAccessoryView = toolBar
        miscA.inputAccessoryView = toolBar
        miscD.inputAccessoryView = toolBar
        numA.inputAccessoryView = toolBar
        
        showDefaults()
    }
    
    func showDefaults() {
        bab.text = "\(ud.value(forKey: "bab") as! Int)"
        dex.text = "\(ud.value(forKey: "dex") as! Int)"
        SA.text = "\(ud.value(forKey: "SADice") as! Int)"
        FA.text = "\(ud.value(forKey: "favoredEnemyBonus") as! Int)"
        ST.text = "\(ud.value(forKey: "studiedTargetBonus") as! Int)"
        miscA.text = "\(ud.value(forKey: "miscAttack") as! Int)"
        miscD.text = "\(ud.value(forKey: "miscDamage") as! Int)"
        numA.text = "\(ud.value(forKey: "numberAttack") as! Int)"
        
        autoA.isOn = ud.bool(forKey: "autoAttack")
        autoD.isOn = ud.bool(forKey: "autoDamage")
    }
    
    // MARK: - Text Field
    
    @objc func dismissKeyboard() {
        currentField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentField = textField
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ud.set(Int(bab.text ?? "0") ?? 0, forKey: "bab")
        ud.set(Int(dex.text ?? "0") ?? 0, forKey: "dex")
        ud.set(Int(SA.text ?? "0") ?? 0, forKey: "SADice")
        ud.set(Int(FA.text ?? "0") ?? 0, forKey: "favoredEnemyBonus")
        ud.set(Int(ST.text ?? "0") ?? 0, forKey: "studiedTargetBonus")
        ud.set(Int(miscA.text ?? "0") ?? 0, forKey: "miscAttack")
        ud.set(Int(miscD.text ?? "0") ?? 0, forKey: "miscDamage")
        ud.set(Int(numA.text ?? "0") ?? 0, forKey: "numberAttack")
    }
    

    
    @IBAction func autoASwitched(_ sender: Any) {
        ud.set(autoA.isOn, forKey: "autoAttack")
    }
    
    @IBAction func autoDSwitched(_ sender: Any) {
        ud.set(autoD.isOn, forKey: "autoDamage")
    }
    
    
}
