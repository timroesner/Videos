//
//  ColorCompatibility.swift
//  10.2 Video Fix
//
//  Created by Tim on 6/21/19.
//  Copyright © 2019 Tim Roesner. All rights reserved.
//

import UIKit

enum ColorCompatibility {
    static var label: UIColor {
        if #available(iOS 13, *) {
            return .label
        }
        return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    }
	
    static var secondaryLabel: UIColor {
        if #available(iOS 13, *) {
            return .secondaryLabel
        }
        return UIColor(red: 0.23529411764705882, green: 0.23529411764705882, blue: 0.2627450980392157, alpha: 0.6)
    }
	
	static var systemBackground: UIColor {
		if #available(iOS 13, *) {
			return .systemBackground
		}
		return .white
	}
}
