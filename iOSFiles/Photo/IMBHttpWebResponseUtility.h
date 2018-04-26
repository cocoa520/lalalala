//
//  IMBHttpWebResponseUtility.h
//  iCloudDemo
//
//  Created by Pallas on 6/25/14.
//  Copyright (c) 2014 com.imobie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMBHttpWebResponseUtility : NSObject {
@private
}

+ (NSData *)postWithData:(NSData*)body withHeaders:(NSDictionary*)headers withHost:(NSString*)host withPath:(NSString*)path withSSL:(BOOL)ssl;

+ (NSString*)getWithHeaders:(NSDictionary*)headers withHost:(NSString*)host withPath:(NSString*)path withSSL:(BOOL)ssl;

+ (NSData*)getBytesWithHeaders:(NSDictionary*)headers withHost:(NSString*)host withPath:(NSString*)path withSSL:(BOOL)ssl;

+ (NSString*)encode:(NSString*)part1 withPart:(NSString*)part2;

+ (NSString*)encode:(NSString *)part;

+ (NSString*)decode:(NSString*)base64str;

+ (NSData *)dataWithBase64EncodedString:(NSString *)string;

+ (NSString *)base64EncodedStringFrom:(NSData *)data;

//后面加的

+ (NSData *)postWithData:(NSData*)body withHeaders:(NSDictionary*)headers withHost:(NSString*)host withPath:(NSString*)path withCookieArray:(NSMutableArray **)cookieArray;

+ (NSData *)postWithData:(NSData*)body withHeaders:(NSDictionary*)headers withHost:(NSString*)host withPath:(NSString*)path withSSL:(BOOL)ssl withCookieStr:(NSString **)cookieStr;

+ (NSString*)getWithHeadersiCloudDrive:(NSDictionary*)headers withHost:(NSString*)host withPath:(NSString*)path;

+ (NSData*)getBytesWithHeadersiCloudDrive:(NSDictionary*)headers withHost:(NSString*)host withPath:(NSString*)path;

@end
