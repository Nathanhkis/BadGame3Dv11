
//
//  player.swift
//  BadGame
//
//  Created by Nathan zhong on 4/7/25.
//



import Foundation
import SpriteKit
import GameplayKit
import SwiftUI
import math_h




let player = SKSpriteNode()
var lastCalledMoveTime = 0.00

//var playerGamePosition = CGPoint(x: 0.0, y: 0.0)

var playerGamePosition: [Float] = [1.0, 6.5, 2.0]
let height = 1






//var playerGamePositionZ = Float(2.0)
var playerAngle = 0.0
var playerAngleZ = 0.0

var playerDZ = 0.0
//var test = CGPoint(x: 1, y:1, z: 1)






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

func getPlayerHeight () -> Int {
    return Int(playerGamePosition[2])
}

func createPlayer () -> SKSpriteNode{
    
    player.size = CGSize(width: 20, height: 20)
    player.color = UIColor.blue
    player.position = CGPoint(x: UIScreen.main.bounds.width/4, y: UIScreen.main.bounds.minY + 100)
    
    //player.position = CGPoint(x:Int(playerGamePosition[0] * 40), y:Int(playerGamePosition[0] * 40))
    player.position = CGPoint(x: 600.0, y: 2600.0)
    
    player.name = "player"
    
    
    let square = SKSpriteNode(color: .white, size: CGSize(width: 5, height: 10))
        square.position = CGPoint(x: 2.5, y: 10)
        player.addChild(square)
    return player
}

func updateDZ (newPlayerDZTemp: CGFloat, map: [[[(Int, Int, Int)?]]]) -> CGFloat {
    var newPlayerDZ = newPlayerDZTemp * CGFloat(1)
    /*
    if playerGamePosition[2] >= 0.0 {
        playerGamePosition[2] += Float(newPlayerDZ)
        if playerGamePosition[2] < 2 {
            playerGamePosition[2] = 2.0
            return 0.0
        }
        return newPlayerDZ
    } else {
        return 0.0
    }*/
    if Int(playerGamePosition[2]+Float(newPlayerDZ)) >= map.count || Int(playerGamePosition[2] + Float(newPlayerDZ) - Float(height)) < 0 {
        return 0.0
    }
    /*
    if map [Int(playerGamePosition[2]+Float(newPlayerDZ))][Int(playerGamePosition[1])][Int(playerGamePosition[0])] == nil && map [Int(playerGamePosition[2]+Float(newPlayerDZ) - 1)][Int(playerGamePosition[1])][Int(playerGamePosition[0])] == nil{
        playerGamePosition[2] += Float(newPlayerDZ)
        return newPlayerDZ
    } else
    {return 0.0}*/
    if checkSpot(map: map, place: [Int(playerGamePosition[0]), Int(playerGamePosition[1]), Int(playerGamePosition[2] + Float(newPlayerDZ)) - height], height: height){
        playerGamePosition[2] += Float(newPlayerDZ)
        return newPlayerDZ - (0.2 * CGFloat(1))
    } else {return 0.0}
}
func checkSpot (map: [[[(Int, Int, Int)?]]], place: [Int], height: Int) -> Bool{
    for x in stride(from: 0, through: height, by: 1) {
        if map [place[2]][place[1]][place[0]] != nil {
            return false
        }
    }
    return true
}
func movePlayer(moveBy: CGVector, angle: CGFloat, angleZ: CGFloat, time: Double, map: [[[(Int, Int, Int)?]]]) {
    
    var amntMoved = time - lastCalledMoveTime
    amntMoved = amntMoved*100
    
    
    
    player.zRotation = angle
    playerAngle = angle/3.14*180
    playerAngle += 90
    
    //playerAngleZ = moveBy
    if playerAngle >= 360 {
        playerAngle -= 360
    }
    
    playerAngleZ = angleZ / 3.14 * 180
    
    
    var dist = sqrt(moveBy.dx * moveBy.dx + moveBy.dy * moveBy.dy) * amntMoved
    var moveAngle = CGFloat()
   
    
    moveAngle = 0
    
    
    //moveAngle = 0
    
    moveAngle -= angle * 180 / 3.14
    
    moveAngle += 360
    moveAngle = moveAngle.truncatingRemainder(dividingBy: 360)
    
    
    
    var slope = tan(moveAngle * 3.14/180)
    
    var num = sqrt(pow (slope, 2) + 1)
    
    num = dist / num
    
    
    
    if moveAngle > 90 && moveAngle < 270{
        num *= -1
        
        //slope *= -1
    }
    num /= 40
    
    //num *= -1
    var newPos = CGPoint (x: CGFloat(playerGamePosition[0]) + slope * num, y: CGFloat(playerGamePosition[1]) + num)
    //var newPos = CGPoint (x: player.position.x + slope * num, y: player.position.y + num)
    var tempX = Int(newPos.x)
    
    var tempY = Int(newPos.y)
    
    //if dis < 0.2
    if newPos.x >= 0 && newPos.x < CGFloat(map[0][0].count) && newPos.y >= 0 && newPos.y < CGFloat(map[0].count){
        if checkSpot(map: map, place: [tempX, tempY, Int(playerGamePosition[2]) - height], height: height){
            //if map[Int(playerGamePosition[2])][tempY][tempX] == nil && map[Int(playerGamePosition[2] - 1)][tempY][tempX] == nil{
            player.position = CGPoint(x: newPos.x * 40, y: newPos.y * 40)
            playerGamePosition[0] = Float(newPos.x)
            playerGamePosition[1] = Float(newPos.y)
            
        } else {
            if checkSpot(map: map, place: [tempX, Int(playerGamePosition[1]), Int(playerGamePosition[2]) - height], height: height){
            //if map[Int(playerGamePosition[2])][tempY][Int(playerGamePosition[0])] == nil && map[Int(playerGamePosition[2] - 1)][Int(playerGamePosition[0])] == nil{
                player.position.x = newPos.x * 40
                playerGamePosition[0] = Float(newPos.x)
                
            } else if checkSpot(map: map, place: [Int(playerGamePosition[0]), tempY, Int(playerGamePosition[2]) - height], height: height){
                
                //player.position.y = point.y * 40
                player.position.y = newPos.y * 40
                //player.position.x = point.x * 40
                playerGamePosition[1] = Float(newPos.y)
                
                
            }
               /*
            } else if map[Int(playerGamePosition[2])][Int(playerGamePosition[1])][tempX] == nil && map[Int(playerGamePosition[2] - 1)][Int(playerGamePosition[1])][tempX] == nil{
                
                //player.position.y = point.y * 40
                player.position.x = newPos.x * 40
                playerGamePosition[0] = Float(newPos.x)
                
                
            }*/
        
        
        }
    }
    /*
    if tempX >= 0 && tempX < 8 && tempY >= 0 && tempY < 8 && {
        
    } else {
        player.position = newPos
    }
    */
    
    
    //playerGamePosition = CGPoint(x: player.position.x/40, y: player.position.y/40)
    
    
    /*
    player.position.x += slope * num
    player.position.y += num
    */

    
    
    
    //roatation of everything
    
    
    
    
    lastCalledMoveTime = time
    
    
}



