//
//  CommentsController.swift
//  CommentsCore
//
//  Created by Ondrej Rafaj on 15/03/2018.
//

import Foundation
import Vapor
import ApiCore
import DbCore
import ErrorsCore
import FluentPostgreSQL


public class CommentsController: Controller {
    
    public enum Error: FrontendError {
        case notAuthorised
        
        public var code: String {
            return "comments_error"
        }
        
        public var description: String {
            return "Not found"
        }
        
        public var status: HTTPStatus {
            return .notFound
        }
    }
    
    public static func boot(router: Router) throws {
        router.get("comments", String.parameter) { (req) -> Future<Response> in
            let group = try req.parameters.next(String.self)
            return try Comment.query(on: req).filter(\Comment.commentGroup == group).sort(\Comment.added, .descending).all().flatMap(to: Response.self) { settings in
                if req.query.plain == true  {
                    let dic: [String: String] = [:]
                    return try dic.asJson().asResponse(.ok, to: req)
                } else {
                    return try settings.asResponse(.ok, to: req)
                }
            }
        }
        
        router.get("comments", String.parameter, DbCoreIdentifier.parameter) { (req) -> Future<Response> in
            let group = try req.parameters.next(String.self)
            let id = try req.parameters.next(DbCoreIdentifier.self)
            return try Comment.query(on: req).filter(\Comment.id == id).filter(\Comment.commentGroup == group).first().flatMap(to: Response.self) { comment in
                guard let comment = comment else {
                    throw ErrorsCore.HTTPError.notFound
                }
                return try comment.asResponse(.ok, to: req)
            }
        }
        
        router.post("comments", String.parameter) { (req) -> Future<Response> in
            return try req.me.isAdmin().flatMap(to: Response.self) { admin in
                return try req.content.decode(Comment.New.self).flatMap(to: Response.self) { newComment in
                    let group = try req.parameters.next(String.self)
                    let comment = try newComment.asComment(group, on: req)
                    if !admin {
                        comment.approved = false
                    }
                    return try comment.save(on: req).asResponse(.created, to: req)
                }
            }
        }
        
        router.put("comments", String.parameter, DbCoreIdentifier.parameter) { (req) -> Future<Comment> in
            return try req.me.isAdmin().flatMap(to: Comment.self) { admin in
                let group = try req.parameters.next(String.self)
                let id = try req.parameters.next(DbCoreIdentifier.self)
                return try Comment.query(on: req).filter(\Comment.id == id).filter(\Comment.commentGroup == group).first().flatMap(to: Comment.self) { comment in
                    let meId = try req.me.user().id
                    guard let comment = comment else {
                        throw ErrorsCore.HTTPError.notFound
                    }
                    guard admin || meId == comment.userId else {
                        throw Error.notAuthorised
                    }
                    return try req.content.decode(Comment.self).flatMap(to: Comment.self) { updatedComment in
                        comment.comment = updatedComment.comment
                        if admin {
                            comment.approved = updatedComment.approved
                        }
                        return comment.save(on: req)
                    }
                }
            }
        }
        
        router.delete("comments", String.parameter, DbCoreIdentifier.parameter) { (req) -> Future<Response> in
            return try req.me.isAdmin().flatMap(to: Response.self) { admin in
                let group = try req.parameters.next(String.self)
                let id = try req.parameters.next(DbCoreIdentifier.self)
                return try Comment.query(on: req).filter(\Comment.id == id).filter(\Comment.commentGroup == group).first().flatMap(to: Response.self) { comment in
                    let meId = try req.me.user().id
                    guard let comment = comment else {
                        throw ErrorsCore.HTTPError.notFound
                    }
                    guard admin || meId == comment.userId else {
                        throw Error.notAuthorised
                    }
                    return try comment.delete(on: req).asResponse(to: req)
                }
            }
        }
        
    }
}
