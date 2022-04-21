# Changelog Mobile Keys iOS SDK

## [7.5.2] - January 2020
* Version 7.5.2 is built with XCode11.3 and latest target iOS 13.3 (deployment target is minimum iOS 11.0)*

### Bug fixes
* Fixed a problem with personalization error by improving its session performance. 


## [7.5.1] - November 2019
* Version 7.5.1 is built with XCode11.2.1 and latest target iOS 13.2 (deployment target is minimum iOS 11.0)*
### Bug fixes
* Fixed error with invalid invite code (eg., UUUU-UUUU-UUUU-UUUU / QQQQ-QQQQ-QQQQ-QQQQ)
* Fixed an internal race condition where the Seos session was closed
* Fixed an internal crash on bluetooth scanner when start/stop scan repeatedly
* Set rotationRecognizer in pause mode when T&G is NOT supported.
* If all hardware is OFF both userMadeUnlockGesture and unlockSpecificReader are disabled
* Added BUILD_LIBRARY_FOR_DISTRIBUTION=YES


## [7.5.0] - September 2019
* Version 7.5.0 is built with XCode11 and latest target iOS 13.0 (deployment target is minimum iOS 11.0)*

* Add the key-value: NSBluetoothAlwaysUsageDescription to info.plist

### Bug fixes
-  `MobileKeysManager:stopReaderScan` did not stop BLE scanning correctly.

## [7.4.1] - August 2019
* Version 7.4.1 is built with XCode10.3 and latest target iOS 12.4 (deployment target is minimum iOS 10.0)*

* Protection framework guards updated to prevent crashes on iOS 13 Beta.

## [7.4.0] - May 2019
* Version 7.4.0 is built with XCode10.2.1 and latest target iOS 12.2 (deployment target is minimum iOS 10.0)*

* The   `MobileKeysManager:setSupportsMachineLeaningModel:enable`  and the option `MobileKeysOptionMachineLearningModelUrl` is removed. This should not affect
any integrator. 

* Minor code changes to prevent crashes on iOS 13 Beta.

### Bug fixes
 - Incorrect notification message displayed in Mobile Access app when Twist and Go option is turned off in settings page
 

## [7.3.0] - May 2019
* Version 7.3.0 is built with XCode10.2 and latest target iOS 12.2 (deployment target is minimum iOS 10.0)*

### API Changes
* Improvements for On Premise TSM Configuration, a new option `MobileKeysOptionCustomSetupAkeKey` for the MobileKeysManager init function. 
See chapter "Custom TSM Configuration for On Premise Systems" of the documentation for details. 

* Metadata tag 0xFF41: Sub tag 0x8B is changed to reserved for compatibility with Android

### New functionality 
Support for machine learning to detect Twist and Go (supported for iOS11.0 or newer)
* To enable machine learning twist and go a coreML file is required.
* Machine learning model is OFF by default, using the original algorithm for detecting T&G.
* To enable machine learning model the application needs to call  `MobileKeysManager:setSupportsMachineLeaningModel:enable` 
and the machinelearning model url needs to be specified with `MobileKeysOptionMachineLearningModelUrl` and added to the app bundle.
* Added CoreML.framework.

### Bug fixes
Wrong error from SDK when entering invalid Invite Code - 702 (Network connectivity) instead of error 901 (Invalid Code)
Optional scan response data can sometimes return an empty string

## [7.2.4] - April 2019
* Version 7.2.4 is built with XCode10.2 and latest target iOS 12.2 (deployment target is minimum iOS 10.0)*

### API Changes
  * The status reporting for Motion unlocks has been changed to closer correlate to how this works on Android. 
 For succesful and failed Twist And Go Unlocks, the logic is now as follows:

When a Twist And Go is detected: 
1. List all readers that are ACTIVE (By ACTIVE, we mean readers that have been seen in the last 10 seconds)
2. Sort this list, find the closest Reader
3. If No reader found, return `MobileKeysOpeningStatusTypeOutOfRange`
4. If the Reader is in TIMEOUT, just return (by TIMEOUT we mean that the readers has a successful opening less than 2 seconds ago)
5. If the Reader does not support the current opening type, return `MobileKeysOpeningStatusTypeMotionNotSupported`
6. If the Reader is not in range return `MobileKeysOpeningStatusTypeOutOfRange`
7. Return the reader (Succesful case) and `MobileKeysOpeningStatusTypeSuccess`

### Bug fixes
MobileKeysOpeningStatusTypeMotionNotSupported missing
MobileKeysOpeningStatusTypeOutOfRange missing

The opening type ApplicationSpecific did not work with default configured readers and returned nil instead of a MobileKeysReader object.
`[mobileKeysManager:closestReaderWithinRangeOfOpeningType:MobileKeysOpeningTypeApplicationSpecific]`

## [7.2.3] - March 2019
Version 7.2.3 is an internal testing release that was never released to the public. 

## [7.2.2] - February 2019
* Version 7.2.2 is built with XCode10.1 and latest target iOS 12.1 (deployment target is minimum iOS 10.0)*

* Support for dual mode with the option MobileKeysOpeningTypeEnhancedTap

### Dual Mode - Phone operating both as a BLE Peripheral and a BLE Central
For some time now, the Seos BLE Specification has allowed for the phone to act as both a BLE Peripheral and a BLE Central. We have made only minor changes to the SDK API 
to allow for this change.

To take advantage of the new BLE Dual Mode:
* Just start scanning like normal, but make sure that the MobileKeysOpeningTypeEnhancedTap opening type is enabled. 
* Add the key-value: NSBluetoothPeripheralUsageDescription to info.plist
* Add the capability: bluetooth-peripheral to UIBackgroundModes
* All this in conjuntion with a updated Reader, supporting Enhanced Tap, allows for really improved opening times.


### API Changes
* MobileKeysOpeningTypeEnhancedTap needs to be specified in the supported opening types when scanning. 
* MobileKeysOpeningResult has a new property "connectionDuration". Connection duration is the time interval when phone and reader communicates over some media (BLE, ...)

* MobilekeyInfoType has a new status type, MobileKeysInfoTypeBleSharingTurnedOff, this means that "Bluetooth sharing" authorization for BLE Peripheral mode has not been granted by the user. 
This should only happen when using Enhanced Tap. Recommended user action is to go to App System Settings and enable Bluetooth Sharing.

## [7.2.1] - January 2018
Version 7.2.1 is an internal testing release that was never released to the public. 

## [7.2.0] - January 2018
Version 7.2.0 is an internal testing release that was never released to the public. 

## [7.1.0] - January 2019
* Version 7.1.0 is built with XCode10.1 and latest target iOS 12.1 (deployment target is minimum iOS 10.0)*
Swift version used for Swift code is Swift 4.2.

*  MobileKeysOpeningTypeEnhancedTap can be set to enable Raptor readers that support "reverse mode"

### API Changes
* MobileKeysReader now keeps track of last successful connection time
* MobileKeysManagerOption constant "MobileKeysOptionPeripheralMode" is removed.

## [7.0.3] - December 2018
* Version 7.0.3 is built with XCode10.1 and latest target iOS 12.1 (deployment target is minimum iOS 10.0)*
Swift version used for Swift code is Swift 4.2.

