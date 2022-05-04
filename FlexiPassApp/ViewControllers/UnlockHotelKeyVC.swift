//
//  UnlockHotelKeyVC.swift
//  FlexiPassApp
//
//  Created by Kyaw Zay Ya Lin Tun on 5/3/22.
//

import UIKit

class UnlockHotelKeyVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var btnUnlockDoor: UIButton!
    @IBOutlet weak var spinnerView: SpinnerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        btnUnlockDoor.layer.cornerRadius = btnUnlockDoor.frame.width / 2
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(handleCloseBarButtonTapped))
            
        // Delete later
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.spinnerView.startSpinning()
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.spinnerView.stopSpinning()
            }
        }
    }
    
    @objc private func handleCloseBarButtonTapped() {
        self.dismiss(animated: true)
    }
}
