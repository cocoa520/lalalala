//
//  IMBAppExport.h
//  AnyTrans
//
//  Created by iMobie on 8/2/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import "IMBBaseTransfer.h"
#import "IMBCommonEnum.h"

@interface IMBAppExport : IMBBaseTransfer {
@protected
    IMBAppTransferTypeEnum _archiveType;
    int _totalStep;
    int _curStep;
    int _singleStep;
}

@end
