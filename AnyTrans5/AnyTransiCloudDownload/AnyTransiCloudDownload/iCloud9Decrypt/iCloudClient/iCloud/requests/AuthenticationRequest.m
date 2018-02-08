//
//  AuthenticationRequest.m
//  
//
//  Created by Pallas on 1/7/16.
//
//  Complete

#import "AuthenticationRequest.h"
#import "Headers.h"

@interface AuthenticationRequest ()

@property (nonatomic, readwrite, retain) NSString *url;
@property (nonatomic, readwrite, retain) Headers *headers;

@end

@implementation AuthenticationRequest
@synthesize url = _url;
@synthesize headers = _headers;

- (id)init:(Headers*)headers {
    self = [super init];
    if (!self) {
        return nil;
    }
    [self setUrl:@"https://setup.icloud.com/setup/authenticate/$APPLE_ID$"];
    [self setHeaders:headers];
    return self;
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_url != nil) [_url release]; _url = nil;
    if (_headers != nil) [_headers release]; _headers = nil;
    [super dealloc];
#endif
}

- (NSMutableURLRequest*)apply:(NSString*)appleId withPassword:(NSString*)password {
    NSString *authorization = [Headers basicToken:appleId withRight:password];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest addValue:((BasicHeader*)[self.headers get:USERAGENT]).value forHTTPHeaderField:USERAGENT];
    [urlRequest addValue:((BasicHeader*)[self.headers get:XMMECLIENTINFO]).value forHTTPHeaderField:XMMECLIENTINFO];
    [urlRequest addValue:authorization forHTTPHeaderField:AUTHORIZATION];
    return urlRequest;
}

@end
