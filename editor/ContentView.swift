
import SwiftUI
import AVFoundation

let composer = SongComposer()
let song = Song()
//let st = load(seq: song.musicSequence!)
//let trackId = song.addTrack(instrumentId: 48)

struct Point: Hashable {
    var coord: CGPoint
    var dur: Double
}

struct ContentView: View {
    @State var points: [Point] = calcCoord(notes: getNotes(song.tracks[0]!))
    var body: some View {
        let player = MidiPlayer()
        
        VStack {
            MenuView(points: $points)
          //      .padding([.top,.leading])
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
