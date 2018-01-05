//
//  AccountSettingsRequest.m
//  
//
//  Created by Pallas on 1/7/16.
//
//  Complete

#import "AccountSettingsRequest.h"
#import "Headers.h"

@interface AccountSettingsRequest ()

@property (nonatomic, readwrite, retain) NSString *url;
@property (nonatomic, readwrite, retain) Headers *headers;

@end

@implementation AccountSettingsRequest
@synthesize url = _url;
@synthesize headers = _headers;

- (id)init:(Headers*)headers {
    self = [super init];
    if (!self) {
        return nil;
    }
    [self setUrl:@"https://setup.icloud.com/setup/get_account_settings"];
    [self setHeaders:headers];
    return self;
}

- (NSMutableURLRequest*)apply:(NSString*)dsPrsID withPassword:(NSString*)mmeAuthToken {
    NSString *authorization = [Headers basicToken:dsPrsID withRight:mmeAuthToken];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest addValue:((BasicHeader*)[self.headers get:USERAGENT]).value forHTTPHeaderField:USERAGENT];
    [urlRequest addValue:((BasicHeader*)[self.headers get:XMMECLIENTINFO]).value forHTTPHeaderField:XMMECLIENTINFO];
    [urlRequest addValue:authorization forHTTPHeaderField:AUTHORIZATION];
    return urlRequest;
}

@end
