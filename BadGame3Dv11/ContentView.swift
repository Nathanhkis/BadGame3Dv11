//
//  ContentView.swift
//  Space invader
//
//  Created by Nathan zhong on 1/14/25.
//

import SwiftUI
import SwiftUI
import SpriteKit

struct ContentView: View {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var scene: SKScene{
        let scene = Gamescene()
        scene.size = CGSize(width:screenWidth, height: screenHeight)
        scene.scaleMode = .fill
        scene.backgroundColor = .white
        return scene
    }
    
    
    var body: some View {
        VStack {
            SpriteView(scene: scene)
                .frame (width: screenWidth, height: screenHeight)
                .edgesIgnoringSafeArea(.all)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}






