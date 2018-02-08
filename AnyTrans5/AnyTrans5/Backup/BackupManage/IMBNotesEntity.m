//
//  IMBNotesBindingEntity.m
//  PhoneClean3.0
//
//  Created by Pallas on 8/19/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBNotesEntity.h"
//#import "IMBHelper.h"
#import "DateHelper.h"
@implementation IMBNotesEntity
@synthesize noteKey = _noteKey;
@synthesize title = _title;
@synthesize author = _author;
@synthesize createDate = _createDate;
@synthesize modifyDate = _modifyDate;
@synthesize content = _content;
@synthesize contentType = _contentType;
@synthesize subject = _subject;
@synthesize isNew = _isNew;

- (NSString *)description {
    NSString *str = [NSString stringWithFormat:@"************************************\ntitle:%@\ncontent:\n%@\n************************************\n",_title,_content];
    return str;
}

- (NSString *)descriptionByCSV {
    NSString *str = [NSString stringWithFormat:@"%@,%@,%@\n",_title,[DateHelper dateFrom2001ToString:_createDate withMode:0],_content];
    return str;
}

- (NSString *)descriptionByCSV1 {
    NSString *str = [NSString stringWithFormat:@"Title,Create Date,Notes\n%@,%@,%@\n",_title,[DateHelper dateFrom2001ToString:_createDate withMode:0],_content];
    return str;
}


@end
