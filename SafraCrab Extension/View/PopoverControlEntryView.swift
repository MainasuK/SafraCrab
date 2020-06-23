//
//  TSDMBaiduYunEntryView.swift
//  SafraCrab Extension
//
//  Created by Cirno MainasuK on 2020-4-14.
//  Copyright © 2020 MainasuK. All rights reserved.
//

import Cocoa
import CommonOSLog

protocol PopoverControlEntryViewDelegate: class {
    func popoverControlEntryView(_ view: PopoverControlEntryView, buttonDidPressed button: NSButton)
}

final class PopoverControlEntryView: NSView {
    
    weak var delegate: PopoverControlEntryViewDelegate?
    
    var userInfo: [AnyHashable: Any] = [:]
    
    let title: NSTextField = {
        let textField = NSTextField(labelWithString: "-")
        textField.maximumNumberOfLines = 1
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let button: NSButton = {
        let button = NSButton()
        button.setButtonType(.momentaryPushIn)
        button.bezelStyle = .roundRect
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        _init()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        _init()
    }
    
    deinit {
        os_log("%{public}s[%{public}ld], %{public}s: deinit", ((#file as NSString).lastPathComponent), #line, #function)
    }
}

extension PopoverControlEntryView {
    
    private func _init() {
        wantsLayer = true
        layer?.masksToBounds = false
        
        title.translatesAutoresizingMaskIntoConstraints = false
        addSubview(title)
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor),
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 4),
            trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: 4),
            button.centerYAnchor.constraint(equalTo: title.centerYAnchor),
        ])
        
        button.setContentHuggingPriority(.required, for: .horizontal)
        
        button.target = self
        button.action = #selector(PopoverControlEntryView.buttonPressed(_:))
    }
    
}

extension PopoverControlEntryView {
    
    @objc private func buttonPressed(_ sender: NSButton) {
        os_log("^ %{public}s[%{public}ld], %{public}s", ((#file as NSString).lastPathComponent), #line, #function)
        delegate?.popoverControlEntryView(self, buttonDidPressed: sender)
    }
    
}