*  MobileKeysManager has a new option constant "MobileKeysOptionCustomEventValue" that can be used to pass a NSNumber restricted to short

### API Changes
* MobileKeysReader now keeps track of optional Scan response data (can be used for storing HID Readers serial number)

## [7.0.2] - November 2018
* Version 7.0.2 is built with XCode10.1 and latest target iOS 12.1 (deployment target is minimum iOS 10.0)*
Swift version used for Swift code is Swift 4.2.

### Bug fixes
* High memory consumption when opening multiple sequential Seos Sessions
 - This could be easily reproduced by looping over the MobileKeys , opening a session for each key and performing an operation on the key. Improvements have been made to decrease the amount of RAM used by each Seos Session.
* Poor performance when working with more than a handful of Mobile Keys
 - Improvements have been made to how we persist and load the protected key vault that should speed things up when the number of keys increase.

## [7.0.1] - October 2018
* Version 7.0.1 is built with XCode10.1 and latest target iOS 12.1 (deployment target is minimum iOS 10.0)*
Swift version used for Swift code is Swift 4.2.

* Version 7 is the first version of the SDK that includes Swift based binaries internally. 
Adding Swift based code to the SDK has provided some interesting (ehem) technical challenges. From this version, all new code inside the 
SDK will be written in Swift, and over time existing code will be converted to Swift as well. 
From an integrator perspective, switching over to 7.0.1 requires a few changes to the Application Build Settings:
- ALWAYS_EMBED_SWIFT_BINARIES need to be set to YES
- Minimal Deployment Target is now 10.0

* Please note that The Mobile Access SDK Main API is still using Objective C.

* Please note that this version does not yet run on Watch OS Targets, even though the pod specification says so. We are working on enabling support for Watch OS. 

### API Changes
* MobileKeysManager has a new option constant "MobileKeysOptionPeripheralMode" that enables communication with Readers operating in BLE Central Mode.
    * This requires a new type of Reader, meaning that there is no reason to activate this feature unless you have access to the new unreleased Readers.
* MobileKeysManager has a new option constant "MobileKeysOptionMotionManager" that can be used to pass an instance of a CMMotionManager to the SDK.

* The MobileKeysMotionRecognizer is rewritten, and now requires a call to "resumeTrackingRotation" before starting. The class should now consume less resources when in a paused state,
and pausing/resuming tracking should be faster.

* Default timeouts when communicating with Readers have been updated. The new default values are:
- Maximum time between packets when communicating with a Reader: 0.3s
- Maximum time waiting for a command (APDU) from Reader: 1.2s
- Maximum time waiting for a connection established: 3.2s

### New functionality
* This version increases the available space for Seos keys to 32x32 kB. Each individual key (up to 32 Keys) may only consist of maximum 32768 bytes, while
previously this was the combined maximum size for all keys.
This means that the maximum storage capability of the Seos vault is now 32k(GDF) + 32*32k (ADFs). For performance and security reasons, this means that when upgrading to 7.0.1, the encrypted Seos Data Vault will increase in size to approximately 1.1 MB.

### Bug fixes
* Fixed an edge case where locks could not be unlocked if the lock was engaged immediately when the application was started
* iBeacon ranging (if enabled) is now disabled while communicating to a Reader
* Changes to faulty log printouts
* Improved memory consumption 

## [7.0.0] - October 2018
Version 7.0.0 is an internal testing release that was never released to the public. 

## [6.5.1] - October 2018
*Version 6.5.1 is built with XCode10.0 and latest target iOS 12.0 (deployment target is minimum iOS 8.0)*

* Recompiling version 6.5.0 for the new archetecture arm64e and iOS12. No other changes.


## [6.5.0] - August 2018
*Version 6.5.0 is built with XCode9.4.1 and latest target iOS 11.4 (deployment target is minimum iOS 8.0)*

### Bug fixes
* Fixed a bug where BLE session handling was not correct, this could lead to reconnecting to a disconnected reader upon a failed connection.


## [6.4.0] - June 2018
 *Version 6.4.0 is built with XCode9.3 and latest target iOS 11.3 (deployment target is minimum iOS 8.0)*
 
 ### Important notice for Mixpanel users
 * don't use Mixpanel::sharedInstance. Use Mixpanel::sharedInstanceWithToken or else your data might be lost.  
 
 ### API Changes
* If your application used the functionality of the `(BOOL)mobileKeysShouldInteractWithScannedReader:(MobileKeysReader *)mobileKeysReader` 
callback, the function did not work as intended. In the previous versions, the SDK would send this callback, and depending on the 
response (or lack thereof) the SDK would sometimes try to connect to MobileKeysReaders (this is NOT the same as the bug fixed on startup, see below). 
This is a low-level method that should only be implemented for custom opening behaviors,  i.e. not one of the types in `MobileKeysOpeningType`.

### New functionality
There are two new options to the options dictionary of the MobileKeysManger init function for use with On Premise TSM 
systems. These can (and should) safely be ignored for most integrators. See the documentation for information on how 
these work.
 - MobileKeysOptionTSMPublicCert
 - MobileKeysOptionTSMBaseURL

