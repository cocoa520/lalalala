//
//  PZFactory.h
//
//
//  Created by JGehry on 8/2/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class PZKeyDerivationFunction;
@class PZKeyUnwrap;
@class PZAssistant;
@class PZAssistantLight;
@class ProtectionZone;
@class ProtectionInfo;

@interface PZFactory : NSObject {
@private
    PZKeyDerivationFunction *_kdf;
    PZKeyUnwrap *_unwrapKey;
    PZAssistant *_assistant;
    PZAssistantLight *_assistantLight;
}

+ (PZFactory*)instance;

- (id)initWithKdf:(PZKeyDerivationFunction*)kdf withUnwrapKey:(PZKeyUnwrap*)unwrapKey withAssistant:(PZAssistant*)assistant withAssistantLight:(PZAssistantLight*)assistantLight;

- (ProtectionZone*)create:(NSMutableArray*)keys;
- (ProtectionZone*)createWithBase:(ProtectionZone*)base withProtectionInfo:(ProtectionInfo*)protectionInfo;
- (NSMutableDictionary *)keys:(NSMutableArray *)keys;

@end
