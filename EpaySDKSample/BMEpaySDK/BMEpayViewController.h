//
//  EpayViewController.h
//  EpaySDKSample
//
//  Created by http://beemobile.kz on 3/29/15.
//  Copyright (c) 2015 Kazkommertsbank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMEpayDefines.h"

@class BMEpayViewController;

@protocol BMEpayControllerDelegate <NSObject>

-(void)epayPaymentSuccededWithController:(BMEpayViewController*)epayViewController;
-(void)epayPaymentFailedWithController:(BMEpayViewController*)epayViewController;
-(void)epayPaymentCancelledWithController:(BMEpayViewController*)epayViewController;

@end

@interface BMEpayViewController : UIViewController

@property (weak, nonatomic) id<BMEpayControllerDelegate> delegate;
@property (nonatomic) EpaySdkMode sdkMode;

@property (strong, nonatomic) NSString *signedOrderBase64;
@property (strong, nonatomic) NSString *shopId;
@property (strong, nonatomic) NSString *clientEmail;
@property (strong, nonatomic) NSString *postLink;
@property (strong, nonatomic) NSString *failurePostLink;
@property (nonatomic) EpayLanguage language;
@property (strong, nonatomic) NSString *appendix;
@property (strong, nonatomic) NSString *template;

@property (strong, nonatomic) NSString *epayUrl;
@property (strong, nonatomic) NSString *epaySuccessUrl;
@property (strong, nonatomic) NSString *epayFailureUrl;

@end
