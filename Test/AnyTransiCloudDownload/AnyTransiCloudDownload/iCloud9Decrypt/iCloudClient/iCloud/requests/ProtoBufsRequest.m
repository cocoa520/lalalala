//
//  ProtoBufsRequest.m
//  
//
//  Created by iMobie on 7/26/16.
//
//  Complete

#import "ProtoBufsRequest.h"
#import "Headers.h"

@interface ProtoBufsRequest ()

@property (nonatomic, readwrite, retain) Headers *headers;
@property (nonatomic, readwrite, retain) NSString *url;
@property (nonatomic, readwrite, retain) NSString *container;
@property (nonatomic, readwrite, retain) NSString *bundle;
@property (nonatomic, readwrite, retain) NSString *cloudKitUserId;
@property (nonatomic, readwrite, retain) NSString *cloudKitToken;

@end

@implementation ProtoBufsRequest
@synthesize headers = _headers;
@synthesize url = _url;
@synthesize container = _container;
@synthesize bundle = _bundle;
@synthesize cloudKitUserId = _cloudKitUserId;
@synthesize cloudKitToken = _cloudKitToken;

+ (Headers*)headers {
    static Headers *_headers = nil;
    @synchronized(self) {
        if (_headers == nil) {
            _headers = [[Headers coreHeaders] retain];
        }
    }
    return _headers;
}

+ (NSString*)accept {
    static NSString *_accept = nil;
    @synchronized(self) {
        if (_accept == nil) {
            _accept = [@"application/x-protobuf" retain];
        }
    }
    return _accept;
}

+ (NSString*)content_type {
    static NSString *_content_type = nil;
    @synchronized(self) {
        if (_content_type == nil) {
            _content_type = [@"application/x-protobuf; desc=\"https://p33-ckdatabase.icloud.com:443/static/protobuf/CloudDB/CloudDBClient.desc\"; messageType=RequestOperation; delimited=true" retain];
        }
    }
    return _content_type;
}

- (id)initWithHeaders:(Headers*)headers withUrl:(NSString*)url withContainer:(NSString*)container withBundle:(NSString*)bundle withCloudKitUserId:(NSString*)cloudKitUserId withCloudKitToken:(NSString*)cloudKitToken {
    if (self = [super init]) {
        [self setHeaders:headers];
        [self setUrl:url];
        [self setContainer:container];
        [self setBundle:bundle];
        [self setCloudKitUserId:cloudKitUserId];
        [self setCloudKitToken:cloudKitToken];
        return self;
    } else {
        return nil;
    }
}

- (id)initWithUrl:(NSString*)url withContainer:(NSString*)container withBundle:(NSString*)bundle withCloudKitUserId:(NSString*)cloudKitUserId withCloudKitToken:(NSString*)cloudKitToken {
    if (self = [self initWithHeaders:[ProtoBufsRequest headers] withUrl:url withContainer:container withBundle:bundle withCloudKitUserId:cloudKitUserId withCloudKitToken:cloudKitToken]) {
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_headers != nil) [_headers release]; _headers = nil;
    if (_url != nil) [_url release]; _url = nil;
    if (_container != nil) [_container release]; _container = nil;
    if (_bundle != nil) [_bundle release]; _bundle = nil;
    if (_cloudKitUserId != nil) [_cloudKitUserId release]; _cloudKitUserId = nil;
    if (_cloudKitToken != nil) [_cloudKitToken release]; _cloudKitToken = nil;
    [super dealloc];
#endif
}

- (NSMutableURLRequest*)apply:(NSString*)uuid withDelimitedMessages:(NSData*)delimitedMessages {
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url]];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:uuid forHTTPHeaderField:XAPPLEREQUESTUUID];
    [urlRequest setValue:[self cloudKitUserId] forHTTPHeaderField:XCLOUDKITUSERID];
    [urlRequest setValue:[self cloudKitToken] forHTTPHeaderField:XCLOUDKITAUTHTOKEN];
    [urlRequest setValue:[self container] forHTTPHeaderField:XCLOUDKITCONTAINERID];
    [urlRequest setValue:[self bundle] forHTTPHeaderField:XCLOUDKITBUNDLEID];
    [urlRequest setValue:[ProtoBufsRequest accept] forHTTPHeaderField:ACCEPT];
    [urlRequest setValue:[ProtoBufsRequest content_type] forHTTPHeaderField:CONTENTTYPE];
    [urlRequest addValue:[((BasicHeader*)[self.headers get:USERAGENT]) value] forHTTPHeaderField:USERAGENT];
    [urlRequest addValue:[((BasicHeader*)[self.headers get:XCLOUDKITPROTOCOLVERSION]) value] forHTTPHeaderField:XCLOUDKITPROTOCOLVERSION];
    [urlRequest addValue:[((BasicHeader*)[self.headers get:XMMECLIENTINFO]) value] forHTTPHeaderField:XMMECLIENTINFO];
    [urlRequest setHTTPBody:delimitedMessages];
    return urlRequest;
}

@end
