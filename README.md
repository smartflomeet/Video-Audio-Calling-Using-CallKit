# Integrating CallKit with SmartfloMeet Platform: An iOS Sample App

This iOS Sample App is an exemplary guide for iOS developers aiming to integrate SmartfloMeet’s robust video and audio capabilities with CallKit framework using iOS Toolkit. This sample app is developed for devices with iOS 12.0 or above and brings the following features:

Native Phone UI Integration: Utilize the native incoming call screen in both locked and unlocked states.
Pre-configured Test Environment: The sample app comes with a pre-configured SmartfloMeet hosted server allowing quick testing.
Enhanced Call Control: Features like call muting, call holding, and many others are readily accessible.
Note: To try out this code, you’ll need an iPhone with iOS 12.0 or higher

*Note: CallKit is not supported in Simulator

What is CallKit?
CallKit is a framework that aims to improve the VoIP experience by allowing applications to integrate with the native phone UI. By adopting CallKit, your app will be able to use the native incoming call screen in both the locked and unlocked states.

### Note: To try out this code, you’ll need an iPhone with iOS 12.0 or higher
**Note: CallKit is not supported in Simulator* 

### What is CallKit?
CallKit is a framework that aims to improve the VoIP experience by allowing applications to integrate with the native phone UI. 
By adopting CallKit, your app will be able to use the native incoming call screen in both the locked and unlocked states.

## Installation and Prerequisites:

### Use CocoaPods to install the project files and dependencies.

