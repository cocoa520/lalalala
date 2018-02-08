//
//  Tables8kGcmMultiplier.m
//  
//
//  Created by Pallas on 7/14/16.
//
//  Complete

#import "Tables8kGcmMultiplier.h"
#import "CategoryExtend.h"
#import "Arrays.h"
#import "GcmUtilities.h"
#import "Pack.h"

@interface Tables8kGcmMultiplier ()

@property (nonatomic, readwrite, retain) NSMutableData *h;
@property (nonatomic, readwrite, retain) NSMutableArray *m;

@end

@implementation Tables8kGcmMultiplier
@synthesize h = _h;
@synthesize m = _m;

- (id)init {
    if (self = [super init]) {
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setH:nil];
    [self setM:nil];
    [super dealloc];
#endif
}

- (void)init:(NSMutableData*)h {
    @autoreleasepool {
        if ([self m] == nil) {
            NSMutableArray *tmpM = [[NSMutableArray alloc] initWithSize:32];
            [self setM:tmpM];
#if !__has_feature(objc_arc)
            if (tmpM != nil) [tmpM release]; tmpM = nil;
#endif
        } else if ([Arrays areEqualWithByteArray:[self h] withB:h]) {
            return;
        }
        
        NSMutableData *tmpData = [Arrays cloneWithByteArray:h];
        [self setH:tmpData];
#if !__has_feature(objc_arc)
        if (tmpData) [tmpData release]; tmpData = nil;
#endif
        
        NSMutableArray *secondArray = [[NSMutableArray alloc] initWithSize:16];
        NSMutableArray *thirdArray = [[NSMutableArray alloc] initWithSize:4];
        secondArray[0] = thirdArray;
        [self m][0] = secondArray;
#if !__has_feature(objc_arc)
        if (secondArray != nil) [secondArray release]; secondArray = nil;
        if (thirdArray != nil) [thirdArray release]; thirdArray = nil;
#endif
        secondArray = [[NSMutableArray alloc] initWithSize:16];
        thirdArray = [[NSMutableArray alloc] initWithSize:4];
        secondArray[0] = thirdArray;
        secondArray[8] = [GcmUtilities asUints:h];
        [self m][1] = secondArray;
#if !__has_feature(objc_arc)
        if (secondArray != nil) [secondArray release]; secondArray = nil;
        if (thirdArray != nil) [thirdArray release]; thirdArray = nil;
#endif
        
        for (int j = 4; j >= 1; j >>= 1) {
            NSMutableArray *tmp = [Arrays cloneWithUIntArray:(NSMutableArray*)(((NSMutableArray*)([self m][1]))[j + j])];
            [GcmUtilities multiplyP:tmp];
            ((NSMutableArray*)([self m][1]))[j] = tmp;
        }
        
        {
            NSMutableArray *tmp = [Arrays cloneWithUIntArray:(NSMutableArray*)(((NSMutableArray*)([self m][1]))[1])];
            [GcmUtilities multiplyP:tmp];
            ((NSMutableArray*)([self m][0]))[8] = tmp;
        }
        
        for (int j = 4; j >= 1; j >>= 1) {
            NSMutableArray *tmp = [Arrays cloneWithUIntArray:(NSMutableArray*)(((NSMutableArray*)([self m][0]))[j + j])];
            [GcmUtilities multiplyP:tmp];
            ((NSMutableArray*)([self m][0]))[j] = tmp;
        }
        
        for (int i = 0; ; ) {
            for (int j = 2; j < 16; j += j) {
                for (int k = 1; k < j; ++k) {
                    NSMutableArray *tmp = [Arrays cloneWithUIntArray:(NSMutableArray*)(((NSMutableArray*)([self m][i]))[j])];
                    [GcmUtilities xorWithUints:tmp withY:(NSMutableArray*)(((NSMutableArray*)([self m][i]))[k])];
                    ((NSMutableArray*)([self m][i]))[j + k] = tmp;
                }
            }
            
            if (++i == 32) return;
            
            if (i > 1) {
                secondArray = [[NSMutableArray alloc] initWithSize:16];
                thirdArray = [[NSMutableArray alloc] initWithSize:4];
                secondArray[0] = thirdArray;
                [self m][i] = secondArray;
#if !__has_feature(objc_arc)
                if (secondArray != nil) [secondArray release]; secondArray = nil;
                if (thirdArray != nil) [thirdArray release]; thirdArray = nil;
#endif
                for (int j = 8; j > 0; j >>= 1) {
                    NSMutableArray *tmp = [Arrays cloneWithUIntArray:(NSMutableArray*)(((NSMutableArray*)([self m][i - 2]))[j])];
                    [GcmUtilities multiplyP8:tmp];
                    ((NSMutableArray*)([self m][i]))[j] = tmp;
                }
            }
        }
    }
}

- (void)multiplyH:(NSMutableData*)x {
    @autoreleasepool {
        NSMutableArray *z = [[NSMutableArray alloc] initWithSize:4];
        for (int i = 15; i >= 0; --i) {
            // [GcmUtilities xorWithUints:z withY:(NSMutableArray*)(((NSMutableArray*)([self m][i + i]))[(((Byte*)(x.bytes))[i] & 0x0f)])];
            NSMutableArray *m = (NSMutableArray*)(((NSMutableArray*)([self m][i + i]))[(((Byte*)(x.bytes))[i] & 0x0f)]);
            z[0] = @([z[0] unsignedIntValue] ^ [m[0] unsignedIntValue]);
            z[1] = @([z[1] unsignedIntValue] ^ [m[1] unsignedIntValue]);
            z[2] = @([z[2] unsignedIntValue] ^ [m[2] unsignedIntValue]);
            z[3] = @([z[3] unsignedIntValue] ^ [m[3] unsignedIntValue]);
            // [GcmUtilities xorWithUints:z withY:(NSMutableArray*)(((NSMutableArray*)([self m][i + i + 1]))[((((Byte*)(x.bytes))[i] & 0xf0) >> 4)])];
            m = (NSMutableArray*)(((NSMutableArray*)([self m][i + i + 1]))[((((Byte*)(x.bytes))[i] & 0xf0) >> 4)]);
            z[0] = @([z[0] unsignedIntValue] ^ [m[0] unsignedIntValue]);
            z[1] = @([z[1] unsignedIntValue] ^ [m[1] unsignedIntValue]);
            z[2] = @([z[2] unsignedIntValue] ^ [m[2] unsignedIntValue]);
            z[3] = @([z[3] unsignedIntValue] ^ [m[3] unsignedIntValue]);
        }
        
        [Pack UInt32_To_BE_Array:z withBs:x withOff:0];
#if !__has_feature(objc_arc)
        if (z != nil) [z release]; z = nil;
#endif
    }
}

@end
