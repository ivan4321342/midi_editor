//
//  editorApp.swift
//  editor
//
//  Created by Иван on 04.02.2024.
//

import SwiftUI

@main
struct editorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView() .navigationTitle("")
             .frame(height: 420)
               // .fixedSize()

                
        }
            .windowResizability(.contentSize)
        
    }
}
