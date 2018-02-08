//
//  ProtoBufsRequest.m
//  
//
//  Created by Pallas on 1/11/16.
//
//  Complete

#import "ProtoBufsRequestLegacy.h"
#import "Headers.h"
#import "CategoryExtend.h"
#import "ProtocolBuffers.h"
#import "CloudKit.pb.h"

@interface ProtoBufsRequestLegacy ()

@property (nonatomic, readwrite, retain) Headers *headers;

@end

@implementation ProtoBufsRequestLegacy
@synthesize headers = _headers;

+ (ProtoBufsRequestLegacy*)singleton {
    static ProtoBufsRequestLegacy *_singleton = nil;
    @synchronized(self) {
        if (_singleton == nil) {
            _singleton = [[ProtoBufsRequestLegacy alloc] initWithHeaders:[Headers coreHeaders]];
        }
    }
    return _singleton;
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

- (NSMutableURLRequest*)newRequest:(NSString*)url withContainer:(NSString*)container withBundle:(NSString*)bundle withCloudKitUserId:(NSString*)cloudKitUserId withCloudKitToken:(NSString*)cloudKitToken withUuid:(NSString*)uuid withProtobufs:(NSArray*)protobufs {
    NSOutputStream* rawOutput = [NSOutputStream outputStreamToMemory];
    PBCodedOutputStream *outputStream = [PBCodedOutputStream streamWithOutputStream:rawOutput];
    [rawOutput open];
    for (RequestOperation *message in protobufs) {
        int len = message.serializedSize;
        [outputStream writeRawVarint32:len];
        [message writeToCodedOutputStream:outputStream];
        [outputStream flush];
    }
    NSData* outputData = [rawOutput propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
    [rawOutput close];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:uuid forHTTPHeaderField:XAPPLEREQUESTUUID];
    [urlRequest setValue:cloudKitUserId forHTTPHeaderField:XCLOUDKITUSERID];
    [urlRequest setValue:cloudKitToken forHTTPHeaderField:XCLOUDKITAUTHTOKEN];
    [urlRequest setValue:container forHTTPHeaderField:XCLOUDKITCONTAINERID];
    [urlRequest setValue:bundle forHTTPHeaderField:XCLOUDKITBUNDLEID];
    [urlRequest setValue:@"application/x-protobuf" forHTTPHeaderField:ACCEPT];
    [urlRequest setValue:@"application/x-protobuf; desc=\"https://p33-ckdatabase.icloud.com:443/static/protobuf/CloudDB/CloudDBClient.desc\"; messageType=RequestOperation; delimited=true" forHTTPHeaderField:CONTENTTYPE];
    [urlRequest addValue:[((BasicHeader*)[self.headers get:USERAGENT]) value] forHTTPHeaderField:USERAGENT];
    [urlRequest addValue:[((BasicHeader*)[self.headers get:XCLOUDKITPROTOCOLVERSION]) value] forHTTPHeaderField:XCLOUDKITPROTOCOLVERSION];
    [urlRequest addValue:[((BasicHeader*)[self.headers get:XMMECLIENTINFO]) value] forHTTPHeaderField:XMMECLIENTINFO];
    [urlRequest setHTTPBody:outputData];
    return urlRequest;
}

@end
