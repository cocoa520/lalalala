//
//  WTauNafMultiplier.m
//  
//
//  Created by Pallas on 5/13/16.
//
//  Complete

#import "WTauNafMultiplier.h"
#import "CategoryExtend.h"
#import "ECCurve.h"
#import "ECPoint.h"
#import "ECFieldElement.h"
#import "BigInteger.h"
#import "Tnaf.h"
#import "PreCompInfo.h"
#import "WTauNafPreCompInfo.h"

@implementation WTauNafMultiplier

// TODO Create WTauNafUtilities class and move various functionality into it
+ (NSString*)PRECOMP_NAME {
    static NSString *_precomp_name = nil;
    @synchronized(self) {
        if (_precomp_name == nil) {
            _precomp_name = [[NSString alloc] initWithString:@"bc_wtnaf"];
        }
    }
    return _precomp_name;
}

/**
 * Multiplies a {@link org.bouncycastle.math.ec.AbstractF2mPoint AbstractF2mPoint}
 * by <code>k</code> using the reduced <code>&#964;</code>-adic NAF (RTNAF)
 * method.
 * @param p The AbstractF2mPoint to multiply.
 * @param k The integer by which to multiply <code>k</code>.
 * @return <code>p</code> multiplied by <code>k</code>.
 */
- (ECPoint*)multiplyPositive:(ECPoint*)point withK:(BigInteger*)k {
    if (point == nil || ![point isKindOfClass:[AbstractF2mPoint class]]) {
        @throw [NSException exceptionWithName:@"Argument" reason:@"Only AbstractF2mPoint can be used in WTauNafMultiplier" userInfo:nil];
    }
    
    ECPoint *retPoint = nil;
    @autoreleasepool {
        AbstractF2mPoint *p = (AbstractF2mPoint*)point;
        AbstractF2mCurve *curve = (AbstractF2mCurve*)[p curve];
        int m = [curve fieldSize];
        int8_t a = (int8_t)[[[curve a] toBigInteger] intValue];
        int8_t mu = [Tnaf getMuWithInt:a];
        // NSMutableArray == BigInteger[]
        NSMutableArray *s = [curve getSi];
        
        ZTauElement *rho = [Tnaf partModReduction:k withM:m withA:a withS:s withMu:mu withC:(int8_t)10];
        
        retPoint = [self multiplyWTnaf:p withLambda:rho withPreCompInfo:[curve getPreCompInfo:p withName:[WTauNafMultiplier PRECOMP_NAME]] withA:a withMu:mu];
        [retPoint retain];
    }
    return (retPoint ? [retPoint autorelease] : nil);
}

/**
 * Multiplies a {@link org.bouncycastle.math.ec.AbstractF2mPoint AbstractF2mPoint}
 * by an element <code>&#955;</code> of <code><b>Z</b>[&#964;]</code> using
 * the <code>&#964;</code>-adic NAF (TNAF) method.
 * @param p The AbstractF2mPoint to multiply.
 * @param lambda The element <code>&#955;</code> of
 * <code><b>Z</b>[&#964;]</code> of which to compute the
 * <code>[&#964;]</code>-adic NAF.
 * @return <code>p</code> multiplied by <code>&#955;</code>.
 */
- (AbstractF2mPoint*)multiplyWTnaf:(AbstractF2mPoint*)p withLambda:(ZTauElement*)lambda withPreCompInfo:(PreCompInfo*)preCompInfo withA:(int8_t)a withMu:(int8_t)mu {
    AbstractF2mPoint *retVal = nil;
    @autoreleasepool {
        // NSArray == ZTauElement[]
        NSArray *alpha = (a == 0) ? [Tnaf Alpha0] : [Tnaf Alpha1];
        
        BigInteger *tw = [Tnaf getTw:mu withW:[Tnaf Width]];
        
        // NSMutableArray == int8_t[]
        NSMutableArray *tmpArray = [alpha mutableCopy];
        NSMutableArray *u = [Tnaf tauAdicWNaf:mu withLambda:lambda withWidth:[Tnaf Width] withPow2w:[BigInteger valueOf:[Tnaf Pow2Width]] withTw:tw withAlpha:tmpArray];
#if !__has_feature(objc_arc)
        if (tmpArray) [tmpArray release]; tmpArray = nil;
#endif
        retVal = [WTauNafMultiplier multiplyFromWTnaf:p withU:u withPreCompInfo:preCompInfo];
        [retVal retain];
    }
    return (retVal ? [retVal autorelease] : nil);
}

/**
 * Multiplies a {@link org.bouncycastle.math.ec.AbstractF2mPoint AbstractF2mPoint}
 * by an element <code>&#955;</code> of <code><b>Z</b>[&#964;]</code>
 * using the window <code>&#964;</code>-adic NAF (TNAF) method, given the
 * WTNAF of <code>&#955;</code>.
 * @param p The AbstractF2mPoint to multiply.
 * @param u The the WTNAF of <code>&#955;</code>..
 * @return <code>&#955; * p</code>
 */
// NSMutableArray == int8_t[]
+ (AbstractF2mPoint*)multiplyFromWTnaf:(AbstractF2mPoint*)p withU:(NSMutableArray*)u withPreCompInfo:(PreCompInfo*)preCompInfo {
    AbstractF2mPoint *retVal = nil;
    @autoreleasepool {
        AbstractF2mCurve *curve = (AbstractF2mCurve*)[p curve];
        int8_t a = (int8_t)[[[curve a] toBigInteger] intValue];
        
        // NSMutableArray == AbstractF2mPoint[]
        NSMutableArray *pu;
        if ((preCompInfo == nil) || ![preCompInfo isKindOfClass:[WTauNafPreCompInfo class]]) {
            pu = [Tnaf getPreComp:p withA:a];
            
            WTauNafPreCompInfo *pre = [[WTauNafPreCompInfo alloc] init];
            [pre setPreComp:pu];
            [curve setPreCompInfo:p withName:[WTauNafMultiplier PRECOMP_NAME] withPreCompInfo:pre];
#if !__has_feature(objc_arc)
            if (pre != nil) [pre release]; pre = nil;
#endif
        } else {
            pu = [((WTauNafPreCompInfo*)preCompInfo) preComp];
        }
        
        // TODO Include negations in precomp (optionally) and use from here
        // NSMutableArray == AbstractF2mPoint[];
        NSMutableArray *puNeg = [[NSMutableArray alloc] initWithSize:(int)(pu.count)];
        for (int i = 0; i < pu.count; ++i) {
            puNeg[i] = (AbstractF2mPoint*)[pu[i] negate];
        }
        
        // q = infinity
        AbstractF2mPoint *q = (AbstractF2mPoint*)[[p curve] infinity];
        
        int tauCount = 0;
        for (int i = (int)(u.count - 1); i >= 0; i--) {
            ++tauCount;
            int ui = [u[i] charValue];
            if (ui != 0) {
                q = [q tauPow:tauCount];
                tauCount = 0;
                
                ECPoint *x = ui > 0 ? pu[ui >> 1] : puNeg[(-ui) >> 1];
                q = (AbstractF2mPoint*)[q add:x];
            }
        }
        if (tauCount > 0) {
            q = [q tauPow:tauCount];
        }
#if !__has_feature(objc_arc)
        if (puNeg != nil) [puNeg release]; puNeg = nil;
#endif
        retVal = q;
        [retVal retain];
    }
    return (retVal ? [retVal autorelease] : nil);
}

@end
