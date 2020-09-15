//
//  NewsCoreData+Class.swift
//  NewsApp
//
//  Created by Zagorovsky, Artem on 9/11/20.
//  Copyright © 2020 Artem Zagorovski. All rights reserved.
//

import Foundation
import CoreData

final class NewsEntity: NSManagedObject {
    @nonobjc class func fetchRequest() -> NSFetchRequest<NewsEntity> {
        return NSFetchRequest<NewsEntity>(entityName: "NewsCoreData")
    }
    @NSManaged var newsTitle: String
    @NSManaged var newsDescription: String
    @NSManaged var isFavourite: Bool
    @NSManaged var publishedAt: String?
    @NSManaged var imageData: Data?
}

extension NewsEntity {
    convenience init(news: News, context: NSManagedObjectContext) {
        self.init(context: context)
        self.newsTitle = news.newsTitle
        self.newsDescription = news.newsDescription
        self.isFavourite = news.isFavourite
        self.publishedAt = news.publishedAt
        self.imageData = news.imageData
    }
}