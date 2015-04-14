//
//  ViewController.m
//  EpaySDKSample
//
//  Created by http://beemobile.kz on 3/26/15.
//  Copyright (c) 2015 Kazkommertsbank. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "BMEpaySDK.h"


@interface ViewController () <BMEpayControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *order;

@end

@implementation ViewController {
//    AFHTTPRequestOperationManager *apiClient;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)payAction:(id)sender {
// https://3dsecure.kkb.kz/jsp/client/signorderb64.jsp is a sample URL which returns a signed order
// Clients have to use their own API for this
    AFHTTPRequestOperationManager *apiClient = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://3dsecure.kkb.kz"]];
    apiClient.responseSerializer = [AFHTTPResponseSerializer serializer];
    [apiClient GET:@"/jsp/client/signorderb64.jsp" parameters:@{@"order_id":self.order.text} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *data = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        BMEpayViewController *controller = [[BMEpayViewController alloc] init];
        controller.delegate = self;
        controller.sdkMode = EpaySdkModeTest;
        controller.signedOrderBase64 = data;
        controller.postLink = @"http://test.kz";
        controller.template = @"besmart_android.xsl";
//        controller.clientEmail = @"test@test.kz";
//        controller.language = EpayLanguageKazakh;
        [self presentViewController:controller animated:YES completion:^{
            
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}

-(void)epayPaymentSuccededWithController:(BMEpayViewController*)epayViewController {
    NSLog(@"SUCCESS");
}

-(void)epayPaymentFailedWithController:(BMEpayViewController*)epayViewController {
    NSLog(@"FAIL");
}

-(void)epayPaymentCancelledWithController:(BMEpayViewController*)epayViewController {
    NSLog(@"CANCEL");
}


@end
