//
//  SocketIOManager.swift
//  TickTock
//
//  Created by Yash on 04/06/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import Foundation


class SocketIOManager: NSObject
{
    static let sharedInstance = SocketIOManager()
    var socket = SocketIOClient(socketURL: URL(string: "http://35.154.46.190:1337")!, config: [.log(true), .forcePolling(true), .connectParams(["__sails_io_sdk_version":"0.11.0"])])
    
    override init()
    {
        super.init()
        
        socket.on("test") { dataArray, ack in
            print(dataArray)
        }
        
        socket.on("game_updates") { dataArray, ack in
           
            print("data:>\(dataArray)")
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "callGameUpdateNotification"), object: dataArray[0] as? [String: AnyObject])
        }
    }
    
    func establishConnection()
    {
        socket.connect()
    }
    
    func closeConnection()
    {
        socket.disconnect()
    }
}
