//
//  ScanResult.swift
//  BLE-iOS
//
//  Created by James Taylor on 5/24/20.
//  Copyright © 2020 James Taylor. All rights reserved.
//

import Foundation

class ScanResult: Hashable {
    var address: String = ""
}

//MARK: - Hashable conformance extension
extension ScanResult {
    static func == (lhs: ScanResult, rhs: ScanResult) -> Bool {
        return lhs.address == rhs.address
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(address)
    }
}
