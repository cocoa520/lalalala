//
//  IMBBackupExplorerExport.h
//  AnyTrans
//
//  Created by iMobie on 8/6/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import "IMBBaseTransfer.h"
#import "IMBBackupDecryptAbove4.h"

@interface IMBBackupExplorerExport : IMBBaseTransfer {
    IMBBackupDecryptAbove4 *_backUpDecrypt;
    NSString *_backupPath;
}

- (id)initWithPath:(NSString *)exportPath exportTracks:(NSArray *)exportTracks withDelegate:(id)delegate backupPath:(NSString *)backupPath backUpDecrypt:(IMBBackupDecryptAbove4 *)backUpDecrypt;

@end
