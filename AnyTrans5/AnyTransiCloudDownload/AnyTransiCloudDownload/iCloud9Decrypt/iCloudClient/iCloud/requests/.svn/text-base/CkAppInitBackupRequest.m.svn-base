//
//  CkAppInitBackupRequest.m
//  
//
//  Created by Pallas on 1/7/16.
//
//

#import "CkAppInitBackupRequest.h"
#import "Headers.h"

@interface CkAppInitBackupRequest ()

@property (nonatomic, readwrite, retain) NSString *url;
@property (nonatomic, readwrite, retain) Headers *headers;

@end

@implementation CkAppInitBackupRequest
@synthesize url = _url;
@synthesize headers = _headers;

+ (CkAppInitBackupRequest*)singleton {
    static CkAppInitBackupRequest *_singleton = nil;
    @synchronized(self) {
        if (_singleton == nil) {
            _singleton = [[CkAppInitBackupRequest alloc] init:@"https://setup.icloud.com/setup/ck/v1/ckAppInit" withHeaders:[Headers coreHeaders]];
        }
    }
    return _singleton;
}

- (id)init:(NSString*)url_ withHeaders:(Headers*)headers_ {
    if (self = [super init]) {
        [self setUrl:url_];
        [self setHeaders:headers_];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_url != nil) [_url release]; _url = nil;
    if (_headers != nil) [_headers release]; _headers = nil;
    [super dealloc];
#endif
}

- (NSMutableURLRequest*)newRequest:(NSString*)dsPrsID withMmeAuthToken:(NSString*)mmeAuthToken withCloudKitAuthToken:(NSString*)cloudKitAuthToken withBundle:(NSString*)bundle withContainer:(NSString*)container {
    NSString *authorization = [Headers basicToken:dsPrsID withRight:mmeAuthToken];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?container=%@", self.url, container]]];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:((BasicHeader*)[self.headers get:USERAGENT]).value forHTTPHeaderField:USERAGENT];
    [urlRequest setValue:((BasicHeader*)[self.headers get:XMMECLIENTINFO]).value forHTTPHeaderField:XMMECLIENTINFO];
    [urlRequest setValue:((BasicHeader*)[self.headers get:XCLOUDKITENVIRONMENT]).value forHTTPHeaderField:XCLOUDKITENVIRONMENT];
    [urlRequest setValue:((BasicHeader*)[self.headers get:XCLOUDKITPARTITION]).value forHTTPHeaderField:XCLOUDKITPARTITION];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:ACCEPT];
    [urlRequest setValue:authorization forHTTPHeaderField:AUTHORIZATION];
    [urlRequest setValue:cloudKitAuthToken forHTTPHeaderField:XCLOUDKITAUTHTOKEN];
    [urlRequest setValue:bundle forHTTPHeaderField:XCLOUDKITBUNDLEID];
    [urlRequest setValue:container forHTTPHeaderField:XCLOUDKITCONTAINERID];
    return urlRequest;
}

@end
