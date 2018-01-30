//
//  IMBooksHelperEntry.m
//  iMobieTrans
//
//  Created by apple on 9/11/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBBooksHelperEntry.h"

@implementation IMBBooksInfoEntry

@synthesize ibookFilePath = _ibookFilePath;
@synthesize ibookLocalPath = _ibookLocalPath;
@synthesize ibookFileName = _ibookFileName;
@synthesize ibookCategory = _ibookCategory;
@synthesize trackID = _trackID;
@synthesize basicInfo = _basicInfo;

@end

@implementation IMBEpubBookInfo
@synthesize extractFolderPath = _extractFolderPath;
@synthesize epubLocalPath = _epubLocalPath;
@synthesize bookName = _bookName;
@synthesize uniqueId = _uniqueId;

@end