### Protected Data handling
The ASSA ABLOY Mobile Access SDK uses data protection for certain files. In practice, this means that it will not be possible to initialize the 
SDK before the user has unlocked the phone after a reboot. Added example code that can be put in AppDelegate.m if you have problems with 
the SDK not returning the correct data (i.e it says it's not registered even though it should be).

### Bug fixes
* The `(BOOL)mobileKeysShouldInteractWithScannedReader:(MobileKeysReader *)mobileKeysReader` callback response is now handled
correctly. 

* Fixed the bug where the application sometimes started reconnecting to a disconnected reader upon startup.

* Fixed a bug where autojoin and autosplit didn't work for the deprecated get/put data methods in MobilekeysManager

* Updated default value of MobileKeysOpeningTypeMotion to -74 (from -60). This default value is overwritten by the advertismentpackage from the 
reader. This old default value could make T&G not responsive at startup.

* No reader in range problem when the device loses an advertisment packege and fallback to the default value. The value from the reader is now latched, 
meaning it starts with a default value and is only updated when advertisment packes are recieved from a reader.

## [6.3.0] - April 2018
*Version 6.3.0 is built with XCode9.3 and latest target iOS 11.3 (deployment target is minimum iOS 8.0)*

### API Changes
 There has been one important change that might require actions by Integrators that rely on the opening
 type "MobileKeysOpeningTypeApplicationSpecific".

* MobileKeysOpeningTypeApplicationSpecific was previously activated by default in the SDK. Now this openeningtype has to
 be activated by the application when scanning, or by the reader.
Add MobileKeysOpeningTypeApplicationSpecific to supportedOpeningTypes when starting scanning with: 
`[MobileKeysManager:startReaderScanInMode:supportedOpeningTypes:lockServiceCodes:error]`.

* Fixed _Nullable markup for lastAuthenticationInfo and blanket NON_NULL for the MobileKeysManagerDelegate
    - This might change the method footprint on some delegate calls when integrating through Swift

### Bug fixes
* Fixed a bug where "putData" did no longer work, it was simply not working.
* Fixed a problem where session openings errors were wrongly detected
* Fixed a problem where the SDK did not allow immediate calls when a Reader connection was closed.
* Fixed a problem where the BLE module could hang if scanning was stopped mid-connection

## [6.2.0] - February 2018
*Version 6.2.0 is built with XCode9.2 and latest target iOS 11.0 (deployment target is minimum iOS 8.0)*

### API Changes
 * Application can now implement the new `[MobileKeysManager:mobileKeysDidUpdateEndpointWithSummary:]` callback method 
 instead of `[MobileKeysManager:mobileKeysDidUpdateEndpoint]`. The new method will provide some high level information on 
 what the last Server update consisted of. The number of updated, revoked and isued keys, as well as some information
 on how long the server communication took. Application can choose which one of these callbacks to implement, but please 
 note that both methods will be called if both are implemented. 

## [6.1.1] - February 2018
*Version 6.1.1 is built with XCode9.2 and latest target iOS 11.0 (deployment target is minimum iOS 8.0)*

 * New Release Notes format (this file)

### API Changes
 * MobileKeysReader now exposes the rssiList and rssiHistory for Readers.

### Bug fixes
 * This release should solve a problem with random crashes where sempahores were dealloced while in use


## [6.1.0] - January 2018
*Version 6.1.0 is built with XCode9.2 and latest target iOS 11.0 (deployment target is minimum iOS 8.0)*

### Changed
- Updated BLE Api so that EOT returns a valid result even though the timeout happens, for cases where the connection isn`t
  promptly closed from the other end upon completion
- Added a "closeSession" to The Reader Session
- Refactored "didCloseConnection" handler so that it handles connections that close after a timeout
- Fixed a bunch of poor debug printouts in MobileKeysManager


### API Changes
- A new function "enableTestVectors:(BOOL)" on the MobileKeysApduConnectionProtocol. This method can be used to implement
specifics when a Seos Apdu Connection protocol implementation needs to enable test vectors.
- The "MobileKeysManager:unregisterEndpoint" method will delete an endpoint by calling the TSM and then uninstall Seos from
the device. This method makes it possible to implement "user initiated opt-out" to comply with GDPR.
- When specifying a timeout for MobileKeysSessionParameters, the "timeout" parameter has been modified to take a timeout in
milliseconds instead of seconds, and the name of this property has been updated to reflect this.
- Deprecated the MobileKeysSeosProvider:closeSeosSession, use the MobileKeysSeosSession:closeSessionWithError instead

### Bug fixes
 - In some instances when a BLE connection is terminated from the remote end, the BLE connection returns "Timeout" even
 though the transaction is OK (Also a functional change above)
 - When setting up a session using Reverse AKE, MobileKeysSeosProvider now closes the attempted session if AKE setup
 doesn`t go well.
 - Seos AKE ephemeral keys are not generated correctly for Reverse AKE (6.0.3)
 - Seos test vector mode can not be enabled correctly by the SDK. (6.0.2)

## [6.0.4] -   (January 2018)
*Version 6.0.4 is built with XCode9.2 and latest target iOS 11.0 (deployment target is minimum iOS 8.0)*

*Version 6.0.5 was never released officially.*

### Bug fixes
 - A new function "enableTestVectors:(BOOL)" on the MobileKeysApduConnectionProtocol. This method can be used to implement
specifics when a Seos Apdu Connection protocol implementation needs to enable test vectors.
 - Updated BLE Api so that EOT returns a valid result even though the timeout happens, for cases where the connection
 isn`t propmply closed from the other end upon completion

## [6.0.3] -   (January 2018)
*Version 6.0.3 is built with XCode9.2 and latest target iOS 11.0 (deployment target is minimum iOS 8.0)*

*Version 6.0.3 was never released officially*

### Bug fixes
 - Seos AKE ephemeral keys are not generated correctly for Reverse AKE

## [6.0.2] -   (Jan 2018)
*Version 6.0.2 is built with XCode9.2 and latest target iOS 11.0 (deployment target is minimum iOS 8.0)*

*Version 6.0.2 was never released officially, but fixed the following bug:
 - Seos test vector mode coan not be enabled correctly by the SDK.

## [6.0.1] -   (Jan 2018)
*Version 6.0.1 is built with XCode9.2 and latest target iOS 11.0 (deployment target is minimum iOS 8.0)*

This release was never published publicly.

## [6.0.0] -   (December 2017)
*Version 6.0.0 is built with XCode9.2 and latest target iOS 11.0 (deployment target is minimum iOS 8.0)*

### Added
The main new feature is the capability to setup sessions to a Card using Terminal reversed AKE (Authenticated Key Exchange).
This gives the user (terminal) the capability to communicate to another Seos (card) located on another device.
The documentation contains code examples as well as test keys. Changes in the Mobile Keys Seos Access API have been done
to provide support for AKE Authentication.

### Changed
Added support for AKE Key Authentication.

If the SDK detects that the Seos Vault no longer is accessible, this is now reported to the TSM, and the
`[MobileKeysManagerDelegate:mobileKeysDidTerminateEndpoint]` will be called. This check is done during startup or endpoint updates.

### API Changes
 - `MobileKeysApduConnectionProtocol` protocol now requires a new method: activeConnection  which needs to be able to suggest
   if there is an active ongoing connection.
 - `MobileKeysSessionParameters::setSingleOidSelection(NSData *)` - new convenience method for setting a single OID for selection
 - `MobileKeysSeosSession` now holds its `MobileKeysSessionParameters`
 - `MobileKeysSeosSessions` can now establish a Session directly through an APDUConnection, although Mutual Authentication is still
   done through the `MobileKeysSeosProvider`.
 - `MobileKeysSeosProvider` now provides a method to establish a Session to a Card using AKE. The current API requires a
   secondary `MobileKeysSeosProvider`.

 - `MobileKeysSeosProvider` class is still used when setting up an APDU Session, but it is now possible to get a Session
   object (using the `[MobileKeysSeosProvider establishSessionWithParameters]` method) and then use the MobileKeysSeosSession
   object to send the parameters. This now works for both "regular" Seos Sessions and Sessions that have been authenticated
   using AKE.

 - Specifying global keys (for security or authentication) is no longer done by specifying the "global" flag, but the
   global keys have been changed into their own enum vaules.

 - The `[MobileKeysManager listReaders]` method did not correctly filter out old Readers. Readers that have not been
   seen in ten seconds are now filtered out.


### Bug fixes
 - Better error checking when validating misc APDU Command objects and the responses


## [5.5.0] -   (November 2017)
*Version 5.5.0 is built with XCode9.0 and latest target iOS 11.0 (deployment target is minimum iOS 8.0)*

### Bug fixes
BLE Communication hanging
Fixed a bug where the lock communication could lock up if no data was received from the lock after a successful connect.

Inaccessible Seos Keys because of changing "identifierForVendor"
Since version 4.1.0 of the SDK, the semi-unique "identifierForVendor" has been used to tie the Seos Vault to a specific
device. Over time it has become obvious that this ID is not consistently persistent across application updates and/or
iOS updates, sometimes causing the Seos Vault to become inaccessible after an upgrade. From *Version 5.5.0, the "identifierForVendor"
will no longer be used for this purpose.

A note on corrupted Seos Vaults
Because of the changing "identifierForVendor" the number of corrupted Seos Vaults has increased lately. Normally, this
has resulted in "error 99". The only workaround has been to uninstall the application and then reinstall it.

The SDK now detects Seos Vault errors, making it possible to re-register by entering a new Invitation code. Previously,
it was neccessary to uninstall the application and reinstall it when the Seos Vault was having problems.

To help detecting if there is something wrong with the Seos Vault, the `[MobileKeysManager:isEndpointSetup:]` method now
responds with "NO" and sets the error to "999" (MobileKeysErrorCodeCorruptedStorage). If this should happen,
the endpoint needs to be setup again.

## [5.4.0] -   (October 2017)
*Version 5.4.0 is built with XCode9.0 and latest target iOS 11.0 (deployment target is minimum iOS 8.0)*

#### Configuring the application to run in the background
Behavior has changed between iOS 10 and iOS 11. To ensure compatibility with both applications that need to run in the
background and application that only need to run in the foreground, configuration of the background modes has been
removed from the SDK, and must be managed by the application.

For applications that only need to run in the foreground,
the method `[MobileKeysManager startReaderScanInMode:supportedOpeningTypes:lockServiceCodes:error:]` with scanMode
MobileKeysScanModeOptimizeBatteryConsumption should be used. In those cases, it is not required to enable background
modes according to the description below.

For applications that need to run in the background,
the method `[MobileKeysManager startReaderScanInMode:supportedOpeningTypes:lockServiceCodes:error:]` with scanMode
MobileKeysScanModeOptimizePerformance should be used. In those cases, it is required to enable background
modes according to the description below.

#### Enabling background running
For any application that needs to be run in the background, steps 2, 3 and 4 below need to be
performed by the application. Step 3 can be performed by the application at any time (e.g. when the application is put
in the background, or when it starts) , and step 4 needs to be performed by the application before calling the
`[MobileKeysManager startReaderScanInMode: MobileKeysScanModeOptimizePerformance supportedOpeningTypes:lockServiceCodes:error:]` method.

The application needs to instantiate a CLLocationManager to perform steps 2,3 and 4.

1. Background mode: Location updates
For iOS 11, the project setting background mode "Location updates" is required. iOS will suspend operations after
approximately 6-8 seconds otherwise.

2. CLLocationManager::allowsBackgroundLocationUpdates must be set to YES.
It is possible to disable the background mode by setting this to NO, e.g. if the apps wants to allow the user to disable
the background mode

3. CLLocationManager::requestAlwaysAuthorization
This will present the user with information about the background modes. The appropriate information needs to be added to
NSLocationWhenInUseUsageDescription, NSLocationAlwaysAndWhenInUseUsageDescription, NSLocationAlwaysUsageDescription and
possibly even to NSLocationUsageDescription in the info.plist.

4. CLLocationManager::startUpdatingLocation tells iOS to start giving us ranginginformation
For iOS 11, this is required if the application needs persistent ranging.

#### Killing the app
For the “Killed state”, ranging stops working after approximately 15 to 30 minutes. However, if the user force quits
the app by swiping it away, it could be argued that he or she doesn’t want the app running.

### API Changes
The property "endpointId" of MobileKeysInfo is being decoupled from the TSM identity for the "endpointId". To make this
difference clear, the SDK property that uniquely identifies the local Seos Vault will be renamed to "seosId".

### Bug fixes
A bug where the SDK sometimes initiated connections to stale peripherals has been resolved. The SDK should no longer hang
if a BLE connection is established immediately upon startup.



## [5.3.0] -   (October 2017)
*Version 5.3.0 is built with XCode9.0 and latest target iOS 11.0 (deployment target is minimum iOS 8.0)*

API changes
-----------
NSError root cause description
  If an error has one or more layer of nested NSErrors in its userinfo disctionary under NSUnderlyingErrorKey, the
  value of the description included in the bottom-most error will be added to NSDebugDescriptionErrorKey of the top-most
  error for visibility.

MobileKeysSessionParameters extensions
  There have been some additions to the MobileKeysSessionParameters object making it possible to configure the session
  with additional properties. All of these are optional, and the BOOL parameters default to NO. For more information, see
  the documentation for these properties.
   - @property(nonatomic) BOOL autoSplitLargeApduCommands;
   - @property(nonatomic) BOOL autoJoinMultipleApduResponses;
   - @property(nonatomic) MobileKeysSessionClientIdentifier mobileKeysSessionClientIdentifier;

Nullability specifier warnings
  Nullability specifiers have been added to large portions of the SDK. This should get rid of most warnings having to do
  with Nullability not being specified. (Especially useful for Swift integrators).

Bug fixes
---------
A threading problem that occurred when multiple Readers were close enough to engage has been resolved. This could force
the API into a deadlock, causing Error 99 (Internal Error) to happen in a multitude of places.

Jailbreak detection for iOS 11 was broken, and phones were wrongly reported as jailbroken. This has been resolved.

Several crashes having to do with bad data input validation of TLV data have been resolved

A deadlock on the BLE layer sometimes caused the app to stop responding, leading to a crash. This has been resolved.

Known issues
------------
Getting the ful list of RSSI values for MobileKeysReaders is currently not working. This will be resolved in later releases.


## [5.2.0] -   (September 2017)
*Version 5.2.0 is built with XCode9.0 and latest target iOS 11.0 (deployment target is minimum iOS 8.0)*

- The options for the MobileKeysManager has a new key
* MobileKeysOptionBeaconUUID: NSString
  This string is an iBeacon UUID to monitor. If defined, this string will override the default iBeacon UUID monitored.
  By default, the SDK will monitor (and range) a specific iBeacon id when scanning is started in mode
  "MobileKeysScanModeOptimizePerformance".
  By default, the iBeacon id monitored is "00009999-0000-1000-8000-00177a000002", but for integrators that deploy
  own iBeacons, this can now be configured.

Bug fixes
---------
- AMSNearbyBeaconDetector should not clear all beacon regions when the SDK stops listening for locks containing  iBeacons,
  in order to be a good citizen when the application uses other frameworks that also use iBeacons.

- The timeout before abandoning hanging BLE connections has been increased. This should decrease the number of crashes
  occurring when the connection to the Reader is unexpectedly dropped.

Code cleanups
-------------
 - A lot of warnings concerning Nullability specification of method parameters have been adressed.
 - Removed deprecated properties from MobileKeysAuthenticationKeySet
 
## [5.1.5] -   (September 2017)
*Version 5.1.5 is built with XCode8.3.3 and latest target iOS 10.3 (deployment target is minimum iOS 8.0)*

Change in how location permissions are managed by the SDK
---------------------------------------------------------
This release changes the way Location permissions are handled, in part since this is changing in iOS 11.

Basically, if the application tries to start BLE scanning using the mode MobileKeysScanModeOptimizePerformance,
the application now needs to request authorization from the OS and enable background location updates. If background
operation is not required, use the MobileKeysScanModeOptimizePowerConsumption scan mode instead.

To summarize, when using the MobileKeysScanModeOptimizePerformance scan mode:
When the scan mode "MobileKeysScanModeOptimizePerformance" is used, the SDK will call CLLocationManager::startUpdatingLocation.
iOS will prevent this (fatal error according to the documentation) unless the application first sets the

 CLLocationManager::allowsBackgroundLocationUpdates property to YES and

calls the

 CLLocationManager::requestAlwaysAuthorization

function that will query the user to authorize location updates preferably in the background.

In addition to this code change, the application also needs to add the appropriate NSLocationWhenInUseUsageDescription,
NSLocationAlwaysAndWhenInUseUsageDescription, NSLocationAlwaysUsageDescription and NSLocationUsageDescription to info.plist


API changes
-----------
 - The MobileKeysApduConnectionProtocol::preSessionSetup and MobileKeysApduConnectionProtocol::postSetupTeardown
 methods now have an additional "options" dictionary that can be used to pass implementation specific information concerning
 the opening and closing of seos sessions.

Location manager changes
------------------------
Removed requestAlwaysAuthorization and allowsBackgroundLocationUpdates from SDK
If background mode is required, add requestAlwaysAuthorization and allowsBackgroundLocationUpdates to the app.
Add NSLocationWhenInUseUsageDescription, NSLocationAlwaysAndWhenInUseUsageDescription, NSLocationAlwaysUsageDescription
and NSLocationUsageDescription to info.plist

Dependency changes
------------------
 - Added LocalAuthentication.framework. Used for a more reliable way of checking if the device has a passcode set.

Bug fixes
---------
- The MobileKeysApduCommand:initWithRawData did not always correctly parse the last "length expected" byte,
which could cause issues in some cases when parsing and serializing APDUs using secure messaging. This has been corrected.
The property "forceLengthExpected" has been renamed to "usesLenghtExpected" and is now parsed correctly.


This release also contains minor bug fixes and improvements.

## [5.1.4] -   (July 2017)
This release was never published publicly.


## [5.1.3] -   (July 2017)
*Version 5.1.3 is built with XCode8.3.2 and latest target iOS 10.3 (deployment target is minimum iOS 8.0)*

Added MobileKeysManagerExtendedDelegate.h to public headers

Resolved issue with SDK returning error code 99 from time to time

## [5.1.2] -   (June 2017)
*Version 5.1.2 is built with XCode8.3.2 and latest target iOS 10.3 (deployment target is minimum iOS 8.0)*

And a note:
If you only use this SDK in foreground mode, set scanMode to MobileKeysScanModeOptimizePowerConsumption. Then the CLLocationManager will not
ask for permissions to be in the background and you don`t need `Locations updates` in Background modes.`

From SDK version 4.1.0: endpoints are tied to the current device using the `[UIDevice identifierForVendor]` identifier. This means that when
this identifier changes, the endpoint will not be accessible on that device.
Please note that this will prevent accessing the mobile keystore data between different kinds of builds like AppStore, TestFlight or local builds.
You need to stay in one kind of build when upgrading version and build number.
Examples:
AppStore (version 1.0) to AppStore (version 1.1)
TestFlight (version 1.0) to TestFlight (version 1.1)
Local  (version 1.0) to Local (version 1.1)
No other combination is supported.

Also note that only TestFlight works for test distribution when incrementing the build number, HockeyApp and Fabric is changing identifierForVendor between builds.

Added log category to all log statements
Readback now only run if there are MID`s in the Secure Storage with readback URL`s

Added support for implementing other means of communicating with readers, or any other entity that drives the communication
and authentication. Please refer to the documentation.

Added possibility to pass a description when opening a session in the MobileKeysSeosProvider, providing more visibility
of what is using the local Seos instance.

Harmonized how the SDK represents a single byte into the one defined in MacTypes.h (uint8)

- MobileKeysSeosProvider#openSessionWithParams:description:withError:
- MobileKeysSeosProvider#openRemoteSessionWithSelectAid:withError:
- MobileKeysSeosProvider#openRemoteSessionWithSelectAid:description:withError:

Removed previously deprecated methods:

MobileKeysManager
- OTPForKeyOid:digits:error: (replaced by generateOTPForKey:error:)
- openMobileKeysSeosSessionWithType:error: (in favour of MobileKeysSeosProvider)

Removed previously deprecated error codes
- MobileKeysBluetoothLENotAvailableError
- MobileKeysBadScanConfigurationError
- MobileKeysOpeningTypeNotPermittedError
- MobileKeysLocationServicesNotDeterminedError
- MobileKeysLocationServicesNotAuthorizedError
- MobileKeysLocationServicesNotEnabledError
- MobileKeysLocationMonitoringNotSupportedError
- MobileKeysInvitationCodeInvalidApplicationError
- MobileKeysInvalidInvitationCodeError
- MobileKeysDeviceSetupFailedError
- MobileKeysDeviceSetupFailedRetryError
- MobileKeysDeviceApiIncompatibleError
- MobileKeysDeviceNotEligibleError
- MobileKeysApiIsBusyError
- MobileKeysNetworkUnreachableError
- MobileKeysServerCommunicationFailedError
- MobileKeysDataStorageEncryptionFailedError
- MobileKeysDataStorageDecryptionFailedError
- MobileKeysEndpointError
- MobileKeysSecureElementError
- MobileKeysInternalError
- MobileKeysUnknownError

Deprecated the following methods:

MobileKeysManager
- putData:keyOid:tag:error: (in favour of MobileKeysSeosProvider using MobileKeysPutDataApduCommand)
- dataForKeyOid:tag:error: (in favour of MobileKeysSeosProvider using MobileKeysGetDataApduCommand)

MobileKeysEndpointInfo
- pushId

MobileKeysManagerDelegate
- mobileKeysShouldInteractWithScannedReader: (the method will be moved to MobileKeysManagerExtendedDelegate.h to avoid confusion in the general use case)
- mobileKeysUserDidUnlockGesture (the method will be moved to MobileKeysManagerExtendedDelegate.h to avoid confusion in the general use case)

Moved
- MobileKeysInfoType from MobileKeysManagerProtocol to MobileKeysManager header
- MobileKeysScanMode from MobileKeysManagerProtocol to MobileKeysManager header

Removed
- MobileKeysReader rssiMeasurementMode
- MobileKeysManagerProtocol

## [5.1.1] - 
This release was never published publicly.

## [5.1.0] - 
This release was never published publicly.


## [5.0.2] -  (May 2017)
*Version 5.0.2 is built with XCode8.2.1 and latest target iOS 10.2.1 (deployment target is minimum iOS 8.0)*

Recovery of Seos session if Bluetoothcommunication is interrupted.
Open SeosSession semaphore timeout changed to two seconds
Ble tap communication failure when double tap corrected


## [5.0.1] -  (Feb 2017)
*Version 5.0.1 is built with XCode8.2 and latest target iOS 10.2 (deployment target is minimum iOS 8.0)*

Added missing SDK classes to the umbrella header
Added missing BerTlv precompiled framework (in case you don`t use CocoaPods)

