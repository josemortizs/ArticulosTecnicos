//
//  StructsWithClassProperties.swift
//  MemoryHeapAndStacksTests
//
//  Created by Jose Manuel Ortiz Sanchez on 18/3/24.
//

import XCTest
import UIKit

struct LabelStruct {
    var text: String
    var font: UIFont
}

class LabelClass {
    var text: String
    var font: UIFont
    init(text: String, font: UIFont) {
        self.text = text
        self.font = font
    }
}

final class StructsWithClassProperties: XCTestCase {

    func testWithStructs() throws {
        self.measure {
            for _ in 1...1_000_000 {
                _ = LabelStruct(text: "Hola Mundo!", font: .boldSystemFont(ofSize: 10))
            }
        }
    }
    
    func testWithClass() throws {
        self.measure {
            for _ in 1...1_000_000 {
                _ = LabelClass(text: "Hola Mundo!", font: .boldSystemFont(ofSize: 10))
            }
        }
    }
}
