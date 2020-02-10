//
//  DecryptHomePage.swift
//  iLocked
//
//  Created by Nathan on 30/08/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

class Decrypt: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var helpBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var sharePublicKeyButton: UIButton!
    @IBOutlet weak var helpAboutSharingButton: UIButton!
    @IBOutlet weak var textToEncryptView: UITextView!
    @IBOutlet weak var encryptButton: UIButton!
    @IBOutlet weak var leftItemButton : UIBarButtonItem!
    
    
    //Help views
    let helpTextLabel = UILabel()
    let helpView = UIView()
    let topBarView = UIView()
    let backgroundInfo = UIView()
    let gesture = UIPanGestureRecognizer()
    
    var textToDecryptViewErrorMessage = UIButton()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        viewConstruction()
        self.textToEncryptView.delegate = self
        
        //Call when the user tap once or twice on the home button
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector((moveHelpView)))
        self.helpView.addGestureRecognizer(gestureRecognizer)
    }
    
    
    
    
    //ferme le clavier au toucher
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func alert(_ title: String, message: String, quitMessage: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: quitMessage, style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }

    //
    // Views construction func
    //
    
    private func viewConstruction(){
        
        self.view.addSubview(self.backgroundInfo)
        self.backgroundInfo.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundInfo.heightAnchor.constraint(equalToConstant: self.view.frame.size.height).isActive = true
        self.backgroundInfo.widthAnchor.constraint(equalToConstant: self.view.frame.size.width).isActive = true
        self.backgroundInfo.centerYAnchor.constraint(equalToSystemSpacingBelow: self.view.centerYAnchor, multiplier: 1).isActive = true
        self.backgroundInfo.centerYAnchor.constraint(equalToSystemSpacingBelow: self.view.centerYAnchor, multiplier: 1).isActive = true
        self.backgroundInfo.backgroundColor = .opaqueSeparator
        self.backgroundInfo.isHidden = true
        
        self.sharePublicKeyButton.rondBorder()
        self.sharePublicKeyButton.backgroundColor = UIColor(red: 0.121, green: 0.13, blue: 0.142, alpha: 1)
        self.textToEncryptView.layer.borderColor = UIColor.lightGray.cgColor
        self.textToEncryptView.layer.borderWidth = 2
        self.textToEncryptView.layer.cornerRadius = 20
        self.textToDecryptViewErrorMessage.center = textToEncryptView.center
        self.textToDecryptViewErrorMessage.frame.size = self.textToEncryptView.frame.size
        self.textToDecryptViewErrorMessage.titleLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 18)
        self.textToDecryptViewErrorMessage.setTitleColor(.systemRed, for: .normal)
        self.textToDecryptViewErrorMessage.layer.cornerRadius = 15
        self.textToDecryptViewErrorMessage.layer.borderWidth = 1
        self.textToDecryptViewErrorMessage.layer.borderColor = UIColor.white.cgColor
        self.textToDecryptViewErrorMessage.backgroundColor = .white
        self.textToDecryptViewErrorMessage.isHidden = true
        self.textToDecryptViewErrorMessage.addTarget(self, action: #selector(textToDecryptErrorMessageSelected), for: .touchUpInside)
        
        //helpView :
        
        self.view.addSubview(self.helpView)
        self.helpView.frame.size.height = self.view.frame.size.height / 2
        self.helpView.frame.size.width = self.view.frame.size.width - 20
        self.helpView.frame.origin = CGPoint(x: self.view.frame.origin.x, y: 2000)
        self.helpView.layer.cornerRadius = 20
        self.helpView.backgroundColor = .black
        self.helpView.alpha = 1
        self.helpView.layer.borderColor = UIColor.white.cgColor
        self.helpView.layer.borderWidth = 4
        
        self.helpView.addSubview(self.topBarView)
        self.topBarView.translatesAutoresizingMaskIntoConstraints = false
        self.topBarView.centerXAnchor.constraint(equalToSystemSpacingAfter: self.helpView.centerXAnchor, multiplier: 1).isActive = true
        self.topBarView.topAnchor.constraint(equalToSystemSpacingBelow: self.helpView.topAnchor, multiplier: 2).isActive = true
        self.topBarView.widthAnchor.constraint(equalToConstant: self.helpView.frame.size.width / 4).isActive = true
        self.topBarView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        self.topBarView.backgroundColor = .white
        self.topBarView.layer.cornerRadius = 5
        
        self.helpView.addSubview(self.helpTextLabel)
        self.helpTextLabel.translatesAutoresizingMaskIntoConstraints = false
        self.helpTextLabel.widthAnchor.constraint(equalToConstant: self.helpView.frame.size.width - 20).isActive = true
        self.helpTextLabel.heightAnchor.constraint(equalToConstant: self.helpView.frame.size.height
             - 10).isActive = true
        self.helpTextLabel.centerXAnchor.constraint(equalToSystemSpacingAfter: self.helpView.centerXAnchor, multiplier: 1).isActive = true
        self.helpTextLabel.centerYAnchor.constraint(equalToSystemSpacingBelow: self.helpView.centerYAnchor, multiplier: 1).isActive = true
        self.helpTextLabel.numberOfLines = 20
        self.helpTextLabel.textAlignment = .justified
        self.helpTextLabel.font = UIFont(name: "American Typewriter", size: 16.0)
        self.helpTextLabel.textColor = .white
    }
    
    
    //
    //IBAction functions
    //
    
    @IBAction func decryptButton(_ sender: UIButton) {
        var isOk = true
        if textToEncryptView.text == "" || textToEncryptView.text == "Text to decrypt"{
            isOk = false
            alert("I don't really think decrypt an empty message is very useful ... 🧐", message: "", quitMessage: "Oh yeah sorry !")
        }
        
        if isOk {
            //Tests passé, on passe au décryptage:
            performSegue(withIdentifier: "showDecryptedText", sender: self)
        }
    }
    
    @IBAction func shareButtonSelected(sender: UIButton){
        if let publicKey: String = KeychainWrapper.standard.string(forKey: userPublicKeyId) {
            let activityViewController = UIActivityViewController(activityItems: ["\(publicKey)" as NSString], applicationActivities: nil)
            present(activityViewController, animated: true, completion: {})
        } else {
            alert("Impossible to access to your public key", message: "An error occur when trying to get the access to your public key", quitMessage: "Let's try again !")
        }
        
    }
    
    @IBAction func closeKeyboard(sender: UIBarButtonItem){ // left bar button item selected
        if sender.image == UIImage(systemName: "keyboard.chevron.compact.down"){
            self.view.endEditing(true)
        } else {//help asked
            self.showHelp(text: "To decrypt a message encrypt with your own public key, just copy and past the text in the field. Then click on the green key.\n\n A new window will be opened and will show the decrypted message. \n\n IMPORTANT : Be sure that the sender encrypted his message with your public key and be careful to copy the whole text. No more no less. Or it's gonna be wierd . . .")
        }
    }
    
    @IBAction func shareButtonHelp(sender: UIButton){
        self.showHelp(text: "Share your public key to your friend. Only this key can encrypt message that you'll be able to decrypt. \n\nUse an other key, including sender public key will return you an error if you try to decrypt the message.")
    }
    
    
 
    //
    // Text view Delegate func
    //
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.translatesAutoresizingMaskIntoConstraints = true
        self.helpBarButtonItem.image = UIImage(systemName: "keyboard.chevron.compact.down")
        self.leftItemButton.image = UIImage(systemName: "info.circle")
        self.leftItemButton.tintColor = .systemOrange
        
        textView.frame.origin.y = 10
        if textView.text == "Text to decrypt" {
            textView.text = ""
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView){
        textView.translatesAutoresizingMaskIntoConstraints = false
        self.helpBarButtonItem.image = UIImage(systemName: "info.circle")
        self.leftItemButton.image = nil
        
        if textView.text == "" {
            textView.text = "Text to decrypt"
            textView.textColor = .lightGray
        }
    }
    
    //
    // Objetctive C call func
    //
    
    @objc private func textToDecryptErrorMessageSelected(sender: UIButton){
        self.flip(firstView: textToDecryptViewErrorMessage, secondView: self.textToEncryptView)
    }
    
    /// Called by notification when the app is moves to background
    @objc private func appMovedToBackground(){
        performSegue(withIdentifier: "lockApp", sender: self)
    }
    
    @objc private func moveHelpView(sender: UIPanGestureRecognizer) {
        if sender.state == .began || sender.state == .changed { // On récupère les nouvelles données
            let translation = sender.translation(in: self.view)
            // note: 'view' is optional and need to be unwrapped
            sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
            
            print( self.view.center.x / sender.view!.center.x)
            sender.setTranslation(CGPoint.zero, in: self.view)
            if sender.view!.center.x > self.view.frame.size.width * (5/8) || sender.view!.center.x < self.view.frame.size.width * (3/8) || sender.view!.center.y < self.view.frame.size.height * (3/8) ||  sender.view!.center.y > self.view.frame.size.height * (5/8){
                sender.view!.layer.borderColor = UIColor.red.cgColor
            } else {
                sender.view!.layer.borderColor = UIColor.white.cgColor
            }
                
        } else if sender.state == .ended{
            let width: CGFloat = self.view.frame.size.width
            if sender.view!.center.x > width * (5/8) {
                self.closeHelp(sender: sender, x: 1000, y: 0)
            } else if sender.view!.center.x < width * (3/8){
                self.closeHelp(sender: sender, x: -1000, y: 0)
            } else if sender.view!.center.y < self.view.frame.size.height * (3/8){
                self.closeHelp(sender: sender, x: 0, y: -1000)
            } else if sender.view!.center.y > self.view.frame.size.height * (5/8){
                closeHelp(sender: sender, x: 0, y: 1000)
            } else {
                let animation = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
                    sender.view!.center = CGPoint(x: self.view.frame.size.width / 2 , y: self.view.frame.size.height / 2)
                })
                animation.startAnimation()
                sender.view!.layer.borderColor = UIColor.white.cgColor
            }
        }
    }
    
    
    //
    // Animationfunction
    //
    
    func flip(firstView : UIView, secondView: UIView) {
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]

        UIView.transition(with: firstView , duration: 1.0, options: transitionOptions, animations: {
            firstView.isHidden = true
        })

        UIView.transition(with: secondView, duration: 1.0, options: transitionOptions, animations: {
            secondView.isHidden = false
        })
    }
    
    func showHelp(text: String){
        self.helpView.layer.borderColor = UIColor.white.cgColor
        self.helpTextLabel.text = text
        let animator = UIViewPropertyAnimator(duration: 0.7, dampingRatio: 0.7, animations: {
            self.helpView.center = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.height / 2)
        })
        animator.startAnimation()
        self.backgroundInfo.isHidden = false
    }
    
    /// func which close help view shown
    /// - sender : contain the sender associated to the help view
    /// - x : the new x coordinate of the view. If it equals to 0, we consider that we don't have to change it
    /// - y : the new y coordinate of the view. If it equals to 0, we consider that we don't have to change it
    func closeHelp(sender: UIPanGestureRecognizer, x: CGFloat, y: CGFloat){
        let animation = UIViewPropertyAnimator(duration: 0.7, curve: .linear, animations: {
            if x != 0{
                sender.view!.frame.origin.x = x
            } else {
                sender.view!.frame.origin.x = y
            }
            
        })
        animation.startAnimation()
        self.backgroundInfo.isHidden = true
    }
    
    
    //
    // segue func
    //
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "lockApp"{
            let lockedView = segue.destination as! LockedView
            lockedView.activityInProgress = true
        } else if segue.identifier == "showDecryptedText"{
            let decryptedResultView = segue.destination as! DecryptedResult
            decryptedResultView.encryptedText = self.textToEncryptView.text
        }
    }
}
