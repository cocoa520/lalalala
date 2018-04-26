//
//  AirTrafficHost.h
//  LoadDylibTest
//
//  Created by zhang yang on 13-1-22.
//  Copyright (c) 2013年 zhang yang. All rights reserved.
//
#ifndef LoadDylibTest_AirTrafficHost_h
#define LoadDylibTest_AirTrafficHost_h
#ifdef __cplusplus
extern "C" {
#endif
    /*
     * its critical that we spell out all integer sizes, for the entry points
     * and data structures in the external DLL/framework that we have no
     * control over.
     */
#include <stdint.h>
#if defined(WIN32)
#include <CoreFoundation.h>
    typedef uint32_t mach_error_t;
#elif defined(__APPLE__)
#include <CoreFoundation/CoreFoundation.h>
#include <mach/error.h>
#endif
   
#if __x86_64__
    /**64位 */
    int64_t ATHostConnectionCreateWithLibrary(void*, void*, int64_t);
    int ATHostConnectionSendPowerAssertion(int64_t, void*);
    int ATHostConnectionRetain(int64_t);
    int ATHostConnectionSendHostInfo(int64_t, void*);
    int64_t ATHostConnectionReadMessage(int64_t);
    int ATHostConnectionSendFileProgress(int64_t, void*, void*, char, int64_t, char);
    int ATHostConnectionSendAssetCompleted(int64_t, void*, void*, void*);
    int ATHostConnectionSendMetadataSyncFinished(int64_t, void*, void*);
    int ATHostConnectionRelease(int64_t);
    int ATHostConnectionInvalidate(int64_t);
    int ATHostConnectionSendFileError(int64_t, void*, void*, int64_t);
    int ATHostConnectionSendMessage(int64_t a1, void* a2);
    int64_t ATHostConnectionGetCurrentSessionNumber(int64_t a1);
    int ATHostConnectionSendPing(int64_t);
    int ATHostConnectionSendSyncRequest(int64_t, void*, void*, void*);
    
    void* ATCFMessageGetName(int64_t);
    void* ATCFMessageCreate(int64_t, void*, void*);
    
#else
     /**32位 */
    int ATHostConnectionCreateWithLibrary(void*, void*, int);
    int ATHostConnectionSendPowerAssertion(int, void*);
    int ATHostConnectionRetain(int);
    int ATHostConnectionSendHostInfo(int, void*);
    int ATHostConnectionReadMessage(int);
    int ATHostConnectionSendFileProgress(int, void*, void*, char, int, char);
    int ATHostConnectionSendAssetCompleted(int, void*, void*, void*);
    int ATHostConnectionSendMetadataSyncFinished(int, void*, void*);
    int ATHostConnectionRelease(int);
    int ATHostConnectionInvalidate(int);
    int ATHostConnectionSendFileError(int, void*, void*, int);
    int ATHostConnectionSendMessage(int a1, void* a2);
    int ATHostConnectionGetCurrentSessionNumber(int a1);
    int ATHostConnectionSendPing(int);
    int ATHostConnectionSendSyncRequest(int, void*, void*, void*);
    
    void* ATCFMessageGetName(int);
    void* ATCFMessageCreate(int a1, void*, void*);
#endif
    int ATHostConnectionGetGrappaSessionId(int);
//    int ATCFMessageGetName(void*);
    void* ATCFMessageGetParam(void*, void*);
//    int ATCFMessageCreate(int a1, void*, void*);
/*
    int __cdecl ATHostConnectionGetGrappaSessionId(int a1);
    int __cdecl ATHostConnectionGetCurrentSessionNumber(int a1);
    int __cdecl ATHostConnectionDestroy(int a3);
    //void __fastcall _ATHostConnectionDestroy(int a1);
    int __cdecl ATHostConnectionRetain(int a3);
    int __cdecl ATHostConnectionRelease(int a3);
    int __fastcall loc_FF9(int, int, int); // weak
    int __cdecl ATHostConnectionInvalidate(int *a1);
    int __cdecl ATHostConnectionCreate(int a1, int a2);
    int __cdecl ATHostConnectionCreateWithLibrary(int a1, int a2, int a3);
    int __cdecl loc_10B3(int, int, int); // weak
    int __cdecl loc_10BB(int, int, int); // weak
    int __cdecl ATHostConnectionSendHostInfo(int a1, int a2);
    void __cdecl ATHostConnectionSendSyncRequest(int a1, int a2, int a3, int a4);
    void __cdecl ATHostConnectionSendMetadataSyncFinished(int a1, int a2, int a3);
    void __cdecl ATHostConnectionSendAssetCompleted(int a1, int a2, int a3, int a4);
    void __cdecl ATHostConnectionSendAssetCompletedWithMetadata(int a1, int a2, int a3, int a4, int a5, int a6);
    void __cdecl ATHostConnectionSendFileBegin(int a1, int a2, int a3, int a4, int a5, int a6, int a7);
    void __cdecl ATHostConnectionSendFileProgress(int a1, int a2, int a3, __int64 a4, __int64 a5);
    void __cdecl ATHostConnectionSendFileError(int a1, int a2, int a3, int a4);
    int __cdecl ATHostConnectionSendSyncFailed(int a1, int a2);
    int __cdecl ATHostConnectionSendPowerAssertion(int a1, int a2);
    int __cdecl ATHostConnectionSendAssetMetricsRequest(int, int); // weak
    int __cdecl ATHostConnectionSendStatusMessage(int a1, int a2);
    int __cdecl ATHostConnectionSendPing(int a1);
    int __cdecl ATHostConnectionSendMessage(int a1, int a2);
    int __cdecl ATHostConnectionReadMessage(int a1);
    int __fastcall ATCreateErrorMessage(int a1);
    int __cdecl ATCFMessageCreate(int a1, int a2, int a3);
    int __cdecl ATCFMessageVerify(int a1, int a2);
    int __cdecl ATCFMessageGetName(int a1);
    int __cdecl ATCFMessageGetParam(int a1, int a2);
    int __cdecl ATCFMessageGetSessionNumber(int a1);
*/
/*
    typedef int (* ATHostConnectionCreateWithLibrary_Func)(void*, void*, int);
    typedef int (* ATHostConnectionSendPowerAssertion_Func)(int, int);
    typedef int (* ATHostConnectionRetain_Func)(int);
    typedef int (* ATHostConnectionSendHostInfo_Func)(int, void*);
    typedef void* (* ATHostConnectionReadMessage_Func)(int);
    typedef int (* ATHostConnectionSendSyncRequest_Func)(int, void*, void*, void*);
    typedef int (* ATHostConnectionGetGrappaSessionId_Func)(int);
    typedef int (* ATHostConnectionSendFileProgress_Func)(int, void*, void*, char, int, char);
    typedef int (* ATHostConnectionSendAssetCompleted_Func)(int, void*, void*, void*);
    typedef int (* ATHostConnectionSendMetadataSyncFinished_Func)(int, void*, void*);
    typedef int (* ATCFMessageGetName_Func)(void*);
    typedef int (* ATHostConnectionRelease_Func)(int);
    typedef int (* ATHostConnectionInvalidate_Func)(int);
    typedef int (* ATHostConnectionSendFileError_Func)(int, void*, void*, int);
    typedef void* (* ATCFMessageGetParam_Func)(void*, void*);
*/
#endif
