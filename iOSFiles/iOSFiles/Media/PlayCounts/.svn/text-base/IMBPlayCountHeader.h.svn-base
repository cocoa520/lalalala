//
//  IMBPlayCountHeader.h
//  iMobieTrans
//
//  Created by Pallas on 1/15/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBBaseDatabaseElement.h"

@interface IMBPlayCountHeader : IMBBaseDatabaseElement {
    int _entrySize;
    int _nbrEntries;
    //保存的是IMBPlayCountEntry对象
    NSMutableArray *_entries;
}

@property (nonatomic, readonly) int entryCount;
- (void)readPlist:(IMBiPod*)ipod playCountsPath:(NSString*)playCountsPath;

- (NSEnumerator*)entries;

@end
