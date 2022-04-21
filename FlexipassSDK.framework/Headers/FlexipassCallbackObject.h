//
//  FlexipassCallbackObject.h
//  FlexipassSDK
//
//  Created by Simon Carraro on 09/07/2020.
//  Copyright © 2020 Simon Carraro. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FlexipassCallbackResultType) {
    FlexipassCallbackResultType_setup_success = 1,
    FlexipassCallbackResultType_setup_failed = 2,
    FlexipassCallbackResultType_startup_success = 3,
    FlexipassCallbackResultType_startup_failed = 4,
    FlexipassCallbackResultType_update_success = 5,
    FlexipassCallbackResultType_update_failed = 6,
    FlexipassCallbackResultType_reader_stared = 8,
    FlexipassCallbackResultType_reader_stopped = 9,
    FlexipassCallbackResultType_terminated = 11,
    FlexipassCallbackResultType_setupNotCompleted= 12,
    FlexipassCallbackResultType_updateProcessAlreadyRunning= 13,
    FlexipassCallbackResultType_termination_failed = 14,
    
    //lock states
    FlexipassCallbackResultType_lock_opened = 60,
    FlexipassCallbackResultType_lock_failed = 61,
    FlexipassCallbackResultType_lock_timed_out = 62,
    FlexipassCallbackResultType_lock_busy = 63,
    FlexipassCallbackResultType_lock_reader_failure = 64,

};

@interface FlexipassCallbackObject : NSObject

@property (nonatomic,strong) NSString* title;
@property (nonatomic) FlexipassCallbackResultType result;

@end

NS_ASSUME_NONNULL_END
