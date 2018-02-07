//
//  IMBDeleteCameraRollPhotos.h
//  PhotoTrans
//
//  Created by iMobie on 11/22/13.
//  Copyright (c) 2013 iMobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ImageCaptureCore/ImageCaptureCore.h>
#import "IMBBaseDelete.h"
@interface IMBDeleteCameraRollPhotos : IMBBaseDelete<ICDeviceBrowserDelegate, ICCameraDeviceDelegate>{
    ICDeviceBrowser *mDeviceBrowser;
    ICDevice *mDevice;
    NSMutableArray *removePhotosArray;
    NSOperationQueue *_processQueue;
    BOOL _isDeleteComplete;
    int counts;
    IMBLogManager *logHandle;
}

@property (nonatomic, assign) BOOL isDeleteComplete;

-(id)initWithArray:(NSArray *)array withIpod:(IMBiPod *)ipod;
-(void)startDeviceBrowser;
- (void)deleteItem;
@end
