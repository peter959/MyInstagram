//
//  NoficationViewController.swift
//  MyInstagram
//
//  Created by Pietro Vassallo on 06/10/21.
//

import UIKit

enum UserNotificationType {
    case like(post: UserPost)
    case follow(state: FollowState)
}

struct UserNotification {
    let type: UserNotificationType
    let text: String
    let user: User
}

final class NoficationViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NotificationLikeEventTableViewCell.self,forCellReuseIdentifier: NotificationLikeEventTableViewCell.identifier)
        tableView.register(NotificationFollowEventTableViewCell.self,forCellReuseIdentifier: NotificationFollowEventTableViewCell.identifier)
        tableView.register(UITableViewCell.self,forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.isHidden = true
        spinner.hidesWhenStopped = true
        spinner.tintColor = .label
        return spinner
    }()
    
    private lazy var noNotificationsView = NoNotificationsView() //lazy -> intitiated only when is called
    
    private var models = [UserNotification]()
    
    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNotifications()
        navigationItem.title = "Notifications"
        view.backgroundColor = .systemBackground
        view.addSubview(spinner)
        //spinner.startAnimating()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
    }
    
    private func fetchNotifications() {
        let user = User(username: "prova", bio: "this is a bio",
                        profilePhoto: URL(string: "https//www.google.com")!,
                        counts: UserCount(followers: 10, following: 10, posts: 0),
                        name: (first: "prova", last: "provata"), birthDate: Date(), Gender: .male,
                        joinDate: Date())
        for x in 0..<10 {
            let post = UserPost(Identifier: "", postType: .photo, thumbnailImage: URL(string: "https//www.google.com")!,
                                postURL: URL(string: "https//www.google.com")!,
                                caption: "", likeCount: [], comments: [], createdDate: Date(), taggedUsers: [],
                                owner: user)
            
            let model = UserNotification (
                type: x % 2 == 0 ? .like(post: post) : .follow(state: .not_following),
                text: "hello world",
                user: user)
            
            models.append(model)
        }
    }
    
    private func addNoNotificationView() {
        tableView.isHidden = true
        view.addSubview(noNotificationsView)
        noNotificationsView.frame = CGRect(x: 0, y: 0, width: view.width/2, height: view.width/4)
        noNotificationsView.center = view.center
    }
    

}

//MARK: TableView

extension NoficationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        
        switch model.type {
        case .follow:
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationFollowEventTableViewCell.identifier,
                                                     for: indexPath) as! NotificationFollowEventTableViewCell
           // cell.configure(with: model)
            cell.delegate = self
            return cell
            
        case .like(_):
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationLikeEventTableViewCell.identifier,
                                                     for: indexPath) as! NotificationLikeEventTableViewCell
            cell.configure(with: model)
            cell.delegate = self
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
}

extension NoficationViewController: NotificationLikeEventTableViewCellDelegate {
    func didTapRelatedPostButton(model: UserNotification) {
        switch model.type {
        case .like(let post):
            let vc = PostViewController(model: post)
            vc.title = post.postType.rawValue
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .follow(_):
            fatalError("Dev Issue: Should neveer get called")
        }
        
        
        
    }
    
    
}

extension NoficationViewController: NotificationFollowEventTableViewCellDelegate {
    func didTapFollowUnfollowButton(model: UserNotification) {
        print("follow/unfollow tapped")
        //perform database update
    }
    
    
}
