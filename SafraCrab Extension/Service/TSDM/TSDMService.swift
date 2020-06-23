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

final class TSDMService: SafraCrabService<TSDM> {
    
    
    // MARK: - Singleton
    public static let shared = TSDMService()
    private override init() { }

    
}

extension TSDMService {
    

    
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
