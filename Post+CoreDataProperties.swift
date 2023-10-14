//
//  Post+CoreDataProperties.swift
//  PostApiCoreData
//
//  Created by Mauricio Casillas on 12/10/23.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var body: String?
    @NSManaged public var id: Int16
    @NSManaged public var title: String?
    @NSManaged public var userId: Int16

}

extension Post : Identifiable {

}
