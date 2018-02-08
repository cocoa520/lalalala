//
//  Headers.m
//  
//
//  Created by Pallas on 4/25/16.
//
//  Complete

#import "Headers.h"
#import "ChunkServer.pb.h"
//#import "ChunkServer.h"

@implementation BasicHeader
@synthesize name = _name;
@synthesize value = _value;

- (id)init:(NSString*)name withValue:(NSString*)value {
    if (self = [super init]) {
        [self setName:name];
        [self setValue:value];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_name != nil) [_name release]; _name = nil;
    if (_value != nil) [_value release]; _value = nil;
    [super dealloc];
#endif
}

@end

@interface Headers ()

@property (nonatomic, readwrite, retain) NSMutableDictionary * headers;

@end

@implementation Headers
@synthesize headers = _headers;

+ (Headers*)coreHeaders {
    static Headers *_coreHeaders = nil;
    @synchronized(self) {
        if (_coreHeaders == nil) {
            _coreHeaders = [[Headers alloc] initWithBaseHeaders:[NSArray arrayWithObjects:
                                                                 [[[BasicHeader alloc] init:USERAGENT withValue:@"CloudKit/479 (13A404)"] autorelease],
                                                                 [[[BasicHeader alloc] init:XMMECLIENTINFO withValue:@"<iPhone5,3> <iPhone OS;9.0.1;13A404> <com.apple.cloudkit.CloudKitDaemon/479 (com.apple.cloudd/479)>"] autorelease],
                                                                 [[[BasicHeader alloc] init:XCLOUDKITPROTOCOLVERSION withValue:@"client=1;comments=1;device=1;presence=1;records=1;sharing=1;subscriptions=1;users=1;mescal=1;"] autorelease],
                                                                 [[[BasicHeader alloc] init:XAPPLEMMCSPROTOVERSION withValue:@"4.0"] autorelease],
                                                                 [[[BasicHeader alloc] init:XCLOUDKITENVIRONMENT withValue:@"production"] autorelease],
                                                                 [[[BasicHeader alloc] init:XCLOUDKITPARTITION withValue:@"production"] autorelease],
                                                                 nil]];
        }
    }
    return _coreHeaders;
}

- (id)init {
    if (self = [super init]) {
        [self setHeaders:[[[NSMutableDictionary alloc] init] autorelease]];
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

- (id)initWithHeaders:(NSDictionary*)headers {
    if (self = [super init]) {
        [self.headers setValuesForKeysWithDictionary:headers];
        return self;
    } else {
        return nil;
    }
}

- (id)initWithBaseHeaders:(NSArray*)baseHeaders {
    self = [self init];
    if (!self) {
        return nil;
    }
    if (baseHeaders != nil && baseHeaders.count > 0) {
        for (BasicHeader *bh in baseHeaders) {
            [self.headers setObject:bh forKey:[bh.name lowercaseString]];
        }
    }
    return self;
}

- (BasicHeader*)get:(NSString*)header {
    if ([self.headers.allKeys containsObject:[header lowercaseString]]) {
        return (BasicHeader*)[self.headers objectForKey:[header lowercaseString]];
    }
    return nil;
}

- (NSArray*)getAll {
    if (self.headers != nil) {
        return self.headers.allValues;
    }
    return nil;
}

+ (BasicHeader*)header:(NSString*)name withValue:(NSString*)value {
    return [[[BasicHeader alloc] init:name withValue:value] autorelease];
}

+ (BasicHeader*)header:(NameValuePair*)header {
    return [Headers header:header.name  withValue:header.value];
}

+ (NSString*)basicToken:(NSString*)left withRight:(NSString*)right {
    return [Headers token:@"Basic" withLeft:left withRight:right];
}

+ (NSString*)mobilemeAuthToken:(NSString*)left withRight:(NSString*)right {
    return [Headers token:@"X-MobileMe-AuthToken" withLeft:left withRight:right];
}

+ (NSString*)token:(NSString*)type withLeft:(NSString*)left withRight:(NSString*)right {
    NSString *str = [NSString stringWithFormat:@"%@:%@", left, right];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [self base64EncodedStringFrom:data];
    return [NSString stringWithFormat:@"%@ %@", type, base64String];
}

#pragma mark - Base64

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

// base64加密字符串内容
+ (NSData *)dataWithBase64EncodedString:(NSString *)string {
    if (string == nil) {
        [NSException raise:NSInvalidArgumentException format:nil];
    }
    if ([string length] == 0) {
        return [NSData data];
    }
    
    static char *decodingTable = NULL;
    if (decodingTable == NULL) {
        decodingTable = malloc(256);
        if (decodingTable == NULL) {
            return nil;
        }
        memset(decodingTable, CHAR_MAX, 256);
        NSUInteger i;
        for (i = 0; i < 64; i++) {
            decodingTable[(short)encodingTable[i]] = i;
        }
    }
    
    const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
    if (characters == NULL) {
        //  Not an ASCII string!
        return nil;
    }
    char *bytes = malloc((([string length] + 3) / 4) * 3);
    if (bytes == NULL) {
        return nil;
    }
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (YES) {
        char buffer[4];
        short bufferLength;
        for (bufferLength = 0; bufferLength < 4; i++) {
            if (characters[i] == '\0') {
                break;
            }
            if (isspace(characters[i]) || characters[i] == '=') {
                continue;
            }
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            if (buffer[bufferLength++] == CHAR_MAX) {
                //  Illegal character!
                free(bytes);
                return nil;
            }
        }
        
        if (bufferLength == 0) {
            break;
        }
        if (bufferLength == 1) {
            //  At least two characters are needed to produce one byte!
            free(bytes);
            return nil;
        }
        
        //  Decode the characters in the buffer to bytes.
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        if (bufferLength > 2) {
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        }
        if (bufferLength > 3) {
            bytes[length++] = (buffer[2] << 6) | buffer[3];
        }
    }
    
    bytes = realloc(bytes, length);
    return [NSData dataWithBytesNoCopy:bytes length:length];
}

// base64加密字节内容
+ (NSString *)base64EncodedStringFrom:(NSData *)data {
    if ([data length] == 0) {
        return @"";
    }
    
    char *characters = malloc((([data length] + 2) / 3) * 4);
    if (characters == NULL) {
        return nil;
    }
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [data length]) {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [data length]) {
            buffer[bufferLength++] = ((char *)[data bytes])[i++];
        }
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1) {
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        } else {
            characters[length++] = '=';
        }
        if (bufferLength > 2) {
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        } else {
            characters[length++] = '=';
        }
    }
    
    return [[[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES] autorelease];
}

@end
