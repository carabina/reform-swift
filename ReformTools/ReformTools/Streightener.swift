//
//  Streightening.swift
//  ReformTools
//
//  Created by Laszlo Korte on 19.08.15.
//  Copyright © 2015 Laszlo Korte. All rights reserved.
//

import ReformCore
import ReformMath


public class Streightener {
    private enum State {
        case Disabled
        case Enabled(inverted: Bool)
    }

    
    private var state : State = .Disabled
    
    public init() {}
    
    func enable() {
        if case .Disabled = state  {
            state = .Enabled(inverted: false)
        }
    }
    
    func disable() {
        state = .Disabled
    }
    
    func invert() {
        if case .Enabled(let inverted) = state {
            state = .Enabled(inverted: !inverted)
        }
    }
    
    func reset() {
        if case .Enabled = state {
            state = .Enabled(inverted: false)
        }
    }
    
    func adjust(delta: Vec2d, step: Angle) -> Vec2d {
        switch state {
        case .Enabled:
            return project(delta, onto: rotate(Vec2d.XAxis, angle: stepped(angle(delta), size: step)))
        case .Disabled:
            return delta
        }
    }
    
    func adjust(angle: Angle) -> Angle {
        switch state {
        case .Enabled:
            return stepped(angle, size: Angle(percent: 1))
        case .Disabled:
            return angle
        }
    }
    
    func directionFor(delta: Vec2d) -> protocol<RuntimeDirection, Labeled> {
        switch state {
        case .Disabled:
            return FreeDirection()
        case .Enabled(let inverted):
            return (abs(delta.x) > abs(delta.y)) != inverted ? Cartesian.Horizontal : Cartesian.Vertical
        }
    }
    
    func axisFor(axis: RuntimeAxis) -> RuntimeAxis {
        switch state {
        case .Disabled:
            return axis
        case .Enabled:
            return .None
        }
    }
}