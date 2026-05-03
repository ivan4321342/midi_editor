//
//  MenuView.swift
//  editor
//
//  Created by Иван on 19.05.2024.
//

import AVFoundation
import SwiftUI


enum Durations: String, CaseIterable, Identifiable {
    case whole, half, quater
    var id: Self { self }
}



struct MenuView: View {
    
    @State var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()

    @State var nowPlaying = false
    @State var elapsedTime: Double = 0.0
    @State var numoftacts = 5

    @Binding var points: [Point]
    @State var openFile = false
    @State private var duration: Durations = .quater

    let player = MidiPlayer()

    
    var body: some View {

        @State var fileName = "no file chosen"
 
            VStack{
                HStack{
                    
                    Spacer()
                }
                Spacer()
            
                keyboardview(points: $points, duration: $duration, seconds: $elapsedTime, numoftacts: $numoftacts)//.foregroundStyle(.gray)
        }
            .toolbar {
                ToolbarItemGroup(placement: .navigation) {
                    
                    Button(action: {
                        if !nowPlaying {
                            player.prepareSong(song: song)
                            elapsedTime = 0
                            
                            nowPlaying = true
                            timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
                                                        
                            Task {
                                
                                await player.playSong()
                                elapsedTime = 0
                                nowPlaying = false
                            }
                           // nowPlaying = false
                        }
                    }, label: {
                        Image(systemName: "play.circle.fill")
                    }) .disabled(nowPlaying)
                    
                    .onReceive(timer) { date in
                        if nowPlaying {
                            elapsedTime += 0.01
                        }
                        
                    }
                
                    
                    Button(action: {x
                        timer.upstream.connect().cancel()
                        elapsedTime = 0
                        nowPlaying = false
                        player.stopPlay()
                    }, label: {
                        Image(systemName: "stop.circle.fill")
                        
                    }).disabled(!nowPlaying)
                    
                    Button("Очистить запись", action: {
                        points.removeAll()
                        song.tracks.removeAll()
                        NewMusicSequence(&song.musicSequence)
                        song.addTrack(instrumentId: 0)
                        song.setTempo(tempo: 240)
                        
                    })
                    
                    Button("Открыть пример", action: {
                        var composer = SongComposer()
                        composer.compose(song: song)
                        song.tracks.forEach() { track in
                            points += calcCoord(notes: getNotes(track.value))
                            print(calcCoord(notes: getNotes(track.value)))
                        }
                        
                    })
                
                    
                    
                    
                    
                    
                    Spacer()
                    Button("Открыть", action: {
                        openFile = true })
                    
                    .fileImporter(isPresented: $openFile, allowedContentTypes: [.midi], allowsMultipleSelection: false, onCompletion: {
                        (Result) in
                        
                        do {
                            
                            let fileURL = try Result.get()
                            print(fileURL)
                            fileName = fileURL.first?.lastPathComponent ?? "file not available"
                            
                            points.removeAll()
                            song.tracks.removeAll()
                            NewMusicSequence(&song.musicSequence)
            
                            load(seq: song.musicSequence!, fileURL: fileURL.first!)
                            retainTracks(song: song)
                            for track in song.tracks.values {
                                points+=calcCoord(notes: getNotes(track))
                            }
                            song.addTrack(instrumentId: 0)
                            song.setTempo(tempo: 240)
                            
                            
                        }
                        catch{
                            print("error reading file \(error.localizedDescription)")
                        }
                        
                    })
                    
                    Button("Сохранить...", action: {
                        print("save press")
                        
                        if let url = showSavePanel() {
                            save(seq: song.musicSequence!, fileURL: url);
                        }
                        
                    })
                }
                
                
                ToolbarItemGroup(placement: .accessoryBar(id: 1)) {
                    ToolbarStepper(variable: $numoftacts)
                    Picker("Ноты", selection: $duration) {
                            Text("1/2").tag(Durations.half)
                            Text("1/4").tag(Durations.quater)
                            Text("1").tag(Durations.whole)
                    }
                    .pickerStyle(.inline)
                  //  .pickerStyle(.segmented)
                }
                
            }
    }
    


    
    

}
