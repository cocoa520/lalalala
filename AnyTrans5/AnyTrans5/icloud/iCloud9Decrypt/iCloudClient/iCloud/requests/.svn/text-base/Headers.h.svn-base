//
//  Headers.h
//  
//
//  Created by Pallas on 4/25/16.
//
//  Complete

#import <Foundation/Foundation.h>

#define ACCEPT                      @"Accept"
#define AUTHORIZATION               @"Authorization"
#define CONTENTTYPE                 @"Content-Type"
#define USERAGENT                   @"User-Agent"
#define XAPPLEMMCSDATACLASS         @"x-apple-mmcs-dataclass"
#define XAPPLEMMCSAUTH              @"x-apple-mmcs-auth"
#define XAPPLEMMCSPROTOVERSION      @"x-apple-mmcs-proto-version"
#define XAPPLEMMEDSID               @"x-apple-mme-dsid"
#define XAPPLEREQUESTUUID           @"X-Apple-Request-UUID"
#define XCLOUDKITAUTHTOKEN          @"X-CloudKit-AuthToken"
#define XCLOUDKITBUNDLEID           @"X-CloudKit-BundleId"
#define XCLOUDKITCONTAINERID        @"X-CloudKit-ContainerId"
#define XCLOUDKITCONTAINER          @"X-CloudKit-Container"
#define XCLOUDKITENVIRONMENT        @"X-CloudKit-Environment"
#define XCLOUDKITPARTITION          @"X-CloudKit-Partition"
#define XCLOUDKITPROTOCOLVERSION    @"X-CloudKit-ProtocolVersion"
#define XCLOUDKITUSERID             @"X-CloudKit-UserId"
#define XCLOUDKITZONES              @"X-CloudKit-Zone"
#define XMMECLIENTINFO              @"X-Mme-Client-Info"

@interface BasicHeader : NSObject {
@private
    NSString *                      _name;
    NSString *                      _value;
}

@property (nonatomic, readwrite, retain) NSString * name;
@property (nonatomic, readwrite, retain) NSString * value;

- (id)init:(NSString*)name withValue:(NSString*)value;

@end

@class NameValuePair;

@interface Headers : NSObject {
@private
    NSMutableDictionary *               _headers;
}

+ (Headers*)coreHeaders;

- (id)initWithHeaders:(NSDictionary*)headers;
- (id)initWithBaseHeaders:(NSArray*)baseHeaders;

- (BasicHeader*)get:(NSString*)header;

+ (BasicHeader*)header:(NSString*)name withValue:(NSString*)value;
+ (BasicHeader*)header:(NameValuePair*)header;
+ (NSString*)basicToken:(NSString*)left withRight:(NSString*)right;
+ (NSString*)mobilemeAuthToken:(NSString*)left withRight:(NSString*)right;
+ (NSString*)token:(NSString*)type withLeft:(NSString*)left withRight:(NSString*)right;

+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
+ (NSString *)base64EncodedStringFrom:(NSData *)data;

@end
