//
//  NavSolServicesManager.h
//  NavSolServices2
//
//  Created by ESD Developer on 2/21/13.
//  Copyright (c) 2013 Navigation Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NavSolService.h"

// forward declaration of the NavSolService class
@class NavSolService;

@interface NavSolServicesManager : NSObject <NSURLConnectionDelegate>
{
    NSString*       tokenGuid;
    NSString*       tenantGuid;
    NSString*       applicationGuid;
    NSMutableData*  recievedData;
    NSString*       baseServicesUrl;
}
@property (nonatomic, strong) NSString* tokenGuid;
@property (nonatomic, strong) NSData* recievedData;
@property (nonatomic, strong) NSString* tenantGuid;
@property (nonatomic, strong) NSString* applicationGuid;
@property (nonatomic, strong) NSString* baseServicesUrl;

// class methods
+ (void) CallService:(NavSolService*)service;
+ (void) CallService:(NSURL*)url method:(NSString*)method_type data:(NSString*)xml_data bytes:(NSData*)bytes_array;
// singleton access methods
+ (NavSolServicesManager *)instance;

@end