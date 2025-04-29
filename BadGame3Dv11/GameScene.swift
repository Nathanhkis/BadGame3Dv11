//
//  GameScene.swift
//  Space invader
//
//  Created by Nathan zhong on 3/1/25.
//


import Foundation
import SpriteKit
import GameplayKit
import SwiftUI


//import other stuff



var currentGameTime = Float(0.0)

let FPSLabel = SKLabelNode(fontNamed: "Helvetica")
var fps = 0
class Gamescene: SKScene{
    
    // define some variable because  why not
    var move = CGVector(dx: 0.0, dy: 0.0)
    var moveDZ = Float16(0.0)
    var moveView = CGVector(dx: 0.0, dy: 0.0)
    var lastTouch = CGPoint (x: 0, y:0)
    var lastTouchTime = Float(0.0)
    var lastTouch2 = CGPoint (x: 0, y:0)
    var lastTouchTime2 = Float(0.0)
    
    
    var playerAngle = Float16(0.0)
    var playerAngleZ = Float16(0.0)
    
    //map define stuff
    
    var mapX = 8
    var mapY = 8
    var mapS = 64
    
    var rayCastNode = SKNode()
    
    
    
    var map = [
        [1, 1, 1, 1, 1, 1, 1, 1],
        [1, 0, 1, 0, 0, 0, 0, 1],
        [1, 0, 1, 0, 0, 0, 0, 1],
        [1, 0, 1, 0, 0, 0, 0, 1],
        [1, 0, 0, 0, 0, 0, 0, 1],
        [1, 0, 0, 0, 0, 1, 0, 1],
        [1, 0, 0, 0, 0, 0, 0, 1],
        [1, 1, 1, 1, 1, 1, 1, 1]
        
        
    ]
    var threeDMap = [
        
        [
        [(110,110,110), (170,170,170), (110,110,110), (170,170,170), (110,110,110), (170,170,170), (110,110,110), (170,170,170)],
        [(170,170,170), (110,110,110), (170,170,170), (110,110,110), (170,170,170), (110,110,110), (170,170,170), (110,110,110)],
        [(110,110,110), (170,170,170), (110,110,110), (170,170,170), (110,110,110), (170,170,170), (110,110,110), (170,170,170)],
        [(170,170,170), (110,110,110), (170,170,170), (110,110,110), (170,170,170), (110,110,110), (170,170,170), (110,110,110)],
        [(110,110,110), (170,170,170), (110,110,110), (170,170,170), (110,110,110), (170,170,170), (110,110,110), (170,170,170)],
        [(170,170,170), (110,110,110), (170,170,170), (110,110,110), (170,170,170), (110,110,110), (170,170,170), (110,110,110)],
        [(110,110,110), (170,170,170), (110,110,110), (170,170,170), (110,110,110), (170,170,170), (110,110,110), (170,170,170)],
        [(170,170,170), (110,110,110), (170,170,170), (110,110,110), (170,170,170), (110,110,110), (170,170,170), (110,110,110)],
        ],
        
        [
        [(230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50)],
        [(230, 50, 50), (100,100,170), (50, 50, 230),           nil,           nil,           nil,           nil, (230, 50, 50)],
        [(230, 50, 50), (100,100,170), (50, 50, 230),           nil,           nil,           nil,           nil, (230, 50, 50)],
        [(230, 50, 50), (100,100,170), (50, 50, 230),           nil,           nil,           nil,           nil, (230, 50, 50)],
        [(230, 50, 50),           nil,           nil,           nil,           nil, (50, 230, 50),           nil, (230, 50, 50)],
        [(230, 50, 50),           nil,           nil,           nil,           nil, (50, 230, 50),           nil, (230, 50, 50)],
        [(230, 50, 50),           nil,           nil,           nil,           nil,           nil,           nil, (230, 50, 50)],
        [(230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50)],
        ],
        
        [
        [(230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50)],
        [(230, 50, 50), (100,100,170), (50, 50, 230),           nil,           nil,           nil,           nil, (230, 50, 50)],
        [(230, 50, 50), (100,100,170), (50, 50, 230),           nil,           nil,           nil,           nil, (230, 50, 50)],
        [(230, 50, 50),           nil, (50, 50, 230),           nil,           nil,           nil,           nil, (230, 50, 50)],
        [(230, 50, 50),           nil,           nil,           nil,           nil,           nil,           nil, (230, 50, 50)],
        [(230, 50, 50),           nil,           nil,           nil,           nil, (50, 230, 50),           nil, (230, 50, 50)],
        [(230, 50, 50),           nil,           nil,           nil,           nil,           nil,           nil, (230, 50, 50)],
        [(230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50)],
        ],
        
        [
        [(230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50)],
        [(230, 50, 50), (100,100,170), (50, 50, 230),           nil,           nil,           nil,           nil, (230, 50, 50)],
        [(230, 50, 50),           nil, (50, 50, 230),           nil,           nil,           nil,           nil, (230, 50, 50)],
        [(230, 50, 50),           nil, (50, 50, 230),           nil,           nil,           nil,           nil, (230, 50, 50)],
        [(230, 50, 50),           nil,           nil,           nil,           nil,           nil,           nil, (230, 50, 50)],
        [(230, 50, 50),           nil,           nil,           nil,           nil, (50, 230, 50),           nil, (230, 50, 50)],
        [(230, 50, 50),           nil,           nil,           nil,           nil,           nil,           nil, (230, 50, 50)],
        [(230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50)],
        ],
        [
            
        [(170,170,170), (170,170,170), (170,170,170), (170,170,170), (170,170,170), (170,170,170), (170,170,170), (170,170,170)],
        [(230, 50, 50),           nil, (170,170,170), (170,170,170), (170,170,170), (170,170,170), (170,170,170), (170,170,170)],
        [(230, 50, 50),           nil, (170,170,170), (170,170,170), (170,170,170), (170,170,170), (170,170,170), (170,170,170)],
        [(230, 50, 50),           nil, (170,170,170), (170,170,170), (170,170,170), (170,170,170), (170,170,170), (170,170,170)],
        [(230, 50, 50),           nil, (170,170,170), (170,170,170), (170,170,170), (170,170,170), (170,170,170), (170,170,170)],
        [(170,170,170), (170,170,170), (170,170,170), (170,170,170), (170,170,170), (170,170,170), (170,170,170), (170,170,170)],
        [(170,170,170), (170,170,170), (170,170,170), (170,170,170), (170,170,170), (170,170,170), (170,170,170), (170,170,170)],
        [(170,170,170), (170,170,170), (170,170,170), (170,170,170), (170,170,170), (170,170,170), (170,170,170), (170,170,170)],
        ],
        
        [
        [(230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50)],
        [(230, 50, 50),           nil,           nil,           nil,           nil,           nil,           nil, (230, 50, 50)],
        [(230, 50, 50),           nil,           nil,           nil,           nil,           nil,           nil, (230, 50, 50)],
        [(230, 50, 50),           nil,           nil,           nil,           nil,           nil,           nil, (230, 50, 50)],
        [(230, 50, 50),           nil,           nil,           nil,           nil,           nil,           nil, (230, 50, 50)],
        [(230, 50, 50),           nil,           nil,           nil,           nil, (50, 230, 50),           nil, (230, 50, 50)],
        [(230, 50, 50),           nil,           nil,           nil,           nil,           nil,           nil, (230, 50, 50)],
        [(230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50)],
        ],
        
        [
        [(230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50)],
        [(230, 50, 50),           nil,           nil,           nil,           nil,           nil,           nil, (230, 50, 50)],
        [(230, 50, 50),           nil,           nil,           nil,           nil,           nil,           nil, (230, 50, 50)],
        [(230, 50, 50),           nil,           nil,           nil,           nil,           nil,           nil, (230, 50, 50)],
        [(230, 50, 50),           nil,           nil,           nil,           nil,           nil,           nil, (230, 50, 50)],
        [(230, 50, 50),           nil,           nil,           nil,           nil, (50, 230, 50),           nil, (230, 50, 50)],
        [(230, 50, 50),           nil,           nil,           nil,           nil,           nil,           nil, (230, 50, 50)],
        [(230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50), (230, 50, 50)],
        ],
        
        
    ] as [[[(Int, Int, Int)?]]]
    
