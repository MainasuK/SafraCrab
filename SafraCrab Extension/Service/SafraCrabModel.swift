//
//  SafraCrabModel.swift
//  SafraCrab Extension
//
//  Created by Cirno MainasuK on 2020-6-23.
//  Copyright © 2020 MainasuK. All rights reserved.
//

import Foundation
import SafariServices

protocol SafraCrabModel: class {
    typealias URI = URL
    
    var uuid: UUID { get }
    var uri: URI { get }
    var page: SFSafariPage? { get set }
    
    init(uri: URI)
}
