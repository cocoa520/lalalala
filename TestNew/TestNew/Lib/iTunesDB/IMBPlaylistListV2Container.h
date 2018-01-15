//
//  IMBPlaylistListV2Container.h
//  MediaTrans
//
//  Created by Pallas on 12/21/12.
//  Copyright (c) 2012 iMobie. All rights reserved.
//

#import "IMBBaseDatabaseElement.h"
#import "IMBPlaylistList.h"

@interface IMBPlaylistListV2Container : IMBBaseDatabaseElement {
@private
    id _header;
    IMBPlaylistList *_childSection;
}

-(id)initWithParent:(id)parent;
-(IMBPlaylistList*)getPlaylistList;

@end
