//
//  ViewController.swift
//  Escape the Cars
//
//  Created by Burak Altunoluk on 29/07/2022.
//

import UIKit
import AVFoundation

final class MainVC: UIViewController {
    private var player: AVAudioPlayer!
    private var affectPlayer: AVAudioPlayer!

    private var carsImage = [UIImage(named: "car1"),UIImage(named: "car2"),UIImage(named: "car3"),UIImage(named: "car4"),UIImage(named: "speedometer"), UIImage(named: "polisCar"),UIImage(named: "car5"),UIImage(named: "car6"),UIImage(named: "car7")]
    
    private var totalClick = 0
    private var greenCarLocation = 0
    private var yellowCarLocation = -400
    private var timer = Timer()
    private var myCarPosition = 262
    private var speed = 0.003
    @IBOutlet var roadImage: UIImageView!
    @IBOutlet var greenCar: UIImageView!
    @IBOutlet var yellowCar: UIImageView!
    @IBOutlet var myCar: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playBackroundMusic()
        myCar.frame.origin.x = 262
        
        // greenCar.frame.origin.y = 0
        runningTimer()
        roadImage.isUserInteractionEnabled = true
        let roadImageGesture = UITapGestureRecognizer(target: self, action: #selector(cordinateOfMyCar))
        roadImage.addGestureRecognizer(roadImageGesture)
    }
    
    
    @objc func cordinateOfMyCar(sender: UITapGestureRecognizer) {
        totalClick += 1
        if myCarPosition == 75 {
            myCar.frame.origin.x = 262
            myCarPosition = 262
        } else {
            myCar.frame.origin.x = 75
            myCarPosition = 75
            
        }
        
    }
    
    @objc func carsController() {
        
        yellowCarLocation += 1
        greenCarLocation += 1
        yellowCar.frame.origin.x = 262
        greenCar.frame.origin.x = 75
        yellowCar.frame.origin.y = CGFloat(yellowCarLocation)
        greenCar.frame.origin.y = CGFloat(greenCarLocation)
        
        if greenCar.frame.origin.y >= 900 {
            greenCarLocation = -10
            if speed >= 0.001 {speed -= 0.0004
                runningTimer()}
            
            greenCar.image = carsImage[Int.random(in: 0...8)]
        }
        
        if greenCar.frame.origin.x == myCar.frame.origin.x {
            
            if greenCar.frame.origin.y >= 335 && greenCar.frame.origin.y <= 540 {
                
                if greenCar.image == #imageLiteral(resourceName: "speedometer") {
                    effectSound(affect: "bonus")
                    speed += 0.001
                    greenCarLocation = -10
                    yellowCarLocation = -400
                    runningTimer()
                    greenCar.image = carsImage[Int.random(in: 0...8)]
                } else {
                    alertMenu()
                }
            }
        }
        
        
        if yellowCar.frame.origin.y >= 900 {
            yellowCarLocation = -20
            yellowCar.image = carsImage[Int.random(in: 0...8)]
        }
        
        if yellowCar.frame.origin.x == myCar.frame.origin.x {
            if yellowCar.frame.origin.y >= 335 && yellowCar.frame.origin.y <= 540 {
                if yellowCar.image == #imageLiteral(resourceName: "speedometer") {
                    effectSound(affect: "bonus")
                    speed += 0.001
                    greenCarLocation = -10
                    yellowCarLocation = -400
                    runningTimer()
                    yellowCar.image = carsImage[Int.random(in: 0...8)]
                } else {
                    alertMenu()
                }
            }
        }
    }
    
    func runningTimer() {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: speed, target: self, selector: #selector(carsController), userInfo: nil, repeats: true)
    }
    
    func alertMenu() {
        effectSound(affect: "crash")
        player.stop()
        timer.invalidate()
        let alert = UIAlertController(title: "Game Over", message: "Your score is: \(totalClick)", preferredStyle: UIAlertController.Style.alert)
        let alertButton = UIAlertAction(title: "Again", style: UIAlertAction.Style.default) { UIAlertAction in
            
            self.totalClick = 0
            self.greenCarLocation = -10
            self.yellowCarLocation = -400
            self.speed = 0.003
            self.runningTimer()
            self.playBackroundMusic()
        }
        alert.addAction(alertButton)
        present(alert, animated: true)
    }
    func playBackroundMusic() {
        let url = Bundle.main.url(forResource: "backroundMusic", withExtension: "mp3")
                player = try! AVAudioPlayer(contentsOf: url!)
                player.play()
                        
    }
    func effectSound(affect: String) {
        let url = Bundle.main.url(forResource: affect, withExtension: "mp3")
        affectPlayer = try! AVAudioPlayer(contentsOf: url!)
        affectPlayer.play()
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}


