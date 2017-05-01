//
//  AudioError.swift
//  Gong
//
//  Created by Daniel Clelland on 29/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import AudioToolbox

public struct AudioError: Error {
    
    public enum Message {
        
        public enum AudioGraph {
            
            case nodeNotFound

            case invalidConnection

            case outputNodeError

            case cannotDoInCurrentContext

            case invalidAudioUnit

        }
        
        case audioGraph(AudioGraph)
        
        public enum AudioUnit {

            case invalidProperty

            case invalidParameter

            case invalidElement

            case noConnection

            case failedInitialization

            case tooManyFramesToProcess

            case invalidFile

            case unknownFileType

            case fileNotSpecified

            case formatNotSupported

            case uninitialized

            case invalidScope

            case propertyNotWritable

            case cannotDoInCurrentContext

            case invalidPropertyValue

            case propertyNotInUse

            case initialized

            case invalidOfflineRender

            case unauthorized

            case audioComponentInstanceInvalidated

            case renderTimeout

        }

        case audioUnit(AudioUnit)

        public enum AudioFile {

            case unspecified

            case unsupportedFileType

            case unsupportedDataFormat

            case unsupportedProperty

            case badPropertySize

            case permissions

            case notOptimized

            case invalidChunk

            case doesNotAllow64BitDataSize

            case invalidPacketOffset

            case invalidFile

            case operationNotSupported

            case notOpen

            case endOfFile

            case position

            case fileNotFound

        }

        case audioFile(AudioFile)
        
        case unknown(status: OSStatus)
        
    }
    
    public let message: Message
    
    public let comment: String
    
    public init(_ message: Message, comment: String) {
        self.message = message
        self.comment = comment
    }
    
}

extension AudioError {
    
    public init(status: OSStatus, comment: String) {
        switch status {
        case kAUGraphErr_NodeNotFound:
            self.init(.audioGraph(.nodeNotFound), comment: comment)
        case kAUGraphErr_InvalidConnection:
            self.init(.audioGraph(.invalidConnection), comment: comment)
        case kAUGraphErr_OutputNodeErr:
            self.init(.audioGraph(.outputNodeError), comment: comment)
        case kAUGraphErr_CannotDoInCurrentContext:
            self.init(.audioGraph(.cannotDoInCurrentContext), comment: comment)
        case kAUGraphErr_InvalidAudioUnit:
            self.init(.audioGraph(.invalidAudioUnit), comment: comment)
        case kAudioUnitErr_InvalidProperty:
            self.init(.audioUnit(.invalidProperty), comment: comment)
        case kAudioUnitErr_InvalidParameter:
            self.init(.audioUnit(.invalidParameter), comment: comment)
        case kAudioUnitErr_InvalidElement:
            self.init(.audioUnit(.invalidElement), comment: comment)
        case kAudioUnitErr_NoConnection:
            self.init(.audioUnit(.noConnection), comment: comment)
        case kAudioUnitErr_FailedInitialization:
            self.init(.audioUnit(.failedInitialization), comment: comment)
        case kAudioUnitErr_TooManyFramesToProcess:
            self.init(.audioUnit(.tooManyFramesToProcess), comment: comment)
        case kAudioUnitErr_InvalidFile:
            self.init(.audioUnit(.invalidFile), comment: comment)
        case kAudioUnitErr_UnknownFileType:
            self.init(.audioUnit(.unknownFileType), comment: comment)
        case kAudioUnitErr_FileNotSpecified:
            self.init(.audioUnit(.fileNotSpecified), comment: comment)
        case kAudioUnitErr_FormatNotSupported:
            self.init(.audioUnit(.formatNotSupported), comment: comment)
        case kAudioUnitErr_Uninitialized:
            self.init(.audioUnit(.uninitialized), comment: comment)
        case kAudioUnitErr_InvalidScope:
            self.init(.audioUnit(.invalidScope), comment: comment)
        case kAudioUnitErr_PropertyNotWritable:
            self.init(.audioUnit(.propertyNotWritable), comment: comment)
        case kAudioUnitErr_CannotDoInCurrentContext:
            self.init(.audioUnit(.cannotDoInCurrentContext), comment: comment)
        case kAudioUnitErr_InvalidPropertyValue:
            self.init(.audioUnit(.invalidPropertyValue), comment: comment)
        case kAudioUnitErr_PropertyNotInUse:
            self.init(.audioUnit(.propertyNotInUse), comment: comment)
        case kAudioUnitErr_Initialized:
            self.init(.audioUnit(.initialized), comment: comment)
        case kAudioUnitErr_InvalidOfflineRender:
            self.init(.audioUnit(.invalidOfflineRender), comment: comment)
        case kAudioUnitErr_Unauthorized:
            self.init(.audioUnit(.unauthorized), comment: comment)
        case kAudioComponentErr_InstanceInvalidated:
            self.init(.audioUnit(.audioComponentInstanceInvalidated), comment: comment)
        case kAudioUnitErr_RenderTimeout:
            self.init(.audioUnit(.renderTimeout), comment: comment)
        case kAudioFileUnspecifiedError:
            self.init(.audioFile(.unspecified), comment: comment)
        case kAudioFileUnsupportedFileTypeError:
            self.init(.audioFile(.unsupportedFileType), comment: comment)
        case kAudioFileUnsupportedDataFormatError:
            self.init(.audioFile(.unsupportedDataFormat), comment: comment)
        case kAudioFileUnsupportedPropertyError:
            self.init(.audioFile(.unsupportedProperty), comment: comment)
        case kAudioFileBadPropertySizeError:
            self.init(.audioFile(.badPropertySize), comment: comment)
        case kAudioFilePermissionsError:
            self.init(.audioFile(.permissions), comment: comment)
        case kAudioFileNotOptimizedError:
            self.init(.audioFile(.notOptimized), comment: comment)
        case kAudioFileInvalidChunkError:
            self.init(.audioFile(.invalidChunk), comment: comment)
        case kAudioFileDoesNotAllow64BitDataSizeError:
            self.init(.audioFile(.doesNotAllow64BitDataSize), comment: comment)
        case kAudioFileInvalidPacketOffsetError:
            self.init(.audioFile(.invalidPacketOffset), comment: comment)
        case kAudioFileInvalidFileError:
            self.init(.audioFile(.invalidFile), comment: comment)
        case kAudioFileOperationNotSupportedError:
            self.init(.audioFile(.operationNotSupported), comment: comment)
        case kAudioFileNotOpenError:
            self.init(.audioFile(.notOpen), comment: comment)
        case kAudioFileEndOfFileError:
            self.init(.audioFile(.endOfFile), comment: comment)
        case kAudioFilePositionError:
            self.init(.audioFile(.position), comment: comment)
        case kAudioFileFileNotFoundError:
            self.init(.audioFile(.fileNotFound), comment: comment)
        default:
            self.init(.unknown(status: status), comment: comment)
        }
    }
    
}

extension AudioError: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return "AudioError(message: \(message), comment: \(comment))"
    }
    
}

extension OSStatus {
    
    public func audioError(_ comment: String) throws {
        if self != noErr {
            throw AudioError(status: self, comment: comment)
        }
    }
    
}