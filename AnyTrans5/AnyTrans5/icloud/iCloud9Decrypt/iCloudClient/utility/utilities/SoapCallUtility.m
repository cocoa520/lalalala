//
//  SoapCallClass.m
//  
//
//  Created by Pallas on 10/22/15.
//
//

#import "SoapCallUtility.h"

@implementation SoapCallUtility
@synthesize servEndPointPath = _servEndPointPath;
@synthesize servNameSpace = _servNameSpace;
@synthesize servRequest = _servRequest;

- (id)initWithUrl:(NSString*)url withNameSpace:(NSString*)ns withRequest:(NSString*)request {
    if (self = [super init]) {
        [self setServEndPointPath:url];
        [self setServNameSpace:ns];
        [self setServRequest:request];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (id)getSoapWithMethodName:(NSString*)methodName withParams:(NSDictionary*)params withParamsOrder:(NSArray*)paramsOrder withErrorCode:(long*)errorCode {
    NSURL *storeURL = [NSURL URLWithString:self.servEndPointPath];
    
    WSMethodInvocationRef rpcCall;
    rpcCall = WSMethodInvocationCreate((CFURLRef)storeURL, (CFStringRef)methodName, kWSSOAP2001Protocol);
    
    WSMethodInvocationSetParameters (rpcCall, (CFDictionaryRef)params, (CFArrayRef)paramsOrder);
    NSDictionary *reqHeaders = nil;
    if ([self servRequest] != nil) {
        reqHeaders = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@#%@# %@", self.servNameSpace, self.servRequest, methodName] forKey:@"SOAPAction"];
    } else {
        reqHeaders = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@%@", self.servNameSpace, methodName] forKey:@"SOAPAction"];
    }
    WSMethodInvocationSetProperty(rpcCall, (CFStringRef)kWSHTTPExtraHeaders, (CFDictionaryRef)reqHeaders);
    
    // for good measure, make the call follow redirects.
    WSMethodInvocationSetProperty(rpcCall, kWSHTTPFollowsRedirects, kCFBooleanTrue);
    WSMethodInvocationSetProperty(rpcCall, kWSSOAPMethodNamespaceURI, (CFStringRef)self.servNameSpace);
    
    // set debug props
    WSMethodInvocationSetProperty(rpcCall, kWSDebugIncomingBody, kCFBooleanTrue);
    WSMethodInvocationSetProperty(rpcCall, kWSDebugIncomingHeaders, kCFBooleanTrue);
    WSMethodInvocationSetProperty(rpcCall, kWSDebugOutgoingBody, kCFBooleanTrue);
    WSMethodInvocationSetProperty(rpcCall, kWSDebugOutgoingHeaders, kCFBooleanTrue);
    
    NSDictionary *result;
    result = (NSDictionary *) (WSMethodInvocationInvoke(rpcCall));
    
    // get HTTP response from SOAP request so we can see the status code
    CFHTTPMessageRef res = (CFHTTPMessageRef) [result objectForKey:(id)kWSHTTPResponseMessage];
    
    long resStatusCode = CFHTTPMessageGetResponseStatusCode(res);
    if (resStatusCode == 200) {
        *errorCode = 0;
        if (WSMethodResultIsFault ((CFDictionaryRef)result)) {
            return [result objectForKey:@"/FaultString"];
        } else {
            return [result objectForKey:@"/Result"];
        }
    } else {
        *errorCode = resStatusCode;
        return nil;
    }
}

@end
