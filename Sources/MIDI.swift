//
//  MIDI.swift
//  Gong
//
//  Created by Daniel Clelland on 17/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import CoreMIDI

public protocol MIDIObserver: MIDIEventObserver, MIDIMessageObserver { }

public protocol MIDIEventObserver: class {
    
    func observe(_ event: MIDIEvent)
    
}

public protocol MIDIMessageObserver: class {
    
    func observe(_ message: MIDIMessage, from source: MIDIEndpoint<Source>)
    
}

public struct MIDI {
    
    public static var client: MIDIClient? = {
        do {
            return try MIDIClient(name: "Default client") { notification in
                process(notification)
            }
        } catch let error {
            print(error)
            return nil
        }
    }()
    
    public static var input: MIDIPort<Input>? = {
        do {
            return try client?.createInput(name: "Default input") { (message, source) in
                process(message, from: source)
            }
        } catch let error {
            print(error)
            return nil
        }
    }()
    
    public static var output: MIDIPort<Output>? = {
        do {
            return try client?.createOutput(name: "Default output")
        } catch let error {
            print(error)
            return nil
        }
    }()
    
    public static func connect() {
        for source in MIDIEndpoint<Source>.all {
            do {
                try input?.connect(source)
            } catch let error {
                print(error)
            }
        }
    }
    
    public static func disconnect() {
        for source in MIDIEndpoint<Source>.all {
            do {
                try input?.disconnect(source)
            } catch let error {
                print(error)
            }
        }
    }
    
    public static func addObserver(_ observer: MIDIObserver) {
        addEventObserver(observer)
        addMessageObserver(observer)
    }
    
    public static func removeObserver(_ observer: MIDIObserver) {
        removeEventObserver(observer)
        removeMessageObserver(observer)
    }
    
    private static var eventObservers = [MIDIEventObserver]()
    
    public static func addEventObserver(_ observer: MIDIEventObserver) {
        eventObservers.append(observer)
    }
    
    public static func removeEventObserver(_ observer: MIDIEventObserver) {
        eventObservers = eventObservers.filter { $0 !== observer }
    }
    
    private static func process(_ event: MIDIEvent) {
        do {
            switch event {
            case .objectAdded(_, let source as MIDIEndpoint<Source>):
                try input?.connect(source)
            case .objectRemoved(_, let source as MIDIEndpoint<Source>):
                try input?.disconnect(source)
            default:
                break
            }
        } catch let error {
            print(error)
        }
        
        for observer in eventObservers {
            observer.observe(event)
        }
    }
    
    private static var messageObservers = [MIDIMessageObserver]()
    
    public static func addMessageObserver(_ observer: MIDIMessageObserver) {
        messageObservers.append(observer)
    }
    
    public static func removeMessageObserver(_ observer: MIDIMessageObserver) {
        messageObservers = messageObservers.filter { $0 !== observer }
    }
    
    private static func process(_ message: MIDIMessage, from source: MIDIEndpoint<Source>) {
        for observer in messageObservers {
            observer.observe(message, from: source)
        }
    }

}

extension MIDIDevice {
    
    public func receive(_ message: MIDIMessage) {
        for entity in entities {
            entity.receive(message)
        }
    }
    
    public func send(_ message: MIDIMessage, via output: MIDIPort<Output>? = MIDI.output) {
        for entity in entities {
            entity.send(message, via: output)
        }
    }
    
}

extension MIDIEntity {
    
    public func receive(_ message: MIDIMessage) {
        for source in sources {
            source.receive(message)
        }
    }
    
    public func send(_ message: MIDIMessage, via output: MIDIPort<Output>? = MIDI.output) {
        for destination in destinations {
            destination.send(message, via: output)
        }
    }
    
}

extension MIDIEndpoint where Type == Source {
    
    public func receive(_ message: MIDIMessage) {
        do {
            try received(message)
        } catch let error {
            print(error)
        }
    }

}

extension MIDIEndpoint where Type == Destination {
    
    public func send(_ message: MIDIMessage, via output: MIDIPort<Output>? = MIDI.output) {
        guard let output = output else {
            return
        }
        
        do {
            try output.send(message, to: self)
        } catch let error {
            print(error)
        }
    }
    
}
