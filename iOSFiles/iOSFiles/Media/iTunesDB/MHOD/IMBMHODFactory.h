//
//  IMBMHODFactory.h
//  MediaTrans
//
//  Created by Pallas on 12/17/12.
//  Copyright (c) 2012 iMobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBBaseMHODElement.h"
#import "IMBUnknownMHOD.h"
#import "IMBUnicodeMHOD.h"
#import "IMBMenuIndexMHOD.h"
#import "IMBPlaylistPositionMHOD.h"

@interface IMBMHODFactory : NSObject

+(IMBBaseMHODElement*)readMHOD:(IMBiPod*)ipod reader:(NSData*)reader currPosition:(long*)currPosition;

@end
