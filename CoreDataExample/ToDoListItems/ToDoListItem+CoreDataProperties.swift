//
//  ToDoListItem+CoreDataProperties.swift
//  CoreDataExample
//
//  Created by Bridge on 04/03/24.
//
//

import Foundation
import CoreData


extension ToDoListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListItem> {
        return NSFetchRequest<ToDoListItem>(entityName: "ToDoListItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var created_at: Date?

}

extension ToDoListItem : Identifiable {

}
