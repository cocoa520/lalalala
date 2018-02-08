//
//  CloudKitty.m
//  
//
//  Created by Pallas on 4/26/16.
//
//  Complete

#import "CloudKitty.h"
#import "CategoryExtend.h"
#import "RequestOperationFactory.h"
#import "CKInit.h"
#import "Account.h"
#import "MobileMe.h"
#import "CKContainer.h"
#import "Tokens.h"
#import "BigInteger.h"
#import "CloudKit.pb.h"
#import "ProtoBufsRequestLegacy.h"
#import "HttpClient.h"
#import "CommonDefine.h"

@interface CloudKitty ()

@property (nonatomic, readwrite, retain) RequestOperationFactory *factory;
@property (nonatomic, readwrite, retain) NSString *container;
@property (nonatomic, readwrite, retain) NSString *bundle;
@property (nonatomic, readwrite, retain) NSString *cloudKitUserId;
@property (nonatomic, readwrite, retain) NSString *cloudKitToken;
@property (nonatomic, readwrite, retain) NSString *baseUrl;

@end

@implementation CloudKitty
@synthesize factory = _factory;
@synthesize container = _container;
@synthesize bundle = _bundle;
@synthesize cloudKitUserId = _cloudKitUserId;
@synthesize cloudKitToken = _cloudKitToken;
@synthesize baseUrl = _baseUrl;

+ (CloudKitty*)backupd:(CKInit*)ckInit withAccount:(Account*)account {
    CloudKitty *retVal = nil;
    @autoreleasepool {
        NSString *container = @"com.apple.backup.ios";
        NSString *bundle = @"com.apple.backupd";
        
        NSString *cloudKitUserId = [ckInit cloudKitUserId];
        
        // Re-direct issues with ckInit baseUrl.
        NSString *baseUrl = [[account mobileMe] get:@"com.apple.Dataclass.CKDatabaseService" withKey:@"url"];
        if ([NSString isNilOrEmpty:baseUrl]) {
            baseUrl = [[ckInit production] url];
        } else {
            baseUrl = [NSString stringWithFormat:@"%@/api/client", baseUrl];
        }
        
        NSString *cloudKitToken = [[account tokens] get:CLOUDKITTOKEN];
        
        NSString *deviceID = [NSString generateGUID];
        BigInteger *dHIDBigInteger = [[BigInteger alloc] initWithSizeInBits:256];
        NSString *deviceHardwareID = [[dHIDBigInteger toStringWithRadix:16] uppercaseStringWithLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
        
        RequestOperationFactory *factory = [[RequestOperationFactory alloc] initWithCloudKitUserId:cloudKitUserId withContainer:container withBundle:bundle withDeviceHardwareID:deviceHardwareID withDeviceID:deviceID];
        
        retVal = [[CloudKitty alloc] init:factory withContainer:container withBundle:bundle withCloudKitUserId:cloudKitUserId withCloudKitToken:cloudKitToken withBaseUrl:baseUrl];
#if !__has_feature(objc_arc)
        if (dHIDBigInteger) [dHIDBigInteger release]; dHIDBigInteger = nil;
        if (factory) [factory release]; factory = nil;
#endif
    }
    return (retVal ? [retVal autorelease] :nil);
}


static int REQUEST_LIMIT = 400;

- (id)init:(RequestOperationFactory*)factory withContainer:(NSString*)container withBundle:(NSString*)bundle withCloudKitUserId:(NSString*)cloudKitUserId withCloudKitToken:(NSString*)cloudKitToken withBaseUrl:(NSString*)baseUrl {
    if (self = [super init]) {
        [self setFactory:factory];
        [self setContainer:container];
        [self setBundle:bundle];
        [self setCloudKitUserId:cloudKitUserId];
        [self setCloudKitToken:cloudKitToken];
        [self setBaseUrl:baseUrl];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setFactory:nil];
    [self setContainer:nil];
    [self setBundle:nil];
    [self setCloudKitUserId:nil];
    [self setCloudKitToken:nil];
    [self setBaseUrl:nil];
    [super dealloc];
#endif
}

// return == ZoneRetrieveResponse[]
- (NSMutableArray*)zoneRetrieveRequest:(NSString*)zone, ... {
    NSMutableArray *retVal = nil;
    NSMutableArray *argsArray = [[NSMutableArray alloc] init];
    va_list params; //定义一个指向个数可变的参数列表指针
    NSString *arg;
    if (zone != nil) {
        va_start(params, zone);//va_start 得到第一个可变参数地址
        [argsArray addObject:zone];
        //va_arg 指向下一个参数地址
        while((arg = va_arg(params, NSString*))) {
            if (arg != nil){
                [argsArray addObject:arg];
            }
        }
        va_end(params);
    }
    if (argsArray.count > 0) {
        retVal = [self zoneRetrieveRequestWithArray:argsArray];
    }
#if !__has_feature(objc_arc)
    if (argsArray != nil) [argsArray release]; argsArray = nil;
#endif
    return retVal;
}

// return == ZoneRetrieveResponse[]
- (NSMutableArray*)zoneRetrieveRequestWithArray:(NSArray*)zones {
    NSMutableArray *retVal = nil;
    @autoreleasepool {
        // M201
        NSArray *requestOperations = [self.factory zoneRetrieveRequestOperation:zones];
        NSArray *response = [self doRequest:requestOperations];
        
        retVal = [[NSMutableArray alloc] init];
        for (ResponseOperation *responseOperation in response) {
            if (responseOperation.hasZoneRetrieveResponse) {
                [retVal addObject:[responseOperation zoneRetrieveResponse]];
            }
        }
    }
    return (retVal ? [retVal autorelease] : nil);
}

// return == RecordRetrieveResponse[]
- (NSMutableArray*)recordRetrieveRequest:(NSString*)zone withRecordName:(NSString*)recordName, ... {
    NSMutableArray *retVal = nil;
    NSMutableArray *argsArray = [[NSMutableArray alloc] init];
    va_list params; //定义一个指向个数可变的参数列表指针
    NSString *arg;
    if (zone != nil) {
        va_start(params, recordName);//va_start 得到第一个可变参数地址
        [argsArray addObject:recordName];
        //va_arg 指向下一个参数地址
        while((arg = va_arg(params, NSString*))) {
            if (arg != nil){
                [argsArray addObject:arg];
            }
        }
        va_end(params);
    }
    if (argsArray.count > 0) {
        retVal = [self recordRetrieveRequest:zone withRecordNames:argsArray];
    }
#if !__has_feature(objc_arc)
    if (argsArray != nil) [argsArray release]; argsArray = nil;
#endif
    return retVal;
}

// return == RecordRetrieveResponse[]
- (NSMutableArray*)recordRetrieveRequest:(NSString*)zone withRecordNames:(NSArray*)recordNames {
    NSMutableArray *retVal = nil;
    @autoreleasepool {
        // M211
        NSMutableArray *requestOperations = [[self factory] recordRetrieveRequestOperations:zone withRecordNames:recordNames];
        NSMutableArray *response = [self doRequest:requestOperations];
        
        retVal = [[NSMutableArray alloc] init];
        for (ResponseOperation *responseOperation in response) {
            if (responseOperation.hasRecordRetrieveResponse) {
                [retVal addObject:[responseOperation recordRetrieveResponse]];
            }
        }
    }
    return (retVal ? [retVal autorelease] : nil);
}

// return == ResponseOperation[]
- (NSMutableArray*)doRequest:(NSArray*)operations {
    if (operations == nil || operations.count <= 0) {
        return nil;
    }
    if (![((RequestOperation*)[operations objectAtIndex:0]) hasRequestOperationHeader]) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"missing request operation header" userInfo:nil];
    }
    
    NSMutableArray *responses = nil;
    @autoreleasepool {
        RequestOperationHeader *requestOperationHeader = [((RequestOperation*)[operations objectAtIndex:0]) requestOperationHeader];
        responses = [[NSMutableArray alloc] init];
        for (int i = 0; i < operations.count; i += REQUEST_LIMIT) {
            int fromIndex = i;
            int toIndex = fromIndex + REQUEST_LIMIT;
            toIndex = toIndex > operations.count ? (int)operations.count : toIndex;
            NSMutableArray *subList = [[operations subarrayWithRange:NSMakeRange(fromIndex, toIndex)] mutableCopy];
            if (![((RequestOperation*)[subList objectAtIndex:0]) hasRequestOperationHeader]) {
                RequestOperation_Builder *builder = [RequestOperation builderWithPrototype:[subList objectAtIndex:0]];
                [builder setRequestOperationHeader:requestOperationHeader];
                RequestOperation *requestOperation = [builder build];
                [subList replaceObjectAtIndex:0 withObject:requestOperation];
            }
            NSMutableArray *subListResponses = [self doSubListRequest:subList];
#if !__has_feature(objc_arc)
            if (subList) [subList release]; subList = nil;
#endif
            if (subListResponses != nil && subListResponses.count > 0) {
                [responses addObjectsFromArray:subListResponses];
            }
        }
    }
    return (responses ? [responses autorelease] : nil);
}

