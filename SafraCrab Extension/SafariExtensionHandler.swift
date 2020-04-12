//
//  SafariExtensionHandler.swift
//  SafraCrab Extension
//
//  Created by Cirno MainasuK on 2020-4-12.
//  Copyright © 2020 MainasuK. All rights reserved.
//

import SafariServices
import Combine
import CommonOSLog
import SwiftyJSON

final class SafariExtensionHandlerViewModel {

    let tsdmService = TSDMService.shared
    
    func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        os_log("^ %{public}s[%{public}ld], %{public}s: message from page: %{public}s\n%{public}s\n%{public}s", ((#file as NSString).lastPathComponent), #line, #function, page.description, messageName, userInfo.debugDescription)
        
        let json = JSON(userInfo ?? [:])
        guard let uri = json["uri"].url else { return }
        
        switch messageName {
        case "TSDM":
            let model = tsdmService.model(of: page, at: uri)
            model.page = page
            
            if let cost = json["cost"].int {
                model.cost = cost
            }
            if let payable = json["payable"].bool {
                model.payable = payable
            }
        
            #if DEBUG
            os_log("^ %{public}s[%{public}ld], %{public}s: TSDM: %{public}s", ((#file as NSString).lastPathComponent), #line, #function, model.debugDescription)
            #endif
            
        case "SafraCrab":
            let model = tsdmService.models[page]
            tsdmService.models[page] = nil
            os_log("^ %{public}s[%{public}ld], %{public}s: remove model: %{public}s", ((#file as NSString).lastPathComponent), #line, #function, model.debugDescription)
            
        default:
            break
        }
    
        os_log("^ %{public}s[%{public}ld], %{public}s: [TSDM-%{public}s]: %{public}s", ((#file as NSString).lastPathComponent), #line, #function, tsdmService.uuid.uuidString, tsdmService.models.debugDescription)
    }
    
    func popoverWillShowForPage(page: SFSafariPage) {
        SafariExtensionViewController.shared.reset()
        
        // [DEBUG]
        // let _TSDM = TSDM(uri: URL(string: "https://demo.com")!)
        // _TSDM.cost = Int.random(in: 10...100)
        // _TSDM.payable = true
        // SafariExtensionViewController.shared.configure(with: _TSDM)
        // return
        
        if let TSDM = tsdmService.model(of: page) {
            SafariExtensionViewController.shared.configure(with: TSDM)
        }
    }
    
}

class SafariExtensionHandler: SFSafariExtensionHandler {
    
    let viewModel = SafariExtensionHandlerViewModel()
    
    // MARK: - message
    
    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        viewModel.messageReceived(withName: messageName, from: page, userInfo: userInfo)
        
//        #if DEBUG
//        page.getPropertiesWithCompletionHandler { properties in
//            NSLog("^ The extension received a message (\(messageName)) from a script injected into (\(String(describing: properties?.url))) with userInfo (\(userInfo ?? [:]))")
//        }
//        #endif
        
    }
    
    // MARK: - toolbar
    
    override func toolbarItemClicked(in window: SFSafariWindow) {
        os_log("^ %{public}s[%{public}ld], %{public}s", ((#file as NSString).lastPathComponent), #line, #function)
        
    }
    
    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping ((Bool, String) -> Void)) {
        // This is called when Safari's state changed in some way that would require the extension's toolbar item to be validated again.
        validationHandler(true, "")
    }
    
    // MARK: - popover
    
    override func popoverWillShow(in window: SFSafariWindow) {
        window.getActiveTab { tab in
            guard let tab = tab else { return }
            
            tab.getActivePage { page in
                guard let page = page else { return }
                
                DispatchQueue.main.async {
                    self.viewModel.popoverWillShowForPage(page: page)
                }
                
                os_log("^ %{public}s[%{public}ld], %{public}s: triggerPopoverForPage: %{public}s", ((#file as NSString).lastPathComponent), #line, #function, page.description)
            }
        }
    }
    
    override func popoverViewController() -> SFSafariExtensionViewController {
        os_log("^ %{public}s[%{public}ld], %{public}s", ((#file as NSString).lastPathComponent), #line, #function)
        return SafariExtensionViewController.shared
    }
    
    override func popoverDidClose(in window: SFSafariWindow) {
//        window.getActiveTab { tab in
//            guard let tab = tab else { return }
//            tab.getActivePage(completionHandler: { page in
//                os_log("^ %{public}s[%{public}ld], %{public}s:\nwindow: %{public}s\ntab: %{public}s\npage: %{public}s", ((#file as NSString).lastPathComponent), #line, #function, window.description, tab.description, page?.description ?? "nil")
//            })
//        }
    }
    
    // MARK: - page
    
    override func page(_ page: SFSafariPage, willNavigateTo url: URL?) {
        let model = viewModel.tsdmService.models[page]
        viewModel.tsdmService.models[page] = nil
        
        os_log("^ %{public}s[%{public}ld], %{public}s: remove model: %{public}s", ((#file as NSString).lastPathComponent), #line, #function, model.debugDescription)
    }

}
