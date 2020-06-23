//
//  SafraCrabService.swift
//  SafraCrab Extension
//
//  Created by Cirno MainasuK on 2020-6-23.
//  Copyright © 2020 MainasuK. All rights reserved.
//

import Foundation
import SafariServices

class SafraCrabService<T: SafraCrabModel> {
    
    let uuid = UUID()
    private(set) var models: [SFSafariPage: T] = [:]
    
    func model(of page: SFSafariPage, at uri: T.URI) -> T {
        if let model = models[page] {
            return model
        } else if let model = models.first(where: { $0.key.isEqual(page) })?.value {
            model.page = page
            return model
        } else {
            let model = T(uri: uri)
            models[page] = model
            return model
        }
    }
    
    func model(of page: SFSafariPage) -> T? {
        if let model = models[page] {
            return model
        } else if let model = models.first(where: { $0.key.isEqual(page) })?.value {
            model.page = page
            return model
        } else {
            return nil
        }
    }
    
    func removeModel(of page: SFSafariPage) {
        if let model = models[page] {
            models[page] = nil
        } else if let page = models.first(where: { $0.key.isEqual(page) })?.key {
            models[page] = nil
        } else {
            // do nothing
        }
    }
}
