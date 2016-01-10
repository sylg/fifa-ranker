//
//  Team.swift
//  fifa-ranker
//
//  Created by Sylvain Giuliani on 10/01/2016.
//  Copyright © 2016 Sylvain Giuliani. All rights reserved.
//

import Foundation

struct Team {
    var fifaTeam:FifaTeam?
    var playerCombination:[Player]?
    var goalsScored:Int?
    
    var playerCombinationIds:[Int] {
        return playerCombination!.map({$0.id!})
    }
    var fifaTeamId:Int {
        return fifaTeam!.id!
    }
}