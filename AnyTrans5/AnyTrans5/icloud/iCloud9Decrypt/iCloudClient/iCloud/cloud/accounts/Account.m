//
//  Account.m
//  
//
//  Created by Pallas on 4/25/16.
//
//  Complete

#import "Account.h"

@interface Account ()

@property (nonatomic, readwrite, retain) MobileMe *mobileMe;
@property (nonatomic, readwrite, retain) AccountInfo *accountInfo;
@property (nonatomic, readwrite, retain) Tokens *tokens;

@end

@implementation Account
@synthesize mobileMe = _mobileMe;
@synthesize accountInfo = _accountInfo;
@synthesize tokens = _tokens;

- (id)init:(MobileMe*)mobileMe_ withAccountInfo:(AccountInfo*)accountInfo_ withTokens:(Tokens*)tokens_ {
    if (self = [super init]) {
        [self setMobileMe:mobileMe_];
        [self setAccountInfo:accountInfo_];
        [self setTokens:tokens_];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_mobileMe != nil) [_mobileMe release]; _mobileMe = nil;
    if (_accountInfo != nil) [_accountInfo release]; _accountInfo = nil;
    if (_tokens != nil) [_tokens release]; _tokens = nil;
    [super dealloc];
#endif
}

- (MobileMe *)mobileMe {
    return _mobileMe;
}

- (AccountInfo *)accountInfo {
    return _accountInfo;
}

- (Tokens *)tokens {
    return _tokens;
}

@end
