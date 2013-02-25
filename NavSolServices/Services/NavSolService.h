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
    NSString    *name;
    NSString    *relativeUrl;
    NSString    *RESTmethod;
    id          data;
    BOOL        isSecure;
}

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* relativeUrl;
@property (nonatomic, strong) NSString* RESTmethod;
@property (nonatomic, strong) id data;
@property (nonatomic) BOOL isSecure;


- (id) initWithUrl:(NSString*)url withData:(id)dataString isSecure:(BOOL)security RESTmethod:(NSString*)method withName:(NSString*)name;
- (NSURL*) buildUrl;

@end
