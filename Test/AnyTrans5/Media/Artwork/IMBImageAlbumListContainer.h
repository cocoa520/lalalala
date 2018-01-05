//
//  IMBImageAlbumListContainer.h
//  iMobieTrans
//
//  Created by Pallas on 1/7/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBBaseDatabaseElement.h"
#import "IMBImageAlbumList.h"

@interface IMBImageAlbumListContainer : IMBBaseDatabaseElement {
@private
    id _header;
    IMBImageAlbumList *_childSection;
}

@property (nonatomic, readonly) IMBImageAlbumList *imageAlbumList;

- (id)initWithParent:(id)parent;

@end
