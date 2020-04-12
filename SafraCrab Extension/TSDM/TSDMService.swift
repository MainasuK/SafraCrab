//
//  TSDMService.swift
//  SafraCrab Extension
//
//  Created by Cirno MainasuK on 2020-4-12.
//  Copyright © 2020 MainasuK. All rights reserved.
//

import Foundation
import SafariServices

final class TSDMService {
    
    typealias URI = URL
    
    // MARK: - Singleton
    public static let shared = TSDMService()
    private init() { }

    let uuid = UUID()
    var models: [SFSafariPage: TSDM] = [:]
    
}

extension TSDMService {
    
    func model(of page: SFSafariPage, at uri: URI) -> TSDM {
        if let model = models[page] {
            return model
        } else if let model = models.first(where: { $0.key.isEqual(page) })?.value {
            model.page = page
            return model
        } else {
            let model = TSDM(uri: uri)
            models[page] = model
            return model
        }
    }
    
    func model(of page: SFSafariPage) -> TSDM? {
        if let model = models[page] {
            return model
        } else if let model = models.first(where: { $0.key.isEqual(page) })?.value {
            model.page = page
            return model
        } else {
            return nil
        }
    }
    
}
