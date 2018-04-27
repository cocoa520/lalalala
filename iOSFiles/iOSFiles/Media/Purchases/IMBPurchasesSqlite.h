//
//  IMBPurchasesSqlite.h
//  iMobieTrans
//
//  Created by zhang yang on 13-7-14.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBiPod.h"
#import "FMDatabase.h"

@interface IMBPurchasesSqlite : NSObject {
        IMBiPod *_iPod;
        NSString *_localLibraryFile, *_localLibrarySHMFile, *_localLibraryWALFile;
        NSFileManager *fileManager;
        FMDatabase *_libraryConnection;
}

- (id)initWithiPod:(IMBiPod *)iPod;
- (NSMutableArray*) getPurchasesTrackList;
//-(void) getInfoFromDirtyTracks;
- (void)closeDataBase;
//- (bool) isExistPlaylist:(IMBPlaylist*)pl;
//- (void) generateDeleteTracksInfo;

@end
