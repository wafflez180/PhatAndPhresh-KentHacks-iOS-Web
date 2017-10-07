//
//  ViewController.swift
//  PhatAndPhresh
//
//  Created by Arthur De Araujo on 10/6/17.
//  Copyright © 2017 Arthur De Araujo. All rights reserved.
//

import UIKit
import Pulsator

class ViewController: UIViewController {
    
    @IBOutlet var buttonContainerView: UIView!
    @IBOutlet var generateButton: GenerateButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: ViewController
    
    func setupUI(){
        setGradientBackground();
        createPulsingHalo();
    }
    
    func createPulsingHalo(){
        let pulsator = Pulsator()
        pulsator.frame = buttonContainerView.frame
        buttonContainerView.layer.addSublayer(pulsator)
        pulsator.radius = buttonContainerView.frame.size.width
        pulsator.backgroundColor = generateButton.backgroundColor?.cgColor
        pulsator.start()
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 226.0/255.0, green: 255.0/255.0, blue: 233.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorBottom]
        gradientLayer.locations = [ 0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

