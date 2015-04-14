//
//  EpayViewController.m
//  EpaySDKSample
//
//  Created by http://beemobile.kz on 3/29/15.
//  Copyright (c) 2015 Kazkommertsbank. All rights reserved.
//

#import "BMEpayViewController.h"
#import "BMEpayException.h"

@interface BMEpayViewController () <UIWebViewDelegate>

@end

@implementation BMEpayViewController {
    UIWebView *webView;
    UINavigationItem *navigationItem;
    UIBarButtonItem *cancelButton;
    UIBarButtonItem *doneSuccessButton;
    UIBarButtonItem *doneFailureButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self checkParameters];
    
    [self prepareUrls];
    
    [self prepareWebView];
    
    [self prepareNavigationBar];
    
    NSURLRequest *urlRequest = [self prepareRequestWithParameters:[self prepareRequestParameters]];
    
    [webView loadRequest:urlRequest];
}

- (void)prepareWebView {
    webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    webView.delegate = self;
    
    UIEdgeInsets insets = webView.scrollView.contentInset;
    insets.top = 64;
    webView.scrollView.contentInset = insets;
    
    [self.view addSubview:webView];
}

- (void)prepareNavigationBar {
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigationBar.backgroundColor = [UIColor whiteColor];
    
    navigationItem = [[UINavigationItem alloc] init];
    navigationItem.title = @"Epay";
    
    cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction:)];
    doneSuccessButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(successAction:)];
    doneFailureButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(failureAction:)];
    
    navigationItem.leftBarButtonItem = cancelButton;
    
    navigationBar.items = @[ navigationItem ];
    
    [self.view addSubview:navigationBar];
}

- (NSURLRequest*)prepareRequestWithParameters:(NSDictionary*)parameters {
    NSString *requestString = [self urlEncodedStringFromDictionary:parameters];
    
    NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.epayUrl]];
    [urlRequest setValue:[NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
    
    urlRequest.HTTPMethod = @"POST";
    urlRequest.HTTPBody = [requestString dataUsingEncoding:NSUTF8StringEncoding];
    
    return urlRequest;
}

- (void)checkParameters {
    if (!self.signedOrderBase64) {
        [BMEpayException raise:@"Invalid signedOrderBase64 value" format:@"signedOrderBase64 cannot be nil"];
    }
    if (!self.postLink) {
        [BMEpayException raise:@"Invalid postLink value" format:@"postLink cannot be nil"];
    }
}

- (void)prepareUrls {
    if (!self.epayUrl) {
        switch (self.sdkMode) {
            case EpaySdkModeTest:
                self.epayUrl = EPAY_TEST_URL;
                break;
            case EpaySdkModeProduction:
                self.epayUrl = EPAY_PRODUCTION_URL;
                break;
        }
    }
    if (!self.epaySuccessUrl) {
        switch (self.sdkMode) {
            case EpaySdkModeTest:
                self.epaySuccessUrl = EPAY_TEST_SUCCESS_URL;
                break;
            case EpaySdkModeProduction:
                self.epaySuccessUrl = EPAY_PRODUCTION_SUCCESS_URL;
                break;
        }
    }
    if (!self.epayFailureUrl) {
        switch (self.sdkMode) {
            case EpaySdkModeTest:
                self.epayFailureUrl = EPAY_TEST_FAILURE_URL;
                break;
            case EpaySdkModeProduction:
                self.epayFailureUrl = EPAY_PRODUCTION_FAILURE_URL;
                break;
        }
    }
}

- (NSDictionary*)prepareRequestParameters {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    // required parameters
    parameters[@"Signed_Order_B64"] = self.signedOrderBase64;
    parameters[@"BackLink"] = EPAY_SUCCESS_BACKLINK;
    parameters[@"PostLink"] = self.postLink;
    
    // optional parameters
    
    parameters[@"FailureBackLink"] = EPAY_FAILURE_BACKLINK;
    
    if (self.shopId) {
        parameters[@"ShopID"] = self.shopId;
    }
    if (self.failurePostLink) {
        parameters[@"FailurePostLink"] = self.failurePostLink;
    }
    if (self.clientEmail) {
        parameters[@"email"] = self.clientEmail;
    }
    switch (self.language) {
        case EpayLanguageEnglish:
            parameters[@"Language"] = @"eng";
            break;
        case EpayLanguageRussian:
            parameters[@"Language"] = @"rus";
            break;
        case EpayLanguageKazakh:
            parameters[@"Language"] = @"kaz";
            break;
        default:
            break;
    }
    if (self.appendix) {
        parameters[@"appendix"] = self.appendix;
    }
    if (self.template) {
        parameters[@"template"] = self.template;
    }
    
    return parameters;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)cancelAction:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        if (self.delegate) {
            [self.delegate epayPaymentCancelledWithController:self];
        }
    }];
}

- (void)successAction:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        if (self.delegate) {
            [self.delegate epayPaymentSuccededWithController:self];
        }
    }];
}

- (void)failureAction:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        if (self.delegate) {
            [self.delegate epayPaymentFailedWithController:self];
        }
    }];
}

#pragma UIWebViewDelegate methods

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([[request.URL absoluteString] isEqualToString:EPAY_SUCCESS_BACKLINK]) {
        [self successAction:self];
        return NO;
    }
    if ([[request.URL absoluteString] isEqualToString:EPAY_FAILURE_BACKLINK]) {
        [self failureAction:self];
        return NO;
    }
    if ([[request.URL absoluteString] isEqualToString:self.epaySuccessUrl]) {
        navigationItem.leftBarButtonItem = nil;
        navigationItem.rightBarButtonItem = doneSuccessButton;
    }
    if ([[request.URL absoluteString] isEqualToString:self.epayFailureUrl]) {
        navigationItem.leftBarButtonItem = nil;
        navigationItem.rightBarButtonItem = doneFailureButton;
    }
    return YES;
}

#pragma Helper methods

// get the string form of any object
static NSString *toString(id object) {
    return [NSString stringWithFormat:@"%@", object];
}

// get the url encoded string form of any object
static NSString *urlEncode(id object) {
    NSString *string = toString(object);
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                 NULL,
                                                                                 (CFStringRef)string,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                 kCFStringEncodingUTF8 ));
}

// convert dictionary to URL-encoded string
-(NSString*) urlEncodedStringFromDictionary:(NSDictionary*)dict {
    NSMutableArray *parts = [NSMutableArray array];
    for (id key in dict) {
        id value = [dict objectForKey: key];
        NSString *part = [NSString stringWithFormat:@"%@=%@", urlEncode(key), urlEncode(value)];
        [parts addObject:part];
    }
    return [parts componentsJoinedByString:@"&"];
}

@end