func checkPointsX (map: [[[(Int, Int, Int)?]]], startPos: [Float], distance: CGFloat, slope: Double, co: Float,  dir: Bool) -> (Bool, CGPoint, Float, (Int, Int, Int)?){

    var dof = 0
    
    
    let aTan = Float(-1*slope)
    //let co = tan(Float(angleZ * 3.14)/180)
    
    
    
    var rx = Float(floor (startPos[0])) //idk if should be startPos.y * 64 /64 or what
    
    if dir {rx += 1}
    
    let ryChange = startPos[0] - rx
    
    var ry = ryChange * aTan + startPos[1]
    
    var xo = Float(-1.0)
    if dir {xo = Float(1.0)}
    let yo = -xo * Float(aTan)
    
    
    //var zo = sqrt(Float(xo * xo) + yo * yo)
    var zo = sqrt (1 + aTan * aTan)
    zo = zo * co
    
    /*
    var rz = sqrt((aTan * aTan + 1) * ryChange * ryChange)
    rz = Float(Float(rz) * co + startPos[2])
    */
    var rz = zo * abs(ryChange) + startPos[2]
    var mx = Int()
    var my = Int()
    var mz = Int()
    while (dof < 200) {
        mx = Int(rx) //idk if /64 or * 64
        my = Int(ry)
        mz = Int(rz)
        if !dir {
            mx += Int(xo)
        }
            
        
        if mz < 0 || mz >= map.count || mx < 0 || mx >= map[0][0].count || my < 0 || my >= map[0].count {
            return (false, CGPoint(x: 0, y: 0), 10000.0, nil)
        }
        
        if map[mz][my][mx] != nil {
        
            var dis = pow((rx - startPos[0]), 2)
            dis += pow((ry - startPos[1]), 2)
            dis += pow((rz - startPos[2]),2)
            dis = sqrt(dis)
            //return (true, CGPoint(x: mx, y: my), dis, (255, 255, 0))
            return (true, CGPoint(x: mx, y: my), dis, map[mz][my][mx])
        }
        rx += xo
        ry += yo
        rz += zo
        dof += 1
       
        
    }
    
    
    
    return (false, CGPoint(x: 0, y: 0), 1000.0, nil)
    
}
func checkPointsY (map: [[[(Int, Int, Int)?]]], startPos: [Float], distance: CGFloat, slope: Double, co: Float, dir: Bool) -> (Bool, CGPoint, Float, (Int, Int, Int)?){
    
    
    
    
    var dof = 0
    
    
    let aTan = Float(-1/slope)
    //let co = tan(Float(angleZ * 3.14)/180)
    
    
    var ry = Float ()
    if dir {
        ry = Float(ceil (startPos[1]))
    } else {
        ry = Float(floor(startPos[1]))
    }
    //var ry = dir ? Float(ceil (startPos[1])): Float(floor(startPos[1])) //idk if should be startPos.y * 64 /64 or what
    
    //if dir {ry += 1}
    
    
    var ryChange = startPos[1]-ry
    
    var rx = (ryChange * aTan)
    rx += startPos[0]

    //var rz = (startPos.y - ry) * (startPos.y - ry) + (startPos.y - ry) * aTan * (startPos.y - ry) * aTan
    
    
    var zo = sqrt(1 + aTan * aTan)
    zo = zo * co
    var rz = zo * abs(ryChange) + Float(startPos[2])
    
    
    
    var yo = -1.0
    if dir {yo = 1.0}
    
    let xo = Float(-yo) * Float(aTan)
    
    
    var mx = Int()
    var my = Int()
    var mz = Int()
    while (dof < 200) {
        mx = Int(rx) //idk if /64 or * 64
        my = Int(ry)
        mz = Int (rz)
        if !dir {
            
            my += Int(yo)
            
        }
            
        
        if mz < 0 || mz >= map.count || mx < 0 || mx >= map[0][0].count || my < 0 || my >= map[0].count {
            return (false, CGPoint(x: 0, y: 0), 10000.0, nil)
        }
        
        if map[mz][my][mx] != nil {
            var dis = pow((rx - startPos[0]), 2)
            dis += pow((ry - startPos[1]), 2)
            dis += pow((rz - startPos[2]),2)
            dis = sqrt(dis)
            //return (true, CGPoint(x: mx, y: my), dis, (0, 255, 255))
            return (true, CGPoint(x: mx, y: my), dis, map[mz][my][mx])
        }
        rx += xo
        ry += Float(yo)
        rz += Float(zo)
        dof += 1
        
        
    }
    return (false, CGPoint(x: 0, y: 0), 1000.0, nil)

    
    
    //return CGPoint (x:rx,y:ry)
    
    
}




