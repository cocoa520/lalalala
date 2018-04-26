//
//  IMBArtworkEntity.h
//  iMobieTrans
//
//  Created by iMobie on 5/15/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMBArtworkEntity : NSObject
{
    NSString *_formatType;
    NSString *_filePath;
    NSString *_localFilePath;
}
@property (nonatomic,retain) NSString *formatType;
@property (nonatomic,retain) NSString *filePath;
@property (nonatomic,retain) NSString *localFilepath;
@end
