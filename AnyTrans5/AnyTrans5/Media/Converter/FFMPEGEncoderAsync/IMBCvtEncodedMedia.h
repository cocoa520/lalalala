//
//  IMBCvtEncodedMedia.h
//  iMobieTrans
//
//  Created by zhang yang on 13-5-9.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMBCvtEncodedMedia : NSObject {
    bool _success;
    NSString* _sourceMediaPath;
    NSString* _encodedMediaPath;
    NSString* _thumbnailPath;
    NSString* _encodingLog;
}

@property (nonatomic, readwrite, retain) NSString* sourceMediaPath;
@property (nonatomic, readwrite, retain) NSString* encodedMediaPath;
@property (nonatomic, readwrite, retain) NSString* thumbnailPath;
@property (nonatomic, readwrite, retain) NSString* encodingLog;
@property (nonatomic, readwrite) bool success;




@end
