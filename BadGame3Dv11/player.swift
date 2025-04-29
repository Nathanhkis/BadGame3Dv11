
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
var lastCalledMoveTime = Double(0.00)

//var playerGamePosition = CGPoint(x: 0.0, y: 0.0)

var playerGamePosition: [Float16] = [1.0, 6.5, 2.0]
let height = 1






//var playerGamePositionZ = Float16(2.0)
var playerAngle = Float16(0.0)
var playerAngleZ = Float16(0.0)

var playerDZ = Float16(0.0)
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

func updateDZ (newPlayerDZTemp: Float16, map: [[[(Int, Int, Int)?]]]) -> Float16 {
    var newPlayerDZ = newPlayerDZTemp * Float16(1)
    /*
    if playerGamePosition[2] >= 0.0 {
        playerGamePosition[2] += Float16(newPlayerDZ)
        if playerGamePosition[2] < 2 {
            playerGamePosition[2] = 2.0
            return 0.0
        }
        return newPlayerDZ
    } else {
        return 0.0
    }*/
    if Int(playerGamePosition[2]+Float16(newPlayerDZ)) >= map.count || Int(playerGamePosition[2] + Float16(newPlayerDZ) - Float16(height)) < 0 {
        return 0.0
    }
    /*
    if map [Int(playerGamePosition[2]+Float16(newPlayerDZ))][Int(playerGamePosition[1])][Int(playerGamePosition[0])] == nil && map [Int(playerGamePosition[2]+Float16(newPlayerDZ) - 1)][Int(playerGamePosition[1])][Int(playerGamePosition[0])] == nil{
        playerGamePosition[2] += Float16(newPlayerDZ)
        return newPlayerDZ
    } else
    {return 0.0}*/
    if checkSpot(map: map, place: [Int(playerGamePosition[0]), Int(playerGamePosition[1]), Int(playerGamePosition[2] + Float16(newPlayerDZ)) - height], height: height){
        playerGamePosition[2] += Float16(newPlayerDZ)
        return newPlayerDZ - (0.2 * Float16(1))
    } else {return 0.0}
}
func checkSpot (map: [[[(Int, Int, Int)?]]], place: [Int], height: Int) -> Bool{
    for x in stride(from: 0, through: height, by: 1) {
        if map [place[2] + x][place[1]][place[0]] != nil {
            return false
        }
    }
    return true
}
func movePlayer(moveBy: CGVector, angle: Float16, angleZ: Float16, time: Double, map: [[[(Int, Int, Int)?]]]) {
    
    var amntMoved = Float(time - lastCalledMoveTime)
    amntMoved = amntMoved*100
    
    
    
    player.zRotation = CGFloat(angle)
    playerAngle = angle/3.14*180
    playerAngle += 90
    
    //playerAngleZ = moveBy
    if playerAngle >= 360 {
        playerAngle -= 360
    }
    
    playerAngleZ = angleZ / 3.14 * 180
    
    
    var dist = Float(abs(moveBy.dx) * 2) * amntMoved
    var moveAngle = Float16()
   
    
    moveAngle = 0
    
    
    //moveAngle = 0
    
    moveAngle -= angle * 180 / 3.14
    
    moveAngle += 360
    moveAngle = moveAngle.truncatingRemainder(dividingBy: 360)
    
    
    
    var slope = Float(tan(Double(moveAngle) * 3.14/180))
    
    var num = Float(sqrt(pow(Double(slope), 2) + 1))
    
    num = dist / num
    
    
    
    if moveAngle > 90 && moveAngle < 270{
        num *= -1
        
        //slope *= -1
    }
    num /= 40
    
    //num *= -1
    var newPos = CGPoint (x: Double(Float(playerGamePosition[0]) + slope * num), y: Double(Float(playerGamePosition[1]) + num))
    //var newPos = CGPoint (x: player.position.x + slope * num, y: player.position.y + num)
    var tempX = Int(newPos.x)
    
    var tempY = Int(newPos.y)
    
    //if dis < 0.2
    if newPos.x >= 0 && newPos.x < Double(map[0][0].count) && newPos.y >= 0 && newPos.y < Double(map[0].count) {
        
        if checkSpot(map: map, place: [tempX, tempY, Int(playerGamePosition[2]) - height], height: height){
            //if map[Int(playerGamePosition[2])][tempY][tempX] == nil && map[Int(playerGamePosition[2] - 1)][tempY][tempX] == nil{
            player.position = CGPoint(x: newPos.x * 40, y: newPos.y * 40)
            playerGamePosition[0] = Float16(newPos.x)
            playerGamePosition[1] = Float16(newPos.y)
            
        } else {
            if checkSpot(map: map, place: [tempX, Int(playerGamePosition[1]), Int(playerGamePosition[2]) - height], height: height){
            //if map[Int(playerGamePosition[2])][tempY][Int(playerGamePosition[0])] == nil && map[Int(playerGamePosition[2] - 1)][Int(playerGamePosition[0])] == nil{
                player.position.x = newPos.x * 40
                playerGamePosition[0] = Float16(newPos.x)
                
            } else if checkSpot(map: map, place: [Int(playerGamePosition[0]), tempY, Int(playerGamePosition[2]) - height], height: height){
                
                //player.position.y = point.y * 40
                player.position.y = newPos.y * 40
                //player.position.x = point.x * 40
                playerGamePosition[1] = Float16(newPos.y)
                
                
            }
               /*
            } else if map[Int(playerGamePosition[2])][Int(playerGamePosition[1])][tempX] == nil && map[Int(playerGamePosition[2] - 1)][Int(playerGamePosition[1])][tempX] == nil{
                
                //player.position.y = point.y * 40
                player.position.x = newPos.x * 40
                playerGamePosition[0] = Float16(newPos.x)
                
                
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



func checkPointsX (map: [[[(Int, Int, Int)?]]], startPos: [Float16], distance: Float16, slope: Float16, co: Float16,  dir: Bool) -> (Bool, CGPoint, Float16, (Int, Int, Int)?){

    var dof = 0
    
    
    var aTan = Float16(-1*slope)
    if aTan > 32766 {
        aTan = 32766
    } else if aTan < -32766 {
        aTan = -32766
    }
    //let co = tan(Float16(angleZ * 3.14)/180)
    
    
    
    var rx = Float16(floor (startPos[0])) //idk if should be startPos.y * 64 /64 or what
    
    if dir {rx += 1}
    
    let ryChange = startPos[0] - rx
    
    var ry = ryChange * aTan + startPos[1]
    
    var xo = Float16(-1.0)
    if dir {xo = Float16(1.0)}
    let yo = -xo * Float16(aTan)
    
    
    //var zo = sqrt(Float16(xo * xo) + yo * yo)
    //var num = Float(sqrt(1 + Double(aTan) * Double(aTan)))
    
    //var zo = Float16(num * Float(co))
    /*
    var num = sqrt(1 + Float(aTan) * Float(aTan))
    var zo = Float(num)
    zo *= Float(co)*/
    var zo = Float(Int(sqrt(1 + Float(aTan) * Float(aTan))*1000)/1000) * Float(co)
    
    /*
    var rz = sqrt((aTan * aTan + 1) * ryChange * ryChange)
    rz = Float16(Float16(rz) * co + startPos[2])
     
    */
    var rz = zo * Float(abs(ryChange)) + Float(startPos[2])
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
        
            var dis = pow(Float(rx - startPos[0]), 2)
            dis += pow(Float(ry - startPos[1]), 2)
            dis += pow(rz - Float(startPos[2]),2)
            dis = sqrt(dis)
            //return (true, CGPoint(x: mx, y: my), dis, (255, 255, 0))
            return (true, CGPoint(x: mx, y: my), Float16(dis), map[mz][my][mx])
        }
        rx += xo
        ry += yo
        rz += zo
        dof += 1
       
        
    }
    
    
    
    return (false, CGPoint(x: 0, y: 0), 1000.0, nil)
    
}
func checkPointsY (map: [[[(Int, Int, Int)?]]], startPos: [Float16], distance: Float16, slope: Float16, co: Float16, dir: Bool) -> (Bool, CGPoint, Float16, (Int, Int, Int)?){
    
    if slope == 0{
        return (false, CGPoint(x: 0, y: 0), 10000.0, nil)
    }
    
    
    var dof = 0
    
    
    var aTan = Float16(-1/slope)
    if aTan > 32766 {
        aTan = 32766
    } else if aTan < -32766 {
        aTan = -32766
    }
    //let co = tan(Float16(angleZ * 3.14)/180)
    
    
    var ry = Float16 ()
    if dir {
        ry = Float16(ceil (startPos[1]))
    } else {
        ry = Float16(floor(startPos[1]))
    }
    //var ry = dir ? Float16(ceil (startPos[1])): Float16(floor(startPos[1])) //idk if should be startPos.y * 64 /64 or what
    
    //if dir {ry += 1}
    
    
    var ryChange = startPos[1]-ry
    
    var rx = (ryChange * aTan)
    rx += startPos[0]

    //var rz = (startPos.y - ry) * (startPos.y - ry) + (startPos.y - ry) * aTan * (startPos.y - ry) * aTan
    
    //var num = Float(Int(sqrt(1 + Double(aTan) * Double(aTan))*1000)/1000)
    //var zo = Float16(num * Float(co))
    var zo = Float(Int(sqrt(1 + Float(aTan) * Float(aTan))*1000)/1000) * Float(co)
    
    var rz = zo * Float(abs(ryChange)) + Float(startPos[2])
    
    
    
    var yo = -1.0
    if dir {yo = 1.0}
    
    let xo = Float16(-yo) * Float16(aTan)
    
    
    var mx = Int()
    var my = Int()
    var mz = Int()
    while (dof < 200) {
        mx = Int(rx) //idk if /64 or * 64
        my = Int(ry)
        mz = Int(rz)
        if !dir {
            
            my += Int(yo)
            
        }
            
        
        if mz < 0 || mz >= map.count || mx < 0 || mx >= map[0][0].count || my < 0 || my >= map[0].count {
            return (false, CGPoint(x: 0, y: 0), 10000.0, nil)
        }
        
        if map[mz][my][mx] != nil {
            var dis = pow(Float(rx - startPos[0]), 2)
            dis += pow(Float(ry - startPos[1]), 2)
            dis += pow(rz - Float(startPos[2]),2)
            dis = sqrt(dis)
            //return (true, CGPoint(x: mx, y: my), dis, (0, 255, 255))
            return (true, CGPoint(x: mx, y: my), Float16(dis), map[mz][my][mx])
        }
        rx += xo
        ry += Float16(yo)
        rz += Float(zo)
        dof += 1
        
        
    }
    return (false, CGPoint(x: 0, y: 0), 1000.0, nil)

    
    
    //return CGPoint (x:rx,y:ry)
    
    
}