    func scaleMap3D(_ map: [[[(Int, Int, Int)?]]], scaleFactor: Int) -> [[[(Int, Int, Int)?]]] {
        var scaledMap = [[[(Int, Int, Int)?]]]()
        
        for layer in map {
            var scaledLayer = [[(Int, Int, Int)?]]()
            
            for row in layer {
                var scaledRow = [(Int, Int, Int)?]()
                
                for element in row {
                    // Repeat each element scaleFactor times horizontally
                    for _ in 0..<scaleFactor {
                        scaledRow.append(element)
                    }
                }
                
                // Repeat each scaled row scaleFactor times vertically
                for _ in 0..<scaleFactor {
                    scaledLayer.append(scaledRow)
                }
            }
            
            // Repeat each scaled layer scaleFactor times in depth
            for _ in 0..<scaleFactor {
                scaledMap.append(scaledLayer)
            }
        }
        
        return scaledMap
    }

    // Usage:
    
    // Usage:
    
    
    
    /*
    var threeDMap = [
        [
        [1, 1, 1, 1, 1, 1, 1, 1],
        [1, 0, 1, 0, 0, 0, 0, 1],
        [1, 0, 1, 0, 0, 0, 0, 1],
        [1, 0, 1, 0, 0, 0, 0, 1],
        [1, 0, 0, 0, 0, 1, 0, 1],
        [1, 0, 0, 0, 0, 1, 0, 1],
        [1, 0, 0, 0, 0, 0, 0, 1],
        [1, 1, 1, 1, 1, 1, 1, 1]
        ],
        [
        [1, 1, 1, 1, 1, 1, 1, 1],
        [1, 0, 1, 0, 0, 0, 0, 1],
        [1, 0, 1, 0, 0, 0, 0, 1],
        [1, 0, 1, 0, 0, 0, 0, 1],
        [1, 0, 0, 0, 0, 1, 0, 1],
        [1, 0, 0, 0, 0, 1, 0, 1],
        [1, 0, 0, 0, 0, 0, 0, 1],
        [1, 1, 1, 1, 1, 1, 1, 1]
        ],
        [
        [1, 1, 1, 1, 1, 1, 1, 1],
        [1, 0, 1, 0, 0, 0, 0, 1],
        [1, 0, 1, 0, 0, 0, 0, 1],
        [1, 0, 1, 0, 0, 0, 0, 1],
        [1, 0, 0, 0, 0, 0, 0, 1],
        [1, 0, 0, 0, 0, 1, 0, 1],
        [1, 0, 0, 0, 0, 0, 0, 1],
        [1, 1, 1, 1, 1, 1, 1, 1]
        ],
        
    ]
    */
    
    
    
    
    let player = createPlayer()
    
