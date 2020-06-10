//
//  MainViewController.swift
//  SurprizeMeTest
//
//  Created by Gamid on 09.06.2020.
//  Copyright © 2020 Gamid. All rights reserved.
//

import UIKit
import CountryPickerView

class MainViewController: UIViewController {
    
    let cpv = CountryPickerView()
    
    let user = User(id: 123, name: "Anitta", phone: "098 765-43-21", email: "anitta@gmail.com")
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    private let url = "https://app.surprizeme.ru/media/store/1186_i1KaYnj_8DuYTzc.jpg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTapGestureToHideKeyboard()
        registerForKeyboardNotifications()
        
        cpv.delegate = self
        cpv.dataSource = self
        cpv.showCountryCodeInView = false
        cpv.font = .systemFont(ofSize: 28)
        
        setLabel()
        setImage()
        setButtons()
        setTextField()
    }

    deinit {
        removeForKeyboardNotification()
    }
    
    private func setLabel() {
        greetingLabel.text = "Hi, \(user.name)"
    }
    
    private func setImage() {
        imageView.layer.cornerRadius = 10
        getImage()
    }
    
    private func setButtons() {
        confirmButton.layer.cornerRadius = 10
    }
    
    private func setTextField() {
        phoneTextField.addBottomBorder()
        phoneTextField.leftView = cpv
        phoneTextField.leftViewMode = .always
        phoneTextField.text = user.phone
    }
    
    private func getImage() {
        guard let url = URL(string: self.url) else { print("Error with image url"); return }
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data!)
            }
        }
    }
    
    @IBAction func confirmAndGetCode() {
        NetworkService.shared.confirm(userId: user.id, userPhone: "\(cpv.selectedCountry.phoneCode) \(user.phone)")
        performSegue(withIdentifier: "confirmSegue", sender: nil)
    }
    
    @IBAction func signOut() {
        greetingLabel.isHidden = true
        phoneTextField.leftView = nil
        phoneTextField.text = nil
        phoneTextField.placeholder = "Your e-mail"
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeForKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }

    }

    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let confirmCodeVC = segue.destination as? ConfirmCodeViewController else { print("Error with confirmSegue"); return }
        confirmCodeVC.userPhone = user.phone
        
    }
    
}

extension MainViewController: CountryPickerViewDelegate, CountryPickerViewDataSource {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        
    }
    
    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
        return "Country code"
    }
    
    func closeButtonNavigationItem(in countryPickerView: CountryPickerView) -> UIBarButtonItem? {
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: nil, action: nil)
        closeButton.tintColor = UIColor.gray
        return closeButton
    }
    
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        return true
    }
    
    func preferredCountries(in countryPickerView: CountryPickerView) -> [Country] {
        guard let country = countryPickerView.getCountryByCode("US") else { return [] }
        return [country]
    }
    
    func sectionTitleForPreferredCountries(in countryPickerView: CountryPickerView) -> String? {
        return "Suggestions"
    }
    
    func sectionTitleLabelFont(in countryPickerView: CountryPickerView) -> UIFont {
        return .boldSystemFont(ofSize: 22)
    }
    
    func sectionTitleLabelColor(in countryPickerView: CountryPickerView) -> UIColor? {
        return .black
    }
    
}
