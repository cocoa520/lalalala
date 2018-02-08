//
//  EscrowProxyRequest.m
//  
//
//  Created by Pallas on 4/26/16.
//
//  Complete

#import "EscrowProxyRequest.h"
#import "Headers.h"
#import "CategoryExtend.h"
#import "Blob.h"

@interface EscrowProxyRequest ()

@property (nonatomic, readwrite, retain) NSString *dsPrsID;
@property (nonatomic, readwrite, retain) NSString *escrowProxyUrl;
@property (nonatomic, readwrite, retain) NSString *mmeAuthToken;
@property (nonatomic, readwrite, retain) Headers *headers;

@end

@implementation EscrowProxyRequest
@synthesize dsPrsID = _dsPrsID;
@synthesize escrowProxyUrl = _escrowProxyUrl;
@synthesize mmeAuthToken = _mmeAuthToken;
@synthesize headers = _headers;

- (id)initWithDsPrsID:(NSString*)dsPrsID withMmeAuthToken:(NSString*)mmeAuthToken withEscrowProxyUrl:(NSString*)escrowProxyUrl withHeaders:(Headers*)headers {
    if (self = [super init]) {
        [self setDsPrsID:dsPrsID];
        [self setMmeAuthToken:mmeAuthToken];
        [self setEscrowProxyUrl:escrowProxyUrl];
        [self setHeaders:headers];
        return self;
    } else {
        return nil;
    }
}

- (id)initWithDsPrsID:(NSString*)dsPrsID withMmeAuthToken:(NSString*)mmeAuthToken withEscrowProxyUrl:(NSString*)escrowProxyUrl {
    if (self = [self initWithDsPrsID:dsPrsID withMmeAuthToken:mmeAuthToken withEscrowProxyUrl:escrowProxyUrl withHeaders:[Headers coreHeaders]]) {
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_dsPrsID != nil) [_dsPrsID release]; _dsPrsID = nil;
    if (_mmeAuthToken != nil) [_mmeAuthToken release]; _mmeAuthToken = nil;
    if (_escrowProxyUrl != nil) [_escrowProxyUrl release]; _escrowProxyUrl = nil;
    if (_headers != nil) [_headers release]; _headers = nil;
    [super dealloc];
#endif
}

- (NSMutableURLRequest*)getRecords {
    NSString *uri = [self.escrowProxyUrl stringByAppendingPathComponent:@"escrowproxy/api/get_records"];
    NSString *mobilemeAuthToken = [Headers mobilemeAuthToken:self.dsPrsID withRight:self.mmeAuthToken];
    NSString *post = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n<plist version=\"1.0\">\n<dict>\n<key>command</key>\n<string>GETRECORDS</string>\n<key>label</key>\n<string>com.apple.protectedcloudstorage.record</string>\n<key>version</key>\n<integer>1</integer>\n</dict>\n</plist>";
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:uri]];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest addValue:@"application/x-apple-plist" forHTTPHeaderField:CONTENTTYPE];
    [urlRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:CONTENTTYPE];
    [urlRequest addValue:mobilemeAuthToken forHTTPHeaderField:AUTHORIZATION];
    [urlRequest addValue:[((BasicHeader*)[self.headers get:USERAGENT]) value] forHTTPHeaderField:USERAGENT];
    [urlRequest addValue:[((BasicHeader*)[self.headers get:XMMECLIENTINFO]) value] forHTTPHeaderField:XMMECLIENTINFO];
    [urlRequest setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
    return urlRequest;
}

- (NSMutableURLRequest*)srpInit:(NSData*)key {
    NSString *uri = [self.escrowProxyUrl stringByAppendingPathComponent:@"escrowproxy/api/srp_init"];
    NSString *mobilemeAuthToken = [Headers mobilemeAuthToken:self.dsPrsID withRight:self.mmeAuthToken];
    NSString *encodedKey = [Headers base64EncodedStringFrom:key];
    
    NSString *post = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n<plist version=\"1.0\">\n<dict>\n<key>blob</key>\n<string>%@</string>\n<key>command</key>\n<string>SRP_INIT</string>\n<key>label</key>\n<string>com.apple.protectedcloudstorage.record</string>\n<key>version</key>\n<integer>1</integer>\n</dict>\n</plist>", encodedKey] ;
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:uri]];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest addValue:@"application/x-apple-plist" forHTTPHeaderField:CONTENTTYPE];
    [urlRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:CONTENTTYPE];
    [urlRequest addValue:mobilemeAuthToken forHTTPHeaderField:AUTHORIZATION];
    [urlRequest addValue:[((BasicHeader*)[self.headers get:USERAGENT]) value] forHTTPHeaderField:USERAGENT];
    [urlRequest addValue:[((BasicHeader*)[self.headers get:XMMECLIENTINFO]) value] forHTTPHeaderField:XMMECLIENTINFO];
    [urlRequest setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
    return urlRequest;
}

- (NSMutableURLRequest*)recover:(NSMutableData*)m1 withUUID:(NSMutableData*)uuid withTag:(NSMutableData*)tag {
    NSString *uri = [self.escrowProxyUrl stringByAppendingPathComponent:@"escrowproxy/api/recover"];
    NSString *mobilemeAuthToken = [Headers mobilemeAuthToken:self.dsPrsID withRight:self.mmeAuthToken];
    
    BlobA5 *blob = [[BlobA5 alloc] init:tag withUid:uuid withMessage:m1];
    DataStream *data = [blob exportDataStream];
#if !__has_feature(objc_arc)
    if (blob) [blob release]; blob = nil;
#endif
    NSString *encodedMessage = [Headers base64EncodedStringFrom:[data toMutableData]];
    
    NSString *post = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n<plist version=\"1.0\">\n<dict>\n<key>blob</key>\n<string>%@</string>\n<key>command</key>\n<string>RECOVER</string>\n<key>label</key>\n<string>com.apple.protectedcloudstorage.record</string>\n<key>version</key>\n<integer>1</integer>\n</dict>\n</plist>", encodedMessage];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:uri]];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest addValue:@"application/x-apple-plist" forHTTPHeaderField:CONTENTTYPE];
    [urlRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:CONTENTTYPE];
    [urlRequest addValue:mobilemeAuthToken forHTTPHeaderField:AUTHORIZATION];
    [urlRequest addValue:[((BasicHeader*)[self.headers get:USERAGENT]) value] forHTTPHeaderField:USERAGENT];
    [urlRequest addValue:[((BasicHeader*)[self.headers get:XMMECLIENTINFO]) value] forHTTPHeaderField:XMMECLIENTINFO];
    [urlRequest setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
    return urlRequest;
}

@end
