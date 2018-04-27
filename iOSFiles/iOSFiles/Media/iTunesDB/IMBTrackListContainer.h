//
//  IMBTrackListContainer.h
//  MediaTrans
//
//  Created by Pallas on 12/16/12.
//  Copyright (c) 2012 iMobie. All rights reserved.
//

#import "IMBBaseDatabaseElement.h"
#import "IMBTracklist.h"

@interface IMBTrackListContainer : IMBBaseDatabaseElement{
@private
    id _header;
    IMBTracklist *_childSection;
}

-(id)initWithParent:(id)parent;
-(IMBTracklist*)getTracklist;

@end
