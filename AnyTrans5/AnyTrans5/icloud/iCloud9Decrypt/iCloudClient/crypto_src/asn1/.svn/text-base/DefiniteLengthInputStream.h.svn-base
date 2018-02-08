//
//  DefiniteLengthInputStream.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "LimitedInputStream.h"
#import "CategoryExtend.h"

@interface DefiniteLengthInputStream : LimitedInputStream {
@private
    int _originalLength;
    int _remaining;
}

- (instancetype)initParamInputStream:(Stream *)paramInputStream paramInt:(int)paramInt;
- (int)getRemaining;
- (int)read;
- (int)readParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramInt1:(int)paramInt1 paramInt2:(int)paramInt2;
- (NSMutableData *)toByteArray;

@end
