{\rtf1\ansi\ansicpg1252\cocoartf2758
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fnil\fcharset0 Menlo-Regular;}
{\colortbl;\red255\green255\blue255;\red70\green137\blue204;\red23\green23\blue23;}
{\*\expandedcolortbl;;\cssrgb\c33725\c61176\c83922;\cssrgb\c11765\c11765\c11765;}
\paperw11900\paperh16840\margl1440\margr1440\vieww28600\viewh18000\viewkind0
\deftab720
\pard\pardeftab720\partightenfactor0

\f0\fs24 \cf2 \cb3 \expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 # Digio iOS UPI SDK Integration Guide\
\
![Github: release](https://img.shields.io/github/v/release/digio-tech/upi)\
[![](https://jitpack.io/v/digio-tech/upi.svg)](https://jitpack.io/#digio-tech/upi)\
[![License](https://img.shields.io/badge/License-Apache2.0-green.svg)](https://github.com/digio-tech/upi/blob/main/LICENSE)\
[![Logo](https://img.shields.io/badge/Powered%20by-Digio-2979BF.svg)](https://www.digio.in)\
\
## Overview\
\
This guide provides step-by-step instructions on how to integrate the Digio UPI SDK into your iOS application. The Digio UPI SDK enables seamless integration of Unified Payments Interface (UPI) functionality into your app, allowing users to make UPI transactions.\
\
**Note:** The Digio SDK supports iOS version 13.0 and above.\
\
## Getting Started\
\
**Step 1:**\
Digio upi is available through CocoaPods. To install it, add the following line to your Podfile \
\
```\
pod 'DigioUpi'\
```\
**Step 2:**\
Run\
```\
pod install\
```\
\
**Step 3:** \
Import Digio UPI Module\
\
```\
import DigioUpi\
```\
**Step 4:** \
Initiate digio Builder and pass required data. \
```\
func startDigio()  \{\
        do \{\
            let digio = try DigioUPI.Builder()\
                .setEnvironment(environment: .PRODUCTION)\
                .setId(id: "nachId/kycId") \
                .clientKeys(clientId: "Your_clientId", clientSecret: "Your_clientSecret")\
                .setServiceType(serviceType: .MANDATE)\
                .build()\
            digio.startDigio()\
        \}catch \{\
            print("digio_exception \\(error.localizedDescription)")\
        \}\
    \}\
```\
\
**Step 5:**\
Initialize DigioCallback in your view to observe response and events\
\
- **SwiftUI**\
Define below in your View\
```\
@ObservedObject var digioCallback = DigioCallback.shared\
```\
- **Swift**\
Define below global varialable in your ViewController  \
```\
private var transactionObserver: Any?\
private var transactionEventsObserver: Any?\
```\
\
**Step 6:**\
Register DigioCallback to observe SUCCESS/FAILURE/Events response.\
\
- **SwiftUI**\
Implement observer inside body of view to get response from framework \
```\
     func observeDigioCallBack()\{\
        if let transactionStatus = digioCallback.transaction\{\
            switch transactionStatus \{\
            case .success(let response):\
                let _ = print("digio_success --> \\(response.description)")\
               \
            case .failure(let response):\
                let _ = print("digio_failure -->\\(response.description)")\
              \
            case .partial(let response):\
                let _ = print("\\(response.description)")\
               \
            \}\
        \}\
        \
        /** Optional : To observe user journey for analytics purpose  **/\
        if let event = digioCallback.transactionEvents\{\
            switch event \{\
            case .onTransactionEvent(let events):\
                let _ = print("digio_event --> \\(events.description)")\
            \}\
        \}\
    \}\
\
```\
\
- **Swift**\
Implement observer inside viewDidLoad to get response from framework \
```\
func observeDigioCallBack()  \{\
        let digioCallback = DigioCallback.shared\
        transactionObserver = digioCallback.$transaction.sink \{ [weak self] transaction in\
            switch transaction\{\
            case .success(let response):\
                print("digio_success--> \\(response.description)")\
            case .failure(let response):\
                print("digio_failure--> \\(response.description)")\
            case .partial(let response):\
                print("digio_partial--> \\(response.description)")\
            case .none:\
                break\
            \}\
        \}\
        \
        /** Optional : To observe user journey for analytics purpose  **/\
        transactionEventsObserver = digioCallback.$transactionEvents.sink \{ [weak self] transactionEvents in\
            switch transactionEvents\{\
            case .onTransactionEvent(let events):\
                print("digio_event --> \\(events.description)")\
            case .none:\
                break\
            \}\
            \
        \}\
    \}\
```\
\
Clear observer from ViewController by calling below in ViewController oustside of viewDidLoad function. This apply only for swift.\
\
```\
deinit \{\
        // Release memory when the view controller is deallocated\
        transactionObserver = nil\
        transactionEventsObserver = nil\
    \}\
```\
\
**Step 7:** \
Add LSApplicationQueriesSchemes in your iOS app's Info.plist file\
```\
<key>LSApplicationQueriesSchemes</key>\
	<array>\
		<string>phonepe</string>\
		<string>gpay</string>\
		<string>paytmmp</string>\
		<string>bhim</string>\
		<string>upi</string>\
		<string>ppe</string>\
	</array>\
```\
\
\
#### Parameter and type\
\
\
| Parameter | Type     | Description                |\
| :-------- | :------- | :------------------------- |\
| `clientId` `clientSecret` | `string` | **Mandatory**. Your clientId and clientSecret key provided by Digio  |\
| `setId` | `string` | **Mandatory**. Your Nach Id for Mandate or KYC ID for Reverse penny drop |\
| `PRODUCTION` `SANDBOX` | `DigioEnvironment` | **Mandatory**. Environment can be SANDBOX or PRODUCTION |\
| `MANDATE` `REVERSE_PENNY_DROP` | `DigioService` | **Mandatory**. DigioService can be MANDATE or REVERSE_PENNY_DROP |\
\
#### Error code and Description\
\
| Code      | Description                |\
| :-------- | :------------------------- |\
| `1103`| **SUCCESS**  |\
| `1104`| **FAILURE**  |\
| `1105`| **CANCELLED**  |\
| `1108`| **PARTIAL**  |\
| `1106`| **UPI APP NOT FOUND**  |\
\
\
#### Response sample \
\
| Status    | Response                |\
| :-------- | :------------------------- |\
| `EVENTS`| DigioEventResponse(action = DIGIO_INITIATED, screen = UPI_PAGE)  |\
| `SUCCESS`| DigioResponse(id= ENA23101017504882619RVM5Y1DTYPEUP, message= Mandate REGISTER_SUCCESS, statusCode= 1103, status= register_success, crash_report= null )  |\
| `FAILURE`| DigioResponse(id= ENA23101017504882619RVM5Y1DTYPEUP, message= Transaction cancelled, statusCode= 1105, status= partial, crash_report= null )  |\
| `PARTIAL`| DigioResponse(id= ENA231012193700713FA5VYQRZT6916UP, message= Mandate created partial, statusCode= 1108, status= partial, crash_report= null )  |\
\
\
## License\
[![License](https://img.shields.io/badge/License-Apache2.0-green.svg)](https://github.com/digio-tech/upi/blob/main/LICENSE)\
\
## Support\
\
For support, email support@digio.in\
}