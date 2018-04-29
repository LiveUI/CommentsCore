//
//  Comment.swift
//  CommentsCore
//
//  Created by Ondrej Rafaj on 11/03/2018.
//

import Foundation
import Vapor
import Fluent
import FluentPostgreSQL
import DbCore
import ErrorsCore


public typealias Comments = [Comment]


public final class Comment: DbCoreModel {
    
    public final class New: Content {

        public var item: DbCoreIdentifier
        public var responseTo: DbCoreIdentifier?
        public var comment: String
        public var approved: Bool
        
        public init(item: DbCoreIdentifier, responseTo: DbCoreIdentifier? = nil, comment: String, approved: Bool) {
            self.item = item
            self.responseTo = responseTo
            self.comment = comment
            self.approved = approved
        }
        
        public func asComment(_ group: String, on req: Request) throws -> Comment {
            guard let meId = try req.me.user().id else {
                throw ErrorsCore.HTTPError.notAuthorized
            }
            return Comment(commentGroup: group, item: item, responseTo: responseTo, comment: comment, approved: approved, userId: meId)
        }
        
    }

    
    public var id: DbCoreIdentifier?
    public var commentGroup: String
    public var item: DbCoreIdentifier
    public var responseTo: DbCoreIdentifier?
    public var added: Date
    public var comment: String
    public var approved: Bool
    public var userId: DbCoreIdentifier
    
    public init(id: DbCoreIdentifier? = nil, commentGroup: String, item: DbCoreIdentifier, responseTo: DbCoreIdentifier? = nil, comment: String, approved: Bool = true, userId: DbCoreIdentifier) {
        self.id = id
        self.commentGroup = commentGroup
        self.item = item
        self.responseTo = responseTo
        self.comment = comment
        self.approved = approved
        self.userId = userId
        self.added = Date()
    }
    
}

// MARK: - Migrations

extension Comment: Migration {
    
    public static var idKey: WritableKeyPath<Comment, DbCoreIdentifier?> = \Comment.id
    
    public static func prepare(on connection: DbCoreConnection) -> Future<Void> {
        return Database.create(self, on: connection) { (schema) in
            schema.addField(type: DbCoreColumnType.id(), name: CodingKeys.id.stringValue, isIdentifier: true)
            schema.addField(type: DbCoreColumnType.bigInt(), name: CodingKeys.commentGroup.stringValue)
            schema.addField(type: DbCoreColumnType.id(), name: CodingKeys.item.stringValue)
            schema.addField(type: DbCoreColumnType.id(), name: CodingKeys.responseTo.stringValue)
            schema.addField(type: DbCoreColumnType.datetime(), name: CodingKeys.added.stringValue)
            schema.addField(type: DbCoreColumnType.text(), name: CodingKeys.comment.stringValue)
            schema.addField(type: DbCoreColumnType.bool(), name: CodingKeys.approved.stringValue)
            schema.addField(type: DbCoreColumnType.id(), name: CodingKeys.userId.stringValue)
        }
    }
    
    public static func revert(on connection: DbCoreConnection) -> Future<Void> {
        return Database.delete(Comment.self, on: connection)
    }
    
}
