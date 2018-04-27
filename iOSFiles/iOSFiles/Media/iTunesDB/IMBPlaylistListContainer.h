//
//  IMBPlaylistListContainer.h
//  MediaTrans
//
//  Created by Pallas on 12/20/12.
//  Copyright (c) 2012 iMobie. All rights reserved.
//

#import "IMBBaseDatabaseElement.h"
#import "IMBPlaylistList.h"

@interface IMBPlaylistListContainer : IMBBaseDatabaseElement{
@private
    id _header;
    IMBPlaylistList *_childSection;
}

-(id)initWithParent:(id)parent;
-(IMBPlaylistList*)getPlaylistList;

@end
