//
//  IMBMenuIndexMHOD.h
//  MediaTrans
//
//  Created by Pallas on 12/17/12.
//  Copyright (c) 2012 iMobie. All rights reserved.
//

#import "IMBBaseMHODElement.h"

typedef enum MenuIndexType{
    Title = 3,
    Album_Track_Title = 4,
    Artist_Album_Track_Title = 5,
    Genre_Artist_Album_Track_Title = 7
}MenuIndexTypeEnum;

@interface IMBMenuIndexMHOD : IMBBaseMHODElement{
    int _indexType;
    Byte *_padding;
    int paddingLength;
    NSMutableArray *_indexes;
}

@property (nonatomic,readonly) int indexType;

-(id)initWithIndexType:(MenuIndexTypeEnum)indexType;

@end
