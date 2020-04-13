//
//  TSDMBaiduYunEntryView.swift
//  SafraCrab Extension
//
//  Created by Cirno MainasuK on 2020-4-14.
//  Copyright © 2020 MainasuK. All rights reserved.
//

import Cocoa

final class PopoverControlEntryView: NSView {
    
    let title: NSTextField = {
        let textField = NSTextField(labelWithString: "百度网盘: -")
        textField.maximumNumberOfLines = 1
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let button: NSButton = {
        let button = NSButton(title: "", target: self, action: #selector(PopoverControlEntryView.buttonPressed(_:)))
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
    }
    
}

extension PopoverControlEntryView {
    
    @objc private func buttonPressed(_ sender: NSButton) {
        
    }
    
}