Added test examples to the documentation for users who want to try the new Seos access API. These examples can be copied to the
SeosExampleApplication app and used with a test credential. The examples uses both encrypted sessions and unencrypted sessions for reading
and writing tags.

And a note:
If you only use this SDK in foreground mode, set scanMode to MobileKeysScanModeOptimizePowerConsumption. Then the CLLocationManager will not
ask for permissions to be in the background and you don`t need `Locations updates` in Background modes.`

- Seos Access API
  - Added support for reading tags with data larger than 256 bytes, response chaining

Bug fixes
---------
- MobileKeysManager#dataForKeyOid:tag:error
  - Fixed a issue where tags with sub-tags only returned the first sub-tag
  - Fixed a issue where monitored regions are cleared (geofencing)


## [5.0.0] -  (Jan 2017)
*Version 5.0.0 is built with XCode8.2 and latest target iOS 10.2 (deployment target is minimum iOS 8.0)*

This release introduces one new dependency to the BerTLV Pod, used internally. The previous TLV implementation was
not keeping up with the new cryptographic functionality introduced by the Seos Session management and had to be replaced.

This release adds a new API to allow integrators to access Seos directly. This API will be extended over time, but
in this release, we add

 - class MobileKeysSeosProvider
  - A class that will let the integrator open sessions to either the locally bundled Seos implementation or
    a provided Seos Implementation.

 - MobileKeysManager#defaultMobileKeysSeosProvider
   - A way to access a MobileKeysSeosProvider for the locally bundled Seos implementation

 - protocol MobileKeysApduConnectionProtocol
  - A Protocol defining the underlying Seos Implementation

