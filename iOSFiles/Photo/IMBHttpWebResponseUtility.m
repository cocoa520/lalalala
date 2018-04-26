//
//  IMBHttpWebResponseUtility.m
//  iCloudDemo
//
//  Created by Pallas on 6/25/14.
//  Copyright (c) 2014 com.imobie. All rights reserved.
//

#import "IMBHttpWebResponseUtility.h"
#import "IMBLogManager.h"
#import "CommonDefine.h"

@implementation IMBHttpWebResponseUtility

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

+ (NSData *)postWithData:(NSData*)body withHeaders:(NSDictionary*)headers withHost:(NSString*)host withPath:(NSString*)path withSSL:(BOOL)ssl {
    NSData *retData = nil;
    NSString *protocol = ssl ? @"https://" : @"http://";
    NSString *url = [NSString stringWithFormat:@"%@%@%@", protocol, host, path];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest addValue:host forHTTPHeaderField:@"Host"];
    [urlRequest setHTTPBody:body];
    if (headers != nil && headers.allKeys.count > 0) {
        NSArray *allkeys = headers.allKeys;
        for (NSString *key in allkeys) {
            [urlRequest addValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
    }
    [urlRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = nil;
    @try {
        responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&error] ;
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
    @finally {
        
    }
    if (responseData != nil && [responseData length] > 0 && error == nil){
        retData = [NSData dataWithData:responseData];
    }
    if (error && [error code] == -1009) {
        // 网络错误
        @throw [NSException exceptionWithName:NOTITY_NETWORK_FAULT_INTERRUPT reason:@"Network fault interrupt" userInfo:nil];
    }
    return retData;
}

+ (NSString*)getWithHeaders:(NSDictionary*)headers withHost:(NSString*)host withPath:(NSString*)path withSSL:(BOOL)ssl {
    NSString *resultStr = nil;
    NSString *protocol = ssl ? @"https://" : @"http://";
    NSString *url = [NSString stringWithFormat:@"%@%@%@", protocol, host, path];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest addValue:host forHTTPHeaderField:@"Host"];
    if (headers != nil && headers.allKeys.count > 0) {
        NSArray *allkeys = headers.allKeys;
        for (NSString *key in allkeys) {
            [urlRequest addValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = nil;
    @try {
        responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&error] ;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    if (responseData != nil && [responseData length] > 0 && error == nil){
        resultStr = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
    }
    if (error && [error code] == -1009) {
        // 网络错误
        @throw [NSException exceptionWithName:NOTITY_NETWORK_FAULT_INTERRUPT reason:@"Network fault interrupt" userInfo:nil];
    }
    return resultStr;
}

+ (NSData*)getBytesWithHeaders:(NSDictionary*)headers withHost:(NSString*)host withPath:(NSString*)path withSSL:(BOOL)ssl {
    NSData *retData = nil;
    NSString *protocol = ssl ? @"https://" : @"http://";
    NSString *url = [NSString stringWithFormat:@"%@%@%@", protocol, host, path];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest addValue:host forHTTPHeaderField:@"Host"];
    if (headers != nil && headers.allKeys.count > 0) {
        NSArray *allkeys = headers.allKeys;
        for (NSString *key in allkeys) {
            [urlRequest addValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
    }
//    [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"url :%@",url]];
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = nil;
    @try {
        responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&error] ;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"responseData length:%d",responseData.length]];
    if (responseData != nil && [responseData length] > 0 && error == nil){
        retData = [NSData dataWithData:responseData];
    }
    if (error && [error code] == -1009) {
        // 网络错误
        @throw [NSException exceptionWithName:NOTITY_NETWORK_FAULT_INTERRUPT reason:@"Network fault interrupt" userInfo:nil];
    }
    return retData;
}

+ (NSString*)encode:(NSString*)part1 withPart:(NSString*)part2 {
    NSString *str = [NSString stringWithFormat:@"%@:%@", part1, part2];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64str = [self base64EncodedStringFrom:data];
    return base64str;
}

+ (NSString*)encode:(NSString *)part {
    NSData *data = [part dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64str = [self base64EncodedStringFrom:data];
    return base64str;
}

+ (NSString*)decode:(NSString*)base64str {
    NSData *data=[self dataWithBase64EncodedString:base64str];
    NSString *_str=[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    return _str;
}

+ (NSData *)dataWithBase64EncodedString:(NSString *)string {
    if (string == nil)
        [NSException raise:NSInvalidArgumentException format:nil];
    if ([string length] == 0)
        return [NSData data];
    
    static char *decodingTable = NULL;
    if (decodingTable == NULL)
    {
        decodingTable = malloc(256);
        if (decodingTable == NULL)
            return nil;
        memset(decodingTable, CHAR_MAX, 256);
        NSUInteger i;
        for (i = 0; i < 64; i++)
            decodingTable[(short)encodingTable[i]] = i;
    }
    
    const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
    if (characters == NULL)     //  Not an ASCII string!
        return nil;
    char *bytes = malloc((([string length] + 3) / 4) * 3);
    if (bytes == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (YES)
    {
        char buffer[4];
        short bufferLength;
        for (bufferLength = 0; bufferLength < 4; i++)
        {
            if (characters[i] == '\0')
                break;
            if (isspace(characters[i]) || characters[i] == '=')
                continue;
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
            {
                free(bytes);
                return nil;
            }
        }
        
        if (bufferLength == 0)
            break;
        if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
        {
            free(bytes);
            return nil;
        }
        
        //  Decode the characters in the buffer to bytes.
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        if (bufferLength > 2)
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        if (bufferLength > 3)
            bytes[length++] = (buffer[2] << 6) | buffer[3];
    }
    
    bytes = realloc(bytes, length);
    return [NSData dataWithBytesNoCopy:bytes length:length];
}

+ (NSString *)base64EncodedStringFrom:(NSData *)data {
    if ([data length] == 0)
        return @"";
    
    char *characters = malloc((([data length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [data length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [data length])
            buffer[bufferLength++] = ((char *)[data bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}

//icloud photos/notes/contact等----20170201
+ (NSData *)postWithData:(NSData*)body withHeaders:(NSDictionary*)headers withHost:(NSString*)host withPath:(NSString*)path withCookieArray:(NSMutableArray **)cookieArray {
    NSData *retData = nil;
    NSString *url = [NSString stringWithFormat:@"%@%@", host, path];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest addValue:[host stringByReplacingOccurrencesOfString:@"https://" withString:@""] forHTTPHeaderField:@"Host"];
    [urlRequest setHTTPBody:body];
    if (headers != nil && headers.allKeys.count > 0) {
        NSArray *allkeys = headers.allKeys;
        for (NSString *key in allkeys) {
            [urlRequest addValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    //跟网页iCloud用的是application/x-www-form-urlencoded
    [urlRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //跟iCloudDrive.exe用的是application/json
    //    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = nil;
    @try {
        responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&error] ;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    //获取cookie数组
    if (urlResponse != nil && cookieArray != nil) {
        NSDictionary *dic = [urlResponse allHeaderFields];
        if (cookieArray != NULL) {
            [*cookieArray addObjectsFromArray:[NSHTTPCookie cookiesWithResponseHeaderFields:dic forURL:[NSURL URLWithString:url]]];

        }
    }
    
    if (responseData != nil && [responseData length] > 0 && error == nil){
        retData = [NSData dataWithData:responseData];
    }
    if (error && [error code] == -1009) {
        // 网络错误
        @throw [NSException exceptionWithName:NOTITY_NETWORK_FAULT_INTERRUPT reason:@"Network fault interrupt" userInfo:nil];
    }
    return retData;
}


+ (NSData *)postWithData:(NSData*)body withHeaders:(NSDictionary*)headers withHost:(NSString*)host withPath:(NSString*)path withSSL:(BOOL)ssl withCookieStr:(NSString **)cookieStr {
    NSData *retData = nil;
    //    NSString *protocol = ssl ? @"https://" : @"http://";
    //    NSString *url = [NSString stringWithFormat:@"%@%@%@", protocol, host, path];
    NSString *url = [NSString stringWithFormat:@"%@%@", host, path];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest addValue:[host stringByReplacingOccurrencesOfString:@"https://" withString:@""] forHTTPHeaderField:@"Host"];
    [urlRequest setHTTPBody:body];
    if (headers != nil && headers.allKeys.count > 0) {
        NSArray *allkeys = headers.allKeys;
        for (NSString *key in allkeys) {
            [urlRequest addValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    if (ssl) {
        //跟网页iCloud用的是application/x-www-form-urlencoded
        [urlRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        //跟iCloudDrive.exe用的是application/json
        //    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }else {
        [urlRequest addValue:@"multipart/form-data; boundary=----WebKitFormBoundary1IR5qsBwtCYcLQaJ" forHTTPHeaderField:@"Content-Type"];
    }
    
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = nil;
    @try {
        responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&error] ;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    if (urlResponse != nil) {
        NSDictionary *dic = [urlResponse allHeaderFields];
        NSArray *array = [NSHTTPCookie cookiesWithResponseHeaderFields:dic forURL:[NSURL URLWithString:url]];
        
        //        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:dic];
        //
        //        NSDictionary *cookieDic = [dic objectForKey:@"Set-Cookie"];
        //
        //        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        //        for (NSHTTPCookie *cookie in [cookieStorage cookies]) {
        //            NSLog(@"cookie:%@",cookie);
        //        }
        if (*cookieStr != nil) {
            int i = 0;
            for (NSHTTPCookie *cookie in array) {
                *cookieStr = [[[*cookieStr stringByAppendingString:cookie.name] stringByAppendingString:@"="] stringByAppendingString:cookie.value];
                i ++;
                if (i < array.count) {
                    *cookieStr = [*cookieStr stringByAppendingString:@";"];
                }
            }
        }
        
    }
    
    if (responseData != nil && [responseData length] > 0 && error == nil){
        retData = [NSData dataWithData:responseData];
    }
    if (error && [error code] == -1009) {
        // 网络错误
        @throw [NSException exceptionWithName:NOTITY_NETWORK_FAULT_INTERRUPT reason:@"Network fault interrupt" userInfo:nil];
    }
    return retData;
}


+ (NSString*)getWithHeadersiCloudDrive:(NSDictionary*)headers withHost:(NSString*)host withPath:(NSString*)path {
    NSString *resultStr = nil;
    NSString *url = [NSString stringWithFormat:@"%@%@", host, path];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest addValue:[host stringByReplacingOccurrencesOfString:@"https://" withString:@""] forHTTPHeaderField:@"Host"];
    if (headers != nil && headers.allKeys.count > 0) {
        NSArray *allkeys = headers.allKeys;
        for (NSString *key in allkeys) {
            [urlRequest addValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = nil;
    @try {
        responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&error] ;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    if (responseData != nil && [responseData length] > 0 && error == nil){
        resultStr = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
    }
    if (error && [error code] == -1009) {
        // 网络错误
        @throw [NSException exceptionWithName:NOTITY_NETWORK_FAULT_INTERRUPT reason:@"Network fault interrupt" userInfo:nil];
    }
    return resultStr;
}

+ (NSData*)getBytesWithHeadersiCloudDrive:(NSDictionary*)headers withHost:(NSString*)host withPath:(NSString*)path {
    NSData *retData = nil;
    NSString *url = [NSString stringWithFormat:@"%@%@", host, path];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest addValue:[host stringByReplacingOccurrencesOfString:@"https://" withString:@""] forHTTPHeaderField:@"Host"];
    if (headers != nil && headers.allKeys.count > 0) {
        NSArray *allkeys = headers.allKeys;
        for (NSString *key in allkeys) {
            [urlRequest addValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = nil;
    @try {
        responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&error] ;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    if (responseData != nil && [responseData length] > 0 && error == nil){
        retData = [NSData dataWithData:responseData];
    }
    if (error && [error code] == -1009) {
        // 网络错误
        @throw [NSException exceptionWithName:NOTITY_NETWORK_FAULT_INTERRUPT reason:@"Network fault interrupt" userInfo:nil];
    }
    return retData;
}


@end
