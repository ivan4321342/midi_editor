//
//  savefile.swift
//  editor
//
//  Created by Иван on 17.04.2024.
//

import AVFoundation
import AppKit


func save(seq: MusicSequence, fileURL: URL) {
    
    print("saving dir:", fileURL)
    var status = MusicSequenceFileCreate(seq, fileURL as CFURL, .midiType, .eraseFile, 0)
    
    if(status != noErr){
        print("Error while saving midi file:", status);
        status = 0;
    }
}
func load(seq: MusicSequence,  fileURL: URL) -> OSStatus {
    print("opening dir:", fileURL)
    
    var status = MusicSequenceFileLoad(seq, fileURL as CFURL, .midiType, MusicSequenceLoadFlags.smf_ChannelsToTracks);
    if(status != noErr){
        print("Error while loading midi file:", status);
        status = 0;
    }
    return status
}

func showSavePanel() -> URL? {
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.midi]
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        savePanel.title = "Сохранить в MIDI файл"
        savePanel.message = "Выберите директорию и имя файла."
        savePanel.nameFieldLabel = "Имя файла:"

      let response = savePanel.runModal()
    return response == .OK ? savePanel.url : nil

    }
