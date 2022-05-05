//
//  ViewController.swift
//  FlexiPassApp
//
//  Created by Sheilar Codigo on 21/04/2022.
//

import UIKit
import SeosMobileKeysSDK
import FlexipassSDK
import SwiftyUserDefaults
import KeychainSwift

enum Toggle: Equatable {
    case show
    case hide
}

struct KeychainKeys {
    static let DIGITAL_KEY_CODE = "DIGITAL_KEY_CODE"
    static let DIGITAL_KEY_ROOM = "DIGITAL_KEY_ROOM"
    static let DIGITAL_KEY_CHECKIN = "DIGITAL_KEY_CHEKIN"
    static let DIGITAL_KEY_CHECKOUT = "DIGITAL_KEY_CHECKOUT"
}

class ViewController: UIViewController {

    private var keychain: KeychainSwift!
    private var flexipass: Flexipass!
    private var logs: [String] = []
    
    @IBOutlet weak var txtMobileKeyCode: UITextField!
    @IBOutlet weak var btnSetup: UIButton!
    @IBOutlet weak var btnOpenDoor: UIButton!
    @IBOutlet weak var lblLog: UILabel!
    @IBOutlet weak var keyInfoStackView: UIStackView!
    @IBOutlet weak var lblKeyInfo: UILabel!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var key: String {
        return txtMobileKeyCode.text ?? ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1.
        setupKeychain()
        setupFlexipass()
        setupInitUI()
        setupInteractions()
        // 2.
        if let keyCode = keychain.get(KeychainKeys.DIGITAL_KEY_CODE), !keyCode.isEmpty {
            showKeyInformationFromKeychain()
            showOrHideSetupKeyForm(.hide)
        } else {
            showOrHideSetupKeyForm(.show)
        }
    }
    
    private func showLoading() {
        loading.startAnimating()
    }

    private func hideLoading() {
        loading.stopAnimating()
    }
    
    private func setupFlexipass() {
        flexipass = Flexipass()
        flexipass.delegate = self
    }
    
    private func setupKeychain() {
        keychain = KeychainSwift()
    }
    
    private func setupInitUI() {
        hideLoading()
        keyInfoStackView.isHidden = true
        
        txtMobileKeyCode.text = ""
        txtMobileKeyCode.clearButtonMode = .whileEditing
        
        lblLog.text = ""
    }
    
