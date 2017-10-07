//
//  ViewRapViewController.swift
//  PhatAndPhresh
//
//  Created by Arthur De Araujo on 10/7/17.
//  Copyright © 2017 Arthur De Araujo. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import AudioToolbox

class ViewRapViewController: UIViewController {

    @IBOutlet var textView: UITextView!
    @IBOutlet var activityIndicator: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - ViewRapViewController

    func setupTextView(rapBars:String){
        textView.text = rapBars
    }
    
    // MARK: - Actions

    @IBAction func pressedShareButton(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()

        // set up activity view controller
        let textToShare = [ "Check out my phresh rap bars generated from Phat & Phresh! \n\n" + textView.text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        // present the view controller
        activityIndicator.startAnimating()
        self.present(activityViewController, animated: true, completion: {
            self.activityIndicator.stopAnimating()
        })
    }
    
    @IBAction func pressedPlayButton(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    @IBAction func pressedExitButton(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        self.dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
