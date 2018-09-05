//
//  EmptyView.swift
//  10.2 Video Fix
//
//  Created by Tim Roesner on 8/30/18.
//  Copyright © 2018 Tim Roesner. All rights reserved.
//

import UIKit

class EmptyView: UIView {
    
    var title = UILabel()
    var sub = UILabel()
    
    func setup(title:String, subtitle:String) -> UIView {
        self.title.text = title
        self.title.font = UIFont.boldSystemFont(ofSize: 36)
        self.title.textAlignment = .center
        self.title.translatesAutoresizingMaskIntoConstraints = false
        
        self.sub.text = subtitle
        self.sub.font = UIFont.preferredFont(forTextStyle: .callout)
        self.sub.textAlignment = .center
        self.sub.translatesAutoresizingMaskIntoConstraints = false
        
        let titleSize = self.title.sizeThatFits(CGSize())
        let subSize = self.sub.sizeThatFits(CGSize())
        
        addSubview(self.title)
        addSubview(self.sub)
        
        self.title.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.title.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.title.widthAnchor.constraint(equalToConstant: titleSize.width).isActive = true
        self.title.heightAnchor.constraint(equalToConstant: titleSize.height).isActive = true
        
        self.sub.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.sub.topAnchor.constraint(equalTo: self.title.bottomAnchor, constant: 6).isActive = true
        self.sub.widthAnchor.constraint(equalToConstant: subSize.width).isActive = true
        self.sub.heightAnchor.constraint(equalToConstant: subSize.height).isActive = true
        
        return self
    }

}
