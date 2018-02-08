//
//  Mod.m
//  
//
//  Created by Pallas on 5/10/16.
//
// Complete

#import "Mod.h"
#import "BigInteger.h"
#import "CategoryExtend.h"
#import "Nat.h"
#import "Pack.h"

@implementation Mod

// p, x, z == uint[]
+ (void)invert:(NSMutableArray*)p withX:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        int len = (int)(p.count);
        if ([Nat isZero:len withX:x]) {
            @throw [NSException exceptionWithName:@"Argument" reason:@"x cannot be 0" userInfo:nil];
        }
        
        if ([Nat isOne:len withX:x]) {
            [z copyFromIndex:0 withSource:x withSourceIndex:0 withLength:len];
            return;
        }
        
        // NSMutableArray == uint[]
        NSMutableArray *u = [Nat copy:len withX:x];
        NSMutableArray *a = [Nat create:len];
        a[0] = @((uint)1);
        int ac = 0;
        
        if (([u[0] unsignedIntValue] & 1) == 0) {
            [Mod inversionStep:p withU:u withUlen:len withX:a withXc:&ac];
        }
        if ([Nat isOne:len withX:u]) {
            [Mod inversionResult:p withAc:ac withA:a withZ:z];
#if !__has_feature(objc_arc)
            if (a) [a release]; a = nil;
#endif
            return;
        }
        
        // NSMutableArray == uint[]
        NSMutableArray *v = [Nat copy:len withX:p];
        NSMutableArray *b = [Nat create:len];
        int bc = 0;
        
        int uvLen = len;
        
        for (;;) {
            while ([u[uvLen - 1] unsignedIntValue] == 0 && [v[uvLen - 1] unsignedIntValue] == 0) {
                --uvLen;
            }
            
            if ([Nat gte:len withX:u withY:v]) {
                [Nat subFrom:len withX:v withZ:u];
                ac += [Nat subFrom:len withX:b withZ:a] - bc;
                [Mod inversionStep:p withU:u withUlen:uvLen withX:a withXc:&ac];
                if ([Nat isOne:len withX:u]) {
                    [Mod inversionResult:p withAc:ac withA:a withZ:z];
#if !__has_feature(objc_arc)
                    if (a) [a release]; a = nil;
                    if (b) [b release]; b = nil;
#endif
                    return;
                }
            } else {
                [Nat subFrom:len withX:u withZ:v];
                bc += [Nat subFrom:len withX:a withZ:b] - ac;
                [Mod inversionStep:p withU:v withUlen:uvLen withX:b withXc:&bc];
                if ([Nat isOne:len withX:v]) {
                    [Mod inversionResult:p withAc:bc withA:b withZ:z];
#if !__has_feature(objc_arc)
                    if (a) [a release]; a = nil;
                    if (b) [b release]; b = nil;
#endif
                    return;
                }
            }
        }
#if !__has_feature(objc_arc)
        if (a) [a release]; a = nil;
        if (b) [b release]; b = nil;
#endif
    }
}

// return == uint[], p == uint[]
+ (NSMutableArray*)random:(NSMutableArray*)p {
    int len = (int)(p.count);
    // NSMutableArray ==  uint[]
    NSMutableArray *s = [Nat create:len];
    
    uint m = [p[len - 1] unsignedIntValue];
    m |= m >> 1;
    m |= m >> 2;
    m |= m >> 4;
    m |= m >> 8;
    m |= m >> 16;
    
    @autoreleasepool {
        do {
            NSMutableData *bytes = [NSMutableData nextBytes:(len << 2)];
            [Pack BE_To_UInt32:bytes withOff:0 withNs:s];
            s[len - 1] = @((uint)([s[len - 1] unsignedIntValue] & m));
        } while ([Nat gte:len withX:s withY:p]);
    }
    
    return [s autorelease];
}

// p, x, y, z == uint[]
+ (void)add:(NSMutableArray*)p withX:(NSMutableArray *)x withY:(NSMutableArray *)y withZ:(NSMutableArray *)z {
    @autoreleasepool {
        int len = (int)(p.count);
        uint c = [Nat add:len withX:x withY:y withZ:z];
        if (c != 0) {
            [Nat subFrom:len withX:p withZ:z];
        }
    }
}

// p, x, y, z == uint[]
+ (void)subtract:(NSMutableArray*)p withX:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    @autoreleasepool {
        int len = (int)(p.count);
        int c = [Nat sub:len withX:x withY:y withZ:z];
        if (c != 0) {
            [Nat addTo:len withX:p withZ:z];
        }
    }
}

// p, a, z == uint[]
+ (void)inversionResult:(NSMutableArray*)p withAc:(int)ac withA:(NSMutableArray*)a withZ:(NSMutableArray*)z {
    @autoreleasepool {
        if (ac < 0) {
            [Nat add:(int)(p.count) withX:a withY:p withZ:z];
        } else {
            [z copyFromIndex:0 withSource:a withSourceIndex:0 withLength:(int)(p.count)];
        }
    }
}

// p, u, x == uint[]
+ (void)inversionStep:(NSMutableArray*)p withU:(NSMutableArray*)u withUlen:(int)uLen withX:(NSMutableArray*)x withXc:(int*)xc {
    @autoreleasepool {
        int len = (int)(p.count);
        int count = 0;
        while ([u[0] unsignedIntValue] == 0) {
            [Nat shiftDownWord:uLen withZ:u withC:0];
            count += 32;
        }
        
        {
            int zeroes = [Mod getTrailingZeroes:[u[0] unsignedIntValue]];
            if (zeroes > 0) {
                [Nat shiftDownBits:uLen withZ:u withBits:zeroes withC:0];
                count += zeroes;
            }
        }
        
        for (int i = 0; i < count; ++i) {
            if (([x[0] unsignedIntValue] & 1) != 0) {
                if (*xc < 0) {
                    *xc += (int)[Nat addTo:len withX:p withZ:x];
                } else {
                    *xc += [Nat subFrom:len withX:p withZ:x];
                }
            }
            [Nat shiftDownBit:len withZ:x withC:(uint)(*xc)];
        }
    }
}

+ (int)getTrailingZeroes:(uint)x {
    int count = 0;
    while ((x & 1) == 0) {
        x >>= 1;
        ++count;
    }
    return count;
}

@end
