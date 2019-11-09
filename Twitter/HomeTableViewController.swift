//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Stephen Karukas on 11/1/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit
import AlamofireImage

class HomeTableViewController: UITableViewController {
    var tweetCollection = [NSDictionary]()
    var numTweets: Int!
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged )
        tableView.refreshControl = myRefreshControl
        self.tableView.estimatedRowHeight = 150
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweets()
    }

    // MARK: - Table view data source
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
    UserDefaults.standard.set(false, forKey: "isLoggedIn")
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tweet", for: indexPath) as! TweetTableViewCell
        

        let dict = tweetCollection[indexPath.row]
        let user = dict["user"] as! NSDictionary
        cell.userName.text = user["name"] as? String
        cell.tweetContent.text = dict["text"] as? String
        cell.userImage.af_setImage(withURL:         URL(string: user["profile_image_url_https"] as! String)!)
        
        cell.setFavorited(dict["favorited"] as! Bool)
        cell.tweetId = dict["id"] as! Int
        cell.setRetweeted(dict["retweeted"] as! Bool)
        print(dict)
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetCollection.count
    }
    
    func getTweets() {
        let tweetUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let params = ["count": numTweets]
        print("trying to get tweets")
        TwitterAPICaller.client?.getDictionariesRequest(url: tweetUrl, parameters: params, success: { (dict: [NSDictionary]) in
            self.tweetCollection.removeAll()
            for tweet in dict { self.tweetCollection.append(tweet) }
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
        }, failure: { (Error) in
            print("Could not get tweets. \(Error)")
        })
    }
    
    @objc func loadTweets() {
        numTweets = 20
        getTweets()
    }

    func loadMoreTweets() {
        numTweets += 20
        getTweets()
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // if at end of page, load more
        if indexPath.row + 1 == tweetCollection.count {
            loadMoreTweets()
        }
    }
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
