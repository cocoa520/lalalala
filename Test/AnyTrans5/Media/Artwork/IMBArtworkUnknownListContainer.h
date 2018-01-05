//
//  IMBArtworkUnknownListContainer.h
//  iMobieTrans
//
//  Created by Pallas on 1/7/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBBaseDatabaseElement.h"

@interface IMBArtworkUnknownListContainer : IMBBaseDatabaseElement {
@private
    id _header;
    Byte *_unk1;
    int unk1Length;
}

- (id)initWithParent:(id)parent;

@end
