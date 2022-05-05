//
//  KeyInfoVC.swift
//  FlexiPassApp
//
//  Created by Kyaw Zay Ya Lin Tun on 5/4/22.
//

import UIKit
import KeychainSwift
import FlexipassSDK
import PKHUD

class KeyInfoVC: UIViewController {

    @IBOutlet weak var lblKeyCode: UILabel!
    @IBOutlet weak var lblDoor: UILabel!
    @IBOutlet weak var lblCheckIn: UILabel!
    @IBOutlet weak var lblCheckOut: UILabel!
    @IBOutlet weak var btnUnlock: UIButton!
    
    private var flexipassManager: FlexipassManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1.
        flexipassManager = .shared
        flexipassManager.delegate = self
        flexipassManager.revokeKeyDelegate = self
        if let keyInfo = flexipassManager.getKeyInfo() {
            showData(keyInfo: keyInfo)
        }
        // 2.
        setupInteractions()
        // temp
    }
    
    
    // MARK: - Set up funcs
    private func showData(keyInfo: KeyInfo) {
        lblKeyCode.text = keyInfo.keyCode
        lblDoor.text = keyInfo.door
        lblCheckIn.text = keyInfo.checkIn
        lblCheckOut.text = keyInfo.checkOut
    }
  
    private func setupInteractions() {
        btnUnlock.addTarget(self, action: #selector(handleBtnTapped), for: .touchUpInside)
    }
    
    private func openKeySetupScreen() {
        guard let vc = UIStoryboard.AddMobileKeyScreen() else {
            return
        }
        self.replaceRootViewController(with: vc)
    }
    
    @objc private func handleBtnTapped() {
        guard let vc = UIStoryboard.UnlockHotelKeyScreen() else { return }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @IBAction func handleRevokeKey(_ sender: Any) {
        showLoading()
        flexipassManager.terminateMobileKey()
    }
    
}

extension KeyInfoVC: FlexipassManagerDelegate, RevokeKeyDelegate {
  
    func didStartUpSuccess() {
        showLoading()
        flexipassManager.updateMobileKey()
    }
    
    func didStartUpFailed(error: String) {
        showAlert(title: "Error", message: error)
    }
    
    func didSetupNotCompleted(error: String) {
        flexipassManager.clearKeyInfo()
        openKeySetupScreen()
    }
    
    func didUpdateSuccess() {
        hideLoading()
    }
    
    func didTerminated() {
        hideLoading()
        showAlert(title: "Success", message: "Key is revoked!", onAction: { [weak self] in
            self?.flexipassManager.clearKeyInfo()
            self?.openKeySetupScreen()
        })
    }
    
    func didFailed(error: String) {
        hideLoading()
        showAlert(title: "Error", message: error)
    }
}
