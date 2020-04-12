//
//  SafariExtensionViewController.swift
//  SafraCrab Extension
//
//  Created by Cirno MainasuK on 2020-4-12.
//  Copyright © 2020 MainasuK. All rights reserved.
//

import SafariServices
import CommonOSLog

class SafariExtensionViewController: SFSafariExtensionViewController {
    
    var tsdm: TSDM?
    
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

}

extension SafariExtensionViewController {
    
    @objc private func payButtonPressed(_ sender: NSButton) {
        guard let tsdm = self.tsdm else { return }
        os_log("^ %{public}s[%{public}ld], %{public}s: pay %{public}s", ((#file as NSString).lastPathComponent), #line, #function, tsdm.debugDescription)
        
        tsdm.page?.dispatchMessageToScript(withName: "TSDM", userInfo: ["action": "pay"])
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
        
        tsdm = nil
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
        // header.font = NSFont.systemFont(ofSize: 14, weight: .medium)
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
        
        let bottomPaddingView = NSView()
        bottomPaddingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomPaddingView.heightAnchor.constraint(equalToConstant: 4),
        ])
        stackView.addArrangedSubview(bottomPaddingView)
    }
    
}
