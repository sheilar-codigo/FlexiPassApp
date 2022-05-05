//
//  UnlockHotelKeyVC.swift
//  FlexiPassApp
//
//  Created by Kyaw Zay Ya Lin Tun on 5/3/22.
//

import UIKit
import FlexipassSDK
import CoreBluetooth

class UnlockHotelKeyVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var btnUnlockDoor: UIButton!
    @IBOutlet weak var spinnerView: SpinnerView!
    
    private var currentButtonState: ButtonState? {
        willSet {
            handleButtonStyle(basedOn: newValue)
        }
    }
    
    private var flexipass: Flexipass!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupFlexipass()
        setupInteractions()
    }
    
    // MARK: - Set up funcs
    private func setupView() {
        currentButtonState = .neutral
        btnUnlockDoor.layer.cornerRadius = btnUnlockDoor.frame.width / 2
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(handleCloseBarButtonTapped))
    }
    
    private func setupFlexipass() {
        flexipass = FlexipassManager.shared.flexipass
        flexipass.delegate = self
    }
    
    private func setupInteractions() {
        btnUnlockDoor.addTarget(self, action: #selector(handleKeyUnlock), for: .touchUpInside)
    }
    
    // MARK: - Action Handlers
    @objc private func handleKeyUnlock() {
        guard let currentButtonState = currentButtonState else {
            return
        }
        
        let manager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey : false])
        guard manager.authorization == .allowedAlways else {
            showAlert(title: "\"FlexiPassApp\" Would Like to Use Bluetooth", message: "We need to use your bluetooth to open the door.")
            return
        }

        switch currentButtonState {
        case .neutral:
            startUnlocking()
        case .unlocking:
            stopUnlocking()
        default:
            ()
        }
    }
    
    @objc private func handleCloseBarButtonTapped() {
        self.dismiss(animated: true)
    }
    
    // MARK: - Private Helpers
    private func startUnlocking() {
        flexipass.startReader()
        currentButtonState = .unlocking
    }
    
    private func stopUnlocking() {
        flexipass.stopReader()
        currentButtonState = .neutral
    }
    
    private func handleButtonStyle(basedOn state: ButtonState?) {
        guard let state = state else { return }
        switch state {
        case .neutral:
            btnUnlockDoor.backgroundColor = .systemBlue
            btnUnlockDoor.setTitle("Unlock Door", for: .normal)
        case .unlocking:
            btnUnlockDoor.backgroundColor = .systemGray
            btnUnlockDoor.setTitle("Cancel", for: .normal)
        case .completed(let success):
            btnUnlockDoor.backgroundColor = success ? .systemGreen : .systemRed
            btnUnlockDoor.setTitle(
                success ? "Door opened!" : "Failed!",
                for: .normal
            )
        }
    }
}

extension UnlockHotelKeyVC {
    enum ButtonState {
        case neutral
        case unlocking
        case completed(Bool)
    }
}

extension UnlockHotelKeyVC: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
    }
}

extension UnlockHotelKeyVC: FlexipassCallbackDelegate {
    func callback_listener(_ fpco: FlexipassCallbackObject) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            switch fpco.result {
            case .reader_stared:
                self.spinnerView.startSpinning()
                print("Start reading...")
            case .reader_stopped:
                self.spinnerView.stopSpinning()
                print("Reading stop")
            case .lock_opened:
                self.currentButtonState = .completed(true)
                self.spinnerView.stopSpinning()
                print("Door lock is opened. You can now go into the room 🥳.")
            case .lock_failed:
                self.currentButtonState = .completed(false)
                self.spinnerView.stopSpinning()
                print("Sorry! Can't open this lock 😣.")
                self.showAlert(message: "Sorry! Can't open this lock 😣.")
            case .lock_timed_out:
                self.currentButtonState = .completed(false)
                self.spinnerView.stopSpinning()
                print("Lock timeout error ⚠️.")
                self.showAlert(message: "Lock timeout error ⚠️.")
            case .lock_busy:
                self.currentButtonState = .completed(false)
                self.spinnerView.stopSpinning()
                print("Lock is busy error ⚠️.")
                self.showAlert(message: "Lock is busy error ⚠️.")
            case .lock_reader_failure:
                self.currentButtonState = .completed(false)
                self.spinnerView.stopSpinning()
                print("Lock reading process failed ⚠️.")
                self.showAlert(message: "Lock reading process failed ⚠️.")
            default:
                ()
            }
        }
    }

}
