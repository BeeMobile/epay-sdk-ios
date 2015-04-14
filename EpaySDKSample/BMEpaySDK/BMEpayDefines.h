//
//  BMEpayDefines.h
//  EpaySDKSample
//
//  Created by http://beemobile.kz on 3/29/15.
//  Copyright (c) 2015 Kazkommertsbank. All rights reserved.
//

#ifndef EpaySDKSample_BMEpayConstants_h
#define EpaySDKSample_BMEpayConstants_h

#define EPAY_PRODUCTION_URL @"https://epay.kkb.kz/jsp/process/logon.jsp"
#define EPAY_TEST_URL @"https://3dsecure.kkb.kz/jsp/process/logon.jsp"

#define EPAY_PRODUCTION_SUCCESS_URL @"https://epay.kkb.kz/jsp/process/result.jsp"
#define EPAY_TEST_SUCCESS_URL @"https://3dsecure.kkb.kz/jsp/process/result.jsp"

#define EPAY_PRODUCTION_FAILURE_URL @"https://epay.kkb.kz/jsp/process/err_process.jsp"
#define EPAY_TEST_FAILURE_URL @"https://3dsecure.kkb.kz/jsp/process/err_process.jsp"

#define EPAY_SUCCESS_BACKLINK @"http://localhost/success"
#define EPAY_FAILURE_BACKLINK @"http://localhost/failure"

typedef NS_ENUM(NSInteger, EpayLanguage) {
    EpayLanguageDefault,
    EpayLanguageRussian,
    EpayLanguageKazakh,
    EpayLanguageEnglish
};

typedef NS_ENUM(NSInteger, EpaySdkMode) {
    EpaySdkModeProduction,
    EpaySdkModeTest
};


#endif
