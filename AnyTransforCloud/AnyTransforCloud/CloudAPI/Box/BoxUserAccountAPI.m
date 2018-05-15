//
//  BoxUserAccountAPI.m
//  DriveSync
//
//  Created by JGehry on 22/03/2018.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "BoxUserAccountAPI.h"

@implementation BoxUserAccountAPI

- (NSString *)baseUrl {
    return BoxAPIBaseURL;
}

- (NSString *)requestUrl {
    return BoxGetCurrentAccount;
}

@end
