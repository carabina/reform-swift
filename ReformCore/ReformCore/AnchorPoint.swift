//
//  AnchorPoint.swift
//  ReformCore
//
//  Created by Laszlo Korte on 13.08.15.
//  Copyright © 2015 Laszlo Korte. All rights reserved.
//

import ReformMath

struct AnchorPoint : RuntimePoint, Labeled {
    private let anchor : Anchor
    
    init(anchor: Anchor) {
        self.anchor = anchor
    }
    
    func getPositionFor<R:Runtime>(runtime: R) -> Vec2d? {
        return anchor.getPositionFor(runtime)
    }
    
    func getDescription(stringifier: Stringifier) -> String {
        return anchor.name
    }
}