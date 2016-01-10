//
//  Game.swift
//  fifa-ranker
//
//  Created by Sylvain Giuliani on 01/01/2016.
//  Copyright © 2016 Sylvain Giuliani. All rights reserved.
//

import Foundation

struct Game: Resource {
    var id:Int?
    var homeTeam:Team?
    var awayTeam:Team?
    var createdAt:NSDate?
    
    var toJSON:[String:NSDictionary] {
        get {
            let object =  [
                "team_one": [
                    "fifa_team":  homeTeam!.fifaTeamId,
                    "players": homeTeam!.playerCombinationIds,
                    "goals_scored": homeTeam!.goalsScored!
                ],
                "team_two": [
                    "fifa_team":  awayTeam!.fifaTeamId,
                    "players": awayTeam!.playerCombinationIds,
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