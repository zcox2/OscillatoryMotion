//
//  ViewController.swift
//  CoreMotionTester
//
//  Created by Zachary Cox on 3/5/16.
//  Copyright © 2016 Zachary Cox. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    // Instance Variables
    
    var currentMaxAccelX: Double = 0.0
    var currentMaxAccelY: Double = 0.0
    var currentMaxAccelZ: Double = 0.0
    var currentMaxRotX: Double = 0.0
    var currentMaxRotY: Double = 0.0
    var currentMaxRotZ: Double = 0.0
    var isRotatingClockwise = true
    var rotationData = [Double]()
    var recordedClockwiseRotation: Int = 0
    var rotationCounter: Int = 0
    var periodCounter: Int = 0
    var posRotationCounter: Int = 0
    var negRotationCounter: Int = 0
    var timeCounter: Int = 0
    var avgFreq: Double = 0
    var totalTime: Double = 0
    var avgPeriod: Double = 0

    
    let updateInterval = 0.02
    
    var motionManager = CMMotionManager()
    
    // Outlets
    
    @IBOutlet var accX: UILabel?
    @IBOutlet var accY: UILabel?
    @IBOutlet var accZ: UILabel?
    @IBOutlet var maxAccX: UILabel?
    @IBOutlet var maxAccY: UILabel?
    @IBOutlet var maxAccZ: UILabel?
    @IBOutlet var rotX: UILabel?
    @IBOutlet var rotY: UILabel?
    @IBOutlet var rotZ: UILabel?
    @IBOutlet var maxRotX: UILabel?
    @IBOutlet var maxRotY: UILabel?
    @IBOutlet var maxRotZ: UILabel?
    @IBOutlet weak var periodCount: UILabel!
    @IBOutlet weak var averageFrequency: UILabel!
    @IBOutlet weak var averagePeriod: UILabel!
    @IBOutlet weak var timeInSec: UILabel!
    
    // Functions
    
    @IBAction func resetMaxValues() {
        currentMaxAccelX = 0
        currentMaxAccelY = 0
        currentMaxAccelZ = 0
        
        currentMaxRotX = 0
        currentMaxRotY = 0
        currentMaxRotZ = 0
        
        recordedClockwiseRotation = 0
        rotationCounter = 0
        periodCounter = 0
        posRotationCounter = 0
        negRotationCounter = 0
        timeCounter = 0
        
        avgFreq = 0
        totalTime = 0
        avgPeriod = 0
    }

    override func viewDidLoad() {
        
        currentMaxAccelX = 0
        currentMaxAccelY = 0
        currentMaxAccelZ = 0
        
        currentMaxRotX = 0
        currentMaxRotY = 0
        currentMaxRotZ = 0
        
        motionManager.gyroUpdateInterval = updateInterval
        motionManager.accelerometerUpdateInterval = updateInterval
        
        //Start Recording Data
        
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!) { (accelerometerData: CMAccelerometerData?, NSError) -> Void in
            
            self.outputAccData(accelerometerData!.acceleration)
            if(NSError != nil) {
                print("\(NSError)")
            }
        }
        
        
        motionManager.startGyroUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: { (gyroData: CMGyroData?, NSError) -> Void in
            self.outputRotData(gyroData!.rotationRate)
            self.trackMotion(gyroData!.rotationRate)
            if (NSError != nil){
                print("\(NSError)")
            }
            
            
        })
        
        
        
        
        
    }
    
    func outputAccData(acceleration: CMAcceleration){
        
        accX?.text = "\(acceleration.x).2fg"
        if fabs(acceleration.x) > fabs(currentMaxAccelX)
        {
            currentMaxAccelX = acceleration.x
        }
        
        accY?.text = "\(acceleration.y).2fg"
        if fabs(acceleration.y) > fabs(currentMaxAccelY)
        {
            currentMaxAccelY = acceleration.y
        }
        
        accZ?.text = "\(acceleration.z).2fg"
        if fabs(acceleration.z) > fabs(currentMaxAccelZ)
        {
            currentMaxAccelZ = acceleration.z
        }
        
        
        maxAccX?.text = "\(currentMaxAccelX).2f"
        maxAccY?.text = "\(currentMaxAccelY).2f"
        maxAccZ?.text = "\(currentMaxAccelZ).2f"
        
        
    }
    
    func trackMotion(rotation: CMRotationRate){
        // rotation rate expressed in radians per second, sign follows right hand rule
        // positive x is from home button to top of phone
        // positive y is from volume buttons to sleep button
        // positive z is directed out of screen
        
        rotationData.append(rotation.z)
        
        if isRotatingClockwise {
            if negRotationCounter < 7 {
                if rotation.z < 0 {
                    negRotationCounter++
                }
                timeCounter++
            } else if timeCounter < 9 {
                isRotatingClockwise = false
                periodCounter++
                avgFreq = Double(periodCounter) / totalTime
                avgPeriod = totalTime / Double(periodCounter)
                negRotationCounter = 0
                timeCounter = 0
            } else {
                timeCounter = 0
                negRotationCounter = 0
            }
        }
        if isRotatingClockwise == false {
            if posRotationCounter < 7 {
                if rotation.z > 0 {
                    posRotationCounter++
                }
                timeCounter++
                
            } else if timeCounter < 9 {
                isRotatingClockwise = true
                posRotationCounter = 0
                timeCounter = 0
            } else {
                timeCounter = 0
                posRotationCounter = 0
            }
        }
        
        totalTime = totalTime + updateInterval
        
        periodCount.text = String(periodCounter)
        
        averageFrequency.text = String(avgFreq)
        averagePeriod.text = String(avgPeriod)
        timeInSec.text = String.localizedStringWithFormat("%.0f", totalTime)
    }
    
    
    func determineRotation(rotation: CMRotationRate){
        // rotation rate expressed in radians per second, sign follows right hand rule
        // positive x is from home button to top of phone
        // positive y is from volume buttons to sleep button
        // positive z is directed out of screen
        
        
        
    }
    
    func outputRotData(rotation: CMRotationRate){
        
        
        rotX?.text = "\(rotation.x).2fr/s"
        if fabs(rotation.x) > fabs(currentMaxRotX)
        {
            currentMaxRotX = rotation.x
        }
        
        rotY?.text = "\(rotation.y).2fr/s"
        if fabs(rotation.y) > fabs(currentMaxRotY)
        {
            currentMaxRotY = rotation.y
        }
        
        rotZ?.text = "\(rotation.z).2fr/s"
        if fabs(rotation.z) > fabs(currentMaxRotZ)
        {
            currentMaxRotZ = rotation.z
        }
        
        
        
        
        maxRotX?.text = "\(currentMaxRotX).2f"
        maxRotY?.text = "\(currentMaxRotY).2f"
        maxRotZ?.text = "\(currentMaxRotZ).2f"
        
        
        
    }
}


