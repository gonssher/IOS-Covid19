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
 
    func updateChart(_ values: [Int]) {
        
         let path1 = CGMutablePath()
        
        let scaleX = 800 /  CGFloat(values.count - 1)
        let maxValue = values.max() ?? 0
        let scaleY = 800 / CGFloat(maxValue)
        let point = CGPoint(x: 12 * scaleX + 150, y: 34 * scaleY + 150)
        
        for i in 0 ..< values.count-1
        {
            
           path1.move(to: CGPoint(x: scaleX * CGFloat(i) + 100,y: scaleY * CGFloat(values[i]) + 100))
           path1.addLine(to: CGPoint(x: scaleX * CGFloat(i+1) + 100,y: scaleY * CGFloat(values[i+1]) + 100))
       
            circle.position = CGPoint(x: scaleX * CGFloat(i+1) + 100,y: scaleY * CGFloat(values[i+1]) + 100)
       
            //circle.Position = CGPoint(x: Int(scaleX) * CGFloat(i+1) + 100,y: Int(scaleY) * CGFloat(values[i+1]) + 100)
        }

        shapeLine1.removeFromParent()
         shapeLine1.path = path1
         shapeLine1.strokeColor = .systemBlue
         shapeLine1.lineWidth = 9
        
        circle.removeFromParent()
        circle.fillColor = .white // fill colour
        circle.strokeColor = .systemRed // border colour
        circle.lineWidth = 10 // border width
       circle.zPosition = 2 // z-index
       // circle.position.x =   path1.move(to: CGPoint(x: scaleX * CGFloat(i) + 100,y: scaleY * CGFloat(values[i]) + 100)) // position
        
        self.addChild(circle)
         self.addChild(shapeLine1)


        
       
     
    }

    
    
    
 
   
    
 }
    
    

    
    
