//
//  FifaTeamPushRow.swift
//  fifa-ranker
//
//  Created by Sylvain Giuliani on 11/01/2016.
//  Copyright © 2016 Sylvain Giuliani. All rights reserved.
//

//import Foundation
//import Eureka
//
//class FifaTeamPushRow<T: Equatable> : SelectorRow<T, FifaTeamTableViewController<T>>, RowType {
//    
//    required init(tag: String?) {
//        super.init(tag: tag)
//        presentationMode = .Show(controllerProvider: ControllerProvider.Callback {
//            return FifaTeamTableViewController<T>(){ _ in }
//            }, completionCallback: { vc in
//                vc.navigationController?.popViewControllerAnimated(true)
//        })
//    }
//}