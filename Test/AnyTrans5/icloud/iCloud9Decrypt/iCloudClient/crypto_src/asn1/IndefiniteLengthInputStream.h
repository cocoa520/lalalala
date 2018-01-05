//
//  IndefiniteLengthInputStream.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "LimitedInputStream.h"

@interface IndefiniteLengthInputStream : LimitedInputStream {
@private
    int _b1;
    int _b2;
    BOOL _eofReached;
    BOOL _eofOn00;
}

- (instancetype)initParamInputStream:(Stream *)paramInputStream paramInt:(int)paramInt;
- (void)setEofOn00:(BOOL)paramBoolean;
- (int)readParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramInt1:(int)paramInt1 paramInt2:(int)paramInt2;
- (int)read;

@end
