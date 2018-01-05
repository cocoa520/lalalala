//
//  Account.h
//  
//
//  Created by Pallas on 4/25/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class MobileMe;
@class AccountInfo;
@class Tokens;

@interface Account : NSObject {
@private
    MobileMe *                  _mobileMe;
    AccountInfo *               _accountInfo;
    Tokens *                    _tokens;
}

- (id)init:(MobileMe*)mobileMe_ withAccountInfo:(AccountInfo*)accountInfo_ withTokens:(Tokens*)tokens_;

- (MobileMe *)mobileMe;
- (AccountInfo *)accountInfo;
- (Tokens *)tokens;

@end
