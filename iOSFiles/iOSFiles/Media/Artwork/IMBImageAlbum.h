//
//  IMBImageAlbum.h
//  iMobieTrans
//
//  Created by Pallas on 1/7/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBBaseDatabaseElement.h"
#import "IMBImageList.h"
#import "IMBImageAlbumItem.h"
#import "IMBBaseMHODElement.h"
#import "MediaHelper.h"

@interface IMBImageAlbum : IMBBaseDatabaseElement {
@private
    int _iD;
    //存储IMBBaseMHODElement对象
    NSMutableArray *_dataObjects;
    //存储ImageAlbumItem对象
    NSMutableArray *_albumItems;
    //存储IMBIPodImage对象
    NSMutableArray *_images;
}

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) int imageCount;
@property (nonatomic, readonly) NSMutableArray *images;

- (NSString*)title;

- (int)imageCount;

#pragma mark - 存储的是IMBIPodImage对象
- (NSMutableArray*)images;

- (void)resolveImages:(IMBImageList*)images;

@end
