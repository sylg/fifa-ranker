//
//  Game.swift
//  fifa-ranker
//
//  Created by Sylvain Giuliani on 01/01/2016.
//  Copyright © 2016 Sylvain Giuliani. All rights reserved.
//

import Foundation

struct Game {
    var homeTeam:Team?
    var awayTeam:Team?
    
    var toJSON:[String:NSDictionary] {
        get {
            let object =  [
                "team_one": [
                    "fifa_team":  homeTeam!.fifaTeamId,
                    "player_combination": homeTeam!.playerCombinationIds,
                    "goals_scored": homeTeam!.goalsScored!
                ],
                "team_two": [
                    "fifa_team":  awayTeam!.fifaTeamId,
                    "player_combination": awayTeam!.playerCombinationIds,
                    "goals_scored": awayTeam!.goalsScored!
                ],
            ]
            return object
        }
    }
    
    init(home:Team, away:Team) {
        self.homeTeam = home
        self.awayTeam = away
    }
    
    
    func submitGame(onCompletion:(response:String?, error:NSError?)-> Void) {
        let api = FifaAPI()
        api.post(.Game, data: self.toJSON, onCompletion: onCompletion)
    }
    
    func isValid() -> Bool {
        // Need to make it better than this shit
        if self.awayTeam?.goalsScored != nil && self.awayTeam?.goalsScored != nil {
            return true
        }
        else {
            return false
        }
    }
    
    
    
}

struct Team {
    var fifaTeam:FifaTeam?
    var playerCombination:[Player]?
    var goalsScored:Int?
    
    var playerCombinationIds:[Int] {
        return playerCombination!.map({$0.id})
    }
    var fifaTeamId:Int {
        return fifaTeam!.id
    }
}
