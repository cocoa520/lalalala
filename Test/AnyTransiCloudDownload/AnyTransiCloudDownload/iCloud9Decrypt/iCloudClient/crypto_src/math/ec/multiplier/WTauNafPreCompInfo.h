//
//  WTauNafPreCompInfo.h
//  
//
//  Created by Pallas on 5/13/16.
//
//  Complete

#import "PreCompInfo.h"

@interface WTauNafPreCompInfo : PreCompInfo {
@protected
    /**
     * Array holding the precomputed <code>AbstractF2mPoint</code>s used for the
     * WTNAF multiplication in <code>
     * {@link org.bouncycastle.math.ec.multiplier.WTauNafMultiplier.multiply()
     * WTauNafMultiplier.multiply()}</code>.
     */
    NSMutableArray *                    _m_preComp; // NSMutableArray == AbstractF2mPoint[];
}


// NSMutableArray == AbstractF2mPoint[]
- (NSMutableArray*)preComp;
- (void)setPreComp:(NSMutableArray*)preComp;

@end
