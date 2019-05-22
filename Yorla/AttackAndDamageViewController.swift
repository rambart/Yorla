//
//  AttackAndDamageViewController.swift
//  Yorla
//
//  Created by Tom on 4/11/19.
//  Copyright © 2019 Tom. All rights reserved.
//

import UIKit
import MediaPlayer

class AttackAndDamageViewController: UIViewController {
    
    // MARK: - Attributes
    let ud = UserDefaults.standard
    var attack = Attack()
    var attackRolls = [AttackRoll]()
    var selectedAttack = 0 {
        didSet {
            showSelectedAttack()
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var attackBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var damageBtn: UIButton!
    @IBOutlet weak var hitSwitch: UISwitch!
    @IBOutlet weak var critSwitch: UISwitch!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var damageTotal: UILabel!
    
    // MARK: - VDL
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        
        
        for i in 1...(ud.value(forKey: "numberAttack") as! Int) {
            if i <= 2 {
                attackRolls.append(AttackRoll(from: attack, manyShot: true))
            } else {
                attackRolls.append(AttackRoll(from: attack, manyShot: false))
            }
        }
        update()
    }
    
    func update() {
        showSelectedAttack()
        
        var allDamage = 0
        for atk in attackRolls {
            if atk.hit {
                if atk.crit {
                    allDamage += atk.critDamage
                } else {
                    allDamage += atk.damage
                }
            }
        }
        damageTotal.text = "\(allDamage)"
        
        table.reloadData()
        
        if allDamage == 420 {
            showMessage(title: "🔥😂 420 Damage 🤣🔥", message: "Blaze it my dude!")
        }
        if allDamage == 69 {
            showMessage(title: "👌 69 Damage 😏", message: "👉👌 😩🍆💦🍑")
        }
    }
    
    // MARK: - Buttons
    
    func showSelectedAttack() {
        if selectedAttack == 0 {
            previousBtn.isEnabled = false
            previousBtn.setTitleColor(UIColor.gray, for: .normal)
        } else {
            previousBtn.isEnabled = true
            previousBtn.setTitleColor(UIColor.black, for: .normal)
        }
        
        if selectedAttack + 1 == ud.value(forKey: "numberAttack") as! Int {
            nextBtn.isEnabled = false
            nextBtn.setTitleColor(UIColor.gray, for: .normal)
        } else {
            nextBtn.isEnabled = true
            nextBtn.setTitleColor(UIColor.black, for: .normal)
        }
        
        let atk = attackRolls[selectedAttack]
        headerLabel.text = "Attack \(selectedAttack + 1)"
        attackBtn.setTitle("\(atk.attackRoll) (\(atk.attackDie))", for: .normal)
        if atk.attackDie >= 19 {
            confirmBtn.setTitle("\(atk.confirm) (\(atk.confirmDie))", for: .normal)
        } else {
            confirmBtn.setTitle("-", for: .normal)
        }
        if atk.hit {
            if atk.crit{
                damageBtn.setTitle("\(atk.critDamage)", for: .normal)
            } else {
                damageBtn.setTitle("\(atk.damage)", for: .normal)
            }
        } else {
            damageBtn.setTitle("-", for: .normal)
        }
        
        hitSwitch.isOn = atk.hit
        critSwitch.isOn = atk.crit
        if atk.attackDie >= 19 {
            critSwitch.isEnabled = true
            critSwitch.tintColor = UIColor.white
            critSwitch.thumbTintColor = UIColor.white
        } else {
            critSwitch.isEnabled = false
            critSwitch.tintColor = UIColor.gray
            critSwitch.thumbTintColor = UIColor.gray
        }
        if atk.attackRoll == 69 {
            showMessage(title: "👌 69 😏", message: "👉👌 😩🍆💦🍑")
        }
    }
    
    @IBAction func prev(_ sender: Any) {
        selectedAttack -= 1
    }
    
    @IBAction func next(_ sender: Any) {
        selectedAttack += 1
    }
    
    @IBAction func hitSwitched(_ sender: UISwitch) {
        let atk = attackRolls[selectedAttack]
        atk.hit = sender.isOn
        if !sender.isOn {
            atk.crit = false
            critSwitch.setOn(false, animated: true)
        }
        if ((ud.value(forKey: "highestAC") as! Int) > atk.attackRoll || (ud.value(forKey: "highestAC") as! Int) == 0) && atk.hit {
            ud.set(atk.attackRoll, forKey: "highestAC")
            for atkRoll in attackRolls {
                atkRoll.checkHitAndCrit()
            }
        }
        if (ud.value(forKey: "highestAC") as! Int) <= atk.attackRoll && !atk.hit {
            ud.set(0, forKey: "highestAC")
            for atkRoll in attackRolls {
                atkRoll.checkHitAndCrit()
            }
        }
        update()
    }
    
    @IBAction func critSwitched(_ sender: UISwitch) {
        let atk = attackRolls[selectedAttack]
        atk.crit = sender.isOn
        if !sender.isOn {
            atk.hit = true
            hitSwitch.setOn(true, animated: true)
        }
        if ((ud.value(forKey: "highestAC") as! Int) > atk.confirm || (ud.value(forKey: "highestAC") as! Int) == 0) && atk.crit {
            ud.set(atk.confirm, forKey: "highestAC")
            for atkRoll in attackRolls {
                atkRoll.checkHitAndCrit()
            }
        }
        if (ud.value(forKey: "highestAC") as! Int) <= atk.confirm && !atk.crit {
            ud.set(0, forKey: "highestAC")
            for atkRoll in attackRolls {
                atkRoll.checkHitAndCrit()
            }
        }
        update()
    }
    
    @IBAction func rerollAttack(_ sender: Any) {
        let atk = attackRolls[selectedAttack]
        let newRoll = atk.attack.roll("attack")
        atk.attackRoll = newRoll.result
        atk.attackDie = newRoll.dice[0]
        atk.checkHitAndCrit()
        update()
    }
    
    @IBAction func rerollConfirm(_ sender: Any) {
        let atk = attackRolls[selectedAttack]
        let newRoll = atk.attack.roll("attack")
        atk.confirm = newRoll.result
        atk.confirmDie = newRoll.dice[0]
        atk.checkHitAndCrit()
        update()
    }
    
    @IBAction func rerollDamage(_ sender: Any) {
        let atk = attackRolls[selectedAttack]
        if atk.manyShot {
            atk.damage = atk.attack.roll("msDamage").result
            atk.critDamage = atk.attack.roll("msCrit").result
        } else {
            atk.damage = atk.attack.roll("damage").result
            atk.critDamage = atk.attack.roll("crit").result
        }
        update()
    }
    
    func showMessage(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Nice", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    
}

extension AttackAndDamageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attackRolls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AttackCell", for: indexPath) as! AttackCell
        let atk = attackRolls[indexPath.row]
        cell.attackRoll = atk
        
        cell.show(atk.hit, label: cell.hitLabel)
        cell.show(atk.crit, label: cell.critLabel)
        
        cell.confirmStack.isHidden = atk.attackDie < 19
        
        let AC = ud.value(forKey: "highestAC") as! Int
        if (atk.attackRoll >= AC && AC != 0) || atk.attackDie >= 17 {
            cell.attackLabel.textColor = UIColor.white
        } else {
            cell.attackLabel.textColor = UIColor.orange
        }
        
        if atk.confirm >= AC && AC != 0{
            cell.confirmLabel.textColor = UIColor.white
        } else {
            cell.confirmLabel.textColor = UIColor.orange
        }
        
        if indexPath.row <= 1 {
            cell.attackTitle.text = "Attack \(indexPath.row + 1) (Manyshot)"
        } else {
            cell.attackTitle.text = "Attack \(indexPath.row + 1)"
        }
        cell.attackLabel.text = "\(atk.attackRoll) (\(atk.attackDie))"
        cell.confirmLabel.text = "\(atk.confirm) (\(atk.confirmDie))"
        if atk.hit {
            if atk.crit {
                cell.damageLabel.text = "\(atk.critDamage)"
            } else {
                cell.damageLabel.text = "\(atk.damage)"
            }
        } else {
            cell.damageLabel.text = "-"
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        selectedAttack = indexPath.row
    }
    
}



class AttackCell: UITableViewCell {
    
    var attackRoll = AttackRoll(manyShot: false)
    
    @IBOutlet weak var attackTitle: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var confirmLabel: UILabel!
    @IBOutlet weak var damageLabel: UILabel!
    @IBOutlet weak var confirmStack: UIStackView!
    @IBOutlet weak var hitLabel: UILabel!
    @IBOutlet weak var critLabel: UILabel!
    
    func show(_ bool: Bool, label: UILabel) {
        if bool {
            label.textColor = UIColor.white
            let blue = UIColor(displayP3Red: 0.0, green: 122.0/255.0, blue: 1, alpha: 1)
            label.backgroundColor = blue
        } else {
            label.textColor = UIColor.lightGray
            label.backgroundColor = UIColor.clear
        }
        
    }
    

}
