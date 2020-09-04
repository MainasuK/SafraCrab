//
//  SafariExtensionViewController.swift
//  SafraCrab Extension
//
//  Created by Cirno MainasuK on 2020-4-12.
//  Copyright © 2020 MainasuK. All rights reserved.
//

import SafariServices
import CommonOSLog
import Combine

class SafariExtensionViewController: SFSafariExtensionViewController {
    
    var disposeBag = Set<AnyCancellable>()
    
    var tsdm: TSDM?
    var appleDeveloper: AppleDeveloper?
    
    static let shared: SafariExtensionViewController = {
        let shared = SafariExtensionViewController()
         shared.preferredContentSize = NSSize(width: 320, height: 44)
        return shared
    }()
    
    let stackView: NSStackView = {
        let stackView = NSStackView()
        stackView.orientation = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 4
        return stackView
    }()
    
    deinit {
        os_log("^ %{public}s[%{public}ld], %{public}s: deinit", ((#file as NSString).lastPathComponent), #line, #function)
    }

}

extension SafariExtensionViewController {
    
    @objc private func payButtonPressed(_ sender: NSButton) {
        guard let tsdm = self.tsdm else { return }
        os_log("^ %{public}s[%{public}ld], %{public}s: pay %{public}s", ((#file as NSString).lastPathComponent), #line, #function, tsdm.debugDescription)
        
        tsdm.page?.dispatchMessageToScript(withName: "TSDM", userInfo: ["action": "pay"])
        dismissPopover()
    }
    
    @objc private func replyButtonPressed(_ sender: NSButton) {
        guard let tsdm = self.tsdm else { return }
        os_log("^ %{public}s[%{public}ld], %{public}s: reply %{public}s", ((#file as NSString).lastPathComponent), #line, #function, tsdm.debugDescription)
        
        tsdm.page?.dispatchMessageToScript(withName: "TSDM", userInfo: ["action": "reply"])
        dismissPopover()
    }
    
}

extension SafariExtensionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension SafariExtensionViewController {
    
    func reset() {
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        disposeBag.removeAll()
        tsdm = nil
        appleDeveloper = nil
    }
    
    func configure(with viewModel: TSDM) {
        os_log("^ %{public}s[%{public}ld], %{public}s: %{public}s", ((#file as NSString).lastPathComponent), #line, #function, viewModel.debugDescription)
        
        tsdm = viewModel
        
        let topPaddingView = NSView()
        topPaddingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topPaddingView.heightAnchor.constraint(equalToConstant: 4),
        ])
        stackView.addArrangedSubview(topPaddingView)
        
        let header = NSTextField(labelWithString: "天使动漫")
        stackView.addArrangedSubview(header)
        
        let line = NSBox()
        line.boxType = .separator
        stackView.addArrangedSubview(line)
        
        if viewModel.payable, let cost = viewModel.cost {
            let payContainerView = NSView()
            payContainerView.wantsLayer = true
            payContainerView.layer?.masksToBounds = false
            
            let payTitle = NSTextField(labelWithString: "购买主题: \(cost) 天使币")
            payTitle.maximumNumberOfLines = 1
            payTitle.translatesAutoresizingMaskIntoConstraints = false
            payContainerView.addSubview(payTitle)
            
            let payButton = NSButton(title: "购买", target: self, action: #selector(SafariExtensionViewController.payButtonPressed(_:)))
            payButton.setButtonType(.momentaryPushIn)
            payButton.bezelStyle = .roundRect
            payButton.translatesAutoresizingMaskIntoConstraints = false
            payContainerView.addSubview(payButton)
            
            NSLayoutConstraint.activate([
                payTitle.topAnchor.constraint(equalTo: payContainerView.topAnchor),
                payTitle.leadingAnchor.constraint(equalTo: payContainerView.leadingAnchor),
                payTitle.bottomAnchor.constraint(equalTo: payContainerView.bottomAnchor),
                payButton.leadingAnchor.constraint(equalTo: payTitle.trailingAnchor, constant: 4),
                payContainerView.trailingAnchor.constraint(equalTo: payButton.trailingAnchor, constant: 4),
                payButton.centerYAnchor.constraint(equalTo: payTitle.centerYAnchor),
            ])
            payButton.setContentHuggingPriority(.required, for: .horizontal)

            payContainerView.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(payContainerView)
            NSLayoutConstraint.activate([
                payContainerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
                payContainerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            ])
        }
        
        if viewModel.respondable {
            let replyContainerView = NSView()
            replyContainerView.wantsLayer = true
            replyContainerView.layer?.masksToBounds = false
            
            let replyTitle = NSTextField(labelWithString: "回复主题")
            replyTitle.maximumNumberOfLines = 1
            replyTitle.translatesAutoresizingMaskIntoConstraints = false
            replyContainerView.addSubview(replyTitle)
            
            let replyButton = NSButton(title: "回复", target: self, action: #selector(SafariExtensionViewController.replyButtonPressed(_:)))
            replyButton.setButtonType(.momentaryPushIn)
            replyButton.bezelStyle = .roundRect
            replyButton.translatesAutoresizingMaskIntoConstraints = false
            replyContainerView.addSubview(replyButton)
            
            NSLayoutConstraint.activate([
                replyTitle.topAnchor.constraint(equalTo: replyContainerView.topAnchor),
                replyTitle.leadingAnchor.constraint(equalTo: replyContainerView.leadingAnchor),
                replyTitle.bottomAnchor.constraint(equalTo: replyContainerView.bottomAnchor),
                replyButton.leadingAnchor.constraint(equalTo: replyTitle.trailingAnchor, constant: 4),
                replyContainerView.trailingAnchor.constraint(equalTo: replyButton.trailingAnchor, constant: 4),
                replyButton.centerYAnchor.constraint(equalTo: replyTitle.centerYAnchor),
            ])
            replyButton.setContentHuggingPriority(.required, for: .horizontal)
            
            replyContainerView.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(replyContainerView)
            NSLayoutConstraint.activate([
                replyContainerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
                replyContainerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            ])
        }
        
        let baiduYunStackView = NSStackView()
        baiduYunStackView.orientation = .vertical
        tsdm?.baiduYuns
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { baiduYuns in
                // cleanup
                for subview in baiduYunStackView.subviews {
                    baiduYunStackView.removeArrangedSubview(subview)
                    subview.removeFromSuperview()
                }

                // insert new views
                baiduYuns
                    .map { info -> PopoverControlEntryView in
                        let entryView = PopoverControlEntryView()
                        entryView.title.stringValue = "百度网盘：\(info.code)"
                        entryView.button.title = "下载"
                        entryView.userInfo["TSDM.BaiduYun"] = info
                        entryView.delegate = self
                        return entryView
                    }
                    .forEach { containerView in
                        baiduYunStackView.addArrangedSubview(containerView)

                        containerView.translatesAutoresizingMaskIntoConstraints = false
                        baiduYunStackView.addArrangedSubview(containerView)
                        NSLayoutConstraint.activate([
                            containerView.leadingAnchor.constraint(equalTo: baiduYunStackView.leadingAnchor),
                            containerView.trailingAnchor.constraint(equalTo: baiduYunStackView.trailingAnchor),
                        ])
                    }
            })
            .store(in: &disposeBag)

        stackView.addArrangedSubview(baiduYunStackView)
        NSLayoutConstraint.activate([
            baiduYunStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            baiduYunStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
        ])
        
        // #if DEBUG
        // let debugLabel = NSTextField(labelWithString: "1")
        // stackView.addArrangedSubview(debugLabel)
        // #endif
    }
    
    func configure(with viewModel: AppleDeveloper) {
        os_log("^ %{public}s[%{public}ld], %{public}s: %{public}s", ((#file as NSString).lastPathComponent), #line, #function, viewModel.debugDescription)
        
        appleDeveloper = viewModel
        
        let topPaddingView = NSView()
        topPaddingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topPaddingView.heightAnchor.constraint(equalToConstant: 4),
        ])
        stackView.addArrangedSubview(topPaddingView)
        
        let header = NSTextField(labelWithString: "Apple Developer")
        stackView.addArrangedSubview(header)
        
        let line = NSBox()
        line.boxType = .separator
        stackView.addArrangedSubview(line)
        
        if let releaseNote = viewModel.releaseNote {
            let entryView = PopoverControlEntryView()
            entryView.title.stringValue = releaseNote.title
            entryView.button.title = "下载"
            entryView.userInfo["AppleDeveloper.ReleaseNote"] = releaseNote
            entryView.delegate = self
            
            entryView.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(entryView)
            NSLayoutConstraint.activate([
                entryView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
                entryView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            ])
        }
    }
    
    func finishConfigure() {
        let constant: CGFloat = stackView.arrangedSubviews.isEmpty ? 20 : 4
        
        let bottomPaddingView = NSView()
        bottomPaddingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomPaddingView.heightAnchor.constraint(equalToConstant: constant),
        ])
        stackView.addArrangedSubview(bottomPaddingView)
    }
    
}

// MARK: - PopoverControlEntryViewDelegate
extension SafariExtensionViewController: PopoverControlEntryViewDelegate {
    
    func popoverControlEntryView(_ view: PopoverControlEntryView, buttonDidPressed button: NSButton) {
        os_log("^ %{public}s[%{public}ld], %{public}s", ((#file as NSString).lastPathComponent), #line, #function)

        defer {
            dismissPopover()
        }
        
        if let baiduYun = view.userInfo["TSDM.BaiduYun"] as? TSDM.BaiduYun {
            SFSafariApplication.getActiveWindow { window in
                guard let window = window else { return }
                window.openTab(with: baiduYun.link, makeActiveIfPossible: true) { tab in
                    // do nothing
                }
            }
        }
        
        if let releaseNote = view.userInfo["AppleDeveloper.ReleaseNote"] as? AppleDeveloper.ReleaseNote {
            let savePanel = NSSavePanel()
            savePanel.allowedFileTypes = ["txt"]
            savePanel.nameFieldStringValue = releaseNote.title
            savePanel.showsTagField = false
            savePanel.begin { response in
                os_log("^ %{public}s[%{public}ld], %{public}s: save response: %{public}s", ((#file as NSString).lastPathComponent), #line, #function, String(describing: response))
                
                if response == .OK, let destinationURL = savePanel.url {
                    try? releaseNote.content.write(to: destinationURL, atomically: true, encoding: .utf8)
                }
            }
        }
    }
    
}
