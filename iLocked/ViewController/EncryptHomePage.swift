//
//  EncryptHomePage.swift
//  iLocked
//
//  Created by Nathan on 27/07/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import Foundation
import UIKit




class Encrypt: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate{
    
    
    @IBOutlet weak var publicKeyButton: UIButton!
    @IBOutlet weak var textToEncrypt: UITextView!
    @IBOutlet weak var keyList: UIPickerView!
    @IBOutlet weak var encryptButton: UIButton!
    @IBOutlet weak var senderView: UIView!
    @IBOutlet weak var chargement: UIActivityIndicatorView!
    @IBOutlet weak var littleHelpLabel : UILabel!
    @IBOutlet weak var shutDownKeyboard: UIBarButtonItem!
    @IBOutlet weak var lockAppButton: UIBarButtonItem!
    
    var keyArray: [String] = ["Add a key", "My encryption key"] // list of all names displayed on UIPIckerView
    var heightPicker: NSLayoutConstraint?
    var heightSender: NSLayoutConstraint?
    var titleButtonClean = ""
    var textEncrypted = "error"
    var nameArray: [String] = [] // list of all name saved
    
    //Data came from ShowKey.swift > encryptMessageSelected()
    var keyNameTransmitted = ""
    
    
    
    //Notification
    static let notificationName = Notification.Name("AddKeyDismissed")
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Observation des notiifcations
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived), name: Encrypt.notificationName, object: nil)
        
        //Récuperation des infos :
        loadData()
        
        self.publicKeyButton.rondBorder()
        self.textToEncrypt.rondBorder()
        self.keyList.delegate = self
        self.keyList.dataSource = self
        self.textToEncrypt.delegate = self
        
        self.senderView.translatesAutoresizingMaskIntoConstraints = false
        self.senderView.centerXAnchor.constraint(equalToSystemSpacingAfter: self.keyList.centerXAnchor, multiplier: 1).isActive = true
        self.senderView.centerYAnchor.constraint(equalToSystemSpacingBelow: self.keyList.centerYAnchor, multiplier: 1).isActive = true
        self.heightSender = self.senderView.heightAnchor.constraint(equalToConstant: 0)
        self.heightSender?.isActive = true
        
        if keyNameTransmitted != "" { //User already choose the key in ShowKey.swift's view
            self.publicKeyButton.setTitle("Use \(self.keyNameTransmitted)'s key", for: .normal)
            self.titleButtonClean = self.keyNameTransmitted
            self.selectKey(sender: self.publicKeyButton) // simulation of user's action
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //Call when the user tap once or twice on the home button
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        //Refresh data
        refreshData()
    }

    func alert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction private func selectKey(sender: UIButton){
        if sender.currentTitle == "Add a key" && self.textToEncrypt.isHidden { // The second part of this condition solve a bug
                performSegue(withIdentifier: "addKey", sender: nil)
        } else if (sender.currentTitle != "Select a public key" && !self.keyList.isHidden) || self.keyNameTransmitted != ""{ // if we choose our key or if the key has already been choosen
            self.keyList.isHidden = true
            self.littleHelpLabel.isHidden = true
            sender.setTitle(self.titleButtonClean, for: .normal)
            self.textToEncrypt.isHidden = false
            self.encryptButton.isEnabled = true
        } else if sender.currentTitle != "Select a public key" && self.keyList.isHidden{
            self.keyList.isHidden = false
            self.littleHelpLabel.isHidden = false
            sender.setTitle("Use \(self.titleButtonClean)", for: .normal)
            self.textToEncrypt.isHidden = true
            self.encryptButton.isEnabled = false
        } else {
            if self.keyList.isHidden {
                self.keyList.isHidden = false
                self.littleHelpLabel.isHidden = false
                sender.setTitle("Add a key", for: .normal)
            }
        }
        
    }
    
    public func loadData(){
        let data = KeyId()
        let keyName = data.getKeyName()
        print("key name recieved = \(keyName)")
        if keyName.count != 0{
            if keyName[0].contains("##ERROR##"){
                alert("Oups ! We got an error ! ", message: keyName[0])
            } else { // we don't have any error
                self.nameArray = keyName
                print("name array : \(nameArray)")
                for name in nameArray{
                    self.keyArray.append(name)
                }
            }
        } 
    }
    
    //
    // IBAction func
    //
    
    @IBAction private func encryptSelected(sender:UIButton){
        self.encryptButton.isEnabled = false
        if self.textToEncrypt.text == "" {
            self.textToEncrypt.layer.borderColor = UIColor.red.cgColor
        } else {
            sender.isEnabled = false
            self.publicKeyButton.isEnabled = false
            self.textToEncrypt.isEditable = false
            self.chargement.startAnimating()
            var keySaved: String? = nil
            if self.publicKeyButton.currentTitle! == "My encryption key"{
                keySaved = KeychainWrapper.standard.string(forKey: userPublicKeyId)
            } else {
                keySaved = KeychainWrapper.standard.string(forKey:self.publicKeyButton.currentTitle!)
            }
            if keySaved == nil {
                alert("Impossible to find the public encryption key", message: "We're unable to find this specific key. Please check that you still have it and check is validity")
                self.encryptButton.isEnabled = true
                self.publicKeyButton.isEnabled = true
                self.textToEncrypt.isEditable = true
                self.chargement.stopAnimating()
            } else {
                var encryptedText = encryptText(text: self.textToEncrypt.text!, publicKey: keySaved!)
                let encryptionMethod = Encryption()
                var nameSelected = self.publicKeyButton.currentTitle
                if nameSelected == "My encryption key"{
                    nameSelected = userPublicKeyId
                }
                encryptedText = encryptionMethod.encryptText(self.textToEncrypt.text, withKeyName: nameSelected!)
                if encryptedText != "error" && encryptedText != "" {
                    self.textEncrypted = encryptedText
                    performSegue(withIdentifier: "Encryption", sender: nil)
                } else {
                    alert("Oups ... encryption error message", message: "Impossible to encrypt this message. Please try again")
                }
                self.encryptButton.isEnabled = true
                self.publicKeyButton.isEnabled = true
                self.textToEncrypt.isEditable = true
                self.chargement.stopAnimating()
            }
        }
        
    }
    
    @IBAction public func shutDownKeyboard(sender: UIBarButtonItem){
        self.view.endEditing(true)
        
    }
    
    @IBAction func lockAppSelected(sender: UIBarButtonItem){
        performSegue(withIdentifier: "lockApp", sender: self)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return keyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let animation = UIViewPropertyAnimator(duration: 0.3, curve: .linear, animations: {
            self.heightSender?.isActive = false
            self.heightSender?.constant = -200
            self.heightSender?.isActive = true
            })
        animation.startAnimation()
        if keyArray[row] != "Add a key" {
            self.publicKeyButton.setTitle("Use \(keyArray[row])'s key", for: .normal)
            titleButtonClean = keyArray[row]
        } else {
            self.publicKeyButton.setTitle("Add a key", for: .normal)
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Futura", size: 30)
        label.text = keyArray[row]
        return label
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.translatesAutoresizingMaskIntoConstraints = true
        textView.frame.origin.y = 10
        self.shutDownKeyboard.image = UIImage(systemName: "keyboard.chevron.compact.down")
        self.shutDownKeyboard.isEnabled = true
        self.encryptButton.isHidden = true
        if textView.text == "Text to encrypt"{
            textView.text = ""
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView){
        textView.translatesAutoresizingMaskIntoConstraints = false
        self.shutDownKeyboard.title = ""
        self.shutDownKeyboard.isEnabled = false
        self.encryptButton.isHidden = false
        if textView.text == "" {
            textView.text = "Text to encrypt"
            textView.textColor = .lightGray
        }
    }
    
    

    //Encryption method :
    private func encryptText(text: String, publicKey: String) -> String{
        do {
            let clear = try ClearMessage(string: text, using: .utf8)
            print("Text to encrypt = \(clear.base64String)")
            //error("Attention verifier qu'il ne faut pas encoder la public key. Que cela marche aussi avec une key sous la forme d'une string")
            
            let encrypted = try clear.encrypted(with: PublicKey(base64Encoded: publicKey) , padding: .PKCS1)
            return encrypted.base64String
        } catch {
            return "error"
        }
    }
    
    //
    // Data func
    //
    
    private func refreshData(){ // Refresh the selector
        //Delete old data
        self.keyArray = ["Add a key", "My encryption key"]
        self.nameArray = []
        //We load the new one
        loadData()
        self.keyList.reloadAllComponents()
    }
    
    //
    // Notifications func
    //
    
    @objc private func notificationReceived(notification: Notification){
        print("notifcation : \(String(describing: notification.userInfo))")
        refreshData()
    }
    
    @objc private func appMovedToBackground(){
        print("notification recieved")
        performSegue(withIdentifier: "lockApp", sender: self)
    }
    
    //
    // Segue func
    //
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Encryption" && textEncrypted != "error" && textEncrypted != ""{
            let encryptionView = segue.destination as! EncryptedResult
            encryptionView.encryptedTextTransmitted = self.textEncrypted
            encryptionView.clearTextTransmitted = self.textToEncrypt.text!
            encryptionView.keyNameTransmitted = self.publicKeyButton.currentTitle!
        } else if segue.identifier == "addKey"{
            let nv = segue.destination as? UINavigationController
            if let addView = nv?.viewControllers.first as? AddKey {
                addView.viewOnBack = "Encrypt"
            } else {
                print("it's other ! : \(segue.destination)")
            }
        } else if segue.identifier == "lockApp"{
            let lockedView = segue.destination as! LockedView
            lockedView.activityInProgress = true
        }
    }
    
}





