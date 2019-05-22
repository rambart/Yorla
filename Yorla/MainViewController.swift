//
//  ViewController.swift
//  Yorla
//
//  Created by Tom on 4/11/19.
//  Copyright © 2019 Tom. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Attributes
    let ud = UserDefaults.standard
    var attack = Attack()
    
    // MARK: - Outlets
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var damageLabel: UILabel!
    
    @IBOutlet weak var highestACField: UITextField!
    
    @IBOutlet weak var PBSSwitch: UISwitch!
    @IBOutlet weak var SASwitch: UISwitch!
    @IBOutlet weak var deadlyAimSwitch: UISwitch!
    @IBOutlet weak var gravBowSwitch: UISwitch!
    @IBOutlet weak var favoredEnemySwitch: UISwitch!
    @IBOutlet weak var studiedTargetSwitch: UISwitch!
    @IBOutlet weak var holySwitch: UISwitch!
    @IBOutlet weak var baneSwitch: UISwitch!
    
    
    // MARK: - VDL
    override func viewDidLoad() {
        super.viewDidLoad()
        //firstRun()
        
        highestACField.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(displayP3Red: 0.16, green:0.51, blue:0.91, alpha:1.0)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissKeyboard))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        highestACField.inputAccessoryView = toolBar
        
        updateDisplay()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateDisplay()
    }
    
    
    func updateDisplay() {
        calculate()
        attackLabel.text = "+\(attack.attackBonus)"
        damageLabel.text = "\(attack.damageDice + attack.nonCritDice)d6+\(attack.damageBonus)"
        
        highestACField.text = String(ud.value(forKey: "highestAC") as! Int)
        
        PBSSwitch.isOn = ud.bool(forKey: "PBS")
        SASwitch.isOn = ud.bool(forKey: "SA")
        deadlyAimSwitch.isOn = ud.bool(forKey: "deadlyAim")
        gravBowSwitch.isOn = ud.bool(forKey: "gravBow")
        favoredEnemySwitch.isOn = ud.bool(forKey: "favoredEnemy")
        studiedTargetSwitch.isOn = ud.bool(forKey: "studiedTarget")
        holySwitch.isOn = ud.bool(forKey: "holy")
        baneSwitch.isOn = ud.bool(forKey: "bane")
    }
    
    @objc func dismissKeyboard() {
        highestACField.resignFirstResponder()
    }
    
    func calculate() {
        attack.attackBonus = (ud.value(forKey: "bab") as! Int) +
            (ud.value(forKey: "dex") as! Int) +
            (ud.value(forKey: "miscAttack") as! Int)
        attack.damageDice = 2
        attack.nonCritDice = 0
        attack.damageBonus = 3 +
            (ud.value(forKey: "miscDamage") as! Int)
        
        if ud.bool(forKey: "PBS") {
            attack.attackBonus += 1
            attack.damageBonus += 1
        }
        
        if ud.bool(forKey: "SA") {
            let saDice = ud.value(forKey: "SADice") as! Int
            attack.nonCritDice += saDice
        }
        
        if ud.bool(forKey: "deadlyAim") {
            let bab = ud.value(forKey: "bab") as! Int
            let daMultiplier = bab / 4
            attack.attackBonus -= daMultiplier
            attack.damageBonus += (2 * daMultiplier)
        }
        
        if ud.bool(forKey: "gravBow") {
            attack.damageDice += 1
        }
        
        if ud.bool(forKey: "favoredEnemy") {
            let feBonus = ud.value(forKey: "favoredEnemyBonus") as! Int
            attack.attackBonus += feBonus
            attack.damageBonus += feBonus
        }
        
        if ud.bool(forKey: "studiedTarget") {
            let stBonus = ud.value(forKey: "studiedTargetBonus") as! Int
            attack.attackBonus += stBonus
            attack.damageBonus += stBonus
        }
        
        if ud.bool(forKey: "holy") {
            attack.nonCritDice += 2
        }
        
        if ud.bool(forKey: "bane") {
            attack.attackBonus += 2
            attack.damageBonus += 2
            attack.nonCritDice += 2

        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let value = Int(textField.text ?? "0") ?? 0
        ud.set(value, forKey: "highestAC")
        return true
    }
    
    
    // MARK: - Buttons
    @IBAction func Commence(_ sender: Any) {
        performSegue(withIdentifier: "commence", sender: self)
    }
    
    @IBAction func switched(_ sender: UISwitch) {
        let value = Int(highestACField.text ?? "0") ?? 0
        ud.set(value, forKey: "highestAC")
        
        switch sender.tag {
        case 1:
            ud.set(sender.isOn, forKey: "PBS")
        case 2:
            ud.set(sender.isOn, forKey: "SA")
        case 3:
            ud.set(sender.isOn, forKey: "deadlyAim")
        case 4:
            ud.set(sender.isOn, forKey: "gravBow")
        case 5:
            ud.set(sender.isOn, forKey: "favoredEnemy")
        case 6:
            ud.set(sender.isOn, forKey: "studiedTarget")
        case 7:
            ud.set(sender.isOn, forKey: "holy")
        case 8:
            ud.set(sender.isOn, forKey: "bane")
        default:
            break
        }
        updateDisplay()
    }
    
    
    
    
    
    
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let value = Int(highestACField.text ?? "0") ?? 0
        ud.set(value, forKey: "highestAC")
        highestACField.resignFirstResponder()
        if segue.identifier == "commence" {
            let advc = segue.destination as! AttackAndDamageViewController
            advc.attack = attack
        }
    }
    

}

