//
//  Nat384.m
//  
//
//  Created by Pallas on 5/26/16.
//
//  Complete

#import "Nat384.h"
#import "Nat192.h"
#import "Nat.h"

@implementation Nat384

// NSMutableArray == uint[]
+ (void)mul:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        [Nat192 mul:x withY:y withZZ:zz];
        [Nat192 mul:x withXoff:6 withY:y withYoff:6 withZZ:zz withZZoff:12];
        
        uint c18 = [Nat192 addToEachOther:zz withUoff:6 withV:zz withVoff:12];
        uint c12 = c18 + [Nat192 addTo:zz withXoff:0 withZ:zz withZoff:6 withCin:0];
        c18 += [Nat192 addTo:zz withXoff:18 withZ:zz withZoff:12 withCin:c12];
        
        NSMutableArray *dx = [Nat192 create], *dy = [Nat192 create];
        BOOL neg = [Nat192 diff:x withXoff:6 withY:x withYoff:0 withZ:dx withZoff:0] != [Nat192 diff:y withXoff:6 withY:y withYoff:0 withZ:dy withZoff:0];
        
        NSMutableArray *tt = [Nat192 createExt];
        [Nat192 mul:dx withY:dy withZZ:tt];
        
        c18 += neg ? [Nat addTo:12 withX:tt withXoff:0 withZ:zz withZoff:6] : (uint)[Nat subFrom:12 withX:tt withXoff:0 withZ:zz withZoff:6];
        [Nat addWordAt:24 withX:c18 withZ:zz withZpos:18];
#if !__has_feature(objc_arc)
        if (dx) [dx release]; dx = nil;
        if (dy) [dy release]; dy = nil;
        if (tt) [tt release]; tt = nil;
#endif
    }
}

// NSMutableArray == uint[]
+ (void)square:(NSMutableArray*)x withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        [Nat192 square:x withZZ:zz];
        [Nat192 square:x withXoff:6 withZZ:zz withZZoff:12];
        
        uint c18 = [Nat192 addToEachOther:zz withUoff:6 withV:zz withVoff:12];
        uint c12 = c18 + [Nat192 addTo:zz withXoff:0 withZ:zz withZoff:6 withCin:0];
        c18 += [Nat192 addTo:zz withXoff:18 withZ:zz withZoff:12 withCin:c12];
        
        NSMutableArray *dx = [Nat192 create];
        [Nat192 diff:x withXoff:6 withY:x withYoff:0 withZ:dx withZoff:0];
        
        NSMutableArray *m = [Nat192 createExt];
        [Nat192 square:dx withZZ:m];
        
        c18 += (uint)[Nat subFrom:12 withX:m withXoff:0 withZ:zz withZoff:6];
        [Nat addWordAt:24 withX:c18 withZ:zz withZpos:18];
#if !__has_feature(objc_arc)
        if (dx) [dx release]; dx = nil;
        if (m) [m release]; m = nil;
#endif
    }
}

@end
