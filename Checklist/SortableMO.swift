//
//  SortableMO.swift
//  Checklist
//
//  Created by Remus Lazar on 08.07.15.
//  Copyright (c) 2015 Remus Lazar. All rights reserved.
//

import UIKit
import CoreData

class SortableMO: NSManagedObject {

    @NSManaged var sorting: NSNumber
    @NSManaged var timestamp: NSDate
    
    override func awakeFromInsert() {
        timestamp = NSDate()
        if let maxSorting = aggr("max:", forKeyPath: "sorting", attributeType: .Integer32AttributeType) as? Int {
            sorting = maxSorting + 1
        }
    }
    
    // helper method to call a aggr function like max, min etc.
    private func aggr(function: String, forKeyPath keyPath: String, attributeType: NSAttributeType) -> AnyObject? {
        let description = NSExpressionDescription()
        description.name = "a"
        description.expression = NSExpression(forFunction: function, arguments: [NSExpression(forKeyPath: keyPath)])
        description.expressionResultType = attributeType
        
        let request = NSFetchRequest(entityName: entity.name!)
        request.resultType = .DictionaryResultType
        request.propertiesToFetch = [description]
        
        return managedObjectContext?.executeFetchRequest(request, error: nil)?.last?[description.name]
    }
    
    
   
}
