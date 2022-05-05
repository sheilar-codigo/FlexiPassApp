//
//  SpinnerView.swift
//  FlexiPassApp
//
//  Created by Kyaw Zay Ya Lin Tun on 5/3/22.
//

import UIKit

class SpinnerView: UIView {
    
    @IBOutlet weak var spinnerContainerView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupView()
    }
    
    private func setupView() {
        let view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.backgroundColor = .clear
        
        addSubview(view)
        self.isHidden = true
    }
    
    func startSpinning() {
        activityIndicator.startAnimating()
        self.isHidden = false
    }
    
    func stopSpinning() {
        activityIndicator.stopAnimating()
        self.isHidden = true
    }
}
