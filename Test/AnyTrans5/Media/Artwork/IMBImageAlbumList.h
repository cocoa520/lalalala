//
//  IMBImageAlbumList.h
//  iMobieTrans
//
//  Created by Pallas on 1/7/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBBaseDatabaseElement.h"
#import "IMBImageList.h"
#import "IMBImageAlbum.h"

@interface IMBImageAlbumList : IMBBaseDatabaseElement {
@private
    // 保存的是IMBImageAlbum对象
    NSMutableArray *_childSections;
}

@property (nonatomic, readonly) NSMutableArray *albums;

- (void)resolveImages:(IMBImageList*)images;

@end
