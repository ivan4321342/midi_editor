//
//  keyboardModel.swift
//  editor
//
//  Created by Иван on 07.04.2024.
//

import Foundation
import SwiftUI

    
func getkeyType(key_num: Int) -> Character {
         var keyType: Character
         var keyn: Int
         
         keyn = key_num % 7 + 1
         switch keyn {
         
         case 1,2,4,5,6:
             keyType = "b"
         case 3,7:
             keyType = "e" //empty
         default:
             fatalError("No such key!")
         }
        return keyType
    }

func midiToYCoord(key_num: Int) -> Int {
         var coord: Int
         coord = 65-key_num
         switch coord {
             case 1...5:
                 break
             case 6...12:
                 coord+=1
             case 13...17:
                coord+=2
             case 18...19:
                 coord+=3
             default:
                coord=0
                 
         }
        return coord
    }

func CoordToMidi(point:CGPoint) -> (timeStamp: Double, pitch: UInt8) { //[timestamp:pitch]
    var midi_num: Int = 0
    var xcoord = Int(point.x)
    var ycoord = Int(point.y)
    var ycoor: Int = Int(nearestCoord(point: CGPoint(x: 0, y: ycoord)).y - 30)/15
    

    switch ycoor {
        case 1...5:
            midi_num = 65-ycoor
        case 7...13:
            midi_num = 66-ycoor
        case 15...19:
             midi_num = 67-ycoor
        case 21...22:
             midi_num = 68-ycoor
         default:
            break
    }
    
    return ( Double((xcoord-120)/100), UInt8(midi_num) )
}
    
public func whitekeyColor(_ down: Bool) -> Color {
    down ? Color(red: 0.6, green: 0.6, blue: 0.6) : Color(red: 0.8, green: 0.8, blue: 0.8)
}
public func blackkeyColor(_ down: Bool) -> Color {
    down ? Color(red: 0.1, green: 0.1, blue: 0.1) : Color(red: 0.3, green: 0.3, blue: 0.3)
}
    
func nearestCoord(point: CGPoint) -> CGPoint {
    
    var coordsarray: [Int] = []
    var minrange: Int = Int.max
    var noteycoord: Int = Int(point.y)
    var noteynear = 10000
    var notexcoord: Int = (Int(point.x)-120+50)/100
    
    for everymidnote in 47...64 {
        coordsarray.append(midiToYCoord(key_num: everymidnote)*15+30)
    }
    coordsarray.forEach { everycoord in
        if abs(everycoord-noteycoord)<minrange {
            minrange = abs(everycoord-noteycoord)
            noteynear = everycoord
        }
    }
    print("coord-----",noteycoord)
    return CGPoint(x: 100*notexcoord+120, y: noteynear)
}

struct keyLine: View {
    
    var lines: some View {
        
        ZStack{
            ForEach(1..<11) { index in
                ZStack{
                    HStack {
                        keyShape("w")
                            .offset(CGSize(width: 0, height: wkeyh*Double(index)))
                        Spacer()
                    }
                    
                }
            }
            ForEach(0..<10) { index in
                if getkeyType(key_num: index) == "b" {
                    HStack {
                        keyShape("b")
                            .offset(CGSize(width: 0, height: wkeyh*Double(index+1)+15))
                        Spacer()
                    }
                }
            }
        }
    }
    
    var body: some View {
        GeometryReader{geometry in lines}
    }
    
}




#Preview {
    keyShape("w")
    
}
