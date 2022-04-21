//
//  AppCustomization.h
//  FlexipassSDK
//
//  Created by Simon Carraro on 15/04/2020.
//  Copyright © 2020 Simon Carraro. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppCustomization : NSObject

@property (nonatomic,strong) NSString* companyID;
@property (nonatomic,strong) NSString* color_button_checkout;
@property (nonatomic,strong) NSString* color_button_refresh;
@property (nonatomic,strong) NSString* color_button_address;
@property (nonatomic,strong) NSString* color_button_call;
@property (nonatomic,strong) NSString* color_label_doorNumber;
@property (nonatomic,strong) NSString* color_label_checkoutInformation;
@property (nonatomic,strong) NSString* color_label_placePhoneOnReader_active;
@property (nonatomic,strong) NSString* color_label_placePhoneOnReader_updating;
@property (nonatomic,strong) NSString* image_background;
@property (nonatomic,strong) NSString* image_title;

@end

NS_ASSUME_NONNULL_END
