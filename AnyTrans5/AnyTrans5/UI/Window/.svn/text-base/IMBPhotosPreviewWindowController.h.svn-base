//
//  IMBPhotosPreviewWindowController.h
//  iMobieTrans
//
//  Created by iMobie on 10/15/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBNextButton.h"
#import "IMBIKimageView.h"
#import "IMBPhotoEntity.h"
#import "IMBiPod.h"

@interface IMBPhotosPreviewWindowController : NSWindowController {
    IBOutlet NSView *_bgWhiteView;
    IBOutlet NSView *_loadingView;
    IBOutlet NSProgressIndicator *_loadingIndicator;
    IBOutlet NSView *_nextBtnView;

    IBOutlet IKImageView *  _imageView;
    
    NSOperationQueue *_processQueue;
    NSDictionary *_imageProperties;
    NSString *_imageUTType;
    
    NSSegmentedControl *_whirlBtn;
    NSSegmentedControl *_scalingBtn;
    NSSegmentedControl *_nextBtn;
    IMBPhotoEntity *_curPhotoEntity;
    IMBiPod *_iPod;
    NSArray *_photoArray;
    NSImage *_curPicture;
    NSData *_photoData;
    
    //msg image
    BOOL _isMsgImage;
}

- (id)initWithArray:(NSArray *)array withIpod:(IMBiPod *)iPod WithPhotoEntity:(IMBPhotoEntity *)entity ;
- (id)initWithPicture:(NSImage *)picture;

@end