    //did move functions
    override func didMove(to view: SKView) {
        //threeDMap = createLarge3DMap()
        //threeDMap = createEnhanced3DMap()
        //threeDMap = generate3DMaze()
        //threeDMap = createMapChagGPT()
        //threeDMap = generateGrandMazeMap()
        //threeDMap = scaleMap3D(threeDMap, scaleFactor: 10)
        self.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
        
        self.view?.isMultipleTouchEnabled = true
        
        print ("Debug")
        self.addChild(rayCastNode)
        
        FPSLabel.text = "FPS: \(fps)"
        FPSLabel.fontSize = 35
        FPSLabel.position = CGPoint(x: 100, y: 320)
        FPSLabel.fontColor = .blue
        addChild(FPSLabel)
        
        
    }
    
    
    
    override func update(_ currentTime: TimeInterval){
        fps = Int(1/(currentTime - Double(currentGameTime)))
        currentGameTime = Float(currentTime)
        //self.removeAllChildren()
        rayCastNode.removeAllChildren()
        draw2dMap()
        
        //moveDZ -= 0.2
        moveDZ = updateDZ(newPlayerDZTemp: moveDZ, map: threeDMap)
        movePlayer(moveBy: move, angle: playerAngle, angleZ: playerAngleZ, time: currentTime, map: threeDMap)
        
        let (points, points2, distances) = rayCastMath(map: threeDMap)
        drawDebug(points2: points2)
        
       
        
        
        draw3dMap(points: points, distance: distances)
        rayCastNode.addChild(player)
        
        FPSLabel.text = String(fps)
        
        
    }
    
    func drawDebug (points2: [CGPoint]){
        for point in points2 {
            let squarePath = UIBezierPath(roundedRect: CGRect(x: point.x * 40, y: point.y * 40, width: 40, height: 40), cornerRadius: 0)
            let square = SKShapeNode(path: squarePath.cgPath)
            
            //square.strokeColor = UIColor.green
            
            square.fillColor = UIColor.green
            rayCastNode.addChild(square)
        }
    }
    
