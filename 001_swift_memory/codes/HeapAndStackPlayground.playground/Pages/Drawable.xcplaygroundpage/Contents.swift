import Foundation

class Drawable { func draw() { } }

class Point: Drawable {
    
    var x, y: Double
    
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    override func draw() { }
}

class Line: Drawable {
    
    var x1, y1, x2, y2: Double
    
    init(x1: Double, y1: Double, x2: Double, y2: Double) {
        self.x1 = x1
        self.y1 = y1
        self.x2 = x2
        self.y2 = y2
    }
    
    override func draw() { }
}

var drawables = [Drawable]()

// ... aquí un usuario podría estar creando diferentes tipos
// de objetos Drawable, bien puntos o bien líneas, e ir
// agregándolos a nuestra array de "drawables".

for drawable in drawables {
    drawable.draw()
}
