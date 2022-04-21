//
//  MobileKeyController.h
//  FlexipassSDK
//
//  Created by Simon Carraro on 15/04/2020.
//  Copyright © 2020 Simon Carraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SeosMobileKeysSDK/SeosMobileKeysSDK.h>
#import <AudioToolbox/AudioServices.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MobileKeyControllerDelegate
    -(void)cb_mobileKeysDidSetupEndpoint;
    -(void)cb_mobileKeysDidFailToSetupEndpoint;
    -(void)cb_mobileKeysDidStartup;
    -(void)cb_mobileKeysDidFailToStartup;
    -(void)cb_mobileKeysDidUpdateEndpoint;
    -(void)cb_mobileKeysDidFailToUpdateEndpoint;
    -(void)cb_mobileKeysDidTerminateEndpoint;
    -(void)cb_lockopened;
    -(void)cb_handleError:(NSError*)error;
    -(void)cb_readerCallback:(MobileKeysOpeningStatusType)openingStatus :(MobileKeysOpeningType)openingType;
@end

@interface MobileKeyController : NSObject <MobileKeysManagerDelegate>

- (NSString*)getSDKVersion;
- (NSDate*)getLastReaderConnection;
- (void)setInvitationCode:(NSString *)code;
- (void)setupMobileKeyController;
- (BOOL)isEndpointSetup;
- (void)startReaderScan;
- (void)stopReaderScan;
- (void)reloadKeys;
- (void)terminateEndpoint;
- (int)mobileKeyCount;

@property(nonatomic, strong) id <MobileKeyControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
