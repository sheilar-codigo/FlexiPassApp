//
//  UIStoryboard+Extension.swift
//  FlexiPassApp
//
//  Created by Kyaw Zay Ya Lin Tun on 5/3/22.
//

import UIKit

extension UIStoryboard {
    
    enum Storyboard: String {
        case MainStoryboard = "Main"
        
        public func instance(_ vc: String) -> UIViewController {
            return UIStoryboard(name: self.rawValue, bundle: Bundle.main).instantiateViewController(withIdentifier: vc)
        }
    }
    
    class func AddMobileKeyScreen() -> AddMobileKeyVC? {
        return Storyboard.MainStoryboard.instance(AddMobileKeyVC.className) as? AddMobileKeyVC
    }
    
    class func UnlockHotelKeyScreen() -> UnlockHotelKeyVC? {
        return Storyboard.MainStoryboard.instance(UnlockHotelKeyVC.className) as? UnlockHotelKeyVC
    }
    
    class func KeyInfoScreen() -> KeyInfoVC? {
        return Storyboard.MainStoryboard.instance(KeyInfoVC.className) as? KeyInfoVC
    }
    
}
