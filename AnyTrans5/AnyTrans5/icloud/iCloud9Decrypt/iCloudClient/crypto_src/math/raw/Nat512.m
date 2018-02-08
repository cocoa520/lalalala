//
//  Nat512.m
//  
//
//  Created by Pallas on 5/26/16.
//
//  Complete

#import "Nat512.h"
#import "Nat256.h"
#import "Nat.h"

@implementation Nat512

// NSMutableArray == uint[]
+ (void)mul:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        [Nat256 mul:x withY:y withZZ:zz];
        [Nat256 mul:x withXoff:8 withY:y withYoff:8 withZZ:zz withZZoff:16];
        
        uint c24 = [Nat256 addToEachOther:zz withUoff:8 withV:zz withVoff:16];
        uint c16 = c24 + [Nat256 addTo:zz withXoff:0 withZ:zz withZoff:8 withCin:0];
        c24 += [Nat256 addTo:zz withXoff:24 withZ:zz withZoff:16 withCin:c16];
        
        NSMutableArray *dx = [Nat256 create], *dy = [Nat256 create];
        BOOL neg = [Nat256 diff:x withXoff:8 withY:x withYoff:0 withZ:dx withZoff:0] != [Nat256 diff:y withXoff:8 withY:y withYoff:0 withZ:dy withZoff:0];
        
        NSMutableArray *tt = [Nat256 createExt];
        [Nat256 mul:dx withY:dy withZZ:tt];
        
        c24 += neg ? [Nat addTo:16 withX:tt withXoff:0 withZ:zz withZoff:8] : (uint)[Nat subFrom:16 withX:tt withXoff:0 withZ:zz withZoff:8];
        [Nat addWordAt:32 withX:c24 withZ:zz withZpos:24];
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
        [Nat256 square:x withZZ:zz];
        [Nat256 square:x withXoff:8 withZZ:zz withZZoff:16];
        
        uint c24 = [Nat256 addToEachOther:zz withUoff:8 withV:zz withVoff:16];
        uint c16 = c24 + [Nat256 addTo:zz withXoff:0 withZ:zz withZoff:8 withCin:0];
        c24 += [Nat256 addTo:zz withXoff:24 withZ:zz withZoff:16 withCin:c16];
        
        NSMutableArray *dx = [Nat256 create];
        [Nat256 diff:x withXoff:8 withY:x withYoff:0 withZ:dx withZoff:0];
        
        NSMutableArray *m = [Nat256 createExt];
        [Nat256 square:dx withZZ:m];
        
        c24 += (uint)[Nat subFrom:16 withX:m withXoff:0 withZ:zz withZoff:8];
        [Nat addWordAt:32 withX:c24 withZ:zz withZpos:24];
#if !__has_feature(objc_arc)
        if (dx) [dx release]; dx = nil;
        if (m) [m release]; m = nil;
#endif
    }
}

@end
