//
//  SettingsViewController.swift
//  MyInstagram
//
//  Created by Pietro Vassallo on 06/10/21.
//


import SafariServices
import UIKit

struct SettingCellModel {
    let title: String
    let handler: (()-> Void)
}

// view controller to show user settings
final class SettingsViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero,
                                    style: .grouped)
        tableView.register(UITableViewCell.self,forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var data = [[SettingCellModel]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureModels() {
        
        //aggiungere [weak self] in caso di problemi
        data.append([
            SettingCellModel(title: "Edit Profile") { () in
                self.didTapEditProfile()
            },
            
            SettingCellModel(title: "Invite Friends") { () in
                self.didTapInviteFriends()
            },
            
            SettingCellModel(title: "Save Original Posts") { () in
                self.didSaveOriginalPosts()
            }
        ])
        
        data.append([
            SettingCellModel(title: "Terms of Service") { () in
                guard let url = URL(string: "https://help.instagram.com/519522125107875") else {
                    return
                }
                let vc = SFSafariViewController(url: url)
                self.present(vc, animated: true)
            }
        ])
    
        data.append([
            SettingCellModel(title: "Log out") {[weak self] in
                self?.didTapLogOut()
            }
        ])
    }
    
    private func didTapEditProfile() {
        let vc = EditProfileViewController()
        vc.title = "Edit Profile"
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }

    private func didTapInviteFriends() {
        
    }
    
    private func didSaveOriginalPosts() {
        
    }

    private func didTapLogOut() {
        let actionSheet = UIAlertController(title: "log out", message: "Are you sure?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "log out", style: .destructive, handler: {_ in
            
            AuthManager.shared.LogOut() { success in
                DispatchQueue.main.async {
                    if (success) {
                        //present log In
                        let loginVC = LoginViewController()
                        loginVC.modalPresentationStyle = .fullScreen
                        self.present(loginVC, animated: true) {
                            self.navigationController?.popToRootViewController(animated: false)
                            self.tabBarController?.selectedIndex = 0
                        }
                    }
                    else {
                        fatalError("Could not log out user")
                    }
                }
                
            }
        }))
        actionSheet.popoverPresentationController?.sourceView = tableView
        actionSheet.popoverPresentationController?.sourceRect = tableView.bounds
        present(actionSheet, animated: true)
        
    }

}

// MARK: - TableView

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        data[indexPath.section][indexPath.row].handler()
        
    }
}
