//
//  IMBiTunesFileExport.h
//  iMobieTrans
//
//  Created by zhang yang on 13-6-21.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import "IMBBaseTransfer.h"
//#import "IMBProgressCounter.h"

@interface IMBiTunesFileExport : IMBBaseTransfer

- (id)initWithExportTracks:(NSArray *)exportTracks exportFolder:(NSString *)exportFolder withDelegate:(id)delegate;

@end
