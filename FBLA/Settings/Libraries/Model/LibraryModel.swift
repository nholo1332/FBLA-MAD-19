//
//  LibraryModel.swift
//  FBLA
//
//  Created by Noah Holoubek on 2/4/19.
//  Copyright © 2019 Noah H. All rights reserved.
//

import UIKit

class Library {
    let name: String
    let creator: String
    let openSource: String
    let viewUsed: String
    
    init (name: String, creator: String, openSource: String, viewUsed: String) {
        self.name = name
        self.creator = creator
        self.openSource = openSource
        self.viewUsed = viewUsed
    }
}
