

import Foundation


class SongComposer {
    func compose(song: Song) -> Song {
        
        let trackId = 0
        song.setTempo(tempo: 240)
        var currentPosition: Float = 0
        for _ in 0...1 {
            song.addNote(trackId: trackId, note: 64,
                      duration: 1.0, position: currentPosition)
            currentPosition += 1.0
            song.addNote(trackId: trackId, note: 63,
                      duration: 1.0, position: currentPosition)
            currentPosition += 1.0
        }
        song.addNote(trackId: trackId, note: 64,
                  duration: 1.0, position: currentPosition)
        currentPosition += 1.0
        song.addNote(trackId: trackId, note: 59,
                  duration: 1.0, position: currentPosition)
        currentPosition += 1.0
        song.addNote(trackId: trackId, note: 62,
                  duration: 1.0, position: currentPosition)
        currentPosition += 1.0
        song.addNote(trackId: trackId, note: 60,
                  duration: 1.0, position: currentPosition)
        currentPosition += 1.0
        
        song.addNote(trackId: trackId, note: 57, duration: 3.0, position:currentPosition)
        //song.addNote(trackId: trackId, note: 45, duration: 3.0, position:currentPosition)
        
        return song
    }
}