In addition to these classes and protocols, base classes for APDU Commands and Responses, and implementations of these
base classes for GetData and PutData have been bundled. A new class, MobileKeysSessionParameters has been included,
allowing anyone that uses the MobileKeysSeosProvider to configure the session opening parameters.


The Twist and Go Detector classes have been exposed in this version of the API. Use the MobileKeysMotionRecognizer to
detect Twist & Go, and the MobileKeysMotionRecognizerDelegate protocol to get callbacks when the system detects a Twist
& Go.

The SDK can now accept readers that do not advertise Manufacturer Specific Data, e.g. iPhone devices acting as readers.

Bug fixes
---------
- The MobileKeysReader now exposes the "localName" of the detected Reader as a property correctly.


## [4.2.0] - 
This release was never published publically.


## [4.1.0] - 
Version 4.1.0 is built with XCode8 and latest target iOS 10.0 (deployment target is minimum iOS 8.0)*

Required capabilities for apps linked on iOS 10 or newer
--------------------------------------------------------
See https://developer.apple.com/library/content/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html
for details on the new capabilities requirements.

An iOS app linked on or after iOS 10.0, and which accesses the Bluetooth interface, must statically declare the intent
to do so. Include the NSBluetoothPeripheralUsageDescription key in your app’s Info.plist file and provide a purpose
string for this key. If your app attempts to access the Bluetooth interface without a corresponding purpose string,
your app exits

