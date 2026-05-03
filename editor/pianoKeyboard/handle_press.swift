//
//  Untitled.swift
//  editor
//
//  Created by Иван on 22.09.2024.
//

func handle_press(<#parameters#>) -> <#return type#> {
    let coord = nearestCoord(point: value.startLocation)
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
    
    if (self.points.contains(point(coord: coord, dur: 1.0)) || self.points.contains(point(coord: coord, dur: 2.0)) || self.points.contains(point(coord: coord, dur: 4.0)) ) {
        var i = 0
        
        while i <= points.endIndex-1 {
            print(points)
            if (points[i].coord == coord) {
                self.points.remove(at: i)
            }
            i += 1
        }
        delNote(musictrack: song.tracks[0]!, timest: CoordToMidi(point: coord).timeStamp, pitch: CoordToMidi(point: coord).pitch )
        
    } else {
        print("dur: ",dur)
        song.addNote(trackId: 0, note: CoordToMidi(point: coord).1, duration: Float(dur), position: Float(CoordToMidi(point: coord).0))
        self.points.append(point(coord: coord, dur: dur))
    }
}
