//
//  ViewController.swift
//  MyInstagram
//
//  Created by Pietro Vassallo on 06/10/21.
//

import FirebaseAuth
import UIKit

//structure of a post divided in 4 sections
// So every post has 4 sections
struct HomeFeedRenderViewModel {
    let header: PostRenderViewModel
    let post: PostRenderViewModel
    let actions: PostRenderViewModel
    let commments: PostRenderViewModel
}

class HomeViewController: UIViewController {
    
    //the array of posts showed in the feed
    private var feedRenderModels = [HomeFeedRenderViewModel]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        //Register cell
        tableView.register(IGFeedPostTableViewCell.self,
                           forCellReuseIdentifier: IGFeedPostTableViewCell.identifier)
        tableView.register(IGFeedPostHeaderTableViewCell.self,
                           forCellReuseIdentifier: IGFeedPostHeaderTableViewCell.identifier)
        tableView.register(IGFeedPostActionsTableViewCell.self,
                           forCellReuseIdentifier: IGFeedPostActionsTableViewCell.identifier)
        tableView.register(IGFeedPostGeneralTableViewCell.self,
                           forCellReuseIdentifier: IGFeedPostGeneralTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        createMockModels()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func createMockModels() {
        let user = User(username: "@prova", bio: "this is a bio",
                        profilePhoto: URL(string: "https//www.google.com")!,
                        counts: UserCount(followers: 10, following: 10, posts: 0),
                        name: (first: "prova", last: "provata"), birthDate: Date(), Gender: .male,
                        joinDate: Date())
        let post = UserPost(Identifier: "", postType: .photo, thumbnailImage: URL(string: "https//www.google.com")!,
                            postURL: URL(string: "https//www.google.com")!,
                            caption: "", likeCount: [], comments: [], createdDate: Date(), taggedUsers: [],
                            owner: user)
        
        var comments = [PostComment]()
        for x in 0..<4 {
            comments.append(PostComment(identifier: "\(x)", username: "@prova", text: "this is a comment",
                                        createdDate: Date(), likes: []))
        }
        for x in 0..<5 {
            let viewModel = HomeFeedRenderViewModel(header: PostRenderViewModel(renderType: .header(provider: user)),
                                                    post: PostRenderViewModel(renderType: .primaryContent (provider: post)),
                                                    actions: PostRenderViewModel(renderType: .actions(provider: "")),
                                                    commments: PostRenderViewModel(renderType: .comments(comments: comments)))
            feedRenderModels.append(viewModel)
        }
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleNotAuthenticated()
    
    }
    
    private func handleNotAuthenticated() {
        //check auth status
        if Auth.auth().currentUser == nil {
            //show Log in
            let loginVC = LoginViewController()
            
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false)
        }
    }


}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return feedRenderModels.count * 4 // 4 section for each post in feedRenderModels
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model: HomeFeedRenderViewModel
        if section == 0 {
            model = feedRenderModels[0]
        }
        else {
            // position of the model (the post in the array)
            let position = section % 4 == 0 ? section/4 : ((section - (section % 4)) / 4)
            model = feedRenderModels[position]
        }
        
        let subSection = section % 4
        
        if subSection == 0 {
            //header
            return 1
        } else if subSection == 1 {
            //post
            return 1
        } else if subSection == 2 {
            //actions
            return 1
        } else if subSection == 3 {
            //comments
            let commentsModel = model.commments
            switch commentsModel.renderType {
            case .comments(let comments): return comments.count > 2 ? 2 : comments.count
            case .header, .actions, .primaryContent: return 0
            //@unknown default: fatalError("invalid case")
            }
       }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model: HomeFeedRenderViewModel
        let section = indexPath.section
        if section == 0 {
            model = feedRenderModels[0]
        }
        else {
            // position of the model (the post in the array)
            let position = section % 4 == 0 ? section/4 : ((section - (section % 4)) / 4)
            model = feedRenderModels[position]
        }
        
        let subSection = section % 4
        if subSection == 0 {
            //header
            let headerModel = model.header
            switch headerModel.renderType {
            case .header(let user):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostHeaderTableViewCell.identifier,
                                                         for: indexPath) as! IGFeedPostHeaderTableViewCell
                cell.configure(with: user)
                cell.delegate = self
                return cell
            case .comments, .actions, .primaryContent: return UITableViewCell()
            
            }
            
        } else if subSection == 1 {
            //post
            let postModel = model.post
            switch postModel.renderType {
            case .primaryContent(let post):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostTableViewCell.identifier,
                                                         for: indexPath) as! IGFeedPostTableViewCell
                cell.configure(with: post)
                return cell
            case .comments, .actions, .header: return UITableViewCell()
            }
            
        } else if subSection == 2 {
            //actions
            let actionModel = model.actions
            switch actionModel.renderType {
            case .actions(let provider):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostActionsTableViewCell.identifier,
                                                         for: indexPath) as! IGFeedPostActionsTableViewCell
                cell.delegate = self
                //cell.configure(with: <#T##UserPost#>)
                return cell
            case .comments, .primaryContent, .header: return UITableViewCell()
            }
            
        } else if subSection == 3 {
            //comments
            let commentsModel = model.commments
            switch commentsModel.renderType {
            case .comments(let comments):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostGeneralTableViewCell.identifier,
                                                         for: indexPath) as! IGFeedPostGeneralTableViewCell
                cell.configure(with: comments[indexPath.row])
                return cell
            case .actions, .primaryContent, .header: return UITableViewCell()
            }
        }
        
        return UITableViewCell()
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //let model: HomeFeedRenderViewModel
        let subSection = indexPath.section % 4
        
        if subSection == 0 {
            //header
            return 70
        } else if subSection == 1 {
            //post
            return tableView.width
        } else if subSection == 2 {
            //actions
            return 60
        } else if subSection == 3 {
            //comments
            return 50
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let subSection = section % 4
        return subSection == 3 ? 70 : 0
    }
        

}

extension HomeViewController: IGFeedPostHeaderTableViewCellDelegate {
    func didTapMoreButton() {
        let actionSheet = UIAlertController(title: "Post Options", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Report", style: .destructive, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
}

extension HomeViewController: IGFeedPostActionsTableViewCellDelegate {
    func didTapLikeButton() {
        //
    }
    
    func didTapCommentButton() {
        //
    }
    
    func didTapSendButton() {
        //
    }
    
    
}
    
