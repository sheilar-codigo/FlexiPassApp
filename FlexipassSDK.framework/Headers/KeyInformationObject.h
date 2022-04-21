//
//  KeyInformationObject.h
//  FlexipassSDK
//
//  Created by Simon Carraro on 15/04/2020.
//  Copyright © 2020 Simon Carraro. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyInformationObject : NSObject

@property (nonatomic,strong) NSString* doorID;
@property (nonatomic,strong) NSString* checkInDate;
@property (nonatomic,strong) NSString* checkInTime;
@property (nonatomic,strong) NSString* checkOutDate;
@property (nonatomic,strong) NSString* checkOutTime;
@property (nonatomic) int companyID;

@end

NS_ASSUME_NONNULL_END
