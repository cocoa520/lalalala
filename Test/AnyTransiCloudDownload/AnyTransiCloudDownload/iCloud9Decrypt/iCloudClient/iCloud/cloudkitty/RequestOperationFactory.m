//
//  RequestOperation.m
//  
//
//  Created by iMobie on 7/27/16.
//
//  Complete

#import "RequestOperationFactory.h"
#import "CategoryExtend.h"
#import "CloudKit.pb.h"

@interface RequestOperationFactory ()

@property (nonatomic, readwrite, retain) RequestOperationHeader *requestOperationHeaderProto;
@property (nonatomic, readwrite, retain) Identifier *cloudKitUserId;
@property (nonatomic, readwrite, retain) NSString *container;
@property (nonatomic, readwrite, retain) NSString *bundle;

@end

@implementation RequestOperationFactory
@synthesize requestOperationHeaderProto = _requestOperationHeaderProto;
@synthesize cloudKitUserId = _cloudKitUserId;
@synthesize container = _container;
@synthesize bundle = _bundle;

+ (RequestOperationHeader*)baseRequestOperationHeader {
    static RequestOperationHeader *_baseRequestOperationHeader = nil;
    @synchronized(self) {
        if (_baseRequestOperationHeader == nil) {
            RequestOperationHeader_Builder *requestOperationHeaderBuilder = [RequestOperationHeader builder];
            [requestOperationHeaderBuilder setF4:@"4.0.0.0"];
            [requestOperationHeaderBuilder setDeviceSoftwareVersion:@"9.0.1"];
            [requestOperationHeaderBuilder setDeviceLibraryName:@"com.apple.cloudkit.CloudKitDaemon"];
            [requestOperationHeaderBuilder setDeviceLibraryVersion:@"479"];
            [requestOperationHeaderBuilder setDeviceFlowControlBudget:40000];
            [requestOperationHeaderBuilder setDeviceFlowControlBudgetCap:40000];
            [requestOperationHeaderBuilder setVersion:@"4.0"];
            [requestOperationHeaderBuilder setF19:1];
            [requestOperationHeaderBuilder setDeviceAssignedName:@"My iPhone"];
            [requestOperationHeaderBuilder setF23:1];
            [requestOperationHeaderBuilder setF25:1];
            _baseRequestOperationHeader = [[requestOperationHeaderBuilder build] retain];
        }
    }
    return _baseRequestOperationHeader;
}

+ (NSString*)ckdFetchRecordZonesOperation {
    static NSString *_ckdFetchRecordZonesOperation = nil;
    @synchronized(self) {
        if (_ckdFetchRecordZonesOperation == nil) {
            _ckdFetchRecordZonesOperation = [@"CKDFetchRecordZonesOperation" retain];
        }
    }
    return _ckdFetchRecordZonesOperation;
}

+ (NSString*)ckdQueryOperation {
    static NSString *_ckdQueryOperation = nil;
    @synchronized(self) {
        if (_ckdQueryOperation == nil) {
            _ckdQueryOperation = [@"CKDQueryOperation" retain];
        }
    }
    return _ckdQueryOperation;
}

+ (NSString*)getRecordsURLRequest {
    static NSString *_getRecordsURLRequest = nil;
    @synchronized(self) {
        if (_getRecordsURLRequest == nil) {
            _getRecordsURLRequest = [@"GetRecordsURLRequest" retain];
        }
    }
    return _getRecordsURLRequest;
}

- (id)initWithCloudKitUserId:(NSString*)cloudKitUserId withContainer:(NSString*)container withBundle:(NSString*)bundle withDeviceHardwareID:(NSString*)deviceHardwareID withDeviceID:(NSString*)deviceID {
    if (self = [super init]) {
        Identifier *deviceIdentifier = [RequestOperationFactory identifier:deviceID withType:2];
        
        RequestOperationHeader_Builder *requestOperationHeaderBuilder = [RequestOperationHeader builderWithPrototype:[RequestOperationFactory baseRequestOperationHeader]];
        [requestOperationHeaderBuilder setDeviceIdentifier:deviceIdentifier];
        [requestOperationHeaderBuilder setDeviceHardwareId:deviceHardwareID];
        [self setRequestOperationHeaderProto:[requestOperationHeaderBuilder build]];
        
        [self setCloudKitUserId:[RequestOperationFactory identifier:cloudKitUserId withType:7]];
        [self setContainer:container];
        [self setBundle:bundle];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_requestOperationHeaderProto != nil) [_requestOperationHeaderProto release]; _requestOperationHeaderProto = nil;
    if (_cloudKitUserId != nil) [_cloudKitUserId release]; _cloudKitUserId = nil;
    if (_container != nil) [_container release]; _container = nil;
    if (_bundle != nil) [_bundle release]; _bundle = nil;
    [super dealloc];
#endif
}

// return == RequestOperation[], zones = string[]
- (NSMutableArray*)zoneRetrieveRequestOperation:(NSArray*)zones {
    RequestOperationHeader *requestOperationHeader = [self requestOperationHeader:[RequestOperationFactory ckdFetchRecordZonesOperation]];
    
    return [self zoneRetrieveRequestOperation:requestOperationHeader withZones:zones];
}

// return == RequestOperation[], zones = string[]
- (NSMutableArray*)zoneRetrieveRequestOperation:(RequestOperationHeader*)requestOperationHeader withZones:(NSArray*)zones {
    NSMutableArray *operations = [[[NSMutableArray alloc] init] autorelease];
    
    for (NSString *zone in zones) {
        [operations addObject:[self zoneRetrieveRequestOperation:requestOperationHeader withZone:zone]];
        if (requestOperationHeader != nil) {
            requestOperationHeader = nil;
        }
    }
    
    return operations;
}

