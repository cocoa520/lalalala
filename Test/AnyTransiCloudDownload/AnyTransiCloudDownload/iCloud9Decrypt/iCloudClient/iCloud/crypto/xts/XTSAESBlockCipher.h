//
//  XTSAESBlockCipher.h
//  
//
//  Created by Pallas on 8/26/16.
//
//

#import "BlockCipher.h"

@class XTSCore;

@interface XTSAESBlockCipher : BlockCipher {
@private
    XTSCore *                               _core;
    int                                     _blockSize;
    int                                     _dataUnitSize;
    int64_t                                 _dataUnit;
    int                                     _index;
}

- (id)initWithClazz:(Class)clazz withSelector:(SEL)selector withDataUnitSize:(int)dataUnitSize;

@end
