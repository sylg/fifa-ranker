//
//  FifaApi.swift
//  fifa-ranker
//
//  Created by Sylvain Giuliani on 01/01/2016.
//  Copyright © 2016 Sylvain Giuliani. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


protocol Endpoint {
    var path:String {get}
    var method:Alamofire.Method {get}
    var resourceName:String {get}
}

protocol Resource {
    var id:Int {get}
}

public enum APIEndpoint: Endpoint {
    case Players
    case FifaTeams
    case PlayerCombinations
    case Game
    case Games
    
    public var path:String {
        switch self {
        case .Players:
            return "players"
        case .FifaTeams:
            return "fifa_teams"
        case .PlayerCombinations:
            return "player_combinations"
        case .Game:
            return "games"
        case .Games:
            return "games/"
        }
    }
    
    public var method:Alamofire.Method {
        switch self {
        case .Players, .FifaTeams, .PlayerCombinations, .Game:
            return .POST
        case .Games:
            return .GET
        }
    }
    
    public var resourceName:String {
        switch self {
        case .Players:
            return "player"
        case .FifaTeams:
            return "fifa_team"
        case .PlayerCombinations:
            return "player_combination"
        case .Game:
            return "games"
        case .Games:
            return "games"
        }
    }
    
}

class FifaAPI {
    var baseUrl:String {
        get {
            let env = NSProcessInfo.processInfo().environment
            if env["environment"] != nil {
                return "http://127.0.0.1:9393/"
            } else {
                return "https://herokuapp.com/"
            }
        }
    }
    
    func post(resource:APIEndpoint, data:AnyObject, onCompletion:(response:String?, error:NSError?)->Void) {
        let fullURL = self.baseUrl + resource.path
        var validData:[String:AnyObject]?
        
        switch resource {
        case .Game:
            print("game")
            validData = (data as! Dictionary)
        default:
            print("not implemented \(resource)")
        }
        
        
        Alamofire.request(.POST, fullURL, parameters: validData!, encoding: .JSON).responseJSON { response in
            print(response)
            switch response.result {
            case .Success:
                onCompletion(response: "success", error: nil)
            case .Failure(let error):
                onCompletion(response: nil, error: error)
            }
            
        }
    }
    
    func getAll(resource:APIEndpoint, onCompletion:(response:[Resource]?, error:NSError?)->Void) {
        let fullURL = self.baseUrl + resource.path
        
        Alamofire.request(.GET, fullURL).responseJSON { response in
            var results = [Resource]()
            
            switch response.result {
                
                case .Success:
                    let json = JSON(data: response.data!)
                    for (_,subJson):(String, JSON) in json {
                        switch resource {
                        case .Players:
                            results.append(Player(SlackId: Int(subJson["slack_id"].string!)!, slackName: subJson["slack_name"].string!, id: subJson["id"].int!))
                        case .FifaTeams:
                            results.append(FifaTeam(teamName: subJson["team_name"].string!, teamRating: subJson["team_rating"].int!, id: subJson["id"].int!))
                        default:
                            print("not implemented")
                        }
                    }
                    onCompletion(response: results , error:nil)
                
                case .Failure(let error):
                    onCompletion(response: nil, error:error)
            }
            
        }
    }
    
    
}