func checkPointsZ (map: [[[(Int, Int, Int)?]]], startPos: [Float], angle: Double, angleZ: Double, dir: Bool) -> (Bool, CGPoint, Float, (Int, Int, Int)?) {
    // Handle cases where angleZ is parallel to the ground
    if angleZ == 0 || angleZ == 180 {
        return (false, CGPoint(x:0, y:0), 10000.0, nil)
    }
    
    
    // Determine if we're looking up or down
    let angleZDir = (angleZ > 0 && angleZ < 180) // true if looking up
    
    
    
    var rz = Float(startPos[2])
    
    if angleZDir {
        rz = Float(floor(rz) + 1)  // Looking up - next Z cell above
    } else {
        rz = Float(ceil(rz) - 1)   // Looking down - next Z cell below
    }
    
    
    // Calculate the distance to next Z boundary
    let disZ = angleZDir ? rz - startPos[2] : startPos[2] - rz
    
    // Calculate the corresponding X and Y steps
    let angleRadian = Float(angle * 3.14 / 180)
    
    //let slopeXY = Float(tan(angleRadian))
    let slopeZ = Float(tan(angleZ * .pi / 180.0))
    
    // Calculate how much X and Y change per Z unit
    let stepScale = disZ / abs(slopeZ)
    
    let stepX = Float(cos(angleRadian) * stepScale)
    let stepY = Float(sin(angleRadian) * stepScale)
    
    // Starting position
    var rx = Float(startPos[0]) + stepX
    var ry = Float(startPos[1]) + stepY
    
    let zStep = angleZDir ? Float(1.0) : Float(-1.0)
    let xStep = stepX / disZ
    let yStep = stepY / disZ
   
    while true {
        let my = Int(ry)
        let mx = Int(rx)
    
        var mz = Int(rz)
        
        if !angleZDir {
            mz += Int(zStep)
        }
        
        
        
        
        
        // Check bounds
        if mz < 0 || mz >= map.count || mx < 0 || mx >= map[0][0].count || my < 0 || my >= map[0].count {
            return (false, CGPoint(x: 0, y: 0), 10000.0, nil)
        }
        
        // Check if we hit a wall
        if map[mz][my][mx] != nil {
            var dis = pow((rx - startPos[0]), 2)
            dis += pow((ry - startPos[1]), 2)
            dis += pow((rz - startPos[2]),2)
            dis = sqrt(dis)
            //return (true, CGPoint(x: mx, y: my), dis, (0, 0, 0))
            return (true, CGPoint(x: mx, y: my), dis, map[mz][my][mx])
        }
        
        // Move to next Z boundary
        rz += zStep
        rx += xStep
        ry += yStep
    }
    
    return (false, CGPoint(x: 0, y: 0), 1000.0, nil)
}


