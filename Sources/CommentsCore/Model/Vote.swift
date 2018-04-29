//
//  Vote.swift
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


public typealias Votes = [Vote]


public final class Vote: DbCoreModel {
    
    public var id: DbCoreIdentifier?
    public var voteGroup: Int
    public var item: DbCoreIdentifier
    public var added: Date
    public var upvote: Bool
    public var userId: DbCoreIdentifier
    
    public init(id: DbCoreIdentifier? = nil, voteGroup: GroupIdentifyable, item: DbCoreIdentifier, isUpvote: Bool, userId: DbCoreIdentifier) {
        self.id = id
        self.voteGroup = voteGroup.rawValue.hashValue
        self.item = item
        self.upvote = upvote
        self.userId = userId
    }
    
}

// MARK: - Migrations

extension Vote: Migration {
    
    public static var idKey: WritableKeyPath<Vote, DbCoreIdentifier?> = \Vote.id
    
    public static func prepare(on connection: DbCoreConnection) -> Future<Void> {
        return Database.create(self, on: connection) { (schema) in
            schema.addField(type: DbCoreColumnType.id(), name: CodingKeys.id.stringValue, isIdentifier: true)
            schema.addField(type: DbCoreColumnType.int(11), name: CodingKeys.voteGroup.stringValue)
            schema.addField(type: DbCoreColumnType.id(), name: CodingKeys.item.stringValue)
            schema.addField(type: DbCoreColumnType.datetime(), name: CodingKeys.added.stringValue)
            schema.addField(type: DbCoreColumnType.bool(), name: CodingKeys.upvote.stringValue)
            schema.addField(type: DbCoreColumnType.id(), name: CodingKeys.userId.stringValue)
        }
    }
    
    public static func revert(on connection: DbCoreConnection) -> Future<Void> {
        return Database.delete(Vote.self, on: connection)
    }
    
}
