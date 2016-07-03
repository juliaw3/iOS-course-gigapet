//
//  ViewController.swift
//  mylittlemoster
//
//  Created by Julia Waggoner on 6/19/16.
//  Copyright © 2016 Julia Waggoner. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var monsterImg: MonsterImg!
    @IBOutlet weak var foodImg: DragImg!
    @IBOutlet weak var heartImg: DragImg!
    
    @IBOutlet weak var penalty1: UIImageView!
    @IBOutlet weak var penalty2: UIImageView!
    @IBOutlet weak var penalty3: UIImageView!


    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTIES = 3
    
    var penalties = 0
    var timer: NSTimer!
    var monsterHappy = false
    var currentItem: UInt32 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodImg.dropTarget = monsterImg
        heartImg.dropTarget = monsterImg
  
        penalty1.alpha = DIM_ALPHA
        penalty2.alpha = DIM_ALPHA
        penalty3.alpha = DIM_ALPHA
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped:", object: nil)
        
        startTimer()
    }
    
    func itemDroppedOnCharacter(notif: AnyObject){
        monsterHappy = true
        startTimer()
        
        foodImg.alpha = DIM_ALPHA
        foodImg.userInteractionEnabled = false
        heartImg.alpha = DIM_ALPHA
        heartImg.userInteractionEnabled = false
    }
    
    func startTimer(){
        if timer != nil{
            timer.invalidate()
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
    }
    
    func changeGameState(){
        
        if !monsterHappy{
            penalties++
            if penalties == 1{
                penalty1.alpha = OPAQUE
                penalty2.alpha = DIM_ALPHA
                penalty3.alpha = DIM_ALPHA
            } else if penalties == 2{
                penalty2.alpha = OPAQUE
                penalty3.alpha = DIM_ALPHA
            } else if penalties >= 3{
                penalty3.alpha = OPAQUE
            } else{
                penalty1.alpha = DIM_ALPHA
                penalty2.alpha = DIM_ALPHA
                penalty3.alpha = DIM_ALPHA
            }
            
            if penalties >= MAX_PENALTIES{
                gameOver()
            }

        }
        
        let rand = arc4random_uniform(2)
        
        if rand == 0{
            foodImg.alpha = DIM_ALPHA
            foodImg.userInteractionEnabled = false
            
            heartImg.alpha = OPAQUE
            heartImg.userInteractionEnabled = true
        } else{
            heartImg.alpha = DIM_ALPHA
            heartImg.userInteractionEnabled = false
            
            foodImg.alpha = OPAQUE
            foodImg.userInteractionEnabled = true
        }
        
        currentItem = rand
        monsterHappy = false
        
    }

    func gameOver(){
        timer.invalidate()
        monsterImg.playDeathAnimation()
    }
}

