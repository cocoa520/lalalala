//
//  XTSAESBlockCipher.m
//  
//
//  Created by Pallas on 8/26/16.
//
//  Complete

#import "XTSAESBlockCipher.h"
#import "CipherParameters.h"
#import "KeyParameter.h"
#import "XTSCore.h"
#import "XTSTweak.h"

@interface XTSAESBlockCipher ()

@property (nonatomic, readwrite, retain) XTSCore *core;
@property (nonatomic, readwrite, assign) int blockSize;
@property (nonatomic, readwrite, assign) int dataUnitSize;
@property (nonatomic, readwrite, assign) int64_t dataUnit;
@property (nonatomic, readwrite, assign) int index;

@end

@implementation XTSAESBlockCipher
@synthesize core = _core;
@synthesize blockSize = _blockSize;
@synthesize dataUnitSize = _dataUnitSize;
@synthesize dataUnit = _dataUnit;
@synthesize index = _index;

-(id)initWithCore:(XTSCore*)core withBlockSize:(int)blockSize withDataUnitSize:(int)dataUnitSize withDataUnit:(int64_t)dataUnit withIndex:(int)index {
    if (self = [super init]) {
        if (!core) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"core" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setCore:core];
        [self setBlockSize:blockSize];
        [self setDataUnitSize:dataUnitSize];
        [self setDataUnit:dataUnit];
        [self setIndex:index];
        return self;
    } else {
        return nil;
    }
}

- (id)initWithCore:(XTSCore*)core withClazz:(Class)clazz withSelector:(SEL)selector withDataUnitSize:(int)dataUnitSize {
    XTSTweak *tweak = [[XTSTweak alloc] initWithClazz:clazz withSelector:selector];
    XTSCore *tmpCore = [[XTSCore alloc] initWithTweak:tweak];
    if (self = [self initWithCore:tmpCore withBlockSize:[core getBlockSize] withDataUnitSize:dataUnitSize withDataUnit:0 withIndex:0]) {
#if !__has_feature(objc_arc)
        if (tweak) [tweak release]; tweak = nil;
        if (tmpCore) [tmpCore release]; tmpCore = nil;
#endif
        return self;
    } else {
#if !__has_feature(objc_arc)
        if (tweak) [tweak release]; tweak = nil;
        if (tmpCore) [tmpCore release]; tmpCore = nil;
        [self release];
#endif
        return nil;
    }
}

- (id)initWithClazz:(Class)clazz withSelector:(SEL)selector withDataUnitSize:(int)dataUnitSize {
    XTSCore *core = [[XTSCore alloc] init];
    if (self = [self initWithCore:core withClazz:clazz withSelector:selector withDataUnitSize:dataUnitSize]) {
#if !__has_feature(objc_arc)
        if (core) [core release]; core = nil;
#endif
        return self;
    } else {
#if !__has_feature(objc_arc)
        if (core) [core release]; core = nil;
        [self release];
#endif
        return nil;
    }
}

- (id)initWithDataUnitSize:(int)dataUnitSize {
    XTSCore *core = [[XTSCore alloc] init];
    if (self = [self initWithCore:core withClazz:[XTSTweak class] withSelector:@selector(defaultTweakFunction:) withDataUnitSize:dataUnitSize]) {
#if !__has_feature(objc_arc)
        if (core) [core release]; core = nil;
#endif
        return self;
    } else {
#if !__has_feature(objc_arc)
        if (core) [core release]; core = nil;
        [self release];
#endif
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setCore:nil];
    [super dealloc];
#endif
}

- (void)init:(BOOL)forEncryption withParameters:(CipherParameters*)parameters {
    if ([parameters isMemberOfClass:[KeyParameter class]]) {
        [[self core] init:forEncryption withKey:(KeyParameter*)parameters];
        return;
    }
    @throw [NSException exceptionWithName:@"IllegalArgument" reason:[NSString stringWithFormat:@"invalid params: %@", [parameters className]] userInfo:nil];
}

- (NSString*)algorithmName {
    return [[self core] getAlgorithmName];
}

- (int)getBlockSize {
    return [self blockSize];
}

- (int)processBlock:(NSMutableData*)inBuf withInOff:(int)inOff withOutBuf:(NSMutableData*)outBuf withOutOff:(int)outOff {
    if (self.index == 0) {
        [[self core] reset:self.dataUnit];
    }
    if ((self.index += self.blockSize) == self.dataUnitSize) {
        self.dataUnit++;
        self.index = 0;
    }
    return [[self core] processBlock:inBuf withInOff:inOff withOutBuf:outBuf withOutOff:outOff];
}

- (void)reset {
    [self setIndex:0];
    [self setDataUnit:0];
}

@end
