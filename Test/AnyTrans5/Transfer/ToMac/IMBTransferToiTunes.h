//
//  IMBTransferToiTunes.h
//  AnyTrans
//
//  Created by iMobie on 8/12/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import "IMBBaseTransfer.h"
#import "IMBInformation.h"
#import "IMBInformationManager.h"

@interface IMBTransferToiTunes : IMBBaseTransfer {
    NSDictionary *_exportDic;
    NSMutableDictionary *_addItemDic;
    int _addCount;
    IMBInformation *_infoMation;
}

- (id)initWithIPodkey:(NSString *)ipodKey exportDic:(NSDictionary *)exportDic withDelegate:(id)delegate;

- (void)sendItemProgressToView:(NSString *)name;

@end
