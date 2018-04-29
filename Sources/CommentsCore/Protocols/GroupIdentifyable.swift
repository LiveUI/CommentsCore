//
//  GroupIdentifyable.swift
//  CommentsCore
//
//  Created by Ondrej Rafaj on 29/04/2018.
//

import Foundation


/// Should fit any string based enum
public protocol GroupIdentifyable {
    var rawValue: String { get }
}
