//
//  ViewController.swift
//  RunLED
//
//  Created by Quan on 6/20/16.
//  Copyright © 2016 MyStudio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var n = 5, i: Int!
    var _margin: CGFloat = 40
    var lastOnLED = 100
    var go: Int = 0 // 0: sang phai, 1: xuong, 2: sang trai, 3: len
    var isTurnning: Bool = false // fasle: xoắn xuôi , xoắn: chạy ngược
    
    override func viewDidLoad() {
        super.viewDidLoad()
        i = 1
        drawRowOfBall()
        let timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(runningLED), userInfo: nil, repeats: true)
        
    }
    
    func runningLED() {
        turnOffLED()
        // nếu là điểm chính giữa đưa đèn về điểm trước điểm chính giữa, đưa kiểu chạy (lên, xuống, trái, phải)là kiểu đi xuống
        if (Int(lastOnLED / 100) + (lastOnLED % 100) == n) && (Int(lastOnLED / 100) - (lastOnLED % 100) == 1) {
            isTurnning = true
            go = 1
            i = i - 1
            lastOnLED = lastOnLED - 1
            turnOnLED()
        // xác định kiểu chạy tuỳ theo kiểu xoắn
        } else {
            
            if go == 0 {
                lastOnLED += 1
            } else if go == 1 {
                lastOnLED += 100
            } else if go == 2 {
                lastOnLED -= 1
            } else {
                lastOnLED -= 100
            }
            
            if isTurnning == true {
                
                if (Int(lastOnLED / 100) == i) && (lastOnLED % 100 == (i-2)) {
                    go = 1
                    i = i - 1
                }
                if (Int(lastOnLED / 100) == i) && (lastOnLED % 100 == (n - i)) {
                    go = 2
                }
                if (Int(lastOnLED / 100) == n-i+1) && (lastOnLED % 100 == (n-i)) {
                    go = 3
                }
                if (Int(lastOnLED / 100) == n-i+1) && (lastOnLED % 100 == (i-1)) {
                    go = 0
                }
            
            } else {
                
                if (Int(lastOnLED / 100) == i) && (lastOnLED % 100 == (i-1)) {
                    go = 0
                    i = i + 1
                    lastOnLED = i * 100 + i - 1
                }
                if (Int(lastOnLED / 100) == i) && (lastOnLED % 100 == (n - i)) {
                    go = 1
                }
                if (Int(lastOnLED / 100) == n-i+1) && (lastOnLED % 100 == (n-i)) {
                    go = 2
                }
                if (Int(lastOnLED / 100) == n-i+1) && (lastOnLED % 100 == (i-1)) {
                    go = 3
                }
                
            }
            turnOnLED()
            
        }
        // nếu là điểm đầu tiên thì đổi kiểu xoắn là false, đưa lại kiểu chạy về sang trái
        if lastOnLED == 100 {
            go = 0
            isTurnning = false
        }
        
    }
    
    func turnOnLED()  {
        if let ball = self.view.viewWithTag(lastOnLED)
            as? UIImageView
        {
            ball.image = UIImage(named: "green")
        }
    }
    
    func turnOffLED() {
        if let ball = self.view.viewWithTag(lastOnLED)
            as? UIImageView
        {
            ball.image = UIImage(named: "grey")
        }
    }
    
    func drawRowOfBall() {
        for indexCol in 0..<n {
            for indexRow in 0..<n {
                let image = UIImage(named: "green")
                let ball = UIImageView(image: image)
                
                ball.center = CGPointMake(_margin + CGFloat(indexRow) * spaceBetweenBallRow(), _margin + CGFloat(indexCol) * spaceBetweenBallCol())
                ball.tag = indexRow + 100 * (indexCol + 1)
                self.view.addSubview(ball)
                
            }
        }
    }
    
    func spaceBetweenBallRow() -> CGFloat{
        let space = (self.view.bounds.width - 2 * _margin) / CGFloat(n-1)
        return space
    }
    
    func spaceBetweenBallCol() -> CGFloat {
        let space = (self.view.bounds.height - 2 * _margin) / CGFloat(n-1)
        return space
    }

    
}