    private func setupInteractions() {
        btnSetup.addTarget(self, action: #selector(handleSetup), for: .touchUpInside)
        btnOpenDoor.addTarget(self, action: #selector(handleOpenDoor), for: .touchUpInside)
        btnUpdate.addTarget(self, action: #selector(handleUpdateKey), for: .touchUpInside)
        btnRemove.addTarget(self, action: #selector(handleRemoveKey), for: .touchUpInside)
    }
    
    @objc func handleSetup() {
        guard let keyCode = txtMobileKeyCode.text else {
            return
        }
        showLoading()
        flexipass.useMobileKey(keyCode) { keyInfo in
            DispatchQueue.main.async { [weak self] in
                // 1. save
                self?.keychain.set(keyCode, forKey: KeychainKeys.DIGITAL_KEY_CODE)
                self?.keychain.set(keyInfo.doorID, forKey: KeychainKeys.DIGITAL_KEY_ROOM)
                self?.keychain.set(keyInfo.checkInDate, forKey: KeychainKeys.DIGITAL_KEY_CHECKIN)
                self?.keychain.set(keyInfo.checkOutDate, forKey: KeychainKeys.DIGITAL_KEY_CHECKOUT)
            }
        } _: { error in
            DispatchQueue.main.async { [weak self] in
                self?.hideLoading()
                self?.showAlert(message: error.localizedDescription)
            }
        }
    }
    
    @objc func handleOpenDoor() {
        showLoading()
        flexipass.startReader()
        flexipass.isSetupComplete()
    }
    
    @objc func handleUpdateKey() {
        showLoading()
        flexipass.updateMobileKey()
    }
    
    @objc func handleRemoveKey() {
        showLoading()
        flexipass.terminateMobileKey()
    }
    
    func showKeyInformationFromKeychain() {
        let keyCode = "Key Code: " + (keychain.get(KeychainKeys.DIGITAL_KEY_CODE) ?? "")
        let doorID = "Door: " + (keychain.get(KeychainKeys.DIGITAL_KEY_ROOM) ?? "")
        let checkIn = "Check In Date: " + (keychain.get(KeychainKeys.DIGITAL_KEY_CHECKIN) ?? "")
        let checkOut = "Check Out Date: " + (keychain.get(KeychainKeys.DIGITAL_KEY_CHECKOUT) ?? "")
        lblKeyInfo.text = keyCode + "\n" + doorID + "\n" + checkIn + "\n" + checkOut
    }
    
    func removeKeyInfoFromKeychain() {
        keychain.delete(KeychainKeys.DIGITAL_KEY_CODE)
        keychain.delete(KeychainKeys.DIGITAL_KEY_ROOM)
        keychain.delete(KeychainKeys.DIGITAL_KEY_CHECKIN)
        keychain.delete(KeychainKeys.DIGITAL_KEY_CHECKOUT)
    }
    
    func showOrHideSetupKeyForm(_ toggle: Toggle) {
        
        switch toggle {
        case .show:
            keyInfoStackView.isHidden = true
            btnOpenDoor.isHidden = true
            btnUpdate.isHidden = true
            btnRemove.isHidden = true
            
            // txtMobileKeyCode.isHidden = false
            // btnSetup.isHidden = false
            // txtMobileKeyCode.text = ""

        case .hide:
            keyInfoStackView.isHidden = false
            btnOpenDoor.isHidden = false
            btnUpdate.isHidden = false
            btnRemove.isHidden = false
            
            // txtMobileKeyCode.isHidden = true
            // btnSetup.isHidden = true
            // txtMobileKeyCode.resignFirstResponder()
        }
        
    }
    
//    func showAlert(message: String) {
//        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        self.present(alert, animated: true)
//    }
    
    func updateKeyReadyUI() {
        hideLoading()
        btnSetup.isHidden = true
        btnOpenDoor.isHidden = false
        
        btnUpdate.isHidden = false
        btnRemove.isHidden = false
    }
    
    func updateDoorOpenUI() {
        hideLoading()
        btnOpenDoor.isHidden = true
    }
}

extension ViewController: FlexipassCallbackDelegate {
    func callback_listener(_ fpco: FlexipassCallbackObject) {
        DispatchQueue.main.async { [weak self] in
                      
            print("FPC title: \(fpco.title)")
            switch fpco.result {
                
            case .setup_success:
                self?.handleUpdateKey()
                // 1.
                self?.hideLoading()
                self?.logs.append("Successfully setup the key on this device. Digital Key is ready to use ✅.")
                // 2. show
                self?.showKeyInformationFromKeychain()
                // 3.
                self?.showOrHideSetupKeyForm(.hide)

            case .setup_failed:
                self?.logs.append("Failed to setup the key. Can't use this Digital Key on this device ⚠️.")
                self?.btnOpenDoor.isHidden = true
                
            case .startup_success:
                self?.logs.append("Flexipass Setup Success ✅")
                
            case .startup_failed:
                self?.logs.append("Flexipass Setup Failed ⚠️.")
                
            case .update_success:
                self?.hideLoading()
                self?.logs.append("Key is updated successfully ✅.")
                
            case .update_failed:
                self?.hideLoading()
                self?.logs.append("Can't update key ⚠️.")
                
            case .reader_stared:
                self?.logs.append("Start reading...")
                
            case .reader_stopped:
                self?.logs.append("Reading stop")
        
            case .termination_failed:
                //mobile key not destoryed
                self?.logs.append("Can't destroy key. ‼️")
                
            case .setupNotCompleted, .terminated:
                //mobile key destoryed
                self?.logs.append("Key is successfully destroyed ✅.")
                self?.removeKeyInfoFromKeychain()
                self?.showOrHideSetupKeyForm(.show)
                self?.hideLoading()
                
            case .updateProcessAlreadyRunning:
                self?.logs.append("Update key....")
                
            case .lock_opened:
                self?.logs.append("Door lock is opened. You can now go into the room 🥳.")
                self?.updateDoorOpenUI()
                
            case .lock_failed:
                self?.logs.append("Sorry! Can't open this lock 😣.")
                self?.hideLoading()
                
            case .lock_timed_out:
                self?.logs.append("Lock timeout error ⚠️.")
                self?.hideLoading()
                
            case .lock_busy:
                self?.logs.append("Lock is busy error ⚠️.")
                self?.hideLoading()
                
            case .lock_reader_failure:
                self?.logs.append("Lock reading process failed ⚠️.")
                self?.hideLoading()
                
            @unknown default:
                self?.logs.append("Unknown error ⚠️.")
            }
            
            self?.lblLog.text = self?.logs.joined(separator: "\n")
        }
    }
    
}
