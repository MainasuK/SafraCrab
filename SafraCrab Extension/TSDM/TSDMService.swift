//
//  TSDMService.swift
//  SafraCrab Extension
//
//  Created by Cirno MainasuK on 2020-4-12.
//  Copyright © 2020 MainasuK. All rights reserved.
//

import Foundation
import SafariServices
import CommonOSLog

final class TSDMService {
    
    typealias URI = URL
    
    // MARK: - Singleton
    public static let shared = TSDMService()
    private init() { }

    let uuid = UUID()
    private(set) var models: [SFSafariPage: TSDM] = [:]
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

extension TSDMService {
    
    func updateBaiduYunState(of page: SFSafariPage) {
        guard let tsdm = model(of: page) else {
            return
        }
        
        tsdm.baiduYuns.send([])
        page.dispatchMessageToScript(withName: "TSDM", userInfo: ["action": "checkBaiduYun"])
        
        os_log("^ %{public}s[%{public}ld], %{public}s", ((#file as NSString).lastPathComponent), #line, #function)
    }
    
    func searchBaiduYunCode(by surl: String) -> String? {
        let baiduYuns = models.values.map { $0.baiduYuns.value }.flatMap { $0 }
        for baiduYun in baiduYuns {
            guard baiduYun.link.absoluteString.contains(surl) else {
                continue
            }
            
            return baiduYun.code
        }
        
        return nil
    }
    
}