Version 4.1.0 no longer uses the GPS for geofencing to remember the location of known readers. It is still possible to
 enable location awareness (using beacon ranging) by scanning in mode "MobileKeysScanModeOptimizePerformance".

In short; the Mobile Keys iOS SDK requires the following capabilities in the plist file to work properly:
	<key>NSBluetoothPeripheralUsageDescription</key>
	<string>Bluetooth is required to open doors.</string>
	<key>NSLocationAlwaysUsageDescription</key>
	<string>To improve the door opening experience, we detect readers when the app is not open. Location Services is used exclusively for this purpose.</string>

Various security enhancements and improvements.
-----------------------------------------------
Endpoints are now tied to the current device using the `[UIDevice identifierForVendor]` identifier. This means that when
this identifier changes, the endpoint will not be accessible on that device. Please note that this will prevent accessing
the mobile keystore data created by an Appstore (or testflight) build using a development version of the application.

API Changes
-----------
MobileKeysReader objects now includes the "localName" from the BLE advertisements as well, and not only the "name" (deviceName)


## [4.0.3] - 
Added support for MTU renegotiation over BLE. This requires support for MTU renegotiation from the lock side. The SDK will
default to the standard 20 byte MTU if the lock does not support larger MTUs.

Various security enhancements and code cleanup

