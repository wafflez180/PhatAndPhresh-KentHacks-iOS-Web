//
//  ViewController.swift
//  PhatAndPhresh
//
//  Created by Arthur De Araujo on 10/6/17.
//  Copyright © 2017 Arthur De Araujo. All rights reserved.
//

import UIKit
import Pulsator
import Spring
import NVActivityIndicatorView
import JTMaterialTransition

class ViewController: UIViewController {
    
    @IBOutlet var buttonContainerView: SpringView!
    @IBOutlet var generateButton: GenerateButton!
    @IBOutlet var activityIndicator: NVActivityIndicatorView!
    
    @IBOutlet var generateBWidthConstraint: NSLayoutConstraint!
    @IBOutlet var generateBHeightConstraint: NSLayoutConstraint!
    
    let repeatedPulsator = Pulsator()
    var transition: JTMaterialTransition?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.transition = JTMaterialTransition(animatedView: self.generateButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: ViewController
    
    func setupUI(){
        setupGradientBackground()
        createPulsingHalo()
    }
    
    func createPulsingHalo(){
        repeatedPulsator.frame = CGRect(x: buttonContainerView.frame.size.width/2, y: buttonContainerView.frame.size.height/2, width: 0, height: 0)
        buttonContainerView.layer.insertSublayer(repeatedPulsator, at: 0)
        repeatedPulsator.radius = buttonContainerView.frame.size.width
        repeatedPulsator.backgroundColor = generateButton.backgroundColor?.cgColor
        repeatedPulsator.numPulse = 2
        repeatedPulsator.start()
    }
    
    func setupGradientBackground() {
        let colorTop =  UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 226.0/255.0, green: 255.0/255.0, blue: 233.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorBottom]
        gradientLayer.locations = [ 0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func createSinglePulse(){
        let pulsator = Pulsator()
        pulsator.frame = CGRect(x: buttonContainerView.frame.size.width/2, y: buttonContainerView.frame.size.height/2, width: 0, height: 0)
        buttonContainerView.layer.insertSublayer(pulsator, at: 1)
        pulsator.radius = buttonContainerView.frame.size.width+10
        pulsator.backgroundColor = generateButton.backgroundColor?.cgColor
        pulsator.repeatCount = 0
        pulsator.animationDuration = 1.5
        pulsator.autoRemove = true
        pulsator.start()
    }
    
    func segueToRapVC(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ViewRapViewController")
        
        controller.view.backgroundColor = generateButton.backgroundColor
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self.transition
        
        self.present(controller, animated: true, completion: {
            self.activityIndicator.stopAnimating()
            self.repeatedPulsator.start()
            self.generateButton.setTitle("Give me some phat bars", for: .normal)
        })
    }
    
    // MARK: Actions
    
    @IBAction func pressedDownOnGenerate(_ sender: Any) {
        generateButton.scaleX = 0.8
        generateButton.scaleY = 0.8
        generateButton.animate()
    }
    
    @IBAction func pressedGenerateButton(_ sender: Any) {
        createSinglePulse()
        generateButton.setTitle("", for: .normal)
        repeatedPulsator.stop()
        if !activityIndicator.isAnimating {
            activityIndicator.startAnimating()
        }
        segueToRapVC()
    }
}

