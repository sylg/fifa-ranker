//
//  GameLogViewController.swift
//  fifa-ranker
//
//  Created by Sylvain Giuliani on 01/01/2016.
//  Copyright © 2016 Sylvain Giuliani. All rights reserved.
//

import UIKit

class GameLogViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var gamesTableView: UITableView!
    var games:[Game]?
    let API = FifaAPI()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "fetchData", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.gamesTableView.addSubview(refreshControl)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        self.gamesTableView.registerNib(UINib(nibName: "GameLogTableViewCell", bundle: nil), forCellReuseIdentifier: "gameCell")

        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.refreshControl.beginRefreshing()
        self.fetchData()
        super.viewWillAppear(animated)
        
        
    }
    
    // MARK: My Func baby
    
    func deleteTapped(game:Game, indexPath:NSIndexPath) {
        self.API.delete(.Games, id: game.id!) { results, error in
            if error != nil {
                let alertController = UIAlertController(title: "Error", message: error!.domain, preferredStyle: .Alert)
                let closelAction = UIAlertAction(title: "Close", style: .Cancel, handler: nil)

                alertController.addAction(closelAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            self.games!.removeAtIndex(indexPath.row)
            self.gamesTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    func fetchData() {
        self.API.getAll(.Games, page: 1, perPage: 50) { results, error in
            if error != nil {
                return
            }
            self.games = results!.map({ $0 as! Game})
            self.gamesTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }

    
    // MARK: UITableview BS
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("gameCell", forIndexPath: indexPath) as! GameLogTableViewCell
        let game = games?[indexPath.row]
        let cellLabelString = "\(game!.homeTeam!.fifaTeam!.teamName) \(game!.homeTeam!.goalsScored!) - \(game!.awayTeam!.goalsScored!) \(game!.awayTeam!.fifaTeam!.teamName)"
        
        cell.gameLabel.text = cellLabelString
        cell.dateLabel.text = game!.createdAt!.relativeTime
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if games != nil{
            return games!.count
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .Destructive, title: "Delete") { action, index in
            if let game = self.games?[indexPath.row] {
                self.deleteTapped(game, indexPath: indexPath)
            }

        }
        return [delete]
    }
}


