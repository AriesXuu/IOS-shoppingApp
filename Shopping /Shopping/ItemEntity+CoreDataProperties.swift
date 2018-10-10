//
//  ItemEntity+CoreDataProperties.swift
//  Shopping List
//
//  Created by Yue Zhang on 2018/4/9.
//  Copyright © 2018年 Yue Zhang. All rights reserved.
//

import Foundation
import CoreData


extension ItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemEntity> {
        return NSFetchRequest<ItemEntity>(entityName: "ItemEntity")
    }

    @NSManaged public var imageName: String?
    @NSManaged public var price: Double
    @NSManaged public var quantity: Int32
    @NSManaged public var title: String?
    @NSManaged public var isPurchased: HistoryEntity?
    @NSManaged public var isSelected: Bool

}
