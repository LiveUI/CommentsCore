//
//  CommentsCore.swift
//  CommentsCore
//
//  Created by Ondrej Rafaj on 20/2/2018.
//

import Foundation
import ApiCore
import DbCore
import Vapor


public class CommentsCore {
    
    static var controllers: [Controller.Type] = [
        CommentsController.self
    ]
    
    public static func boot(router: Router) throws {
        for c in controllers {
            try c.boot(router: router)
        }
    }
    
    public static func configure(_ config: inout Config, _ env: inout Vapor.Environment, _ services: inout Services) throws {
        DbCore.add(model: Comment.self, database: .db)
        DbCore.add(model: Vote.self, database: .db)
    }
    
}
