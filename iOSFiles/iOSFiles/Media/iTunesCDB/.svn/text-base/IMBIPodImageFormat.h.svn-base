//
//  IMBIPodImageFormat.h
//  iMobieTrans
//
//  Created by Pallas on 1/7/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBBaseDatabaseElement.h"
#import "IMBArtworkStringMHOD.h"
#import "IMBSupportedArtworkFormat.h"

@interface IMBIPodImageFormat : IMBBaseDatabaseElement {
@private
    int _childCount, _unk1;
    BOOL _isPhoto;
    uint _formatID, _fileOffset, _imageSize, _iThmbBlockSize;
    uint16 _verticalPadding, _horizontalPadding, _height, _width;
    uint _computedWidth, _computedHeight;
    IMBArtworkStringMHOD *_childElement;
}

@property (nonatomic, readwrite) BOOL isPhoto;
@property (nonatomic, readwrite) uint fileOffset;
@property (nonatomic, readwrite) uint imageSize;
@property (nonatomic, readwrite) uint imageBlockSize;
@property (nonatomic, readonly) uint formatID;
@property (nonatomic, readonly) uint16 width;
@property (nonatomic, readonly) uint16 height;
@property (nonatomic, readonly) BOOL isFullResolution;

- (BOOL)isFullResolution;
- (NSString*)getFileName;

- (id)init:(BOOL)isPhotoFormat;
- (NSImage*)loadFromFile;
- (void)create:(IMBiPod*)ipod format:(IMBSupportedArtworkFormat*)format imageData:(NSData*)imageData;
- (void)updateImageData:(NSData*)imageData;

@end
