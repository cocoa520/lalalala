//
//  IMBIPodImage.h
//  iMobieTrans
//
//  Created by Pallas on 1/7/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBBaseDatabaseElement.h"
#import "IMBTrack.h"
#import "IMBMHODType2.h"
#import "IMBIPodImageFormat.h"

@interface IMBIPodImage : IMBBaseDatabaseElement {
@private
    //保存MHODType2对象
    NSMutableArray *_formatElements;
    //保存BaseMHODElement对象
    NSMutableArray *_allElements;
    //保存的是IMBIPodImageFormat对象
    NSMutableArray *_formatsArray;
    uint _iD;
    int64_t _trackDBID;
    
    uint _usedCount;
    uint _unk1, _unk2, _unk3, _unk4, _unk5, _unk6, _unk7, _originalImageSize;
}

@property (nonatomic, readonly) uint iD;
@property (nonatomic, readonly) int64_t trackDBID;
@property (nonatomic, readwrite) uint usedCount;
@property (nonatomic, readonly) uint originalImageSize;

// NSmutableArray保存的是IMBIPodImageFormat对象
- (NSMutableArray*)getFormats;
- (void)setIsPhotoFormat:(BOOL)isPhotoFormat;
- (IMBIPodImageFormat*)getSmallestFormat;
- (IMBIPodImageFormat*)getLargestFormat;
- (void)create:(IMBiPod*)ipod track:(IMBTrack*)track image:(NSImage*)image;
- (void)update:(NSImage*)image;
- (int)formatsCount;

@end
