//
//  IMBIOS5Sqlite.h
//  iMobieTrans
//
//  Created by Pallas on 1/18/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBPCSqliteTables.h"

@interface IMBIOS5Sqlite : IMBPCSqliteTables {
@protected
    NSString *_localLibraryFile, *_localLibrarySHMFile, *_localLibraryWALFile;
    NSFileManager *fileManager;
    NSMutableArray *_entryList;
}

- (id)initWithIPod:(IMBiPod *)ipod;

@end
