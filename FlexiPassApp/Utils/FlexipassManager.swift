//
//  FlexipassManager.swift
//  FlexiPassApp
//
//  Created by Kyaw Zay Ya Lin Tun on 5/4/22.
//

import Foundation
import FlexipassSDK
import KeychainSwift

struct KeyInfo {
    let keyCode: String
    let door: String
    let checkIn: String
    let checkOut: String
}

protocol FlexipassManagerDelegate: AnyObject {
    func didStartUpSuccess()
    func didStartUpFailed(error: String)
    func didSetupNotCompleted(error: String)
}

protocol KeySetupDelegate: AnyObject {
    func didSuccess()
    func didFailed(error: String)
}

protocol DoorUnlockDelegate: AnyObject {
    func didUpdateFailed(error: String)
    func didUpdateSuccess()
    func didLockOpened()
    func didLockFailed(error: String)
    func didReaderStarted()
    func didReaderStopped()
    func didLoadReaderFailure(error: String)
    func didLockBusy()
    func didLockTimeout()
}

protocol RevokeKeyDelegate: AnyObject {
    func didUpdateSuccess()
    func didTerminated()
    func didFailed(error: String)
}

final class FlexipassManager {
    
    static let shared = FlexipassManager()
    
    private let flexipass: Flexipass
    private let keychain: KeychainSwift
    
    public weak var delegate: FlexipassManagerDelegate?
    public weak var setupDelegate: KeySetupDelegate?
    public weak var doorUnlockDelegate: DoorUnlockDelegate?
    public weak var revokeKeyDelegate: RevokeKeyDelegate?
    
    public var isStartUpFinished: Bool = false
    
    private init() {
        keychain = KeychainSwift()
        flexipass = Flexipass()
        flexipass.delegate = self
    }
    
    func updateMobileKey() {
        flexipass.updateMobileKey()
    }
    
    func terminateMobileKey() {
        flexipass.terminateMobileKey()
    }
    
    func startReader() {
        flexipass.startReader()
    }
    
    func stopReader() {
        flexipass.stopReader()
    }
    
    func clearKeyInfo() {
        keychain.clear()
    }
    
    func isSetupComplete() -> Bool {
        return flexipass.isSetupComplete()

    }
    
    func getKeyInfo() -> KeyInfo? {
        guard let keyCode = keychain.get(KeychainKeys.DIGITAL_KEY_CODE) else {
            return nil
        }
        
        let door = keychain.get(KeychainKeys.DIGITAL_KEY_ROOM) ?? ""
        let checkIn = keychain.get(KeychainKeys.DIGITAL_KEY_CHECKIN) ?? ""
        let checkOut = keychain.get(KeychainKeys.DIGITAL_KEY_CHECKOUT) ?? ""
        
        return KeyInfo(keyCode: keyCode,
                       door: door,
                       checkIn: checkIn,
                       checkOut: checkOut)
    }
    
    func useMobileKey(keyCode: String) {
        
        flexipass.useMobileKey(keyCode) { [weak self] keyInfo in
            self?.keychain.set(keyCode, forKey: KeychainKeys.DIGITAL_KEY_CODE)
            self?.keychain.set(keyInfo.doorID, forKey: KeychainKeys.DIGITAL_KEY_ROOM)
            self?.keychain.set(keyInfo.checkInDate, forKey: KeychainKeys.DIGITAL_KEY_CHECKIN)
            self?.keychain.set(keyInfo.checkOutDate, forKey: KeychainKeys.DIGITAL_KEY_CHECKOUT)
        } _: { [weak self] error in
            DispatchQueue.main.async {
                self?.setupDelegate?.didFailed(error: error.localizedDescription)
            }
        }
    }
}

// MARK: - FlexipassCallbackDelegate
extension FlexipassManager: FlexipassCallbackDelegate {
    func callback_listener(_ fpco: FlexipassCallbackObject) {
        DispatchQueue.main.async { [weak self] in
            
            switch fpco.result {
            case .startup_success:
                self?.isStartUpFinished = true 
                self?.delegate?.didStartUpSuccess()
                
            case .startup_failed:
                self?.delegate?.didStartUpFailed(error: "startup_failed")
                
            case .setup_success:
                self?.setupDelegate?.didSuccess()
                
            case .setup_failed:
                self?.setupDelegate?.didFailed(error: "setup_failed")
                
            case .update_success:
                self?.revokeKeyDelegate?.didUpdateSuccess()
                self?.doorUnlockDelegate?.didUpdateSuccess()
                print("key count: \(String(describing: self?.flexipass.mobileKeyCount()))")
                
            case .update_failed:
                self?.doorUnlockDelegate?.didUpdateFailed(error: "update_failed")
                self?.revokeKeyDelegate?.didFailed(error: "update_failed")
                
            case .terminated:
                self?.revokeKeyDelegate?.didTerminated()
                
            case .termination_failed:
                self?.revokeKeyDelegate?.didFailed(error: "termination_failed")
                
            case .lock_opened:
                self?.doorUnlockDelegate?.didLockOpened()
                
            case .lock_failed:
                self?.doorUnlockDelegate?.didLockFailed(error: "lock_failed")
                
            case .reader_stared:
                self?.doorUnlockDelegate?.didReaderStarted()
                
            case .reader_stopped:
                self?.doorUnlockDelegate?.didReaderStopped()
                
            case .lock_reader_failure:
                self?.doorUnlockDelegate?.didLoadReaderFailure(error: "lock_reader_failure")
                
            case .setupNotCompleted:
                print("setupNotCompleted")
                self?.delegate?.didSetupNotCompleted(error: "setupNotCompleted")
                
            default:
                break
            }
        }
    }
}
