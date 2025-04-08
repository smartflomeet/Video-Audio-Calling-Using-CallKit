//
//  EnxRoomInfoModel.swift
//  QuickApp_iOS
//
//  Created by smartflomeet on 08/04/2025.
//  Copyright © 2018 smartflomeet. All rights reserved.
//

import Foundation

import UIKit
//Mark : - This Model For getting Room Details
class EnxRoomInfoModel: NSObject {
    var role : String!
    var room_id : String!
    var  mode : String!
    var participantName : String!
    var error : String!
    var isRoomFlag : Bool!
}
//Mark : - This Model For getting Token Details
class EnxTokenModel: NSObject {
    var token :String!
    var error : String!
    
}
