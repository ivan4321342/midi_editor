//
//  unused.swift
//  editor
//
//  Created by Иван on 16.10.2024.
//


/*
 HStack{
/*     Button("\(Image(systemName: "play.circle.fill"))", action: {
         player.prepareSong(song: song)
         Task {
             await player.playSong()
             
         }
     })  */
     Button(action: {
         player.prepareSong(song: song)
         Task {
             await player.playSong()
             
         }
     }, label: {
         Image(systemName: "play.circle.fill")
     })
     //.buttonBorderShape(.roundedRectangle)
     
     .controlSize(.extraLarge)
     
     
     Button("\(Image(systemName: "pause.circle.fill"))", action: {
         player.stopPlay()
     })
     
     Button("Очистить запись", action: {
         points.removeAll()
         song.tracks.removeAll()
         NewMusicSequence(&song.musicSequence)
         song.addTrack(instrumentId: 0)
         
     })
     Button("Открыть пример", action: {
         var composer = SongComposer()
         composer.compose(song: song)
         song.tracks.forEach() { track in
             points += calcCoord(notes: getNotes(track.value))
             print(calcCoord(notes: getNotes(track.value)))
         }
         
     })
     
     
     
     Button("Открыть", action: {
         openFile = true })
     
     .fileImporter( isPresented: $openFile, allowedContentTypes: [.midi], allowsMultipleSelection: false, onCompletion: {
         (Result) in
         
         do{
            
             let fileURL = try Result.get()
             print(fileURL)
             fileName = fileURL.first?.lastPathComponent ?? "file not available"
             
             points.removeAll()
             
             
             load(seq: song.musicSequence!, fileURL: fileURL.first!)

             retainTracks(song: song)
             for track in song.tracks.values {
                 points+=calcCoord(notes: getNotes(track))
             }
             
            
         }
         catch{
            print("error reading file \(error.localizedDescription)")
         }
         
     })
     
     Button("Сохранить...", action: {
         if let url = showSavePanel() {
             save(seq: song.musicSequence!, fileURL: url);
         }

     })
     
     Spacer()
 }
 


 
 */