Please also remember that since the SDK is designed to detect modification attempts it does not support creating
categories or inheriting from it`s classes.

## [4.0.2] - 
Fixed a bug where the reading of tags consisting of one byte (e.g. tag 61) did not work as intended.

## [4.0.1] - 
Fixed an issue where the SDK could not initialize on a completely cleared phone

## [4.0.0] - 
iOS SDK 4.0.0 Supports The TSM 3.0 as well as upgrading from a previous version of the local soft storage.

The Release version of the SDK now includes both the iphoneos as well as the iphonesimulator architectures.
Please make sure to use the build setting “Build Active Architecture only (ONLY_ACTIVE_ARCH) = YES” when publishing,
as Apples servers will automatically reject uploaded bundles that contain simulator slices.

Dependency and CocoaPods changes
------------------
 - Changes have been made to the Pod specifications to support CocoaPods 1.0
  - This version has been developed using Cocoapods 1.0.1
 - The SDK is no longer dependent on OpenSSL

 - The Debug build of the SDK is now also protected using obfuscation.

API Changes
-----------

The MobileKeyEndpointInfo class has been updated with two new properties, while three properties have been deprecated.

@property(nonatomic, readonly, getter=isSetup) BOOL isSetup;
 - Will return YES if the endpoint is already Setup, otherwise NO. Please be aware that the endpoint state may have changed
 since the endpoint Info was fetched, so it is advisable that you use the SDK API method to check the Endpoint Status
 instead of relying on this value.

@property(nonatomic, assign) EnvironmentType environmentType is now accessible. Be advised that this value will show
"UNKNOWN" until the endpoint has been successfully setup.

Four seldom used properties of the MobileKeysEndpointInfo have been deprecated. This will most likely not affect anyone.

@property(nonatomic, strong) NSString *snmpEngineId has been deprecated.
@property(nonatomic, strong) NSString *snmpUserName has been deprecated.
@property(nonatomic, assign) BOOL snmpUserStatus has been deprecated.
@property(nonatomic, assign) EnvironmentType getEnvironment has been removed (use environmentType instead).


The OTP functionality has been updated to support the new type of OTP credentials supported by Seos 1.0.100+.

`[MobileKeysManager OTPForKeyOid:digits:error:]` method has been deprecated (and this function will not work in the future)
instead, use the
`[MobileKeysManager generateOTPForKey:key error:]` method to get a 6 digit OTP NSString from keys that support the new OTP
functionalty.


MobileKeysManagerDelegate callback functions have been slightly modified to support the new BLE Protocol functionality
for sending additional status codes back to the phone on a disconnect. To allow this, the following changes have been made:

`[MobileKeysManagerDelegate mobileKeysDidDisconnectFromReader:openingType:openingStatus:]`
has been changed to
`[MobileKeysManagerDelegate mobileKeysDidDisconnectFromReader:openingType:openingResult:]`

The new MobileKeysOpeningResult class will contain two properties:
@property(nonatomic) MobileKeysOpeningStatusType status;
@property(nonatomic) NSData *statusPayload;

`[MobileKeysManagerDelegate mobileKeysDidConnectToReader:openingType:openingStatus:]`
has been changed to
`[MobileKeysManagerDelegate mobileKeysDidConnectToReader:openingType:]`

The reasoning behind this change is that the MobileKeysOpeningStatusType was always "Success" for this callback.

Bug fixes
---------


## [3.3.0] - 
Bug fixes
Fixed a bug where the application could crash when unrecognized data was received over the BLE channel
Internal errors when communicating with the Secure Storage now prints the internal error code in Debug mode

## [3.2.0] - 
Error code cleanup
- Each MobileKeysErrorCode enum has a description and a recommended action
- Each MobileKeysInfoType from MobileKeysManager.healthCheck has a description and a recommended action
The SDK now handles the new metadataformat for keys (usable for TSM 3.0)
The podspec is split into release and debug versions
Possible to define timeout configuration in MobileKeysManager
Detect if passcode is set with MobileKeysManager health check

Bug fixes
Bluetooth connection errors are no longer reported as reader errors


## [3.1.0] - 
New method on MobileKeysKey: isExpired
 - This method will return "YES" if the current date > key expiry date.

Bug fixes
Resolved a bug in the SDK where location monitoring in the SDK sometimes caused the application to crash-
 - This fix has also been back-ported to SDK 2.2.4


## [3.0.2] - 
Resolved an issue where SDK analytics were not sent to the servers

## [3.0.1] - 
Version 3.0.X of the SDK is no longer a static framework, but is now a dynamic Cocoa Touch Framework.
This change means that the framework is not a drop-in replacement to the 2.x versions of the SDK

Important information:
- The minimum iOS version supported is now iOS 8.0

- The SDK is now a dynamic Cocoa Touch Framework and will no longer require the finalizer

- The SDK now supports the distribution system CocoaPods, though as a local pod.
  * Check the installation instructions for new information about integrating this version

- The SDK now comes with license information about all thrird party licenses
  * The license.plist file contains all information

SDK API Changes

Bug fixes
- A rare bug where local key database could get out of sync compared to the server info on a hard reset of the phone has been fixed
-

## [2.2.1] - 

- Removed dependency to libextobjc framework
- New SDK call to get the last authenticated key
 - (MobileKeysLastAuthenticationInfo *)lastAuthenticationInfo:(NSError **)error;


## [2.1.1] - 

- Resolved a bug that could make the SDK crash while communicating over HTTP when running in the Debug Configuration
- Resolved a crash bug happening during personalization
- 2.1.0 included the wrong Finalizer. 2.1.1 now includes Finalizer 7.2.
- Removed assertion for isProtectedDataAvailable introduced in 2.1.0


## [2.1.0] - 
To link against 2.1.x of the SDK you may need to add -licucore to other linker flags if you are not using
Cocoapods.

- New protection for the library, please upgrade Xcode to with the new Finalizer using
Finalizer-N.N.N.NNNN-macosx-x86/Xcode/install-xcode-finalizer-wrapper.sh
- Fixed header files in bundled thirdparty frameworks
- Renamed third-party OpenSSL-Universal.framework to openssl.framework so that includes work correctly
- Removed not useful method setPushIdToken: from API
- Prefixed internal variable base64EncodeLookup to avoid name collision
- The SDK can now be used from non-ARC files
- `-[MobileKeysReader meanRssi]` now only returns the mean of recent RSSI values
- Assertion preventing calling `-[MobileKeysManager initWithDelegate:options:]` in background with
`![UIApplication sharedApplication].isProtectedDataAvailable,` i.e. the screen is locked and the SDK cannot read protected files
- New SDK calls to enable/disable mobile IDs
 - (BOOL)activateMobileKey:(MobileKeysKey *)key error:(NSError **)error;
 - (BOOL)deactivateMobileKey:(MobileKeysKey *)key error:(NSError **)error;

New property on MobileKeysKey
- @property(nonatomic) BOOL active;


## [2.0.2] - 

- Decrease the maximum size of Response APDUs
- Accept that the lock selects AIDs that are specific for the Integrator environment (HCE specific AIDs)
Team Directory


## [2.0.1] - 

- Making MobileKeysErrorCode visible from Swift


## [2.0.0] - 

Rewritten public API which should allow for a simpler app implementation. Also the API more closely adheres to Apple`s
coding standards with respect to method naming, delegate callbacks and error handling.
It has been redesigned to be easier for new integrators to use. Unfortunately this means that the 2.0.0 SDK will not work as a drop-in
replacement for the previous 1.2.X versions.

Preparations have also been made to drop support for iOS 7.X, although this version still supports iOS 7. 

## [1.2.X] - 
 - The MobileKeysApi is renamed to MobileKeysManager
 - The MobileKeysBluetoothProtocol and the MobileKeysProtocol have been deprecated and a new MobileKeysManagerDelegate protocol has been introduced
 - The options for the MobileKeysManager is now an NSDictionary of options instead of a configuration object
  * MobileKeysOptionApplicationId: NSString
  * MobileKeysOptionVersion: NSString
 - The MobileKeysError class has been replaced with regular NSErrors.
 - The asynchronous methods (endpointSetup, endpointUpdate and applicationStartup) now return all results through a new MobileKeysManagerDelegate.
 - The `[MobileKeysApi endpointSetup:delegate:error:]` has been replaced with `[MobileKeysManager setupEndpoint:]`. 
 - The `[MobileKeysApi applicationStartup:delegate:error:]` has been replaced with `[MobileKeysManager startup]`. 
 - The `[MobileKeysApi endpointUpdate:delegate:error:]` has been replaced with `[MobileKeysManager updateEndpoint]`. 
 - The `[MobileKeysApi getEndpointInfo:]` has been replaced with `[MobileKeysManager endpointInfo]`. 
  - The `[MobileKeysApi isEndpointSetupComplete:]` has been replaced with `[MobileKeysManager isEndpointSetup:]`.
 - Error codes have been renamed to be more easy to use
 - The API only allow calls on the main thread
 - The SDK now enforces certain flows. applicatonStartup is now required before endpointSetup and endpointUpdate
 - A new method; `[openMobileKeysSeosSessionWithType:error:]` is intruduced to allow for custom APDU communication with Seos
 - Lock Service Codes are now passed on the `[startReaderScanInMode:supportedOpeningTypes:lockServiceCodes:error:]` method instead as configuration 
 - SDK now uses Seos version 1.0.102

## Added
This version introduces the capability to directly interact with Seos Tags.
 - Reading of Seos Tags through the `[MobileKeysManager dataForKeyOid:tag:error:]`
 - Writing of Seos Tags through the `[MobileKeysManager putData:keyOid:tag:error:]`
 - Reading Seos OTP Tags through the `[MobileKeysManager OTPForKeyOid:digits:error:]`
 - Setting up a Seos session through the SDK for custom ADPU communication with Seos

