//
//  Flexipass.h
//  FlexipassSDK
//
//  Created by Simon Carraro on 08/04/2020.
//  Copyright © 2020 Simon Carraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <AFNetworking/AFNetworking.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import "KeyInformationObject.h"
#import "AppCustomization.h"
#import "MobileKeyController.h"
#import "FlexipassCallbackObject.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FlexipassCallbackDelegate
    -(void)callback_listener:(FlexipassCallbackObject*)fpco;
@end

@interface Flexipass : NSObject<MobileKeyControllerDelegate,CBCentralManagerDelegate>

-(void)useMobileKey:(NSString*)mobileKeyCode :(void (^)(KeyInformationObject *suc))success :(void (^)(NSError *err))error;
-(void)getAppCustomization:(NSString*)mobileKeyCode :(void (^)(AppCustomization *ap))success :(void (^)(NSError *err))error;
-(Boolean)isSetupComplete;
-(void)startReader;
-(void)stopReader;
-(void)updateMobileKey;
-(void)detectBluetooth;
-(void)terminateMobileKey;
-(int)mobileKeyCount;
-(NSString*)getSDKVersion;
-(NSDate*)getLastReaderConnection;

@property(nonatomic, strong) id <FlexipassCallbackDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
