//
//  ViewController.swift
//  RunLED
//
//  Created by Quan on 6/20/16.
//  Copyright © 2016 MyStudio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var n = 6
    var _margin: CGFloat = 40
    var lastOnLED = 100
    var turn: String = "" // chiều đi : xuôi, ngược
    var Root: [Int] = [0, 0, 0, 0] // vị trí cuối cùng có thể đi theo hướng cũ, gặp Root thì đổi hướng đi
    var trend: String! // hướng đi: trái, phải, lên, xuống
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawRowOfBall()
        prepareForStart("xuoi")
        let timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(runningLED), userInfo: nil, repeats: true)
        
    }
    
    func runningLED() {
        turnOffLED()
        trend = nextTrend(lastOnLED, currentTrend: trend, turn: turn)
        lastOnLED = nextLED(trend)
        
        if isStop(lastOnLED) == true {
            if turn == "xuoi" {
                turn = "nguoc"
            } else {
                turn = "xuoi"
            }
            prepareForStart(turn) // chuẩn bị cho quá trình bắt đầu lại nếu bị stop
        }
        turnOnLED()
        
    }
    
    func nextLED(trend: String) -> Int {
        if trend == "trai" {
            return lastOnLED - 1
        } else if trend == "phai" {
            return lastOnLED + 1
        } else if trend == "xuong" {
            return lastOnLED + 100
        } else {
            return lastOnLED - 100
        }
    }
    
    func nextTrend(currentLED: Int, currentTrend: String, turn: String) -> String{
        // nếu gặp Root thì chuyển hướng và thay đổi Root sang vị trí mới
        if turn == "xuoi" {
            if currentLED == Root[0] {
                Root[0] = Root[0] + 101
                return "phai"
            }
            if currentLED == Root[1] {
                Root[1] = Root[1] + 99
                return "xuong"
            }
            if currentLED == Root[2] {
                Root[2] = Root[2] - 99
                return "len"
            }
            if currentLED == Root[3] {
                Root[3] = Root[3] - 101
                return "trai"
            }
            return currentTrend
        } else {
            if currentLED == Root[0] {
                Root[0] = Root[0] - 101
                return "xuong"
            }
            if currentLED == Root[1] {
                Root[1] = Root[1] - 99
                return "trai"
            }
            if currentLED == Root[2] {
                Root[2] = Root[2] + 99
                return "phai"
            }
            if currentLED == Root[3] {
                Root[3] = Root[3] + 101
                return "len"
            }
            return currentTrend
        }
        
    }
    
    func isStop(currentLED: Int) -> Bool {
        var v = Int(n/2) + 1
        // currentLED = 100
        if currentLED == 100 {
            return true
        }
        // hoac vi tri trong cung tuy theo  gia tri cua n
        if (n % 2 == 1) && (currentLED == v*101 - 1) {
            return true
        }
        if (n % 2 == 0) && (currentLED == v * 101 - 2) {
            return true
        }
        //thì trả về true
        
        //neu không trả về fasle
        return false
    }
    
    func prepareForStart(turn: String) {
        // cài lại Root và trend để bắt đầu lại
        if turn == "xuoi" {
            Root[0] = 200
            Root[1] = 99 + n
            Root[2] = n * 100
            Root[3] = n * 101 - 1
            trend = "phai"
            self.turn = "xuoi"
        } else {
            Root[0] = Root[0] - 101
            Root[1] = Root[1] - 99
            Root[2] = Root[2] + 99
            Root[3] = Root[3] + 101
            if (n % 2) == 0 {
                trend = "phai"
            } else {
                trend = "trai"
            }
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

