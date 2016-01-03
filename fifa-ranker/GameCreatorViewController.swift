//
//  GameCreatorViewController.swift
//  fifa-ranker
//
//  Created by Sylvain Giuliani on 01/01/2016.
//  Copyright © 2016 Sylvain Giuliani. All rights reserved.
//

import UIKit
import Eureka

class GameCreatorViewController: FormViewController {
    
    var players:[Player]?
    var fifaTeams:[FifaTeam]?
    let formTeams = ["Home", "Away"]
    var game:Game?
    var homeTeam = Team()
    var awayTeam = Team()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Bootstrap
        for team in formTeams {
            self.addFormForTeam(team)
        }
        

        // Fetching Data
        // TODO: Multi threads that shit group_async FTW
        let t = FifaAPI()
        t.getAll(.Players) { results, error in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            self.players = results!.map({ $0 as! Player})
            self.updatePlayersPicker(self.players!)
        }
        
        t.getAll(.FifaTeams) { results, error in
            if error != nil {
                print(error!.localizedDescription)
                return
            }

            self.fifaTeams = results!.map({ $0 as! FifaTeam})
            self.updateTeamsPicker(self.fifaTeams!)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.translucent = false
    }
    
    
    // MARK: - My Func baby
    
    func updatePlayersPicker(players:[Player]) {
        for team in formTeams {
            let row = self.form.rowByTag("pickPlayers-\(team)") as! MultipleSelectorRow<Player>
            row.options = players
        }
    }
    
    func updateTeamsPicker(teams:[FifaTeam]) {
        for team in formTeams {
            let row = self.form.rowByTag("pickTeam-\(team)") as! PickerInlineRow<FifaTeam>
            row.options = teams
        }
    }
    
    func addFormForTeam(team: String) {
        form +++ Section("\(team) Team")
            <<< MultipleSelectorRow<Player>() {
                $0.selectorTitle = "Pick one or more players"
                $0.tag = "pickPlayers-\(team)"
                $0.title = "Player(s)"
            }
            .onPresent { from, to in
                to.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: from, action: "multipleSelectorDone:")
            }.onChange { row in
                let selectedValue = row.value!.map({$0 as Player})
                if team == "Home" {
                    self.homeTeam.playerCombination = selectedValue
                }
                else {
                    self.awayTeam.playerCombination = selectedValue
                }

            }
            
            <<< PickerInlineRow<FifaTeam>() {
                $0.tag = "pickTeam-\(team)"
                $0.title = "Team"
            }.onChange { row in
                if team == "Home" {
                    self.homeTeam.fifaTeam = row.value!
                }
                else {
                    self.awayTeam.fifaTeam = row.value!
                }
            }
            <<< IntRow() {
                $0.title = "Score"
            }.onChange { row in
                if team == "Home" {
                    self.homeTeam.goalsScored = row.value!
                }
                else {
                    self.awayTeam.goalsScored = row.value!
                }
            }
    }
    
    func multipleSelectorDone(item:UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func submitGame(sender:UIButton) {
        // TODO: I can haz Validation pwease
//        let player1 = Player(SlackId: 123, slackName: "syl", id: 2)
//        let player2 = Player(SlackId: 1234, slackName: "jack", id: 1)
//        
//        let fifateam1 = FifaTeam(teamName: "ARS", teamRating: 90, id: 1)
//        let fifateam2 = FifaTeam(teamName: "NEW", teamRating: 02, id: 2)
//        
//        let team1 = Team(fifaTeam: fifateam1, playerCombination: [player1], goalsScored: 10)
//        let team2 = Team(fifaTeam: fifateam2, playerCombination: [player2], goalsScored: 20)
//        
//        self.game = Game(home: team1, away:team2)
        
        self.game = Game(home: self.homeTeam, away: self.awayTeam)
        if self.game!.isValid() {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
            activityIndicator.startAnimating()
            activityIndicator.center = CGPoint(x: sender.frame.size.width * 0.3 , y: sender.frame.size.height * 0.5)
            
            sender.addSubview(activityIndicator)
            sender.setTitle("Sending...", forState: .Normal)
            
            self.game!.submitGame({ (response, error) -> Void in
                print("response form game submit")
                activityIndicator.removeFromSuperview()
                sender.setTitle("Success ✔︎", forState: .Normal)
                NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "dismissMessage:", userInfo: sender, repeats: false)
            })
        }
        else {
            print("please valid biatch")
            let alertController = UIAlertController(title: "Invalid Data", message: "Please fill the game report", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Close", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
    func dismissMessage(timer:NSTimer) {
        let button = timer.userInfo as! UIButton
        button.setTitle("Submit Game", forState: .Normal)
    }
    
    func createFooterView() -> UIView {
        let wrapperView = UIView()
        wrapperView.clipsToBounds = false
        wrapperView.translatesAutoresizingMaskIntoConstraints = true
        
        let button = UIButton(type: UIButtonType.Custom) as UIButton
        button.backgroundColor = UIColor(hue: 0.3778, saturation: 0.59, brightness: 0.56, alpha: 1.0)
        button.layer.cornerRadius = 5
        button.transform = CGAffineTransformMakeScale(1, 1)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Submit Game", forState: .Normal)
        button.addTarget(self, action: "submitGame:", forControlEvents: UIControlEvents.TouchUpInside)
        
        wrapperView.addSubview(button)
        
        let buttonWidth = NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal , toItem: wrapperView, attribute: .Width, multiplier: 0.8, constant: 0)
        
        let buttonHeight = NSLayoutConstraint(item: button, attribute: .Height, relatedBy: .Equal, toItem: wrapperView, attribute: .Height, multiplier: 0.5, constant: 0)
        
        let centerVertically = NSLayoutConstraint(item: wrapperView, attribute: .CenterY, relatedBy: .Equal, toItem: button, attribute: .CenterY, multiplier: 1, constant: 0)
        
        let centerHorizontally = NSLayoutConstraint(item: wrapperView, attribute: .CenterX, relatedBy: .Equal, toItem: button, attribute: .CenterX, multiplier: 1, constant: 0)
        
        wrapperView.addConstraint(buttonHeight)
        wrapperView.addConstraint(buttonWidth)
        wrapperView.addConstraint(centerVertically)
        wrapperView.addConstraint(centerHorizontally)
        return wrapperView
    }
    
    // MARK: - TableView Delegate BS
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 120
        }
        else {
            return 0
        }
        
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            return createFooterView()
        }
        else {
            return nil
        }
    }
}
