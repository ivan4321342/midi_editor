//
//  ToolbarStepper.swift
//  editor
//
//  Created by Иван on 18.10.2024.
//

import SwiftUI

struct ToolbarStepper: View {
    @Binding var variable: Int
    var body: some View {
        //VStack{
            

            //HStack{
                Button("", systemImage: "plus", action: {variable+=1})
                
                    .controlSize(.mini)
        Button("", systemImage: "minus", action: {variable > 1 ? (variable -= 1) : (variable += 0) })
                    .controlSize(.mini)
         //   }
          //  .frame(width: 10, height: 10)
            Text("Тактов: \(variable)")
       // }
        
    }
}
