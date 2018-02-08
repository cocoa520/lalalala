//
//  XTSTweak.m
//  
//
//  Created by Pallas on 8/26/16.
//
//  Complete

#import "XTSTweak.h"
#import "AesFastEngine.h"
#import "Arrays.h"
#import "BlockCipher.h"
#import "CategoryExtend.h"
#import "Pack.h"
#import "KeyParameter.h"

@interface XTSTweak ()

@property (nonatomic, readwrite, retain) BlockCipher *cipher;
@property (nonatomic, readwrite, retain) NSMutableData *tweak;
@property (nonatomic, readwrite, retain) Class clazz;
@property (nonatomic, readwrite, assign) SEL selector;

@end

@implementation XTSTweak
@synthesize cipher = _cipher;
@synthesize tweak = _tweak;
@synthesize clazz = _clazz;
@synthesize selector = _selector;

+ (NSMutableData*)defaultTweakFunction:(int64_t)tweakValue {
    NSMutableData *bs = [Pack Int64_To_LE:tweakValue];
    bs = [Arrays copyOfRangeWithByteArray:bs withFrom:0 withTo:[XTSTweak BLOCK_SIZE]];
    return (bs ? [bs autorelease] : nil);
}

+ (int64_t)FDBK {
    return 0x87;
}

+ (int64_t)MSB {
    return 0x8000000000000000LL;
}

+ (int)BLOCK_SIZE {
    return 16;
}

- (id)initWithCipher:(BlockCipher*)cipher withClazz:(Class)clazz withSelector:(SEL)selector withTweak:(NSMutableData*)tweak {
    if (self = [super init]) {
        if (!cipher) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"cipher" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (!tweak) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"tweak" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setCipher:cipher];
        [self setClazz:clazz];
        [self setSelector:selector];
        [self setTweak:tweak];
        
        if ([[self cipher] getBlockSize] != [XTSTweak BLOCK_SIZE]) {
            @throw [NSException exceptionWithName:@"IllegalArgument" reason:[NSString stringWithFormat:@"bad block size: %d", [[self cipher] getBlockSize]] userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        return self;
    } else {
        return nil;
    }
}

- (id)initWithCipher:(BlockCipher*)cipher withClazz:(Class)clazz withSelector:(SEL)selector {
    NSMutableData *tmpData = [[NSMutableData alloc] initWithSize:[[self cipher] getBlockSize]];
    if (self = [self initWithCipher:cipher withClazz:clazz withSelector:selector withTweak:tmpData]) {
#if !__has_feature(objc_arc)
        if (tmpData) [tmpData release]; tmpData = nil;
#endif
        return self;
    } else {
#if !__has_feature(objc_arc)
        if (tmpData) [tmpData release]; tmpData = nil;
        [self release];
#endif
        return nil;
    }
}

- (id)initWithClazz:(Class)clazz withSelector:(SEL)selector {
    AesFastEngine *aesFast = [[AesFastEngine alloc] init];
    if (self = [self initWithCipher:aesFast withClazz:clazz withSelector:selector]) {
#if !__has_feature(objc_arc)
        if (aesFast) [aesFast release]; aesFast = nil;
#endif
        return self;
    } else {
#if !__has_feature(objc_arc)
        if (aesFast) [aesFast release]; aesFast = nil;
        [self release];
#endif
        return nil;
    }
}

- (id)init {
    if (self = [self initWithClazz:[XTSTweak class] withSelector:@selector(defaultTweakFunction:)]) {
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setCipher:nil];
    [self setTweak:nil];
    [self setClazz:nil];
    [super dealloc];
#endif
}

- (XTSTweak*)init:(KeyParameter*)key {
    [[self cipher] init:YES withParameters:key];
    return self;
}

- (XTSTweak*)reset:(int64_t)tweakValue {
    IMP imp = [[self clazz] methodForSelector:[self selector]];
    id result = imp([self clazz], [self selector], tweakValue);
    NSMutableData *data = nil;
    if (result && [result isKindOfClass:[NSData class]]) {
        data = (NSMutableData*)result;
    }
    return data ? [self resetWithData:data] : nil;
}

- (XTSTweak*)resetWithData:(NSMutableData*)tweakBytes {
    [[self cipher] processBlock:tweakBytes withInOff:0 withOutBuf:[self tweak] withOutOff:0];
    return self;
}

- (NSMutableData*)value {
    NSMutableData *retData = nil;
    if ([self tweak]) {
        retData = [Arrays copyOfWithData:[self tweak] withNewLength:(int)([self tweak].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (XTSTweak*)next {
    int64_t lo = [Pack LE_To_Int64:[self tweak] withOff:0];
    int64_t hi = [Pack LE_To_Int64:[self tweak] withOff:8];
    int64_t fdbk = (hi & [XTSTweak MSB]) == 0 ? 0L : [XTSTweak FDBK];
    hi = (hi << 1) | (((uint64_t)(lo)) >> 63);
    lo = (lo << 1) ^ fdbk;
    [Pack Int64_To_LE:lo withBs:[self tweak] withOff:0];
    [Pack Int64_To_LE:hi withBs:[self tweak] withOff:8];
    return self;
}

@end
