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
import Alamofire

protocol ViewRapVCDelegate: class {
    func dismissingVC()
}

class ViewRapViewController: UIViewController {
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var activityIndicator: NVActivityIndicatorView!
    @IBOutlet var trashButton: UIButton!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    weak var delegate: ViewRapVCDelegate?
    
    var savedIndex:Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - ViewRapViewController
    
    func setupUI(rapBars:String, isSavedRap:Bool, savedIndex:Int){
        setupTextView(rapBars: rapBars)
        playButton.isHidden = isSavedRap
        saveButton.isHidden = isSavedRap
        trashButton.isHidden = !isSavedRap
        self.savedIndex = savedIndex
    }
    
    func setupTextView(rapBars:String){
        textView.attributedText = getHighlightedText(rapBars: rapBars, rhymedWords: [])
    }
    
    func getHighlightedText(rapBars:String, rhymedWords:[String]) -> NSMutableAttributedString {
        let attributedText = NSMutableAttributedString.init(string: rapBars, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20.0), NSAttributedStringKey.foregroundColor: UIColor.init(red: 74.0/255.0, green: 74.0/255.0, blue: 74.0/255.0, alpha: 1.0)])
        
        //https://stackoverflow.com/questions/27180184/color-all-occurrences-of-string-in-swift/27180679
        for rhyme in rhymedWords {
            let inputLength = attributedText.length
            let searchString = rhyme
            let searchLength = searchString.characters.count
            var range = NSRange(location: 0, length: attributedText.length)
            
            while (range.location != NSNotFound) {
                range = (attributedText.string as NSString).range(of: searchString, options: [], range: range)
                if (range.location != NSNotFound) {
                    attributedText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.init(red: 248.0/255.0, green: 231.0/255.0, blue: 28.0/255.0, alpha: 1.0) , range: NSRange(location: range.location, length: searchLength))
                    range = NSRange(location: range.location + range.length, length: inputLength - (range.location + range.length))
                }
            }
        }
        return attributedText
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
        if !self.activityIndicator.isAnimating {
            self.activityIndicator.startAnimating()
            self.playButton.isEnabled = false
        }
        requestRap { newRapBars in
            self.textView.attributedText = self.getHighlightedText(rapBars: self.textView.text+"\n"+newRapBars, rhymedWords: [])
            self.activityIndicator.stopAnimating()
            self.playButton.isEnabled = true
        }
    }
    
    @IBAction func pressedExitButton(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        self.dismiss(animated: true)
    }
    
    @IBAction func pressedTrashButton(_ sender: Any) {
        let defaults = UserDefaults.standard
        var savedTitlesArray = defaults.stringArray(forKey: "SavedRapTitles") ?? [String]()
        var savedRapsArray = defaults.stringArray(forKey: "SavedRapBars") ?? [String]()
        
        savedTitlesArray.remove(at: savedIndex)
        savedRapsArray.remove(at: savedIndex)
        
        defaults.set(savedTitlesArray, forKey: "SavedRapTitles")
        defaults.set(savedRapsArray, forKey: "SavedRapBars")
        
        self.delegate?.dismissingVC()
        self.dismiss(animated: true)
    }
    
    @IBAction func pressedSaveButton(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        let defaults = UserDefaults.standard
        var savedTitlesArray = defaults.stringArray(forKey: "SavedRapTitles") ?? [String]()
        var savedRapsArray = defaults.stringArray(forKey: "SavedRapBars") ?? [String]()
        
        // Add title and rap bars
        getRapBarTitle { title in
            var savedTitle:String = title
            if title == "" {
                savedTitle = "Dope Rap #" + String(savedTitlesArray.count+1)
            }
            
            savedTitlesArray.append(savedTitle)
            savedRapsArray.append(self.textView.text)
            
            defaults.set(savedTitlesArray, forKey: "SavedRapTitles")
            defaults.set(savedRapsArray, forKey: "SavedRapBars")
            
            self.delegate?.dismissingVC()
            self.dismiss(animated: true)
        }
    }
    
    func getRapBarTitle(completion: @escaping (_ result: String) -> Void){
        let alertController = UIAlertController(title: "Save Rap Bars", message: "Please type the title of this verse.", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            print("Title: \(String(describing: firstTextField.text))")
            completion(firstTextField.text!)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Verse Title"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - API
    
    func requestRap(completion: @escaping (_ result: String) -> Void) {
        Alamofire.request("http://phatandphresh.azurewebsites.net/api/phresh").responseJSON { response in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
                completion(utf8Text)
            }
        }
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