func checkPointsZ (map: [[[(Int, Int, Int)?]]], startPos: [Float16], angle: Float16, angleZ: Float16, dir: Bool) -> (Bool, CGPoint, Float16, (Int, Int, Int)?) {
    // Handle cases where angleZ is parallel to the ground
    if angleZ == 0 || angleZ == 180 {
        return (false, CGPoint(x:0, y:0), 10000.0, nil)
    }
    
    
    // Determine if we're looking up or down
    let angleZDir = (angleZ > 0 && angleZ < 180) // true if looking up
    
    
    
    var rz = Float16(startPos[2])
    
    if angleZDir {
        rz = Float16(floor(rz) + 1)  // Looking up - next Z cell above
    } else {
        rz = Float16(ceil(rz) - 1)   // Looking down - next Z cell below
    }
    
    
    // Calculate the distance to next Z boundary
    let disZ = angleZDir ? rz - startPos[2] : startPos[2] - rz
    
    // Calculate the corresponding X and Y steps
    let angleRadian = Float16(angle * 3.14 / 180)
    
    //let slopeXY = Float16(tan(angleRadian))
    let slopeZ = Float16(tan(Double(angleZ) * 3.14 / 180.0))
    
    // Calculate how much X and Y change per Z unit
    let stepScale = Float16(disZ / abs(slopeZ))
    
    let stepX = Float16(Float16(cos(Double(angleRadian))) * stepScale)
    let stepY = Float16(Float16(sin(Double(angleRadian))) * stepScale)
    
    // Starting position
    var rx = Float16(startPos[0]) + stepX
    var ry = Float16(startPos[1]) + stepY
    
    let zStep = angleZDir ? Float16(1.0) : Float16(-1.0)
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
            var dis = pow(Float(rx - startPos[0]), 2)
            dis += pow(Float(ry - startPos[1]), 2)
            dis += pow(Float(rz - startPos[2]),2)
            dis = sqrt(dis)
            //return (true, CGPoint(x: mx, y: my), dis, (0, 0, 0))
            return (true, CGPoint(x: mx, y: my), Float16(dis), map[mz][my][mx])
        }
        
        // Move to next Z boundary
        rz += zStep
        rx += xStep
        ry += yStep
    }
    
    return (false, CGPoint(x: 0, y: 0), 1000.0, nil)
}


