//
//  IMBSDHeader.h
//  iMobieTrans
//
//  Created by Pallas on 1/23/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBBaseDatabaseElement.h"

@interface IMBSDHeader : IMBBaseDatabaseElement {
@private
    int _trackCount;
    Byte *_unk1;
    int unk1Length;
    Byte *_headerPadding;
    int headerPaddingLength;
}

- (id)initWithIPod:(IMBiPod*)ipod;

@end
