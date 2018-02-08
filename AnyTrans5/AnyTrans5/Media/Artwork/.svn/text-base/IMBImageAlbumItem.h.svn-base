//
//  IMBImageAlbumItem.h
//  iMobieTrans
//
//  Created by Pallas on 1/7/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBBaseDatabaseElement.h"
#import "IMBIPodImage.h"

@interface IMBImageAlbumItem : IMBBaseDatabaseElement {
@private
    int _unk1;
    //存储的是IMBBaseMHODElement对象
    NSMutableArray *_dataObjects;
    //存储的是IMBImageAlbum对象
    NSMutableArray *_image;
    
    uint _imageID;
    IMBIPodImage *_artwork;
}

@property (nonatomic, readwrite) uint imageID;
@property (nonatomic, readwrite, retain) IMBIPodImage *artwork;

@end
