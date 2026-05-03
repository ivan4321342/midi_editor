//
//  keyboardview.swift
//  editor
//
//  Created by Иван on 03.04.2024.
//
import AudioToolbox
import SwiftUI

let wkeyh: CGFloat = 30
let bkeyh: CGFloat = 20 //4*3


func keyShape(_ color: Character) -> some View {
    if color == "w" {
        return RoundedRectangle(cornerRadius: 7)
            .fill(whitekeyColor(false))
        .frame(width: wkeyh*3, height: wkeyh) }
    else {
        return RoundedRectangle(cornerRadius: 7)
            .fill(blackkeyColor(false))
            .frame(width: bkeyh*2.5, height: bkeyh)
    }
}




struct keyboardview: View {
    
    @Binding var points: [Point]
    @Binding var duration: Durations
    @Binding var seconds: Double
    @Binding var numoftacts: Int
   
    
    var body: some View {
        
    
            ZStack{
                // Color("Background")
                
                
                
                ScrollView(.horizontal, content: {
                    ZStack{
                        Rectangle() .frame(width: CGFloat(numoftacts*4*100+100), height: 0)
                        
                        HStack{
                            VStack{
                                ForEach(1..<10) { index in
                                    Rectangle()
                                        .frame(width: CGFloat(numoftacts*4*100-3), height: 1)
                                        .offset(CGSize(width: 90, height: 21*Double(index)+39))
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                            }
                     
                            Spacer()
                        }
                        
                        VStack{
                            HStack{
                                
                                Rectangle()
                                    .frame(width: 2, height: 350)
                                    .offset(CGSize(width: 90+seconds/60*240*100, height: 0))
                                    .foregroundColor(seconds == 0 ? .gray : Color("playLine"))
                                
                                
                                ForEach(1 ..< numoftacts*4+1, id:\.self) { index in
                                    Rectangle()
                                        .frame(width: (index+4) % 4 == 0 ? 2 : 1, height: 350)
                                        .offset(CGSize(width: 91*Double(index)+80, height: 0))
                                        .foregroundColor(index+1 % 4 == 0 ? Color("TactLine") : Color("Line"))
                                }
                                Spacer()
                            }
                            Spacer()
                        }
                        PointRecorderView(duration: $duration, points: $points)
                    }
                })
                .scrollIndicators(.visible)

                keyLine()
                
            }
        }
    }


struct PointRecorderView: View {

    
    
    @Binding var duration: Durations
    @Binding var points: [Point]
    @State private var width = 90.0
    @State var hoverLocation: CGPoint = CGPoint(x: 5000, y: 100)
    @State var isHovering: Bool = false
    
    var body: some View {
     
        GeometryReader { geometry in

            ZStack {
                
                
                RoundedRectangle(cornerRadius: 7)
                    .frame(width: durationNum(duration: duration)*90, height: 20)
                    .foregroundColor(.gray)
                    .position(CGPoint(x: 10+nearestCoord(point: hoverLocation).x+45*(durationNum(duration: duration)-1), y: nearestCoord(point: hoverLocation).y))
                
                
 
                ForEach(Array(points.enumerated()), id: \.element) { i, point in

                    RoundedRectangle(cornerRadius: 7)
                        .frame(width: point.dur*90, height: 20)
                        .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                        .position(CGPoint(x: 10+point.coord.x+45*(point.dur-1), y: point.coord.y))

                        .gesture(DragGesture()
//                        .onChanged({ ( value ) in
//                 
//                            var coord1 = nearestCoord(point: value.location).x
//                            var coord2 = point.coord.x+45*(point.dur-1)
//                            var adif = abs(coord1 - coord2)
//                        //width += value.translation.width
//                            var addduration = Double(Int(adif / 90 + 1))
//                            points[i].dur += addduration
//                            print(addduration)
//                    })
                          .onEnded({ ( value ) in

                              var coord1 = nearestCoord(point: value.location).x
                              var coord2 = point.coord.x+45*(point.dur-1)
                              var adif = abs(coord1 - coord2)
                              var xchange = value.translation.width
                              
                              var newduration = Double(Int(adif / 90 + 1))
                              points[i].dur = newduration

                              delNote(musictrack: song.tracks[0]!, timest: CoordToMidi(point: points[i].coord).timeStamp, pitch: CoordToMidi(point: points[i].coord).pitch )
                              
                              song.addNote(trackId: 0, note: CoordToMidi(point: points[i].coord).1, duration: Float(newduration), position: Float(CoordToMidi(point: points[i].coord).0))

                          }))
                }
            }
        }
        .onContinuousHover { phase in
            switch phase {
            case .active(let location):

                switch phase {
                    case .active(let location):
                        hoverLocation = location
                        isHovering = true
                    case .ended:
                        isHovering = false
                    
                }
                
            case .ended: hoverLocation = CGPoint(x: 10000, y: 1)
                
            }
        }
        .gesture(
            
            
            DragGesture(minimumDistance: 0)
                .onEnded { value in
                    if value.translation.width < 3 {
                        let coord = nearestCoord(point: value.startLocation)
                        var dur = durationNum(duration: duration)
                        
                        var contains = false
                        for point in points {
                            if point.coord == coord {
                                contains = true
                            }
                        }
                        
                        if contains {
                            var i = 0
                            
                            while i <= points.endIndex-1 {
                                print(points)
                                if (points[i].coord == coord) {
                                    self.points.remove(at: i)
                                }
                                i += 1
                            }
                            for track in 0...song.tracks.count-1 {
                                delNote(musictrack: song.tracks[track]!, timest: CoordToMidi(point: coord).timeStamp, pitch: CoordToMidi(point: coord).pitch)
                            }
                            
                            
                        } else {
                            print("dur: ",dur)
                            song.addNote(trackId: 0, note: CoordToMidi(point: coord).1, duration: Float(dur), position: Float(CoordToMidi(point: coord).0))
                            self.points.append(Point(coord: coord, dur: dur))
                        }
                    }
                }
                 )
    }
}

func calcCoord(notes: [MidiNote]) -> [Point] {
    var x,y,notedur: Double
    var res: [Point] = []
    
    for notee in notes {
        x = Double(120+notee.timeStamp * 100)
        y = Double(Double(midiToYCoord(key_num: Int(notee.note)))*15+30)
        notedur = Double(notee.duration)
        res.append(Point(coord: CGPoint(x: x, y: y), dur: notedur))
    }
    
    return res
}

func durationNum(duration: Durations) -> Double {
    var dur = 1.0
    
    switch duration {
    case .half:
        dur = 2
    case .whole:
        dur = 4
    case .quater:
        dur = 1
    default:
        dur = 1
    }
    
    return dur
}


extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        // combine the x-coordinate of the point with the hasher
        hasher.combine(x)
        // combine the y-coordinate of the point with the hasher
        hasher.combine(y)
    }
}


//#Preview {
//    keyboardview(points: points)
//}
