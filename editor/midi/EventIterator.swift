

import AudioToolbox
import Foundation

struct EventInfo {
    let type: MusicEventType
    let timeStamp: MusicTimeStamp
    let data: UnsafeRawPointer?
    let dataSize: UInt32
    let note: MidiNote?
}

class MidiNote: Identifiable {
    
    private let regularTempoTimeStamp: MusicTimeStamp
    private let regularDuration: Float32
    
    public let timeStamp: MusicTimeStamp
    public let duration: Float32
    public let note: UInt8
    public let velocity: UInt8
    public let channel: UInt8
    public let releaseVelocity: UInt8

    public init(regularTimeStamp: MusicTimeStamp, regularDuration: Float32, note: UInt8, velocity: UInt8, channel: UInt8, releaseVelocity: UInt8 = 0) {
        //let timeStampInTicks = Milliseconds(regularTimeStamp).toTicks(andTicksPerBeat: ticksPerBeat)
        //let durationInTicks = Milliseconds(Double(regularDuration)).toTicks(andTicksPerBeat: ticksPerBeat)
        
        self.regularTempoTimeStamp = regularTimeStamp
        self.regularDuration = regularDuration
        
        self.timeStamp = regularTimeStamp
        self.duration = regularDuration
        self.note = note
        self.velocity = velocity
        self.channel = channel
        self.releaseVelocity = releaseVelocity
    }
    
}

extension MidiNote {

    func convert() -> MIDINoteMessage {
        return MIDINoteMessage(channel: channel, note: note, velocity: velocity, releaseVelocity: releaseVelocity, duration: duration)
    }

}

final class EventIterator {
    private let _iterator: MusicEventIterator
    
    init(track: MusicTrack) {
        var iterator: MusicEventIterator?
        check(NewMusicEventIterator(track, &iterator), label: "NewMusicEventIterator")
        
        guard let eventIterator = iterator else {
            fatalError("Ошибка инициализации MusicEventIterator")
        }
        _iterator = eventIterator
    }
    
    deinit {
        check(DisposeMusicEventIterator(_iterator),
              label: "DisposeMusicEventIterator")
    }
    
    var hasNextEvent: Bool {
        var hasNextEvent: DarwinBoolean = false
        check(MusicEventIteratorHasNextEvent(_iterator, &hasNextEvent),
              label: "MusicEventIteratorHasNextEvent")
        return hasNextEvent.boolValue
    }
    
    var hasCurrentEvent: Bool {
        var hasCurrentEvent: DarwinBoolean = false
        check(MusicEventIteratorHasCurrentEvent(_iterator, &hasCurrentEvent),
              label: "MusicEventIteratorHasCurrentEvent")
        return hasCurrentEvent.boolValue
    }
    
    func nextEvent() {
        check(MusicEventIteratorNextEvent(_iterator), label: "MusicEventIteratorNextEvent")
    }
    
    func previousEvent() {
        check(MusicEventIteratorPreviousEvent(_iterator), label: "MusicEventIteratorPreviousEvent")
    }
    
    
    var currentEvent: EventInfo? {
        var eventType: MusicEventType = 0
        var eventTimeStamp: MusicTimeStamp = -1
        var eventData: UnsafeRawPointer?
        var eventDataSize: UInt32 = 0
        var eventNote: MidiNote? = nil
        
        
        if MusicEventIteratorGetEventInfo(_iterator, &eventTimeStamp, &eventType, &eventData, &eventDataSize) != noErr {
            return nil
        }
        
        if eventType == kMusicEventType_MIDINoteMessage {
            let noteMessage = eventData!.load(as: MIDINoteMessage.self)
            eventNote = MidiNote(regularTimeStamp: eventTimeStamp,
                                regularDuration: noteMessage.duration,
                                note: noteMessage.note,
                                velocity: noteMessage.velocity,
                                channel: noteMessage.channel,
                                releaseVelocity: noteMessage.releaseVelocity)
            
        }
        
        

        return EventInfo(type: eventType, timeStamp: eventTimeStamp, data: eventData, dataSize: eventDataSize, note: eventNote)
    }
    
    func seek(in timestamp: MusicTimeStamp) {
        check(MusicEventIteratorSeek(_iterator, timestamp), label: "MusicEventIteratorSeek")
    }
    
   
    func enumerate(seekTime: MusicTimeStamp = 0, block: (_ info: EventInfo, _ finished: inout Bool, _ next: inout Bool) -> Void) {
        seek(in: seekTime)
        while hasCurrentEvent {
            var finished: Bool = false
            var next: Bool = true
            
            if let info = currentEvent {
                block(info, &finished, &next)
            }
            if finished || !hasNextEvent { break }
            if next {
                nextEvent()
            }
        }
    }
    
    func deleteEvent() {
        check(MusicEventIteratorDeleteEvent(_iterator), label: "MusicEventIteratorDeleteEvent")
    }
}

extension MIDINoteMessage: Equatable {
    public static func == (lhs: MIDINoteMessage, rhs: MIDINoteMessage) -> Bool {
        return lhs.channel == rhs.channel
            && lhs.duration == rhs.duration
            && lhs.note == rhs.note
            && lhs.releaseVelocity == rhs.releaseVelocity
            && lhs.velocity == rhs.velocity
    }
}
func retainTracks(song: Song) {
    //tempoTrack = MidiTempoTrack(musicTrack: sequence.tempoTrack)
    var tracks: [MusicTrack] = []
    var num_tracks: UInt32 = 0
    
    MusicSequenceGetTrackCount(song.musicSequence!, &num_tracks)
    
    for i in 0 ..< num_tracks {
        var musicTrack: MusicTrack?
        if MusicSequenceGetIndTrack(song.musicSequence!, i, &musicTrack) == noErr {
            let track = musicTrack
            song.addTrack(instrumentId: 0)
            let trackId = song.tracks.count
            song.tracks[trackId] = track
            
        }
    }
    
  
}


func getNotes(_ musictrack: MusicTrack) -> [MidiNote] {
    let iteratorObj = EventIterator(track: musictrack)
    var hasCurrentEvent: Bool
    hasCurrentEvent = iteratorObj.hasCurrentEvent
    var notesArray: [MidiNote] = []
    
    while (hasCurrentEvent) {

        print(iteratorObj.currentEvent)
        print(/n/)
        
        if iteratorObj.currentEvent?.note != nil {
            notesArray.append((iteratorObj.currentEvent?.note)!)
        }
        
        iteratorObj.nextEvent()
        hasCurrentEvent = iteratorObj.hasCurrentEvent
    }
    return notesArray
}



func delNote(musictrack: MusicTrack, timest: MusicTimeStamp, pitch: UInt8) {
    
        let iteratorObj = EventIterator(track: musictrack)
        var hasCurrentEvent: Bool
        hasCurrentEvent = iteratorObj.hasCurrentEvent
      
        
        while (hasCurrentEvent) {

            print(iteratorObj.currentEvent?.note ?? "no note")
            print(/n/)
            
            if iteratorObj.currentEvent?.note != nil {
                if iteratorObj.currentEvent?.note?.note == pitch &&
                    iteratorObj.currentEvent?.note?.timeStamp == timest {
                    iteratorObj.deleteEvent()
                }
            }
            
            iteratorObj.nextEvent()
            hasCurrentEvent = iteratorObj.hasCurrentEvent
        }
       
    
    
}


func check(_ status: OSStatus, label: String) {
    if status != noErr {
        let str = "\(label) error: \(status)"
        print(str)
    }

}
