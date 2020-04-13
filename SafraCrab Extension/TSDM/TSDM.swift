//
//  TSDM.swift
//  SafraCrab Extension
//
//  Created by Cirno MainasuK on 2020-4-12.
//  Copyright © 2020 MainasuK. All rights reserved.
//

import Foundation
import SafariServices
import Combine

class TSDM {
    
    var page: SFSafariPage?
    
    let uuid = UUID()
    
    var uri: URL
    
    // post payment info
    var cost: Int?
    var payable = false
    
    // post BaiduYun info
    let baiduYuns = CurrentValueSubject<[BaiduYun], Never>([])
    
    init(uri: URL) {
        self.uri = uri
    }
    
}

extension TSDM {
    
    struct BaiduYun {
        let link: URL
        let code: String
    }
    
}

extension TSDM: CustomDebugStringConvertible {
    
    var debugDescription: String {
        return """
        uuid: \(uuid.uuidString)
        uri: \(uri.description)
        cost: \(cost ?? -1)
        payable: \(payable)
        baiduYun: \(baiduYuns.value.debugDescription)
        """
    }

}

extension TSDM.BaiduYun: CustomDebugStringConvertible {
    
    var debugDescription: String {
        return """
        link: \(link.description)
        code: \(code)
        """
    }
    
}
