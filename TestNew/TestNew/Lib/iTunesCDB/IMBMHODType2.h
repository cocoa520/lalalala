//
//  IMBMHODType2.h
//  iMobieTrans
//
//  Created by Pallas on 1/8/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBBaseMHODElement.h"
#import "IMBIPodImageFormat.h"
#import "IMBSupportedArtworkFormat.h"

@interface IMBMHODType2 : IMBBaseMHODElement {
@private
    IMBIPodImageFormat *_childElement;
}

- (IMBIPodImageFormat*)getArtworkFormat;
- (void)create:(IMBiPod*)ipod format:(IMBSupportedArtworkFormat*)format imageData:(NSData*)imageData;

@end
