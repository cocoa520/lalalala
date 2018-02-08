//
//  IMBImageListContainer.h
//  iMobieTrans
//
//  Created by Pallas on 1/7/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBBaseDatabaseElement.h"
#import "IMBImageList.h"

@interface IMBImageListContainer : IMBBaseDatabaseElement {
@private
    id _header;
    IMBImageList *_childSection;
}

@property (nonatomic, readonly) IMBImageList *imageList;

- (id)initWithParent:(id)parent;

@end
