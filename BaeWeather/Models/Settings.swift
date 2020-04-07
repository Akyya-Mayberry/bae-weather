//
//  Settings.swift
//  OnrampProject
//
//  Created by Chris Hurley on 3/5/20.
//

import Foundation

struct Settings: Codable {
    var modelName: String
    var modelImageSet: [String?]
    var defaultImagesInUse: [Bool]
}
