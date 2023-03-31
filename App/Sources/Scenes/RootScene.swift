//
//  RootScene.swift
//  BasicApp
//
//  Created by Morisson Marcel Ferreira Maciel on 31/03/23.
//

import SwiftUI

struct RootScene: View {
    var body: some View {
        VStack {
            Image("swiftui_icon")
            
            Text("Hello, World!")
                .font(.title)
            
            Text("This is your first basic iOS app with Swift UI")
        }
    }
}

struct RootScene_Previews: PreviewProvider {
    static var previews: some View {
        RootScene()
    }
}
