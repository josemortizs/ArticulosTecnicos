import UIKit
import Foundation

struct MemoryAddress<T>: CustomStringConvertible {

    let intValue: Int

    var description: String {
        let length = 2 + 2 * MemoryLayout<UnsafeRawPointer>.size
        return String(format: "%0\(length)p", intValue)
    }

    // for structures
    init(of structPointer: UnsafePointer<T>) {
        intValue = Int(bitPattern: structPointer)
    }
}

extension MemoryAddress where T: AnyObject {

    // for classes
    init(of classInstance: T) {
        intValue = unsafeBitCast(classInstance, to: Int.self)
        // or      Int(bitPattern: Unmanaged<T>.passUnretained(classInstance).toOpaque())
    }
}

class Label {
    var text: String
    var font: UIFont
    init(text: String, font: UIFont) {
        self.text = text
        self.font = font
    }
}

var label1 = Label(text: "Hola!", font: .boldSystemFont(ofSize: 10))
var label2 = label1

let structInstanceAddress = MemoryAddress(of: label1)
let structInstanceAddress2 = MemoryAddress(of: label2)

print(String(format: "%018p", structInstanceAddress.intValue))

print(String(format: "%018p", structInstanceAddress2.intValue))

let classInstanceAddress = MemoryAddress(of: label1.font)
let classInstanceAddress2 = MemoryAddress(of: label2.font)

print(String(format: "%018p", classInstanceAddress.intValue))
print(String(format: "%018p", classInstanceAddress2.intValue))


print(UUID().uuidString)
