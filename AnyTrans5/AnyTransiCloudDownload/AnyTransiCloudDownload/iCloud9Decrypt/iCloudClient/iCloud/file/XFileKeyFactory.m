//
//  XFileKeyFactory.m
//  
//
//  Created by Pallas on 8/29/16.
//
//  Complete

#import "XFileKeyFactory.h"
#import "CategoryExtend.h"
#import "DPCipherFactories.h"
#import "FileKeyAssistant.h"
#import "KeyBlob.h"
#import "XFileKey.h"

@interface XFileKeyFactory ()

@property (nonatomic, readwrite, retain) id target;
@property (nonatomic, readwrite, assign) SEL selector;
@property (nonatomic, readwrite, assign) IMP imp;

@end

@implementation XFileKeyFactory
@synthesize target = _target;
@synthesize selector = _selector;
@synthesize imp = _imp;

- (id)initWithTarget:(id)target withSel:(SEL)sel withFunction:(IMP)function {
    if (self = [super init]) {
        if (!target) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"target" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setTarget:target];
        [self setSelector:sel];
        [self setImp:function];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setTarget:nil];
    [self setSelector:nil];
    [self setImp:nil];
    [super dealloc];
#endif
}

- (XFileKey*)apply:(NSMutableData*)encryptionKey {
    KeyBlob *kb = [KeyBlob create:encryptionKey];
    if (kb) {
        return [self fileKey:kb];
    } else {
        return nil;
    }
}

- (XFileKey*)fileKey:(KeyBlob*)blob {
    NSMutableData *unwrapData = [FileKeyAssistant unwrap:[self target] withSel:[self selector] withFunction:[self imp] withBlob:blob];
    if (unwrapData) {
        return [self fileKey:blob withKey:unwrapData];
    } else {
        return nil;
    }
}

- (XFileKey*)fileKey:(KeyBlob*)blob withKey:(NSMutableData*)key {
    return [[[XFileKey alloc] initWithKey:key withCiphers:[self ciphers:blob] withFlags:[self flags:blob]] autorelease];
}

- (NSMutableData*)flags:(KeyBlob*)blob {
    DataStream *buffer = [[DataStream alloc] initWithAllocateSize:12];
    [buffer putInt:[blob u1]];
    [buffer putInt:[blob u2]];
    [buffer putInt:[blob u3]];
    
    NSMutableData *retData = [[[buffer toMutableData] retain] autorelease];
#if !__has_feature(objc_arc)
    if (buffer) [buffer release]; buffer = nil;
#endif
    return retData;
}

- (BlockCipher*)ciphers:(KeyBlob*)blob {
    // u3 - 0x00FF0000;
    // experimental
    return ([blob u3] & 0x00FF0000) == 0 ? [DPCipherFactories AES_CBC] : [DPCipherFactories AES_XTS];
}

@end
