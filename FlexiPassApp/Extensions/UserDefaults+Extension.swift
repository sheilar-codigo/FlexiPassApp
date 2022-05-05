//
//  UserDefaults+Extension.swift
//  FlexiPassApp
//
//  Created by Kyaw Zay Ya Lin Tun on 5/5/22.
//

import SwiftyUserDefaults

extension DefaultsKeys {
    var isFirstLaunch: DefaultsKey<Bool> { .init("isFirstLaunch", defaultValue: true) }
}