// return == ResponseOperation[]
- (NSMutableArray*)doSubListRequest:(NSArray*)operationsSubList {
    if (operationsSubList.count > REQUEST_LIMIT) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:[NSString stringWithFormat:@"sub list size over request limit: %ld", (unsigned long)operationsSubList.count] userInfo:nil];
    }
    
    NSMutableArray *retVal = nil;
    @autoreleasepool {
        NSMutableURLRequest *urlRequest = [[ProtoBufsRequestLegacy singleton] newRequest:[NSString stringWithFormat:@"%@/record/retrieve", self.baseUrl] withContainer:self.container withBundle:self.bundle withCloudKitUserId:self.cloudKitUserId withCloudKitToken:self.cloudKitToken withUuid:[NSString generateGUID] withProtobufs:operationsSubList];
        NSData *responsedData = [HttpClient execute:urlRequest];
        retVal = [[NSMutableArray alloc] init];
        if (responsedData != nil) {
            PBCodedInputStream *respStream = [PBCodedInputStream streamWithData:responsedData];
            for (int i = 0; ![respStream isAtEnd]; i++) {
                int len = [respStream readRawVarint32];
                ResponseOperation *responseOperation = nil;
                @try {
                    responseOperation = [ResponseOperation parseFromData:[respStream readRawData:len]];
                }
                @catch (NSException *exception) {
                    NSLog(@"exception reason(ResponseOperation): %@", exception.reason);
                }
                if (responseOperation != nil) {
                    [retVal addObject:responseOperation];
                }
            }
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTITY_NETWORK_FAULT_INTERRUPT object:nil];
        }
    }
    return (retVal ? [retVal autorelease] : nil);
}

@end
