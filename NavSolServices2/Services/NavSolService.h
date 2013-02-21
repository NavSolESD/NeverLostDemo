//
//  NavSolService.h
//  NavSolServices2
//
//  Created by ESD Developer on 2/21/13.
//  Copyright (c) 2013 Navigation Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NavSolServicesManager.h"

@interface NavSolService : NSObject
{
    NSString    *relativeUrl;
    NSString    *data;
    NSString    *RESTmethod;
    BOOL        isSecure;
    NSString    *name;
}

@property (nonatomic, strong) NSString* relativeUrl;
@property (nonatomic, strong) NSString* data;
@property (nonatomic, strong) NSString* RESTmethod;
@property (nonatomic) BOOL isSecure;
@property (nonatomic, strong) NSString* name;

- (id) initWithUrl:(NSString*)url withData:(NSString*)dataString isSecure:(BOOL)security RESTmethod:(NSString*)method withName:(NSString*)name;
- (NSURL*) buildUrl;

@end
