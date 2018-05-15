//
//  TwitterOAuthAPI.m
//  DriveSync
//
//  Created by JGehry on 21/03/2018.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "TwitterOAuthAPI.h"

#include <CommonCrypto/CommonHMAC.h>

@implementation TwitterOAuthAPI
@synthesize oauthRequestToken = _oauthRequestToken;
@synthesize oauthAccessToken = _oauthAccessToken;
@synthesize accountName = _accountName;

- (void)dealloc
{
    self.oauthRequestToken = nil;
    self.oauthAccessToken = nil;
    self.accountName = nil;
    [super dealloc];
}

- (instancetype)initWithFetchResource:(NSString *)resource
                           httpMethod:(NSString *)httpMethod
                        baseURLString:(NSString *)baseURLString
                          consumerKey:(NSString *)consumerKey
                   withConsumerSecret:(NSString *)consumerSecret
                         withTokenKey:(NSString *)tokenKey
                      withTokenSecret:(NSString *)tokenSecret
                              withPIN:(NSString *)PIN
                    isHasRequestToken:(BOOL)hasRequestToken
                     isHasAccessToken:(BOOL)hasAccessToken {
    if (self = [super init]) {
        NSString *nonce = [NSString st_random32Characters];
        NSString *timestamp = [self oauthTimestamp];
        NSMutableArray *oauthParameters = [NSMutableArray arrayWithObjects:
                                           @{@"oauth_consumer_key" : consumerKey},
                                           @{@"oauth_nonce" : nonce},
                                           @{@"oauth_signature_method" : @"HMAC-SHA1"},
                                           @{@"oauth_timestamp" : timestamp},
                                           @{@"oauth_version" : @"1.0"}, nil];
        
        if (!hasRequestToken) {
            [oauthParameters addObject:@{@"oauth_callback" : @"oob"}];
        }
        
        if (hasAccessToken) {
            [oauthParameters addObject:@{@"oauth_token" : tokenKey}];
        }else if (hasRequestToken) {
            [oauthParameters addObject:@{@"oauth_token" : tokenKey}];
        }
        
        if (PIN) {
            [oauthParameters addObject:@{@"oauth_verifier": PIN}];
        }
        
        if ([baseURLString hasSuffix:@"/"]) {
            baseURLString = [baseURLString substringToIndex:[baseURLString length] - 1];
        }
        
        if ([httpMethod isEqualToString:@"GET"]) {
            if ([resource rangeOfString:@"="].location != NSNotFound) {
                NSArray *resourceArray = [resource componentsSeparatedByString:@"="];
                resource = [resourceArray objectAtIndex:0];
                self.accountName = [resourceArray lastObject];
                [oauthParameters addObject:@{@"screen_name": _accountName}];
            }
        }
        NSString *urlString = [NSString stringWithFormat:@"%@/%@", baseURLString, resource];
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSString *signatureBaseString = [self signatureBaseStringWithHTTPMethod:httpMethod url:url allParametersUnsorted:oauthParameters];
        
        if ([httpMethod isEqualToString:@"GET"]) {
            if (self.accountName) {
                [oauthParameters removeLastObject];
            }
        }
        
        NSString *encodedConsumerSecret = [consumerSecret st_urlEncodedString];
        NSString *encodedTokenSecret = [tokenSecret st_urlEncodedString];
        
        NSString *signingKey = [NSString stringWithFormat:@"%@&", encodedConsumerSecret];
        
        if (encodedTokenSecret) {
            signingKey = [signingKey stringByAppendingString:encodedTokenSecret];
        }
        
        NSString *signature = [signatureBaseString st_signHmacSHA1WithKey:signingKey];
        [oauthParameters addObject:@{@"oauth_signature" : signature}];
        
        if (hasRequestToken) {
            self.oauthAccessToken = [self oauthHeaderValueWithParameters:oauthParameters];
        }else {
            self.oauthRequestToken = [self oauthHeaderValueWithParameters:oauthParameters];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

#pragma mark -- 新增键值对
- (NSString *)oauthTimestamp {
    /*
     The oauth_timestamp parameter indicates when the request was created. This value should be the number of seconds since the Unix epoch at the point the request is generated, and should be easily generated in most programming languages. Twitter will reject requests which were created too far in the past, so it is important to keep the clock of the computer generating requests in sync with NTP.
     */
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    
    return [NSString stringWithFormat:@"%d", (int)timeInterval];
}

- (NSArray *)encodedParametersDictionaries:(NSArray *)parameters {
    
    NSMutableArray *encodedParameters = [NSMutableArray array];
    
    for(NSDictionary *d in parameters) {
        
        NSString *key = [[d allKeys] lastObject];
        NSString *value = [[d allValues] lastObject];
        
        NSString *encodedKey = [key st_urlEncodedString];
        NSString *encodedValue = [value st_urlEncodedString];
        
        [encodedParameters addObject:@{encodedKey : encodedValue}];
    }
    
    return encodedParameters;
}

- (NSString *)stringFromParametersDictionaries:(NSArray *)parametersDictionaries {
    
    NSMutableArray *parameters = [NSMutableArray array];
    
    for(NSDictionary *d in parametersDictionaries) {
        
        NSString *encodedKey = [[d allKeys] lastObject];
        NSString *encodedValue = [[d allValues] lastObject];
        
        NSString *s = [NSString stringWithFormat:@"%@=\"%@\"", encodedKey, encodedValue];
        
        [parameters addObject:s];
    }
    
    return [parameters componentsJoinedByString:@", "];
}

- (NSString *)oauthHeaderValueWithParameters:(NSArray *)parametersDictionaries {
    
    NSArray *encodedParametersDictionaries = [self encodedParametersDictionaries:parametersDictionaries];
    
    NSString *encodedParametersString = [self stringFromParametersDictionaries:encodedParametersDictionaries];
    
    NSString *headerValue = [NSString stringWithFormat:@"OAuth %@", encodedParametersString];
    
    return headerValue;
}

- (NSString *)signatureBaseStringWithHTTPMethod:(NSString *)httpMethod url:(NSURL *)url allParametersUnsorted:(NSArray *)parameters {
    NSMutableArray *allParameters = [NSMutableArray arrayWithArray:parameters];
    
    NSArray *encodedParametersDictionaries = [self encodedParametersDictionaries:allParameters];
    
    NSArray *sortedEncodedParametersDictionaries = [self parametersDictionariesSortedByKey:encodedParametersDictionaries];
    
    /**/
    
    NSMutableArray *encodedParameters = [NSMutableArray array];
    
    for(NSDictionary *d in sortedEncodedParametersDictionaries) {
        NSString *encodedKey = [[d allKeys] lastObject];
        NSString *encodedValue = [[d allValues] lastObject];
        
        NSString *s = [NSString stringWithFormat:@"%@=%@", encodedKey, encodedValue];
        
        [encodedParameters addObject:s];
    }
    
    NSString *encodedParametersString = [encodedParameters componentsJoinedByString:@"&"];
    
    NSString *signatureBaseString = [NSString stringWithFormat:@"%@&%@&%@",
                                     [httpMethod uppercaseString],
                                     [[url st_normalizedForOauthSignatureString] st_urlEncodedString],
                                     [encodedParametersString st_urlEncodedString]];
    
    return signatureBaseString;
}

- (NSArray *)parametersDictionariesSortedByKey:(NSArray *)parametersDictionaries {
    
    return [parametersDictionaries sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDictionary *d1 = (NSDictionary *)obj1;
        NSDictionary *d2 = (NSDictionary *)obj2;
        
        NSString *key1 = [[d1 allKeys] lastObject];
        NSString *key2 = [[d2 allKeys] lastObject];
        
        return [key1 compare:key2];
    }];
    
}

@end

@implementation NSString (TwitterRequestTokenAPI)

+ (NSString *)st_randomString {
    CFUUIDRef cfuuid = CFUUIDCreate (kCFAllocatorDefault);
    NSString *uuid = (__bridge NSString *)(CFUUIDCreateString (kCFAllocatorDefault, cfuuid));
    CFRelease (cfuuid);
    return uuid;
}

+ (NSString *)st_random32Characters {
    NSString *randomString = [self st_randomString];
    
    NSAssert([randomString length] >= 32, @"");
    
    return [randomString substringToIndex:32];
}

- (NSString *)st_signHmacSHA1WithKey:(NSString *)key {
    
    unsigned char buf[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, [key UTF8String], [key length], [self UTF8String], [self length], buf);
    NSData *data = [NSData dataWithBytes:buf length:CC_SHA1_DIGEST_LENGTH];
    return [data base64Encoding];
}

- (NSDictionary *)st_parametersDictionary {
    
    NSArray *parameters = [self componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
    for(NSString *parameter in parameters) {
        NSArray *keyValue = [parameter componentsSeparatedByString:@"="];
        if([keyValue count] != 2) {
            continue;
        }
        
        [md setObject:keyValue[1] forKey:keyValue[0]];
    }
    
    return md;
}

- (NSString *)st_urlEncodedString {
    // https://dev.twitter.com/docs/auth/percent-encoding-parameters
    // http://tools.ietf.org/html/rfc3986#section-2.1
    
    return [self st_stringByAddingRFC3986PercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)st_stringByAddingRFC3986PercentEscapesUsingEncoding:(NSStringEncoding)encoding {
    
    NSString *s = (__bridge NSString *)(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                (CFStringRef)self,
                                                                                NULL,
                                                                                CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                kCFStringEncodingUTF8));
    return s;
}

@end

@implementation NSURL (TwitterRequestTokenAPI)

- (NSArray *)st_rawGetParametersDictionaries {
    
    NSString *q = [self query];
    
    NSArray *getParameters = [q componentsSeparatedByString:@"&"];
    
    NSMutableArray *ma = [NSMutableArray array];
    
    for(NSString *s in getParameters) {
        NSArray *kv = [s componentsSeparatedByString:@"="];
        NSAssert([kv count] == 2, @"-- bad length");
        if([kv count] != 2) continue;
        NSString *value = [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; // use raw parameters for signing
        [ma addObject:@{kv[0] : value}];
    }
    
    return ma;
}

- (NSString *)st_normalizedForOauthSignatureString {
    return [NSString stringWithFormat:@"%@://%@%@", [self scheme], [self host], [self path]];
}

@end