1. Install CocoaPods as described in [CocoaPods Getting 
Started](https://guides.cocoapods.org/using/getting-started.html#getting-started).\
1.1 In Terminal, `cd` to your project directory and type `pod install`.\
1.2  Reopen your project in Xcode using the new `*.xcworkspace` file.

> SmartfloMeet Developer Center: https://doc.smartflomeet.ttns.in/

## 2. How to get started

### 2.1 Prerequisites

#### 2.1.1 App Id and App Key 


#### 2.1.2 Test Application Server

You need to set up an Application Server to provision Web Service API for your iOS Application to enable Video Session. 

To help you to try our iOS Application quickly, without having to set up Application Server, the Application is shipped pre-configured with SmartfloMeet hosted Application Server i.e. https://demo.smartflomeet.ttns.in/

Our Application Server restricts a single Session Durations to 10 minutes, and allows 1 moderator and not more than 3 participants in a Session.

Once you tried SmartfloMeet iOS Sample Application, you may need to set up your own  Application Server and verify your Application to work with your Application Server.  Refer to point 3 for more details on this.


#### 2.1.3 Configure iOS Client 

* Open the App
* Go to VCXConstant.swift, it's reads- 

``` 
 /* To try the App with SmartfloMeet Hosted Service you need to set the kTry = true
    When you setup your own Application Service, set kTry = false */
    
    let kTry = true

 /* Your Web Service Host URL. Keet the defined host when kTry = true */
    
    let kBasedURL = "https://demo.SmartfloMeet.io/"
     
 /* Your Application Credential required to try with SmartfloMeet Hosted Service
    When you setup your own Application Service, remove these */
    
    let kAppId    = ""
    let kAppkey   = ""
 
 ```
 ### 2.2 Test

 #### 2.2.1 Open the App

 * Open the App in your Device. 
 * You need to create a Room by clicking the "Call Triger" button.
 * Once the Room Id is created, your app will automatically create the "token" and join the room. Same time you can send push notification with the same room_id for other end user to join the same room.
 * Once the other end user has received the push notification, he/she will parse metadata and get room_Id to join the same room. 

 Note: Only one user with the Moderator Role is allowed to connect to a Virtual Room while trying with SmartfloMeet Hosted Service. Your Own Application Server can allow upto 5 Moderators. 
 
 Note: In case of emulator/simulator your local stream will not create. It will create only on real device.
 
 ## 3. Set up Your Own Application Server

 You need to set up your own Application Server after you tried the Sample Application with SmartfloMeet hosted Server. We have different variants of Application Server Sample Code. Pick the one in your preferred language and follow instructions given in respective README.md file.

 * NodeJS: [https://github.com/smartflomeet/Video-Conferencing-Open-Source-Web-Application-Sample.git]<br/>
* PHP: [https://github.com/smartflomeet/Group-Video-Call-Conferencing-Sample-Application-in-PHP]

 Note the following:

 * You need to use App ID and App Key to run this Service.
 * Your iOS Client EndPoint needs to connect to this Service to create Virtual Room and Create Token to join the session.
 * Application Server is created using SmartfloMeet Server API while a Rest API Service helps in provisioning, session access and post-session reporting.  

 
 ### 3.1 iOS Toolkit

 This Sample Application uses SmartfloMeet iOS Toolkit to communicate with SmartfloMeet Servers to initiate and manage Real-Time Communications. Please update your Application with latest version of SmartfloMeet IOS Toolkit as and when a new release is available.

* Documentation: https://doc.smartflomeet.ttns.in/docs/references/sdks/video-sdk/ios-sdk/index
* Download Toolkit: https://doc.smartflomeet.ttns.in/developer/video-api/client-api/ios-toolkit/

### 3.2 Use Xcode to build and run the app on an iOS device.

## 4. Exploring the sample app

**Call Triger**: 

![home](./home.png)

The iOS system boosts the call priority of the app. Then, the app starts publishing to SmartfloMeet platform. You will not notice any differences until you go to the home screen.
- An incoming native phone call will not interrupt the current VoIP call, instead, it shows the option menu.
- App will show native incoming call UI to answer the call.

**Incoming Call Unlock Screen**

![unlock](./unlock.png)

**Incoming Call Lock Screen**

![lock](./lock.png)

**Receive Call Lock Screen**

![lock1](./lock1.png)


**Use a push server or [NWPusher](https://github.com/noodlewerk/NWPusher) to call**

This requires a few more steps:

- Create your certificate
- Configure your push notification backend or NWPusher
- Locate your device token for testing (launch the app and get it from the console)
- Send a remote notification from your backend or NWPusher


## 5. Exploring the code
**CXProvider**\
CXProvider is an object which handles for report and out-of-band notifications to the system.
To initialize the provider with the appropriate `CXProviderConfiguration` object, the provider configuration specifies the behavior and capabilities of the calls to pass on the `CXProvider` initializer. In order to receive telephony events of the provider, the provider needs to specify an object conforming to the `CXProviderDelegate` protocol.

```swift
// create a provider 
let providerConfiguration = CXProviderConfiguration(localizedName: "EnxCall")
providerConfiguration.supportsVideo = false
providerConfiguration.maximumCallsPerCallGroup = 1
providerConfiguration.supportedHandleTypes = [.phoneNumber]
providerConfiguration.ringtoneSound = "callTone.caf"

// set up a provider
provider = CXProvider(configuration: type(of: self).providerConfiguration)
provider.setDelegate(self as? CXProviderDelegate, queue: nil)
```

The `CXProviderDelegate` protocol defines events of the telephony provider (`CXProvider`) such as - the call starting / the call being put on hold / end call / answer call.

```swift
// MARK: Provider Delegates
func providerDidReset(_ provider: CXProvider) {
for call in callManager.calls{
call.endCall()
}
callManager.removeAllCalls()
}

func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
print("To start a call action")
}

func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
print("Answer incoming call action")
}

func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
print("End call action")
}

func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
print("Hold call action")
}

func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
print("Mute call action")
}
``` 

The following methods indicate whether your VoIP call has been successfully priority boosted or recovered.

```swift
func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) {
print("Timed out Action")
// React to the action timeout if necessary, such as showing an error UI.
}

func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
// Start call audio media, now that the audio session has been activated after having its priority boosted.
}

func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
/*
Restart any non-call related audio now that the app's audio session has been
de-activated after having its priority restored to normal.
*/
}
```

**CXCallController** \
`CXCallController` is responsible to inform the system about user-initiated requests, such as a start call action. This is the key difference between the `CXProvider` and the `CXCallController`. The provider reports to the system whereas the call controller makes requests from the system on behalf of the user.

The call controller uses `CXTransaction` object  to request a telephony action (which will later trigger delegate methods as explained above, if succeeded). Each telephony action has a corresponding `CXAction` class such as `CXEndCallAction` for ending a call, `CXSetHeldCallAction` for setting a call on hold.

Once you have these ready, invoke the `request(_:completion:)` by passing a ready transaction object. Here's how you start a call:

```swift
// create a CXAction
let handle = CXHandle(type: .phoneNumber, value: handle)
let startCall = CXStartCallAction(call: UUID(), handle: handle): handle))


// create a transaction
let callTransaction = CXTransaction()
callTransaction.addAction(startCall)

// create a label
let action = "startCall"

callContr.request(callTrans){ error in
if let error = error {
print("Error requesting transaction: \(error)")
} else {
print("Requested transaction \(action) successfully")
}
}

```

As for answering a call, the `CallKit` framework provides a convenient API to present a native call UI. By invoking `reportNewIncomingCall(with:update:completion:)` on the provider, you will have the same as experience as receiving a native phone call. Often, this piece of code works with VoIP remote notification to make calls to a device/person same like native call UI experience.

```swift
// Construct a CXCallUpdate describing the incoming call, including the caller.
let update = CXCallUpdate()
update.remoteHandle = CXHandle(type: .phoneNumber, value: handle)

// Report the incoming call to the system
provider.reportNewIncomingCall(with: uuid, update: update) { error in
/*
Only add incoming call to the app's list of calls if the call was allowed (i.e. there was no error)
since calls may be "denied" for various legitimate reasons. See CXErrorCodeIncomingCallError.
*/
}
```
