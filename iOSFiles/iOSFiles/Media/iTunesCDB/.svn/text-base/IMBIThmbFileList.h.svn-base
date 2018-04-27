//
//  IMBIThmbFileList.h
//  iMobieTrans
//
//  Created by Pallas on 1/7/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBBaseDatabaseElement.h"
#import "IMBIPodImageFormat.h"
#import "IMBIThmbFile.h"

@interface IMBIThmbFileList : IMBBaseDatabaseElement {
@private
    //保存IThmbFile对象
    NSMutableArray *_childSections;
}

@property (nonatomic, readonly) NSMutableArray *files;

- (void)addIThmbFile:(IMBIPodImageFormat*)format;
- (NSMutableArray*)getIThmbFiles;

@end
