//
//  IMBSDEntry.h
//  iMobieTrans
//
//  Created by Pallas on 1/23/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBBaseDatabaseElement.h"

@class IMBTrack;

@interface IMBSDEntry : IMBBaseDatabaseElement {
@private
    int _entrySize;
    int _unk1;
    Byte *_unk2;
    int unk2Length;
    int _volume;
    int _unk3;
    NSString *_fileName;
    BOOL _shuffleFlag;
    BOOL _bookmarkFlag;
    Byte _unk4;
}

- (id)initWithTrack:(IMBTrack*)track;

@end
