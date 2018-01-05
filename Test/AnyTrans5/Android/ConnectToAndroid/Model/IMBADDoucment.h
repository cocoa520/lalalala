//
//  IMBADDoucment.h
//  PhoneRescue_Android
//
//  Created by iMobie on 4/13/17.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "IMBBaseCommunicate.h"
#import "IMBADFileEntity.h"
#import "IMBADPhotoEntity.h"
#import "DeviceInfo.h"

@interface IMBADDoucment : IMBBaseCommunicate {
    CategoryNodesEnum _category;
    IMBResultEntity *_moviesReslutEntity;
    IMBResultEntity *_musicReslutEntity;
    IMBResultEntity *_ibookReslutEntity;
    IMBResultEntity *_photoReslutEntity;
    IMBResultEntity *_compressedReslutEntity;
    BOOL _isDocument;
}
@property (nonatomic, readwrite) BOOL isDocument;
@property (nonatomic, readwrite) CategoryNodesEnum category;
@property (nonatomic, readwrite, retain) IMBResultEntity *moviesReslutEntity;
@property (nonatomic, readwrite, retain) IMBResultEntity *musicReslutEntity;
@property (nonatomic, readwrite, retain) IMBResultEntity *ibookReslutEntity;
@property (nonatomic, readwrite, retain) IMBResultEntity *photoReslutEntity;
@property (nonatomic, readwrite, retain) IMBResultEntity *compressedReslutEntity;

- (BOOL)queryThumbnailContentWithApp:(IMBADPhotoEntity *)appPhotoEntity;

@end