- (RequestOperation*)zoneRetrieveRequestOperation:(RequestOperationHeader*)requestOperationHeader withZone:(NSString*)zone {
    Operation *operation = [self operation:201];
    ZoneRetrieveRequest *zoneRetrieveRequest = [self zoneRetrieveRequest:zone];
    
    RequestOperation_Builder *builder = [RequestOperation builder];
    [builder setOperation:operation];
    [builder setZoneRetrieveRequest:zoneRetrieveRequest];
    if (requestOperationHeader != nil) {
        [builder setRequestOperationHeader:requestOperationHeader];
    }
    return [builder build];
}

- (ZoneRetrieveRequest*)zoneRetrieveRequest:(NSString*)zone {
    RecordZoneIdentifier *recordZoneID = [self recordZoneIdentifier:zone];
    
    ZoneRetrieveRequest_Builder *zoneRetrieveRequestBuilder = [ZoneRetrieveRequest builder];
    [zoneRetrieveRequestBuilder setZoneIdentifier:recordZoneID];
    
    return [zoneRetrieveRequestBuilder build];
}

// return == RequestOperation[]
- (NSMutableArray*)recordRetrieveRequestOperations:(NSString*)zone withRecordNames:(NSArray*)recordNames {
    RequestOperationHeader *requestOperationHeader = [self requestOperationHeader:[RequestOperationFactory getRecordsURLRequest]];
    
    return [self recordRetrieveRequestOperations:requestOperationHeader withZone:zone withRecordNames:recordNames];
}

// return == RequestOperation[], recordNames == string[]
- (NSMutableArray*)recordRetrieveRequestOperations:(RequestOperationHeader*)requestOperationHeader withZone:(NSString*)zone withRecordNames:(NSArray*)recordNames {
    NSMutableArray *operations = [[[NSMutableArray alloc] init] autorelease];
    
    for (NSString *recordName in recordNames) {
        [operations addObject:[self recordRetrieveRequestOperation:requestOperationHeader withZone:zone withRecordName:recordName]];
        
        if (requestOperationHeader != nil) {
            requestOperationHeader = nil;
        }
    }
    
    return operations;
}

- (RequestOperation*)recordRetrieveRequestOperation:(RequestOperationHeader*)requestOperationHeader withZone:(NSString*)zone withRecordName:(NSString*)recordName {
    Operation *operation = [self operation:211];
    RecordRetrieveRequest *recordRetrieveRequest = [self recordRetrieveRequest:zone withRecordName:recordName];
    
    RequestOperation_Builder *builder = [RequestOperation builder];
    [builder setOperation:operation];
    [builder setRecordRetrieveRequest:recordRetrieveRequest];
    if (requestOperationHeader != nil) {
        [builder setRequestOperationHeader:requestOperationHeader];
    }
    
    return [builder build];
}

- (RecordRetrieveRequest*)recordRetrieveRequest:(NSString*)zone withRecordName:(NSString*)recordName {
    RecordZoneIdentifier *recordZoneID = [self recordZoneIdentifier:zone];
    RecordIdentifier *recordIdentifier = [self recordIdentifier:recordZoneID withRecordName:recordName];
    
    RecordRetrieveRequest_Builder *recordRetrieveRequestBuilder = [RecordRetrieveRequest builder];
    [recordRetrieveRequestBuilder setRecordId:recordIdentifier];
    
    return [recordRetrieveRequestBuilder build];
}

- (RequestOperationHeader*)requestOperationHeader:(NSString*)operation {
    RequestOperationHeader_Builder *builder = [RequestOperationHeader builderWithPrototype:[self requestOperationHeaderProto]];
    [builder setApplicationContainer:[self container]];
    [builder setApplicationBundle:[self bundle]];
    [builder setOperation:operation];
    return [builder build];
}

- (Operation*)operation:(int)type {
    Operation_Builder *builder = [Operation builder];
    [builder setUuid:[NSString generateGUID]];
    [builder setType:type];
    return [builder build];
}

- (RecordZoneIdentifier*)recordZoneIdentifier:(NSString*)zone {
    Identifier *identifier = [RequestOperationFactory identifier:zone withType:6];
    
    RecordZoneIdentifier_Builder *builder = [RecordZoneIdentifier builder];
    [builder setValue:identifier];
    [builder setOwnerIdentifier:[self cloudKitUserId]];
    return [builder build];
}

- (RecordIdentifier*)recordIdentifier:(RecordZoneIdentifier*)recordZoneID withRecordName:(NSString*)recordName {
    Identifier *identifier = [RequestOperationFactory identifier:recordName withType:1];
    
    RecordIdentifier_Builder *builder = [RecordIdentifier builder];
    [builder setValue:identifier];
    [builder setZoneIdentifier:recordZoneID];
    return [builder build];
}

+ (Identifier*)identifier:(NSString*)name withType:(int)type {
    Identifier_Builder *builder = [Identifier builder];
    [builder setName:name];
    [builder setType:type];
    return [builder build];
}

- (NSString*)toString {
    return [NSString stringWithFormat:@"RequestOperationFactory{requestOperationHeaderProto=%@, userID=%@, container=%@, bundle=%@}", [self requestOperationHeaderProto], [self cloudKitUserId], [self container], [self bundle]];
}

@end
