//
//  Extension.swift
//  VisionKitApp
//
//  Created by tokomac.
//

import Foundation

extension String {
    func enterInsert(_ length: Int) -> String {
        var str = self
        let count = (str.count / length)
        for i in 0 ..< count {
            str.insert("\n", at: str.index(str.startIndex, offsetBy: (i + 1) * length))
        }
        return str
    }
}
