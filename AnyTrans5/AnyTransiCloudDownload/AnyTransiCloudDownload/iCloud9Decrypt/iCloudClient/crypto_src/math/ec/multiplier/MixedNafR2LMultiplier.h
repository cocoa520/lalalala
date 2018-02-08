//
//  MixedNafR2LMultiplier.h
//  
//
//  Created by Pallas on 5/13/16.
//
//  Complete

#import "AbstractECMultiplier.h"

@class ECCurve;

@interface MixedNafR2LMultiplier : AbstractECMultiplier {
@protected
    int                         _additionCoord;
    int                         _doublingCoord;
}

- (int)additionCoord;
- (int)doublingCoord;

- (id)initWithAdditionCoord:(int)additionCoord withDoublingCoord:(int)doublingCoord;

- (ECCurve*)configureCurve:(ECCurve*)c withCoord:(int)coord;

@end
