//
//  IMBIThmbFileListContainer.h
//  iMobieTrans
//
//  Created by Pallas on 1/7/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBBaseDatabaseElement.h"
#import "IMBIThmbFileList.h"

@interface IMBIThmbFileListContainer : IMBBaseDatabaseElement {
@private
    id _header;
    IMBIThmbFileList *_childSection;
}

@property (nonatomic, readonly) IMBIThmbFileList *fileList;

- (id)initWithParent:(id)parent;

@end