func singleRayMath (map: [[[(Int, Int, Int)?]]], angle: Float16, slope: Float16, angleZ: Float16, slopeZ: Float16, playerPosInGame: [Float16]) -> ((Int, Int, Int)?, CGPoint, Float16){
    
    
    
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

func rayCastMath (map:[[[(Int, Int, Int)?]]]) -> ([[(Int, Int, Int)?]], [CGPoint], [[Float16]]){


    
    
    var colors = [[(Int, Int, Int)?]]()  // Start with empty array
    var debugPoints = [CGPoint]()  // Renamed for clarity (instead of "lines")
    var distances = [[Float16]]()
    //points = [CGPoint(x: 0, y:0)]
    
    for z in stride (from: -60, through: 60, by: 2){
        colors.append([(Int, Int, Int)?]())
        distances.append([Float16]())
        
        //temp = 0
        var tempAngleZ = playerAngleZ + Float16(z)
        var upsideDown = false
        if (tempAngleZ > 90 && tempAngleZ < 270) || (tempAngleZ < -90 && tempAngleZ > -270) {
            
            tempAngleZ = tempAngleZ > 0 ? 180 - tempAngleZ : 0 - tempAngleZ
            //upsideDown = true
        }
        for i in stride(from: 30, through: -30, by: -1) {
            var rayAngle = Float16(playerAngle + Float16(i))
            
            
            
            //rayAngle = (playerAngle + Float16(i))
            if upsideDown {
                rayAngle += 180
                
                
            }
            
            rayAngle = rayAngle.truncatingRemainder(dividingBy: 360)
            
            var temp = tan(Double(tempAngleZ*3.14/180.0))
            temp *= cos (Double(i)*3.14/180)
            temp = atan(temp)*180/3.14
            
           
            
            
            let (ans, ans2, disAns) = singleRayMath(map: map, angle: rayAngle, slope: Float16(tan(Double(rayAngle) * 3.14 / 180)), angleZ: Float16(temp), slopeZ: Float16(tan(temp*3.14/180)), playerPosInGame: playerGamePosition)
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













