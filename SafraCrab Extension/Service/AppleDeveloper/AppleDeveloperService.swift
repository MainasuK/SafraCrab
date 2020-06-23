//
//  AppleDeveloperService.swift
//  SafraCrab Extension
//
//  Created by Cirno MainasuK on 2020-6-23.
//  Copyright © 2020 MainasuK. All rights reserved.
//

import Foundation
import SafariServices
import CommonOSLog

final class AppleDeveloperService: SafraCrabService<AppleDeveloper> {
    
    // MARK: - Singleton
    public static let shared = AppleDeveloperService()
    private override init() { }
    
}
