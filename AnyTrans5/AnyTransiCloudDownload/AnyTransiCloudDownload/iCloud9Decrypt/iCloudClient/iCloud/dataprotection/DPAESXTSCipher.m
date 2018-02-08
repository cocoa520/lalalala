//
//  DPAESXTSCipher.m
//  
//
//  Created by Pallas on 8/26/16.
//
//  Complete

#import "DPAESXTSCipher.h"
#import "Arrays.h"
#import "DPAESXTSCipher.h"
#import "Pack.h"

@implementation DPAESXTSCipher

+ (NSMutableData*)tweakFunction:(int64_t)tweakValue {
    NSMutableData *bs = [Pack Int64_To_LE:tweakValue];
    return [Arrays concatenateWithByteArray:bs withB:bs];
}

+ (int)BLOCK_SIZE {
    return 4096;
}

- (id)initWithBlockSize:(int)blockSize {
    if (self = [super initWithClazz:[DPAESXTSCipher class] withSelector:@selector(tweakFunction:) withDataUnitSize:blockSize]) {
        return self;
    } else {
        return nil;
    }
}

- (id)init {
    if (self = [self initWithBlockSize:[DPAESXTSCipher BLOCK_SIZE]]) {
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

@end
