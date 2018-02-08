//
//  IMBAirTrafficHost64.h
//  
//
//  Created by JGehry on 3/24/17.
//
//

#import <Foundation/Foundation.h>

@interface IMBAirTrafficHost64 : NSObject

+ (long long)ATHostConnectionCreateWithLibrary:(id)parm1  Parm2:(id)parm2 Parm3:(long long)parm3;
+ (int)ATHostConnectionSendPowerAssertion:(long long)parm1  Parm2:(id)parm2;
+ (int)ATHostConnectionRetain:(long long)parm1;
+ (int)ATHostConnectionSendHostInfo:(long long)parm1 Parm2:(id)parm2 ;
+ (id)ATHostConnectionReadMessage:(long long)parm1;
+ (int)ATHostConnectionSendFileProgress:(long long)parm1  Parm2:(id)parm2 Parm3:(id)parm3 Parm4:(id)parm4 Parm5:(long long)parm5 Parm6:(id)parm6;
+ (int)ATHostConnectionSendAssetCompleted:(long long)parm1  Parm2:(id)parm2 Parm3:(id)parm3 Parm4:(id)parm4;
+ (int)ATHostConnectionSendMetadataSyncFinished:(long long)parm1  Parm2:(id)parm2 Parm3:(id)parm3;
+ (int)ATHostConnectionRelease:(long long)parm1 ;
+ (int)ATHostConnectionInvalidate:(long long)parm1 ;
+ (int)ATHostConnectionGetCurrentSessionNumber:(long long)parm1 ;
+ (int)ATHostConnectionSendPing:(long long)parm1 ;
+ (int)ATHostConnectionSendFileError:(long long)parm1  Parm2:(id)parm2 Parm3:(id)parm3 Parm4:(long long)parm4;
+ (int)ATHostConnectionSendMessage:(long long)parm1  Parm2:(id)parm2 ;
+ (int)ATHostConnectionSendSyncRequest:(long long)parm1  Parm2:(id)parm2 Parm3:(id)parm3 Parm4:(id)parm4;
+ (int)ATHostConnectionGetGrappaSessionId:(int)parm1 ;
+ (int)ATCFMessageGetName:(id)parm1 ;
+ (id)ATCFMessageGetParam:(id)parm1 Parm2:(id)parm2;
+ (int)ATCFMessageCreate:(int)parm1  Parm2:(id)parm2 Parm3:(id)parm3;

@end
