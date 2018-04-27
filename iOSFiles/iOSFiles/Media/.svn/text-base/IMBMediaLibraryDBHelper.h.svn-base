//
//  IMBMediaLibraryDBHelper.h
//  iMobieTrans
//
//  Created by iMobie on 5/15/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBiPod.h"
#import "FMDatabase.h"

@interface IMBMediaLibraryDBHelper : NSObject
{
    IMBiPod *_ipod;
    FMDatabase *_libraryConnection;
}


- (id)initWithIpod:(IMBiPod *)ipod;
- (BOOL)openDatabase;
- (void)closeDB;
- (void)readNewIosArtworkItems:(NSArray *)mediaTracks;
- (void)getArtWorkPathiOS9:(NSArray *)mediaTracks;
- (void)getArtWorkPathiOS8Point3:(NSArray *)mediaTracks;
- (NSArray *)readArtworkFromatsIDs;
- (NSString *)readTrackArtworkFileName:(long long)DBId;
- (void)disposable;
@end
