//
//  FixedPointUtilities.m
//  
//
//  Created by Pallas on 5/13/16.
//
//  Complete

#import "FixedPointUtilities.h"
#import "ECCurve.h"
#import "BigInteger.h"
#import "ECPoint.h"
#import "FixedPointPreCompInfo.h"
#import "CategoryExtend.h"

@implementation FixedPointUtilities

+ (NSString*)PRECOMP_NAME {
    static NSString *_precomp_name = nil;
    @synchronized(self) {
        if (_precomp_name == nil) {
            _precomp_name = [[NSString alloc] initWithString:@"bc_fixed_point"];
        }
    }
    return _precomp_name;
}

+ (int)getCombSize:(ECCurve*)c {
    BigInteger *order = [c order];
    return order == nil ? [c fieldSize] + 1 : [order bitLength];
}

+ (FixedPointPreCompInfo*)getFixedPointPreCompInfo:(PreCompInfo*)preCompInfo {
    if (preCompInfo != nil && [preCompInfo isKindOfClass:[FixedPointPreCompInfo class]]) {
        return (FixedPointPreCompInfo*)preCompInfo;
    }
    
    return [[[FixedPointPreCompInfo alloc] init] autorelease];
}

+ (FixedPointPreCompInfo*)precompute:(ECPoint*)p withMinWidth:(int)minWidth {
    ECCurve *c = [p curve];
    
    int n = 1 << minWidth;
    FixedPointPreCompInfo *info = nil;
    @autoreleasepool {
        info = [FixedPointUtilities getFixedPointPreCompInfo:[c getPreCompInfo:p withName:[FixedPointUtilities PRECOMP_NAME]]];
        // lookupTable == ECPoint[]
        NSMutableArray *lookupTable = [info preComp];
        
        if (lookupTable == nil || [lookupTable count] < n) {
            int bits = [FixedPointUtilities getCombSize:c];
            int d = (bits + minWidth - 1) / minWidth;
            
            // pow2Table == ECPoint[]
            NSMutableArray *pow2Table = [[NSMutableArray alloc] initWithSize:minWidth];
            pow2Table[0] = p;
            for (int i = 1; i < minWidth; ++i) {
                pow2Table[i] = [pow2Table[i - 1] timesPow2:d];
            }
            
            [c normalizeAll:pow2Table];
            
            lookupTable = [[NSMutableArray alloc] initWithSize:n];
            lookupTable[0] = [c infinity];
            
            for (int bit = minWidth - 1; bit >= 0; --bit) {
                ECPoint *pow2 = pow2Table[bit];
                
                int step = 1 << bit;
                for (int i = step; i < n; i += (step << 1)) {
                    lookupTable[i] = [((ECPoint*)lookupTable[i - step]) add:pow2];
                }
            }
            
            [c normalizeAll:lookupTable];
            
            [info setPreComp:lookupTable];
            [info setWidth:minWidth];
            
            [c setPreCompInfo:p withName:[FixedPointUtilities PRECOMP_NAME] withPreCompInfo:info];
#if !__has_feature(objc_arc)
            if (lookupTable != nil) [lookupTable release]; lookupTable = nil;
            if (pow2Table != nil) [pow2Table release]; pow2Table = nil;
#endif
        }
        
        [info retain];
    }
    
    return (info ? [info autorelease] : nil);
}

@end
