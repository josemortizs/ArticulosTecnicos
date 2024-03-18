//
//  MemoryHeapAndStacksTests.swift
//  MemoryHeapAndStacksTests
//
//  Created by José Manuel Ortiz Sánchez on 11/3/24.
//

import XCTest
import UIKit

enum Color { case blue, green, gray }
enum Orientation { case left, right }
enum Tail { case none, tail, buble }

struct Attributes: Hashable {
    var color: Color
    var orientation: Orientation
    var tail: Tail
}

class AttributesClass: Hashable {
    var color: Color
    var orientation: Orientation
    var tail: Tail
    
    init(color: Color, orientation: Orientation, tail: Tail) {
        self.color = color
        self.orientation = orientation
        self.tail = tail
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(color)
        hasher.combine(orientation)
        hasher.combine(tail)
    }
    
    static func == (lhs: AttributesClass, rhs: AttributesClass) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

var cache = [Attributes: UIImage]()

func makeBalloon(_ color: Color, orientation: Orientation, tail: Tail) -> UIImage {
    let key = Attributes(color: color, orientation: orientation, tail: tail)
    if let image = cache[key] { return image }
    // Aquí iría el resto de implementación para devolver el UIImage correspondiente,
    // no nos vale para el ejemplo así que la obvio.
    return UIImage()
}

final class MemoryHeapAndStacksTests: XCTestCase {
    
    func testWithString() throws {
        self.measure {
            for _ in 1...1_000_000 {
                _ = "\(Color.blue):\(Orientation.left):\(Tail.buble)"
            }
        }
    }
    
    func testWithClass() throws {
        self.measure {
            for _ in 1...1_000_000 {
                _ = AttributesClass(color: .blue, orientation: .left, tail: .buble)
            }
        }
    }
    
    func testWithStruct() throws {
        self.measure {
            for _ in 1...1_000_000 {
                _ = Attributes(color: .blue, orientation: .left, tail: .buble)
            }
        }
    }
}

final class MemoryHeapAndStacksHashableTests: XCTestCase {
    
    func testVerifyHashableInClass() throws {
        let attributesClass1 = AttributesClass(color: .blue, orientation: .left, tail: .buble)
        let attributesClass2 = AttributesClass(color: .blue, orientation: .left, tail: .buble)
        let attributesClass3 = AttributesClass(color: .gray, orientation: .left, tail: .buble)
        
        XCTAssertEqual(attributesClass1, attributesClass2)
        XCTAssertNotEqual(attributesClass2, attributesClass3)
    }
}
