//
//  AuthorizeGetRequest.m
//  
//
//  Created by iMobie on 8/8/16.
//
//  Complete

#import "AuthorizeGetRequest.h"
#import "CategoryExtend.h"
#import "CloudKit.pb.h"
#import "Headers.h"
#import "Hex.h"

@interface AuthorizeGetRequest ()

@property (nonatomic, readwrite, retain) Headers *headers;

@end

@implementation AuthorizeGetRequest
@synthesize headers = _headers;

+ (AuthorizeGetRequest*)instance {
    static AuthorizeGetRequest *_instance = nil;
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [[AuthorizeGetRequest alloc] initWithHeaders:[Headers coreHeaders]];
        }
    }
    return _instance;
}

- (id)initWithHeaders:(Headers*)headers {
    if (self = [super init]) {
        [self setHeaders:headers];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_headers != nil) [_headers release]; _headers = nil;
    [super dealloc];
#endif
}

- (NSMutableURLRequest*)newRequest:(NSString*)dsPrsID withContentBaseUrl:(NSString*)contentBaseUrl withContainer:(NSString*)container withZone:(NSString*)zone withFileTokens:(FileTokens*)fileTokens {
    if ([fileTokens fileTokensList].count == 0) {
        return nil;
    }
    
    FileToken *base = [fileTokens fileTokensAtIndex:0];
    NSString *mmcsAuthToken = [NSString stringWithFormat:@"%@ %@ %@", [NSString dataToHex:[base fileChecksum]], [NSString dataToHex:[base fileSignature]], [base token]];
    
    NSOutputStream* rawOutput = [NSOutputStream outputStreamToMemory];
    [rawOutput open];
    [fileTokens writeToOutputStream:rawOutput];
    NSData* outputData = [rawOutput propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
    [rawOutput close];
    
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/authorizeGet", contentBaseUrl, dsPrsID]]];
    [urlRequest setHTTPMethod:@"POST"];
    
    [urlRequest addValue:@"application/vnd.com.apple.me.ubchunk+protobuf" forHTTPHeaderField:ACCEPT];
    [urlRequest addValue:@"application/vnd.com.apple.me.ubchunk+protobuf" forHTTPHeaderField:CONTENTTYPE];
    [urlRequest addValue:@"com.apple.Dataclass.CloudKit" forHTTPHeaderField:XAPPLEMMCSDATACLASS];
    [urlRequest addValue:mmcsAuthToken forHTTPHeaderField:XAPPLEMMCSAUTH];
    [urlRequest addValue:dsPrsID forHTTPHeaderField:XAPPLEMMEDSID];
    [urlRequest addValue:container forHTTPHeaderField:XCLOUDKITCONTAINER];
    [urlRequest addValue:zone forHTTPHeaderField:XCLOUDKITZONES];
    [urlRequest addValue:((BasicHeader*)[self.headers get:USERAGENT]).value forHTTPHeaderField:USERAGENT];
    [urlRequest addValue:((BasicHeader*)[self.headers get:XAPPLEMMCSPROTOVERSION]).value forHTTPHeaderField:XAPPLEMMCSPROTOVERSION];
    [urlRequest addValue:((BasicHeader*)[self.headers get:XMMECLIENTINFO]).value forHTTPHeaderField:XMMECLIENTINFO];
    [urlRequest setHTTPBody:outputData];
    return urlRequest;
}

@end