    /*
    func draw3dMap (points: [[Bool]]) {
        let map =  SKNode()
        for (y, yLis) in points.enumerated(){
            for (x, bol) in yLis.enumerated(){
                
                if !bol {
                    continue
                }
                
                
                
                let squarePath = UIBezierPath(roundedRect: CGRect(x: x*5 + 400, y: y * 5 + 50, width: 5, height: 5), cornerRadius: 0)
                let square = SKShapeNode(path: squarePath.cgPath)
                square.strokeColor = UIColor.red
                square.fillColor = UIColor.red
                
                map.addChild(square)
                //print (length)
            }
        }
        
        map.position.y = 0
        map.position = CGPoint(x: 0, y: 0)
        rayCastNode.addChild(map)
    
    }
    */
    func draw3dMap(points: [[(Int, Int, Int)?]], distance: [[Float16]]) {
        
        
        for (y, yLis) in points.enumerated() {
            for (x, bol) in yLis.enumerated() {
                if bol == nil { continue }
                
                guard var (red, green, blue) = bol else { continue }
                
                
                var dis = CGFloat(distance[y][x])
                
                if dis > 1 {
                    dis = pow(Double(dis - 1), 1.5) / 20 + 1
                    dis = sqrt(dis-1) / 2 + 1
                } else {
                    dis = 1
                }
                
                
                
                
                let squarePath = UIBezierPath(roundedRect: CGRect(x: x*5 + 400, y: y * 5 + 50, width: 5, height: 5), cornerRadius: 0)
                let square = SKShapeNode(path: squarePath.cgPath)
                
                
                
                // Convert Int values (0-255) to CGFloat values (0.0-1.0)
                square.strokeColor = UIColor(red: CGFloat(red)/255.0/dis,
                                            green: CGFloat(green)/255.0/dis,
                                            blue: CGFloat(blue)/255.0/dis,
                                            alpha: 1)
                square.fillColor = UIColor(red: CGFloat(red)/255.0/dis,
                                          green: CGFloat(green)/255.0/dis,
                                          blue: CGFloat(blue)/255.0/dis,
                                          alpha: 1)
                
                rayCastNode.addChild(square)
            }
        }
    }
    
    
    
    
    // movement calculator
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            
            let location = touch.location (in: self)
            if location.x > self.size.width/2{
                let newLocation = CGPoint(x: location.x, y: location.y)
                lastTouch = newLocation
                lastTouchTime = Float(currentGameTime)
            } else {
                let newLocation = CGPoint(x: location.x, y: location.y)
                lastTouch2 = newLocation
                lastTouchTime2 = Float(currentGameTime)
            }
        }
        
        
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print ("new")
        for touch in touches{
            //print (touch)
            print ("yay")
            
            let location = touch.location (in: self)
            print (location)
            
            if location.x > self.size.width/2 || (abs(lastTouch.x - location.x) < 200 && abs(lastTouch.y - location.y) < 200) {
                let newLocation = CGPoint(x: location.x, y: location.y)
                
                
                
                moveView = CGVector(dx:(lastTouch.x - newLocation.x), dy:lastTouch.y - newLocation.y)
                
                playerAngle += Float16(moveView.dx / -40)
                
                playerAngleZ += Float16(moveView.dy / 40)
                
                
                playerAngle = if playerAngle < 0 {playerAngle + 6.28} else if playerAngle > 6.28 {playerAngle - 6.28} else {playerAngle}
                
                playerAngleZ = if playerAngleZ < -3.14 {-3.14} else if playerAngleZ > 3.14 {3.14} else {playerAngleZ}
                
                
                
                lastTouch = newLocation
                
            } else {
                
                
                move = CGVector(dx:location.x - lastTouch2.x, dy:location.y - lastTouch2.y)
                
                move.dx /= 100
                move.dy /= 100
                
                var temp = sqrt(pow(move.dx, 2) + pow(move.dy, 2))
                if temp > 1 {temp = 1/temp; move.dx *= temp; move.dy *= temp}
                
                
                
                //lastTouch2 = location
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            
            let location = touch.location (in: self)
            
            if location.x > self.size.width/2 || (abs(lastTouch.x - location.x) < 200 && abs(lastTouch.y - location.y) < 200){
                moveView = CGVector(dx: 0.0, dy: 0.0)
                
            } else {
                move = CGVector(dx: 0.0, dy: 0.0)
                if currentGameTime - lastTouchTime2 < 0.3{
                    
                    if abs(moveDZ) != 0.0 {
                        continue
                    }
                    
                    moveDZ = 0.8
                    continue
                }
                
                //lastTouch2 = location
                
            }
        }
    }
    
    
    func draw2dMap(){
        

        // Method 1: Using SKTexture
        
        let twoDMap =  SKNode()
        var height = Int()
        height = 2
        for (y, yList) in threeDMap[height].enumerated(){
            
            for (x, value) in yList.enumerated(){
                
                let squarePath = UIBezierPath(roundedRect: CGRect(x: x * 40, y: y * 40, width: 39, height: 39), cornerRadius: 0)
                let square = SKShapeNode(path: squarePath.cgPath)
                //square.strokeColor = UIColor.green
                if (value == nil){
                    square.fillColor = UIColor.white
                } else {
                    square.fillColor = UIColor.gray
                }
                
                twoDMap.addChild(square)
            }
        }
        
        twoDMap.position.y = 0
        twoDMap.position = CGPoint(x: 0, y: 0)
        rayCastNode.addChild(twoDMap)
    }
    
}

struct gameScene_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}








