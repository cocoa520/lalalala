//
//  IMBArtworkEntity.m
//  iMobieTrans
//
//  Created by iMobie on 5/15/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBArtworkEntity.h"

@implementation IMBArtworkEntity
@synthesize formatType = _formatType;
@synthesize filePath = _filePath;
@synthesize localFilepath = _localFilePath;

-(void)dealloc{
    if (_formatType != nil) {
        [_formatType release];
    }
    if (_filePath != nil) {
        [_filePath release];
    }
    if (_localFilePath) {
        [_localFilePath release];
        _localFilePath = nil;
    }
    [super dealloc];
}
@end
