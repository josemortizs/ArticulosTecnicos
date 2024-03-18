import UIKit

struct Label {
    var text: String
    var font: UIFont
}

let label1 = Label(text: "Hola!", font: .boldSystemFont(ofSize: 10))
let label2 = label1
