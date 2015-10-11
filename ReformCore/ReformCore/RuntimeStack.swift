//
//  RuntimeStack.swift
//  ReformCore
//
//  Created by Laszlo Korte on 14.08.15.
//  Copyright © 2015 Laszlo Korte. All rights reserved.
//

final class RuntimeStack {
    var frames = [StackFrame]()
    var data : [UInt64] = []
    var dataSize : Int = 0
    var formMap : [FormIdentifier:Form] = [:]
    var forms : [FormIdentifier] = []
    var offsets : [FormIdentifier:Int] = [:]
    
    func pushFrame() {
        frames.append(StackFrame())
    }
    
    func popFrame() {
        let top = frames.removeLast()
        
        for id in top.forms.reverse() {
            remove(id)
        }
    }
    
    func declare(form : Form) {
        if let topFrame = frames.last {
            topFrame.forms.append(form.identifier)
            formMap[form.identifier] = form
            offsets[form.identifier] = dataSize
            dataSize += form.dynamicType.stackSize
            growIfNeeded()
            forms.append(form.identifier)
        }
    }
    
    func growIfNeeded() {
        while data.count < dataSize {
            data.append(0)
        }
    }
    
    func getData(id: FormIdentifier, offset: Int) -> UInt64? {
        guard let o = offsets[id] where o + offset < dataSize else {
            return nil
        }
        
        return data[o+offset]
    }
    
    func setData(id: FormIdentifier, offset: Int, newValue: UInt64){
        if let o = offsets[id]
        where o + offset < dataSize {
            data[o+offset] = newValue

        }
    }
    
    func getForm(id: FormIdentifier) -> Form? {
        return formMap[id]
    }
    
    func clear() {
        frames.removeAll(keepCapacity: true)
        data.removeAll(keepCapacity: true)
        dataSize = 0
        formMap.removeAll(keepCapacity: true)
        forms.removeAll(keepCapacity: true)
        offsets.removeAll(keepCapacity: true)
    }
    
    private func remove(id: FormIdentifier) {
        if let form = formMap.removeValueForKey(id) {
            let offset = offsets.removeValueForKey(id)!
            let size = form.dynamicType.stackSize
            for i in 0..<size
            {
                data[offset + i] = 0
            }
            dataSize -= size
            forms.removeLast() // TODO: fix
        }
    }
}

final class StackFrame {
    var forms : [FormIdentifier] = []
}