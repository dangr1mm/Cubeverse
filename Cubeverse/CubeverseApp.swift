//
//  CubeverseApp.swift
//  Cubeverse
//
//  Created by Dan Grimm on 19/07/22.
//

import SwiftUI
import Firebase

@main
struct CubeverseApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            AuthView()
        }
    }
}
