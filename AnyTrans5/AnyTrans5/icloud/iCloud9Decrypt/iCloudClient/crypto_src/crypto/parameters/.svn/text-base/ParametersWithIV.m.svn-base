//
//  ParametersWithIV.m
//  
//
//  Created by Pallas on 7/14/16.
//
//  Complete

#import "ParametersWithIV.h"
#import "CategoryExtend.h"

@interface ParametersWithIV ()

@property (nonatomic, readwrite, retain) CipherParameters *parameters;
@property (nonatomic, readwrite, retain) NSMutableData *iv;

@end

@implementation ParametersWithIV
@synthesize parameters = _parameters;
@synthesize iv = _iv;

- (id)initWithParameters:(CipherParameters*)parameters withIv:(NSMutableData*)iv {
    if (self = [self initWithParameters:parameters withIv:iv withIvOff:0 withIvLen:(int)(iv.length)]) {
        return self;
    } else {
        return nil;
    }
}

- (id)initWithParameters:(CipherParameters*)parameters withIv:(NSMutableData*)iv withIvOff:(int)ivOff withIvLen:(int)ivLen {
    if (self = [super init]) {
        // NOTE: 'parameters' may be null to imply key re-use
        if (iv == nil) {
            @throw [NSException exceptionWithName:@"ArgumentNull" reason:@"iv" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        
        @autoreleasepool {
            [self setParameters:parameters];
            NSMutableData *tmpData = [[NSMutableData alloc] initWithSize:ivLen];
            [self setIv:tmpData];
#if !__has_feature(objc_arc)
            if (tmpData != nil) [tmpData release]; tmpData = nil;
#endif
            [[self iv] copyFromIndex:0 withSource:iv withSourceIndex:ivOff withLength:ivLen];
        }
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setParameters:nil];
    [self setIv:nil];
    [super dealloc];
#endif
}

- (NSMutableData*)getIV {
    int keyLength = (int)([self iv].length);
    NSMutableData *retData = [[[NSMutableData alloc] initWithSize:keyLength] autorelease];
    [retData copyFromIndex:0 withSource:[self iv] withSourceIndex:0 withLength:keyLength];
    return retData;
}

@end
