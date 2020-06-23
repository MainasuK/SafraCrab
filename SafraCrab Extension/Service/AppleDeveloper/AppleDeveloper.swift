//
//  AppleDeveloper.swift
//  SafraCrab Extension
//
//  Created by Cirno MainasuK on 2020-6-23.
//  Copyright © 2020 MainasuK. All rights reserved.
//

import Foundation
import SafariServices

class AppleDeveloper: SafraCrabModel {
    
    let uuid = UUID()
    
    var page: SFSafariPage?
    var uri: URL
    
    var releaseNote: ReleaseNote?
    
    required init(uri: URI) {
        self.uri = uri
    }
    
}

extension AppleDeveloper {
    struct ReleaseNote {
        let title: String
        let content: String
    }
}


extension AppleDeveloper: CustomDebugStringConvertible {
    
    var debugDescription: String {
        return """
        uuid: \(uuid.uuidString)
        uri: \(uri.description)
        releaseNote: \(releaseNote.debugDescription)
        """
    }
    
}

extension AppleDeveloper.ReleaseNote: CustomDebugStringConvertible {
    
    var debugDescription: String {
        return """
        title: \(title)
        content: \(content)
        """
    }
    
}
