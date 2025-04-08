//
//  ConfrencePageViewController.swift
//  sampleCallkit
//
//  Created by smartflomeet on 08/04/2025.
//  Copyright © 2020 smartflomeet. All rights reserved.
//

import UIKit
import EnxRTCiOS
import Foundation
class ConfrencePageViewController: UIViewController {

    var remoteRoom : EnxRoom!
    var objectJoin : EnxRtc!
    var localStream : EnxStream!
    @IBOutlet weak var localPlayerView: EnxPlayerView!
    @IBOutlet weak var speakerBTN : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localPlayerView.layer.cornerRadius = 8.0
        localPlayerView.layer.borderWidth = 2.0
        localPlayerView.layer.borderColor = UIColor.lightGray.cgColor
        localPlayerView.layer.masksToBounds = true
        objectJoin = EnxRtc()
        self.createToken()
        // Do any additional setup after loading the view.
    }
    @IBAction func muteUnMuteEvent(_ sender: UIButton) {
        guard remoteRoom != nil else {
            return
        }
        if sender.isSelected {
            localStream.muteSelfAudio(false)
        }
        else{
            localStream.muteSelfAudio(true)
        }
        sender.isSelected = !sender.isSelected
    }
    @IBAction func cameraOnOffEvent(_ sender: UIButton) {
        guard remoteRoom != nil else {
            return
        }
        if sender.isSelected {
            localStream.muteSelfVideo(false)
        }
        else{
            localStream.muteSelfVideo(true)
        }
        sender.isSelected = !sender.isSelected
    }
    @IBAction func changeCameraAngle(_ sender: UIButton) {
          _ = localStream.switchCamera()
    }
    @IBAction func speakerOnOffEvent(_ sender: UIButton) {
        guard remoteRoom != nil else {
            return
        }
        if sender.isSelected {
            remoteRoom.switchMediaDevice("EARPIECE")
        }
        else{
           remoteRoom.switchMediaDevice("Speaker")
        }
        sender.isSelected = !sender.isSelected
    }
    @IBAction func endCallEvent(_ sender: Any) {
        self.leaveRoom()
        
    }
    private func leaveRoom(){
           remoteRoom?.disconnect()
       }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func createToken(){
        guard let appdel = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        //5f0c70a27357b3e321b8cd0f
        let inputParam : [String : String] = ["name" :"EnablexRoom" , "role" :  "participant" ,"roomId" : appdel.room_Id, "user_ref" : "2236"]
        VCXServicesClass.featchToken(requestParam: inputParam, completion:{token  in
            DispatchQueue.main.async {
                //  Success Response from server
                let videoSize : [String : Any] =  ["minWidth" : 320 , "minHeight" : 180 , "maxWidth" : 1280, "maxHeight" :720]
                let playerConfiguration : [String : Any] = ["avatar":true,"audiomute":true, "videomute":true,"bandwidht":true, "screenshot":true,"iconColor" :"#0000FF"]
                let roomInfo : [String : Any] = ["allow_reconnect" :true , "number_of_attempts" :  3 ,"timeout_interval" : 20,"playerConfiguration":playerConfiguration,"activeviews" : "view"]
                    let localStreamInfo : [String : Any] = ["video" : true ,"audio" : true  ,"data" :true ,"name" :"Jay","type" : "public","audio_only" : false ,"maxVideoBW" : 120 ,"minVideoBW" : 80 , "videoSize" : videoSize]
                guard let steam = self.objectJoin.joinRoom(token, delegate: self, publishStreamInfo: localStreamInfo , roomInfo: roomInfo, advanceOptions: nil) else{
                        return
                    }
                    self.localStream = steam
                self.localStream.delegate = self as EnxStreamDelegate
            }
        })
    }
   func endCallTriger()  {
        NotificationCenter.default.post(name: NSNotification.Name("endCallTriger"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
}
/*
 // MARK: - Extension
 Delegates Methods
 */
extension ConfrencePageViewController : EnxRoomDelegate, EnxStreamDelegate {
    //Mark - EnxRoom Delegates
    /*
     This Delegate will notify to User Once he got succes full join Room
     */
    func room(_ room: EnxRoom?, didConnect roomMetadata: [String : Any]?) {
        remoteRoom = room
        remoteRoom.publish(localStream)
        localStream.attachRenderer(localPlayerView)
    }
    /*
     This Delegate will notify to User Once he Getting error in joining room
     */
     func room(_ room: EnxRoom?, didError reason: [Any]?) {
    }
    /*
     This Delegate will notify to  User Once he Publisg Stream
     */
    func room(_ room: EnxRoom?, didPublishStream stream: EnxStream?) {
        //To Do
        remoteRoom.switchMediaDevice("Speaker")
        speakerBTN.isSelected = true
    }
    /*
     This Delegate will notify to  User Once he Unpublisg Stream
     */
    func room(_ room: EnxRoom?, didUnpublishStream stream: EnxStream?) {
        //To Do
    }
    /*
     This Delegate will notify to User if any new person added to room
     */
    func room(_ room: EnxRoom?, didAddedStream stream: EnxStream?) {
        _ = room!.subscribe(stream!)
    }
    /*
     This Delegate will notify to User to subscribe other user stream
     */
    func room(_ room: EnxRoom?, didSubscribeStream stream: EnxStream?) {
        //To Do
    }
    /*
     This Delegate will notify to User to Unsubscribe other user stream
     */
    func room(_ room: EnxRoom?, didUnSubscribeStream stream: EnxStream?) {
        //To Do
    }
    /*
     This Delegate will notify to User if Room Got discunnected
     */
    func didRoomDisconnect(_ response: [Any]?) {
        endCallTriger();
    }
    /*
     This Delegate will notify to User if any person join room
     */
    func room(_ room: EnxRoom?, userDidJoined Data: [Any]?) {
        //listOfParticipantInRoom.append(Data!)
    }
    /*
     This Delegate will notify to User if any person got discunnected
     */
    func room(_ room: EnxRoom?, userDidDisconnected Data: [Any]?) {
        endCallTriger()
    }
    /*
     This Delegate will notify to User if any person got discunnected
     */
    func room(_ room: EnxRoom?, didChangeStatus status: EnxRoomStatus) {
        //To Do
    }
    /*
     This Delegate will notify to User to get updated attributes of particular Stream
     */
    func room(_ room: EnxRoom?, didUpdateAttributesOfStream stream: EnxStream?) {
        //To Do
    }
    /*
     This Delegate will notify to User if any new User Reconnect the room
     */
    func room(_ room: EnxRoom?, didReconnect reason: String?) {
        //To Do
    }
    /*
     This Delegate will notify to User with active talker list
     */
    func room(_ room: EnxRoom?, didActiveTalkerView view: UIView?) {
        self.view.addSubview(view!)
        self.view.sendSubviewToBack(view!)
    }
    
    func room(_ room: EnxRoom?, didEventError reason: [Any]?) {
        //let resDict = reason![0] as! [String : Any]
    }
    
    //Mark- EnxStreamDelegate Delegate
    /*
     This Delegate will notify to current User If any user has stoped There Video or current user Video
     */
    func didVideoEvents(_ data: [String : Any]?) {
        //To Do
    }
    /*
     This Delegate will notify to current User If any user has stoped There Audio or current user Video
     */
    func didAudioEvents(_ data: [String : Any]?) {
        //To Do
    }
    
}
