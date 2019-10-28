//
//  ShowKey.swift
//  Trust
//
//  Created by Nathan on 31/07/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

class ShowKey: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var nameKeyTitle = UILabel()
    var nameKey = UILabel()
    var keyTitle = UILabel()
    var key = UITextView()
    var encryptButton = UIButton()
    var shareButton = UIButton()
    var deleteButton = UIButton()
    var editButton = UIBarButtonItem()
    
    
    
    
    @IBOutlet weak var editBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var trashBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var shareBarButtonItem: UIBarButtonItem!
    
    
    
    var name = ""
    var idKey = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("idKey = \(idKey)")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.backgroundView.backgroundColor = .black
        self.scrollView.delegate = self
        constructView()
        
        
        
    }
    
    
    //
    // Views creation func
    //
    
    func alert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func constructView(){
        self.backgroundView.addSubview(self.nameKeyTitle)
        self.nameKeyTitle.translatesAutoresizingMaskIntoConstraints = false
        self.nameKeyTitle.leftAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.leftAnchor, multiplier: 2).isActive = true
        self.nameKeyTitle.topAnchor.constraint(equalToSystemSpacingBelow: self.scrollView.topAnchor, multiplier: 2).isActive = true
        self.nameKeyTitle.text = "Encryption key owner"
        self.nameKeyTitle.textColor = .white
        self.nameKeyTitle.font = UIFont(name: "Arial Rounded MT Bold", size: 25)
        
        self.backgroundView.addSubview(self.nameKey)
        self.nameKey.translatesAutoresizingMaskIntoConstraints = false
        self.nameKey.centerXAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.centerXAnchor, multiplier: 1).isActive = true
        self.nameKey.topAnchor.constraint(equalToSystemSpacingBelow: self.nameKeyTitle.bottomAnchor, multiplier: 2).isActive = true
        self.nameKey.widthAnchor.constraint(equalToConstant: self.scrollView.frame.size.width - 70).isActive = true
        self.nameKey.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.nameKey.layer.masksToBounds = true
        self.nameKey.layer.cornerRadius = 20
        self.nameKey.text = "  \(name)  "
        self.nameKey.font = UIFont(name: "American Typewriter", size: 19)
        self.nameKey.textColor = .systemOrange
        self.nameKey.backgroundColor = UIColor(red: 0.121, green: 0.13, blue: 0.142, alpha: 0.5)
        self.nameKey.lineBreakMode = .byTruncatingTail
        
        
        
        self.backgroundView.addSubview(self.keyTitle)
        self.keyTitle.translatesAutoresizingMaskIntoConstraints = false
        self.keyTitle.leftAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.leftAnchor, multiplier: 2).isActive = true
        self.keyTitle.topAnchor.constraint(equalToSystemSpacingBelow: self.nameKey.bottomAnchor, multiplier: 5).isActive = true
        self.keyTitle.text = "Encryption key"
        self.keyTitle.textColor = .white
        self.keyTitle.font = UIFont(name: "Arial Rounded MT Bold", size: 25)
        
        self.backgroundView.addSubview(self.key)
        self.key.translatesAutoresizingMaskIntoConstraints = false
        self.key.centerXAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.centerXAnchor, multiplier: 1).isActive = true
        self.key.topAnchor.constraint(equalToSystemSpacingBelow: self.keyTitle.bottomAnchor, multiplier: 2).isActive = true
        self.key.widthAnchor.constraint(equalToConstant: self.scrollView.frame.size.width - 70).isActive = true
        self.key.heightAnchor.constraint(equalToConstant: 200).isActive = true
        self.key.isEditable = false
        self.key.isSelectable = false
        self.key.textColor = .systemOrange
        if let retrievedString: String = KeychainWrapper.standard.string(forKey: idKey){
            self.key.text = "\(retrievedString)"
        } else {
            self.key.text = "Impossible de récupérer la clé associée à ce nom. Assurez vous de ne pas avoir fait d'erreur lors de l'enregistrement, de posséder la dernière version de l'application et d'avoir de la place sur votre iDevice."
            self.key.textColor = .systemRed
        }
        
        self.key.font = UIFont(name: "American Typewriter", size: 17)
        
        self.key.backgroundColor = UIColor(red: 0.121, green: 0.13, blue: 0.142, alpha: 0.5)
        self.key.layer.cornerRadius = 20
        
        
        self.backgroundView.addSubview(self.encryptButton)
        self.encryptButton.translatesAutoresizingMaskIntoConstraints = false
        self.encryptButton.centerXAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.centerXAnchor, multiplier: 1).isActive = true
        self.encryptButton.topAnchor.constraint(equalToSystemSpacingBelow: self.key.bottomAnchor, multiplier: 5).isActive = true
        self.encryptButton.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - 40).isActive = true
        self.encryptButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        if #available(iOS 13.0, *) {
            self.encryptButton.setImage(UIImage(systemName: "lock.fill") , for: .normal)
        } else {
            self.encryptButton.setImage(UIImage(named: "addKey"), for: .normal)
        }
        self.encryptButton.backgroundColor = UIColor(red: 0.121, green: 0.13, blue: 0.142, alpha: 1)
        self.encryptButton.setTitleColor(.white, for: .normal)
        self.encryptButton.setTitle(" Use this key to encrypt a msg", for: .normal)
        self.encryptButton.tintColor = .systemOrange
        self.encryptButton.titleLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 17)
        self.encryptButton.rondBorder()
        
        self.backgroundView.addSubview(self.shareButton)
        self.shareButton.translatesAutoresizingMaskIntoConstraints = false
        self.shareButton.centerXAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.centerXAnchor, multiplier: 1).isActive = true
        self.shareButton.topAnchor.constraint(equalToSystemSpacingBelow: self.encryptButton.bottomAnchor, multiplier: 4).isActive = true
        self.shareButton.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - 40).isActive = true
        self.shareButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        if #available(iOS 13.0, *) {
            self.shareButton.setImage(UIImage(systemName: "square.and.arrow.up") , for: .normal)
        }
        self.shareButton.backgroundColor = UIColor(red: 0.121, green: 0.13, blue: 0.142, alpha: 1)
        self.shareButton.setTitleColor(.white, for: .normal)
        self.shareButton.setTitle(" Share this key", for: .normal)
        self.shareButton.tintColor = .systemOrange
        self.shareButton.titleLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 17)
        self.shareButton.rondBorder()
        
        self.backgroundView.addSubview(self.deleteButton)
        self.deleteButton.translatesAutoresizingMaskIntoConstraints = false
        self.deleteButton.centerXAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.centerXAnchor, multiplier: 1).isActive = true
        self.deleteButton.topAnchor.constraint(equalToSystemSpacingBelow: self.shareButton.bottomAnchor, multiplier: 4).isActive = true
        self.deleteButton.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - 40).isActive = true
        self.deleteButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        if #available(iOS 13.0, *) {
            self.deleteButton.setImage(UIImage(systemName: "trash") , for: .normal)
        }
        self.deleteButton.backgroundColor = UIColor(red: 0.121, green: 0.13, blue: 0.142, alpha: 1)
        self.deleteButton.setTitleColor(.systemRed, for: .normal)
        self.deleteButton.setTitle(" Destroy this key", for: .normal)
        self.deleteButton.tintColor = .systemOrange
        self.deleteButton.titleLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 17)
        self.deleteButton.rondBorder()
        self.deleteButton.addTarget(self, action: #selector(trashButtonSelected), for: .touchUpInside)
        
    }
    
    
    
    //
    // IBOutlet func
    //
    
    @IBAction private func shareBarButtonItemSelected(sender: UIBarButtonItem){
        
    }
    
    @IBAction private func trashBarButtonItemSelected(sender: UIBarButtonItem){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let A1 = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        let A2 = UIAlertAction(title: "Destroy this key", style: UIAlertAction.Style.destructive, handler: { (_) in
            self.destroyKey()
        })
        alert.addAction(A1)
        alert.addAction(A2)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction private func editBarButtonItemSelected(sender: UIBarButtonItem){
        
    }
    
    //
    // Obj C func
    //
    
    @objc private func shareButtonSelected(sender: UIButton){
        
    }
    
    @objc private func trashButtonSelected(sender: UIButton){
        sender.isEnabled = false
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let A1 = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (_) in
            sender.isEnabled = true
        })
        let A2 = UIAlertAction(title: "Destroy this key", style: UIAlertAction.Style.destructive, handler: { (_) in
            self.destroyKey()
        })
        alert.addAction(A1)
        alert.addAction(A2)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func editButtonSelected(sender: UIButton){
        
    }
    
    @objc private func dismissView(){
        _ = navigationController?.popViewController(animated: true)
    }
    
    //
    // Data gestion func
    //
    
    func destroyKey(){
        //First in the dictionnary :
        let keyNameData = KeyId()
        var listeKeyName = keyNameData.getKeyIdArray()
        listeKeyName.removeValue(forKey: idKey)
        keyNameData.stockNewNameIdArray(listeKeyName)
        //then the keychain :
        KeychainWrapper.standard.removeObject(forKey: idKey)
        UIView.animate(withDuration: 1.5, animations: {
            self.key.alpha = 0
            self.nameKey.alpha = 0
            self.keyTitle.alpha = 0
            self.nameKeyTitle.alpha = 0
            self.deleteButton.alpha = 0
            self.shareButton.alpha = 0
            self.encryptButton.alpha = 0
        })
        self.perform(#selector(dismissView), with: nil, afterDelay: 1.6)
    }
}
