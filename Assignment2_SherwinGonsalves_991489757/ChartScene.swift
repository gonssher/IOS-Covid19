//
//  ChartScene.swift
//  Assignment2_SherwinGonsalves_991489757
//
//  Created by Sherwin Gonsalves on 2020-11-20.
//

import UIKit
import SpriteKit
import GameplayKit


class ChartScene: SKScene {

    var shapeLine1 = SKShapeNode()
    let circle = SKShapeNode(circleOfRadius: 15)
    let labelValueCases = SKLabelNode(fontNamed: "Helvetica")
    let labelValueDate = SKLabelNode(fontNamed: "Helvetica")
    let OrangeLine = SKShapeNode()


 
    func updateChart(_ values: [Int], _ cases : String, _ dates : String) {
        
        let path1 = CGMutablePath()
        let lineDrawing = CGMutablePath()
        let scaleX = 800 /  CGFloat(values.count - 1)
        let maxValue = values.max() ?? 0
        let scaleY = 800 / CGFloat(maxValue)
        let point = CGPoint(x: 12 * scaleX + 150, y: 34 * scaleY + 150)
      
        for i in 0 ..< values.count-1
        {
            
           path1.move(to: CGPoint(x: scaleX * CGFloat(i) + 100,y: scaleY * CGFloat(values[i]) + 100))
           path1.addLine(to: CGPoint(x: scaleX * CGFloat(i+1) + 100,y: scaleY * CGFloat(values[i+1]) + 100))
            
            
            

           circle.position = CGPoint(x: scaleX * CGFloat(i+1) + 100,y: scaleY * CGFloat(values[i+1]) + 100)
           labelValueCases.position = CGPoint(x:  scaleX * CGFloat(i+1) + 125, y: scaleY * CGFloat(values[i+1]) + 125)
           labelValueDate.position = CGPoint(x:  scaleX * CGFloat(i+1)  , y: scaleY + 50 )

           
          
        }

        
        labelValueCases.removeFromParent()
        labelValueDate.removeFromParent()
        OrangeLine.removeFromParent()
       
        
        DispatchQueue.main.async
        {
            self.labelValueCases.text = "\(cases)"
            self.labelValueDate.text = "\(dates)"
        }

        
    
        OrangeLine.removeFromParent()
        OrangeLine.path = lineDrawing
        OrangeLine.strokeColor = .systemRed
        OrangeLine.lineWidth = 12
        
        
        
        labelValueDate.fontSize = 55
        labelValueDate.fontColor = SKColor.black
        labelValueCases.fontSize = 65
        labelValueCases.fontColor = SKColor.black
        
        shapeLine1.removeFromParent()
        shapeLine1.path = path1
        shapeLine1.strokeColor = .systemBlue
        shapeLine1.lineWidth = 9
 

        circle.removeFromParent()
        circle.fillColor = .white
        circle.strokeColor = .systemRed
        circle.lineWidth = 10
        circle.zPosition = 2
    
        print("Date Passed \(dates)")
        self.addChild(circle)
        self.addChild(shapeLine1)
        self.addChild(labelValueCases)
        self.addChild(labelValueDate)
        self.addChild(OrangeLine)
       
     
    }
    
    
    func drawmyFinalLine() {
     
    }
    


 }

    
    

    
    
