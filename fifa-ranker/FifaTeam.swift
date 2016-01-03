//
//  Team.swift
//  fifa-ranker
//
//  Created by Sylvain Giuliani on 01/01/2016.
//  Copyright © 2016 Sylvain Giuliani. All rights reserved.
//

import Foundation

class FifaTeam: Resource, Hashable, CustomStringConvertible {
    let id:Int
    let teamName:String
    let teamRating:Int
    
    var hashValue:Int {
        return id
    }
    
    var description:String {
        return teamName
    }
    
    init(teamName:String, teamRating:Int, id:Int) {
        self.id = id
        self.teamName = teamName
        self.teamRating = teamRating        
    }
}

func ==(lhs: FifaTeam, rhs: FifaTeam) -> Bool {
    return lhs.id == rhs.id
}