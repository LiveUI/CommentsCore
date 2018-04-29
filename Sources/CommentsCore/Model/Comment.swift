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
    
    public var id: DbCoreIdentifier?
    public var commentGroup: String
    public var item: DbCoreIdentifier
    public var responseTo: DbCoreIdentifier?
    public var added: Date
    public var comment: String
    public var approved: String
    public var userId: DbCoreIdentifier
    
    public init(id: DbCoreIdentifier? = nil, commentGroup: GroupIdentifyable, item: DbCoreIdentifier, responseTo: DbCoreIdentifier? = nil, comment: String, approved: String = true, userId: DbCoreIdentifier) {
        self.id = id
        self.commentGroup = commentGroup.rawValue
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
            schema.addField(type: DbCoreColumnType.datetime(), name: CodingKeys.added.stringValue)
            schema.addField(type: DbCoreColumnType.varChar(250), name: CodingKeys.uri.stringValue)
            //            schema.addField(type: DbCoreColumnType.varChar(8), name: CodingKeys.method.stringValue)
            schema.addField(type: DbCoreColumnType.text(), name: CodingKeys.error.stringValue)
        }
    }
    
    public static func revert(on connection: DbCoreConnection) -> Future<Void> {
        return Database.delete(Comment.self, on: connection)
    }
    
}