This release adds the ability to implement custom mechanics for opening readers. You will be able to open a
reader through the `[MobileKeysApi connectToReaderWithOpeningType:openingType:error:]` selector.
- You will be able to receive callbacks whenever the API receives an advertisement from a reader through
the delegate method `[MobileKeysManagerDelegate mobileKeysShouldInteractWithScannedReader:]`.
- In addition to the `[MobileKeysApi listReaders:]` selector, it is now possible to query the API for the
closest reader within range of a certain `[MobileKeysReader MobileKeysOpeningType]` via the `[MobileKeysApi closestReaderWithinRangeOfOpeningType:]` selector.
- A new delegate method was introduced: `didReceiveUnlockGesture:` whenever the API detects a Twist and Go motion pattern.
- To improve the flexibility of selecting which of the OpeningTypes that are active during scanning, the list of supported OpeningTypes was moved
from `MobileKeysApplicationConfig` to the `[MobileKeysApi#startReaderScanInMode:supportedOpeningTypes:error:]` selector. This change also
removed the selectors `startReaderScan` and `startReaderScanInMode:error:` from `MobileKeysApi`
- It is now possible to determine if the API is currently scanning or not via the `[MobileKeysApi isScanning]` selector

The following error codes has been introduced in this release:
- MobileKeysErrorCodeTypeBluetoothLENotAvailable: if the API receives a request to start scanning through the `[MobileKeysApi startReaderScanInMode:supportedOpeningTypes:error:]`
while Bluetooth Low Energy is either turned off or not supported by the device, the API will set the MobileKeysError with this code.
- `MobileKeysErrorCodeTypeBadScanConfiguration:` if the list of OpeningTypes passed in the message to `[MobileKeysApi startReaderScanInMode:supportedOpeningTypes:error:]`
is empty or malformed, the API will set the MobileKeysError with this code.
- `MobileKeysErrorCodeTypeOpeningTypeNotPermitted:` if a message to `[MobileKeysApi connectToReaderWithOpeningType:openingType:error:]` contains an `MobileKeysReader#MobileKeysOpeningType` that the API is not currently scanning with, the API will set the `MobileKeysError` with this code.
 


## [1.2.5] - 
- This release resolves some long outstanding issues with the endpoint infrequently getting out of sync with the TSM,
the SDK now uses a new protocol to communicate with the TSM Server.
- Errors when communicating with the TSM have been cleaned up and aligned with the Android SDK.
- All internal classes and names are now prefixed with the AMK prefix to avoid naming clashes with the integrating application
- Third-party frameworks are now delivered as artifacts. This includes the previously required OpenSSL, but also two new
dependencies; JSONModel and CocoaLumberjack.
- Updated SDK to support iOS 8.2 (data protection for files functionality changed)
- A long-standing bug in the `MobileKeysApi#applicationStartup:` method was resolved, meaning that it should now
be safe (and it is now recommended) to call the applicationStartup method after the MobileKeysApi has been initialized
- The "Debug" configuration of the SDK will no longer work in Appstore Builds, so it`s imperative that Appstore Releases
use the "ReleaseArxan" Configuration.


## [1.2.5] - 
- This release resolves an issue where the beginDate and endDate on keys were not parsed correctly, causing them to
show the wrong time. These times are now always shown as UTC dates.
- Added assertions to most of the public SDK classes to prevent them from being subclassed.
- The SDK now correctly parses the "no timeout" flag from locks, providing the functionality needed for Logical Access Systems
to keep the BLE connection open for a longer time.

## [1.2.3] - 
- This release resolves a bug where the SDK sometimes connected to readers before the initial advertisement handshake
was completed, leaving the BLE connection in a state where the communication timed out.

## [1.2.2] - 
- This release resolves a bug where the SDK always allowed for seamless openings even if Seamless openings
were disabled in the configuration of the SDK
- This release is the first release that is encrypted, and requires the finalizer step to link with
the host application.

## [1.2.0] - 
- This release decreases battery consumption for the BLE scanning by ~50%
- This release introduces a new scan mode that should give faster lock detection, but will consume more power
- This release changes the names of a bunch of status codes reported by the BLE layer to the application

### API Changes
New method for listing readers in range.
- `MobileKeysApi#listReaders:`

New method for starting scanning that replaces the previous methods for starting and stopping
location monitoring.
- `MobileKeysApi#startReaderScanInMode:error:`

Removed methods
- `startLocationMonitoring`
- `stopLocationMonitoring`

The MobileKeysEndpointInfo class now contains a property(nonatomic) NSDate *lastServerSyncDate that contains
a timestamp for when the endpoint was last synchronized with the TSM Backend.

#### Changes in status codes from Reader Communication
`MobileKeysOpeningStatusTypeProximityNotSupported` enum constant is now called MobileKeysOpeningStatusTypeTapNotSupported
`MobileKeysOpeningStatusTypeFailed` enum constant is now called MobileKeysOpeningStatusTypeBluetoothCommunicationFailed
`MobileKeysOpeningStatusTypeMobileKeyNotFound` is a new enum constant
`MobileKeysOpeningStatusTypeReaderAntiPassback` is a new enum constant
`MobileKeysOpeningStatusTypeReaderFailure` is a new enum constant

#### Changes in error codes from asynchronous methods (applicationStartup/endpointSetup/endpointUpdate)
These error codes have been cleaned up. There is still work planned for these codes, but since 1.2.0 several of the
codes that were never used have been removed.


## [1.1.7] - 
Maintenance release.

## [1.1.6] - 

The internal secure storage session management has been reworked. In practice, this means that it is now
possible to connect to Readers even if the application is communicating with the Seos TSM, and it is
possible to update keys even if the phone is communicating with a Reader.


### API Changes
- New selector to retrieve supported opening types for a `MobileKeysReader`
  - `MobileKeysReader#supportedOpeningTypes`

### Added
- [SDB-519] Seamless open mode now supported for Readers that support this mode
- [SDB-1877] iphone 6 and 6plus support
- [SDB-1892] Single tap per zone visit (the phone must be pulled away from the reader after a successful unlock)


### Bug fixes
- [SDB-1762] Reader config is updated properly when rediscovered
- [SDB-1105] Updating keys or processing Push messages fail silently when phone is talking to reader
- [SDB-1952] SDK now handles "Server busy" HTTP Codes when server is congested
- [SDB-1967] Twist and go sensitivity was tweaked to provide a more reliable functionality
- [SDB-1874] Wrong Endpoint Info was sometimes sent to Server if the secure element was busy

## [1.1.5] - 

*Release 1.1.5 contains several changes that will enable the BLE scanning to operate better in the background.*

### API Changes
- New methods to start/stop location monitoring
  - `MobileKeysApi#startLocationMonitoring:`
  - `MobileKeysApi#stopLocationMonitoring`

- New Error Codes in MobileKeysError
  - MobileKeysErrorCodeTypeLocationMonitoringNotSupported  CLBeaconRegion monitoring or ranging is not supported by this device
  - MobileKeysErrorCodeTypeLocationServicesNotEnabled  Location services is not enabled in app project settings
  - MobileKeysErrorCodeTypeLocationServicesNotAuthorized  Location services is not authorized by user.
  - MobileKeysErrorCodeTypeLocationServicesNotDetermined  Location services authorization is not determined by user. iOS8 and above need to call requestAlwaysAuthorization

### Bug fixes
Various bug fixes and improvements have been made in the SDK. Problems that affected earlier versions were:
 - [SDB-1775] RSSI Values are no longer reset when performing Twist and Go. This means faster recovery on communication errors
 - [SDB-1781] Multiple packets downloaded from the Seos TSM were not acknowledged correctly by the SDK.
 
