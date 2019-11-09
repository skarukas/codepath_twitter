//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Stephen Karukas on 11/1/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    var favorited: Bool = false
    var retweeted: Bool = false
    var tweetId = -3
    @IBOutlet weak var favButton: UIButton!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    @IBAction func retweet(_ sender: Any) {
        if (!retweeted) {
            TwitterAPICaller.client?.retweet(id: self.tweetId, success: {
                self.setRetweeted(true)
            }, failure: { (error) in
                print("error retweeting: \(error)")
            })
        }
    }
    @IBAction func favorite(_ sender: Any) {
        if (!favorited) {
            TwitterAPICaller.client?.favoriteTweet(id: self.tweetId, success: {}, failure: { (error) in
                print("error favoriting tweet: \(error)")
            })
        } else {
            TwitterAPICaller.client?.unfavoriteTweet(id: self.tweetId, success:{}, failure: { (error) in
                print("error unfavoriting tweet: \(error)")
            })
        }
        setFavorited(!favorited)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setFavorited(_ isFavorited: Bool) {
        favorited = isFavorited
        if (favorited) { favButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
        } else {
            favButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
        }
    }
    
    func setRetweeted(_ isRetweeted: Bool) {
        retweeted = isRetweeted
        if (retweeted) {
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
            retweetButton.isEnabled = false
        } else {
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
            retweetButton.isEnabled = true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
