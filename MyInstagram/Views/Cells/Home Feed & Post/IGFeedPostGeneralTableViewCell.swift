//
//  IGFeedPostGeneralTableViewCell.swift
//  MyInstagram
//
//  Created by Pietro Vassallo on 14/10/21.
//

import UIKit

//Comments
class IGFeedPostGeneralTableViewCell: UITableViewCell {
    static let identifier = "IGFeedPostGeneralTableViewCell"
    
    var comment: PostComment?
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "@username"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    
    let commentTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "this is a comment test"
        //label.numberOfLines = 1
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //contentView.backgroundColor = .systemOrang
        contentView.addSubview(commentTextLabel)
        contentView.addSubview(usernameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func configure(with comment: PostComment) {
        usernameLabel.text = comment.username
        commentTextLabel.text = comment.text
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = Float(usernameLabel.text!.count) * 8.3
        usernameLabel.frame = CGRect(x: 2, y: 2, width:CGFloat(size), height: contentView.height-4)
        commentTextLabel.frame = CGRect(x: usernameLabel.right+5, y: 2,
                                     width: contentView.width-15, height: contentView.height-4)
    }

}
