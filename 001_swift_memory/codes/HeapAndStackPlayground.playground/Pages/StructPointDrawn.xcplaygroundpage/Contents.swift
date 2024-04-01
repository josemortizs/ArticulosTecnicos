import Foundation

struct Point {
    var x, y: Double
    func draw() {
        // ...
    }
}

func drawAPoint(_ point: Point) {
    point.draw()
}

let point = Point(x: 0, y: 0)
drawAPoint(point)
