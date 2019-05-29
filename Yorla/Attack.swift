//
//  Attack.swift
//  Yorla
//
//  Created by Tom on 4/11/19.
//  Copyright © 2019 Tom. All rights reserved.
//

import Foundation
import GameplayKit

class Attack {
    
    var attackBonus: Int
    var damageDice: Int
    var damageBonus: Int
    var nonCritDice: Int
    
    init(attackBonus: Int = 0,
         damageDice: Int = 1,
         damageBonus: Int = 0,
         nonCritDice: Int = 0) {
        self.attackBonus = attackBonus
        self.damageDice = damageDice
        self.damageBonus = damageBonus
        self.nonCritDice = nonCritDice
    }
    
    
    
    func roll(_ mode: String) -> (result: Int, dice: [Int]) {
        
        var diceSize = 6
        var diceNumber = 0
        var bonus = 0
        var fickle = true
        
        switch mode {
        case "attack":
            diceSize = 20
            diceNumber = 1
            bonus = attackBonus
            fickle = false
        case "damage":
            diceSize = 6
            diceNumber = damageDice + nonCritDice
            bonus = damageBonus
        case "crit":
            diceSize = 6
            diceNumber = (3 * damageDice) + nonCritDice
            bonus = (3 * damageBonus)
        case "msDamage":
            diceSize = 6
            diceNumber = (2 * damageDice) + nonCritDice
            bonus = (2 * damageBonus)
        case "msCrit":
            diceSize = 6
            diceNumber = (4 * damageDice) + nonCritDice
            bonus = (4 * damageBonus)
        default:
            break
        }
        
        let critMaster = UserDefaults.standard.bool(forKey: "critMaster")
        let diceResults = rollDice(x: diceNumber, d: diceSize, fickle: fickle, max: (critMaster && diceSize == 6))
        
        
        return ((diceResults.result + bonus), diceResults.rolls)
    }
    
    
    
    func rollDice(x: Int, d: Int, fickle: Bool = true, max: Bool = false) -> (result: Int, rolls: [Int]) {
        var total: Int = 0
        var rolls = [Int]()
        let dice = GKRandomDistribution(lowestValue: 1, highestValue: d)
        for _ in 1...x {
            var rollResult = dice.nextInt()
            if rollResult <= 3 && fickle {
                rollResult = 6
            }
            total += rollResult
            rolls.append(rollResult)
        }
        if max {
            total = x * d
            rolls = [Int]()
            for _ in 1...x {
                rolls.append(d)
            }
        }
        return (total, rolls)
    }
    
    
    
}


class AttackRoll {
    
    var attack: Attack
    var attackRoll: Int
    var attackDie: Int
    var confirm: Int
    var confirmDie: Int
    var damage: Int
    var critDamage: Int
    var manyShot: Bool
    var hit: Bool = false
    var crit: Bool = false
    
    
    init(from: Attack = Attack(), manyShot: Bool) {
        attack = from
        self.manyShot = manyShot
        let atkRoll = attack.roll("attack")
        attackRoll = atkRoll.result
        attackDie = atkRoll.dice[0]
        let confirmRoll = attack.roll("attack")
        confirm = confirmRoll.result
        confirmDie = confirmRoll.dice[0]
        if self.manyShot {
            damage = attack.roll("msDamage").result
            critDamage = attack.roll("msCrit").result
        } else {
            damage = attack.roll("damage").result
            critDamage = attack.roll("crit").result
        }
        
        if !UserDefaults.standard.bool(forKey: "autoAttack")  {
            attackRoll = 0
            attackDie = 0
            confirm = 0
            confirmDie = 0
        }
        
        if !UserDefaults.standard.bool(forKey: "autoDamage") {
            damage = 0
            critDamage = 0
        }
        checkHitAndCrit()
    }
    
    
    func checkHitAndCrit() {
        let highAC = UserDefaults.standard.value(forKey: "highestAC") as! Int
        hit = (attackDie >= 17 || (attackRoll >= highAC && highAC != 0)) && attackDie != 1
        crit = attackDie >= 19 && confirm >= highAC && highAC != 0
    }
    
    func reroll(_ mode: String) {
        switch mode {
        case "attack":
            let atkRoll = attack.roll("attack")
            attackRoll = atkRoll.result
            attackDie = atkRoll.dice[0]
        case "confirm":
            let confirmRoll = attack.roll("attack")
            confirm = confirmRoll.result
            confirmDie = confirmRoll.dice[0]
        case "damage" :
            if manyShot {
                damage = attack.roll("msDamage").result
            } else {
                damage = attack.roll("damage").result
            }
        case "crit" :
            if manyShot {
                critDamage = attack.roll("msCrit").result
            } else {
                critDamage = attack.roll("crit").result
            }
        default:
            break
        }
    }
    
    
    
    
}
