//
//  BackupAccountClient.m
//  
//
//  Created by iMobie on 7/25/16.
//
//  Complete

#import "BackupAccountClient.h"
#import "CloudKit.pb.h"
#import "PZFactory.h"
#import "BackupAccountFactory.h"

@implementation BackupAccountClient

+ (BackupAccount *)backupAccount:(CloudKitty *)kitty zone:(ProtectionZone *)zone {
    NSMutableArray *responses = [kitty recordRetrieveRequest:@"mbksync" withRecordName:@"BackupAccount", nil];
    if ([responses count] != 1) {
        return nil;
    }
    ProtectionInfo *protectionInfo = [[[responses objectAtIndex:0] record] protectionInfo];
    ProtectionZone *optionalNewZone = [[PZFactory instance] createWithBase:zone withProtectionInfo:protectionInfo];
    if (!optionalNewZone) {
        return nil;
    }
    ProtectionZone *newZone = optionalNewZone;
    BackupAccount *backupAccount = [BackupAccountFactory from:[[responses objectAtIndex:0] record] withProtectionZone:newZone];
    return backupAccount;
}

@end
