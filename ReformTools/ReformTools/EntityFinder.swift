//
//  EntityFinder.swift
//  ReformTools
//
//  Created by Laszlo Korte on 19.08.15.
//  Copyright © 2015 Laszlo Korte. All rights reserved.
//


import ReformMath
import ReformCore
import ReformStage
import ReformExpression


struct EntityQuery {
    let filter: FormFilter
    let location: LocationFilter
}

struct EntityFinder {
    let stage : Stage
    
    func getEntity(id: FormIdentifier) -> Entity? {
        for entity in stage.entities {
            if entity.id == id {
                return entity
            }
        }
        
        return nil
    }
    
    func getEntities(query: EntityQuery) -> [Entity] {
        var result = [Entity]()
        
        for entity in stage.entities {
            if case .Except(entity.id) = query.filter {
                continue
            }
            if case .Only(let id) = query.filter where id != entity.id {
                continue
            }

            if case .Near(let loc, let d) = query.location where !entity.hitArea.contains(loc, margin: d) {
                continue
            }
            
            result.append(entity)
        }
        
        return result
    }
}