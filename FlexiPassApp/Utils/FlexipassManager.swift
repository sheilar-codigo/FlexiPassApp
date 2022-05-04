//
//  FlexipassManager.swift
//  FlexiPassApp
//
//  Created by Kyaw Zay Ya Lin Tun on 5/4/22.
//

import Foundation
import FlexipassSDK

final class FlexipassManager {
    
    static let shared = FlexipassManager()
    
    public let flexipass: Flexipass
    
    private init() {
        flexipass = Flexipass()
        
    }
}
