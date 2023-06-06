//
//  SettingsViewController.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 5/29/23.
//

import UIKit
import MessageUI

struct Section {
    let title: String
    let dataSource: [SettingsActionModel]
}

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {

    //MARK: - Globals

    @IBOutlet weak var navigationBackgroundView: UIView!
    @IBOutlet weak var logoContainerView: UIView!
    @IBOutlet weak var logoBackgroundView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var logoTitle: UILabel!
    @IBOutlet weak var logoDescriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private let petarEmail = "applesakota@gmail.com"
    private let urosEmail = "urosveljkovic@yahoo.com"
    
    class var identifier: String { return "SettingsViewController" }
    
    private var dataSource: [Section] {
        return [
            Section(title: "Personalizuj kvizler", dataSource: [
                SettingsActionModel(name: "Personalizuj", section: "Pisite", icon: UIImage(named: "brush")!, action: self.presonalise)
            ]),
            
            Section(title: "", dataSource: [
                SettingsActionModel(name: "Podeli", section: "Share", icon: UIImage(named: "share")!, action: self.shareApplication),
                SettingsActionModel(name: "Oceni aplikaciju", section: "Share", icon: UIImage(named: "rate")!, action: self.rateKvizler),
                SettingsActionModel(name: "Privacy Policy", section: "Share", icon: UIImage(named: "policy")!, action: self.presentPrivacyPolicy),
            ]),
            
            
            Section(title: "Pišite nam", dataSource: [
                SettingsActionModel(name: "applesakota@gmail.com", section: "Pisite", icon: UIImage(named: "sendEmail")!, action: self.presendSendToPetarMail),
                SettingsActionModel(name: "urosveljkovic@yahoo.com", section: "Pisite", icon: UIImage(named: "sendEmail")!, action: self.presendSendToUrosMail)
            ])

//            SettingsActionModel(name: "Credits", icon: UIImage(named: "policy")!, action: self.presentAppIconVariant)
        ]
    }
    
    
    
    class func instantiate() -> SettingsViewController {
        let viewController = UIStoryboard.main.instantiate(self.identifier) as! SettingsViewController
        viewController.tabBarItem = UITabBarItem(title: "Podešavanja", image: #imageLiteral(resourceName: "setting"), selectedImage: #imageLiteral(resourceName: "setting"))
        return viewController
    }
    
    class func instantiateWithNavigation() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: instantiate())
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.backgroundColor = UIColor.clear
        return navigationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareThemeAndLocalization()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.prepareNavigationBarTheme()

    }
    
    func prepareNavigationBarTheme() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.tintColor = AppTheme.current.textColor
        self.navigationBackgroundView.backgroundColor = AppTheme.current.containerColor
    }
    
    func presonalise() {
        let viewController = PersonaliseViewController.instantiate()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func shareApplication() {
        // Setting description
        let firstActivityItem = "Share Kvizler"
        // Setting url
        let secondActivityItem: NSURL = NSURL(string: "https://apps.apple.com/us/app/kvizler/id6446685036")!
        
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem], applicationActivities: nil)
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = view
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY,width: 0,height: 0)
        
        // Pre-configuring activity items
        activityViewController.activityItemsConfiguration = [
        UIActivity.ActivityType.message
        ] as? UIActivityItemsConfigurationReading
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo,
            UIActivity.ActivityType.postToFacebook
        ]
        
        
        activityViewController.isModalInPresentation = true
        self.present(activityViewController, animated: true, completion: nil)

    }
    
    
    func presendSendToPetarMail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([petarEmail])
            self.present(mail, animated: true)
        } else {
            let alert = UIAlertController(title: "Greška", message: "Trenutno nije moguće poslati mail", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
                self.dismiss(animated: true)
            })
            self.present(alert, animated: false)
        }
    }
    
    func presendSendToUrosMail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([urosEmail])
            self.present(mail, animated: true)
        } else {
            let alert = UIAlertController(title: "Greška", message: "Trenutno nije moguće poslati mail", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
                self.dismiss(animated: true)
            })
            self.present(alert, animated: false)
        }
    }
    
    func presentPrivacyPolicy() {
        let viewController = WebViewController.instantiate()
        viewController.navigationItem.title = "Privacy policy"
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func rateKvizler() {
        AppStoreReviewManager.requestReviewIfAppropriate()
    }
    
    //MARK: - Utils
    
    func prepareThemeAndLocalization() {
        self.view.backgroundColor = AppTheme.current.scoreboardTableViewBackgroundColor
        self.navigationItem.title = "Podešavanja"
        self.logoContainerView.backgroundColor = UIColor.clear
        self.logoBackgroundView.backgroundColor = AppTheme.current.mainColor
        self.logoBackgroundView.layer.cornerRadius = 10
        self.logoTitle.text = "Kvizler"
        self.logoTitle.textColor = AppTheme.current.mainColor
        self.logoDescriptionLabel.text = "Verzija \(AppGlobals.appVersion ?? "")"
        self.logoDescriptionLabel.textColor = AppTheme.current.bodyTextColor
        
    }

    //MARK: - TableViewDataSource TableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as? SettingsTableViewCell else { return
            UITableViewCell()
        }
        cell.setupTheme(with: dataSource[indexPath.section].dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.dataSource[indexPath.section].dataSource[indexPath.row].action()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 { return 0 }
        return 24
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = dataSource[section]
        return section.title
    }
    
    //MARK: - MFMailComposeViewController
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }

}


