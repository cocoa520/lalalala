//
//  IMBADGallery.h
//  
//
//  Created by ding ming on 17/3/17.
//
//

#import "IMBBaseCommunicate.h"
#import "IMBADPhotoEntity.h"

@interface IMBADGallery : IMBBaseCommunicate {
//    IMBAudioTrack *_deviceInfo;
}

- (BOOL)queryThumbnailContent:(IMBADPhotoEntity *)photoEntity;

@end
