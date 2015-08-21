//
//  ArcForm.swift
//  ReformCore
//
//  Created by Laszlo Korte on 13.08.15.
//  Copyright © 2015 Laszlo Korte. All rights reserved.
//

import ReformMath
import ReformGraphics


extension ArcForm {
    
    public enum PointId : ExposedPointIdentifier {
        case Start = 0
        case End = 1
        case Center = 2
    }
}

final public class ArcForm : Form, Creatable {
    public static var stackSize : Int = 5
    
    public let identifier : FormIdentifier
    public var drawingMode : DrawingMode = DrawingMode.Draw
    public var name : String
    
    
    public init(id formId: FormIdentifier, name : String) {
        self.identifier = formId
        self.name = name
    }
    
    public var startPoint : WriteableRuntimePoint {
        return StaticPoint(formId: identifier, offset: 0)
    }
    
    public var endPoint : WriteableRuntimePoint {
        return StaticPoint(formId: identifier, offset: 2)
    }
    
    public var offset : WriteableRuntimeLength {
        return StaticLength(formId: identifier, offset: 4)
    }
    
    public func initWithRuntime(runtime: Runtime, min: Vec2d, max: Vec2d) {
        startPoint.setPositionFor(runtime, position: min)
        endPoint.setPositionFor(runtime, position: max)
        offset.setLengthFor(runtime, length: 50)
    }
    
    public func getPoints() -> [ExposedPointIdentifier:LabeledPoint] {
        return [
            PointId.Start.rawValue:ExposedPoint(point: startPoint, name: "Start"),
            PointId.End.rawValue:ExposedPoint(point: endPoint, name: "End"),
            PointId.Center.rawValue:ExposedPoint(point: AnchorPoint(anchor: controlAnchor), name: "Center"),
        ]
    }
    
    public var outline : Outline {
        return NullOutline()
    }
}

extension ArcForm : Rotatable {
    
    public var rotator : Rotator {
        return BasicPointRotator(points: startPoint, endPoint)
    }
    
}

extension ArcForm : Translatable {
    
    public var translator : Translator {
        return BasicPointTranslator(points: startPoint, endPoint)
    }
}

extension ArcForm : Scalable {
    
    public var scaler : Scaler {
        return BasicPointScaler(points: startPoint, endPoint)
    }
    
}

extension ArcForm {
    var controlAnchor : Anchor {
        return OrthogonalOffsetAnchor(name: "Control Point", pointA: startPoint, pointB: endPoint, offset: offset)
    }
}

extension ArcForm : Morphable {
    
    public enum AnchorId : AnchorIdentifier {
        case Start = 0
        case End = 1
        case Offset = 2
    }
    
    public func getAnchors() -> [AnchorIdentifier:Anchor] {
        return [
            AnchorId.Start.rawValue:StaticPointAnchor(point: startPoint, name: "Start"),
            AnchorId.End.rawValue:StaticPointAnchor(point: endPoint, name: "End"),
            AnchorId.Offset.rawValue:controlAnchor,
        ]
    }
    
}

extension ArcForm : Drawable {
    
    public func getPathFor(runtime: Runtime) -> Path? {
        return nil
    }
    
    public func getShapeFor(runtime: Runtime) -> Shape? {
        guard let path = getPathFor(runtime) else { return nil }
        
        return Shape(area: .PathArea(path), background: .Fill(Color(r: 128, g: 128, b: 128, a: 128)), stroke: .Solid(width: 1, color: Color(r:50, g:50, b:50, a: 255)))
    }
}
