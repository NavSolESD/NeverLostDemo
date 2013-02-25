//
//  NavSolServicesManager.m
//  NavSol Services
//
//  Created by ESD Developer on 2/19/13.
//  Copyright (c) 2013 Navigation Solutions. All rights reserved.
//

#import "NavSolServicesManager.h"

@implementation NavSolServicesManager
@synthesize tokenGuid;
@synthesize recievedData;
@synthesize tenantGuid;
@synthesize applicationGuid;
@synthesize baseServicesUrl;

- (id)init
{
    self = [super init];
    if (self)
    {
        baseServicesUrl = @"dev-services.navsol.net";
        tenantGuid = @"9F4E1CAD-83F0-44F3-AF33-398F703768A6";
        applicationGuid = @"141b2bdc-2840-4f66-a051-89bdb027958d";
    }

    return self;
}

// singleton
static NavSolServicesManager *myInstance;
+ (NavSolServicesManager*) instance
{
    if(myInstance == NULL)
    {
        myInstance = [[NavSolServicesManager alloc] init];
    }
    return myInstance;
}

// class methods
+ (void) CallService:(NavSolService *)service
{
    if([service.RESTmethod isEqualToString:@"POST"] || [service.RESTmethod isEqualToString:@"PUT"])
    {
        // serialize our data object to JSON
        NSData* data = [NSJSONSerialization dataWithJSONObject:service.data options:0 error:nil];
        [NavSolServicesManager CallService:[service buildUrl] method:service.RESTmethod data:nil bytes:data];
    }
    else
    {
        [NavSolServicesManager CallService:[service buildUrl] method:service.RESTmethod data:nil bytes:nil];
    }    
}

+ (void) CallService:(NSURL*)url method:(NSString *)method_type data:(NSString *)json_data bytes:(NSData *)bytes_array
{
    // create the request object
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    // set our header values
    [request setHTTPMethod: method_type];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"accept"];

    // if we have a token guid, put it in the header
    // a token is required for almost every service call, except for GetToken
    if ([NavSolServicesManager instance].tokenGuid != NULL )
    {
        [request setValue:[NavSolServicesManager instance].tokenGuid forHTTPHeaderField:@"Authorization"];
    }

    // if this service call is either a POST or PUT type, then
    // this message will use either the json_data OR the bytes_array, but not both.
    // if the bytes_array is populated, we just use that data. Otherwise, encode the
    // json as utf-8 and send the raw data from it
    if([method_type isEqualToString:@"POST"] || [method_type isEqualToString:@"PUT"])
    {
        if(bytes_array == NULL && json_data != NULL)
        {
            bytes_array = [json_data dataUsingEncoding:NSUTF8StringEncoding];
        }
        
        [request setHTTPBody:bytes_array];
        [request setValue:[NSString stringWithFormat: @"%d", [bytes_array length]] forHTTPHeaderField:@"content-length"];
    }

    // start a connection
    NSLog(@"Calling service with url: %@", [url absoluteString]);
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:[NavSolServicesManager instance]];
    if(connection)
    {
        [NavSolServicesManager instance].recievedData = [NSMutableData data];
    }
    else
    {
        // the connection failed.

    }
}

// instance methods
- (void) GetToken
{
    // register for the notification when this ends
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(populateTextView) name:@"serviceCallFinished" object:NULL];

    NSURL *getTokenUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@?tenantGuid=%@&applicationGuid=%@", @"http://", baseServicesUrl, @"/tokenmanagement/createtoken", tenantGuid, applicationGuid ]];

    [NavSolServicesManager CallService:getTokenUrl method:@"GET" data:NULL bytes:NULL];
}

// - NSURLConnection Delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // reset the data in case of redirects
    [recievedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // build up our data object
    [recievedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection failed - %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"success");

    NSString *requestUrl = [[connection.currentRequest URL] absoluteString];
    NSRange range = [requestUrl rangeOfString:@"createtoken" options:NSCaseInsensitiveSearch];
    if( range.location != NSNotFound){
        NSError *e = NULL;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:recievedData options:NSJSONReadingMutableLeaves error:&e];
        if(e) {
            NSLog(@"error: %@", e);
        } else {
            NSLog(@"%@", [json objectForKey:@"Data"]);
            tokenGuid = [json objectForKey:@"Data"];
        }
    }
    NSLog(@"urlContainsCreateToken?: %d", [[[connection.currentRequest URL] absoluteString] compare:@"createtoken" options:NSCaseInsensitiveSearch] );

    [[NSNotificationCenter defaultCenter] postNotificationName:@"serviceCallFinished" object:NULL];
}

@end