func singleRayMath (map: [[[(Int, Int, Int)?]]], angle: CGFloat, slope: CGFloat, angleZ: CGFloat, slopeZ: Float, playerPosInGame: [Float]) -> ((Int, Int, Int)?, CGPoint, Float){
    
    
    
    //slope = tan(angle)
    
    var dir = Bool()
    //if angle < 90 || angle > 270 {dir  =  true} else {dir = false}
    dir = angle < 90 || angle > 270 ? true:  false
    
    
                    
    //dir sohould be up = 0, down = 1, left = 2, right = 3
    //
    //var points = [CGPoint (x:0, y:0)]
    
    let (boolLR, pointLR, pointDisLR, colorLR) = checkPointsX(map: map, startPos: playerPosInGame, distance: 0.5, slope: slope, co: slopeZ, dir: dir)
    let (boolFB, pointFB, pointDisFB, colorFB) = checkPointsZ(map: map, startPos: playerPosInGame, angle: angle, angleZ: angleZ, dir: dir)
    //var boolLR = false
        //points.append(point)
    
    
    
    
    dir = angle < 180 && angle > 0 ? true : false
    
    
    let (boolUD, pointUD, pointDisUD, colorUD) = checkPointsY(map: map, startPos: playerPosInGame, distance: 0.5, slope: slope, co: slopeZ, dir: dir)
    //boolUD = false
    //return boolFB
    
    if boolLR || boolUD || boolFB{
        var min = min(pointDisLR, pointDisFB, pointDisUD)
        
        if min == pointDisLR {
            
            return (colorLR, pointLR, pointDisLR)
        } else if min == pointDisUD {
            return (colorUD, pointUD, pointDisUD)
        } else if min == pointDisFB{
            return (colorFB, pointFB, pointDisFB)
        }
        
        return (nil, pointFB, min)}
    else {
            return (nil, pointFB, 0)}
    
    
}

func rayCastMath (map:[[[(Int, Int, Int)?]]]) -> ([[(Int, Int, Int)?]], [CGPoint], [[Float]]){


    
    
    var colors = [[(Int, Int, Int)?]]()  // Start with empty array
    var debugPoints = [CGPoint]()  // Renamed for clarity (instead of "lines")
    var distances = [[Float]]()
    //points = [CGPoint(x: 0, y:0)]
    
    for z in stride (from: -60, through: 60, by: 2){
        colors.append([(Int, Int, Int)?]())
        distances.append([Float]())
        
        //temp = 0
        var tempAngleZ = playerAngleZ + Double(z)
        var upsideDown = false
        if (tempAngleZ > 90 && tempAngleZ < 270) || (tempAngleZ < -90 && tempAngleZ > -270) {
            
            tempAngleZ = tempAngleZ > 0 ? 180 - tempAngleZ : 0 - tempAngleZ
            //upsideDown = true
        }
        for i in stride(from: 30, through: -30, by: -1) {
            var rayAngle = (playerAngle + CGFloat(i))
            
            
            
            //rayAngle = (playerAngle + CGFloat(i))
            if upsideDown {
                rayAngle += 180
                
                
            }
            
            rayAngle = rayAngle.truncatingRemainder(dividingBy: 360)
            
            var temp = tan(Double(tempAngleZ*3.14/180.0))
            temp *= cos (Double(i)*3.14/180)
            temp = atan(temp)*180/3.14
            
           
            
            
            let (ans, ans2, disAns) = singleRayMath(map: map, angle: rayAngle, slope: tan(rayAngle * 3.14 / 180), angleZ: temp, slopeZ: Float(tan(temp*3.14/180)), playerPosInGame: playerGamePosition)
            colors[colors.count-1].append(ans)
            distances[distances.count-1].append(disAns)
            
            debugPoints.append(ans2)
            
            
        }
    }
    return (colors, debugPoints, distances)
    
}




#Preview {
    ContentView()
}












