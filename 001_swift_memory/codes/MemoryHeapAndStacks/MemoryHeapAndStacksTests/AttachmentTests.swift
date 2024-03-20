//
//  AttachmentTests.swift
//  MemoryHeapAndStacksTests
//
//  Created by José Manuel Ortiz Sánchez on 19/3/24.
//

import XCTest

struct Attachment {
    let fileURL: URL
    let uuid: String
    let mimeType: String
    
    init?(fileURL: URL, uuid: String, mimeType: String) {
        
        guard mimeType.isMimeType
        else { return nil }
        
        self.fileURL = fileURL
        self.uuid = uuid
        self.mimeType = mimeType
    }
}

extension String {
    var isMimeType: Bool {
        switch self {
        case "image/jpeg":
            return true
        case "image/png":
            return true
        case "image/gif":
            return true
        default:
            return false
        }
    }
}

enum MimeType: String {
    case jpeg = "image/jpeg"
    case png = "image/png"
    case gif = "image/gif"
}

struct ImprovedAttachment {
    let fileURL: URL
    let uuid: UUID
    let mimeType: MimeType
    
    init?(fileURL: URL, uuid: UUID, mimeType: String) {
        guard let mimeType = MimeType(rawValue: mimeType)
        else { return nil }
        
        self.fileURL = fileURL
        self.uuid = uuid
        self.mimeType = mimeType
    }
}

final class AttachmentTests: XCTestCase {

    func testWithAttachment() throws {
        self.measure {
            for _ in 1...1_000_000 {
                _ = Attachment(
                    fileURL: URL(string: "url")!,
                    uuid: "41079A5D-8E32-4D87-8A93-6B5F28FE9B09-8E32-4D87-8A93",
                    mimeType: "image/jpeg"
                )
            }
        }
    }
    
    func testWithImprovedAttachment() throws {
        self.measure {
            for _ in 1...1_000_000 {
                _ = ImprovedAttachment(
                    fileURL: URL(string: "url")!,
                    uuid: UUID(),
                    mimeType: "image/jpeg"
                )
            }
        }
    }
}
