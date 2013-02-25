//
//  NavSolMasterViewController.h
//  NavSolServices2
//
//  Created by ESD Developer on 2/21/13.
//  Copyright (c) 2013 Navigation Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavSolService.h"
#import "NavSolServicesManager.h"

@class NavSolDetailViewController;

@interface NavSolMasterViewController : UITableViewController
{
    NSDictionary    *services;
    NSArray         *serviceNames;
    NSString        *baseServicesUrl;
}

@property (strong, nonatomic) NavSolDetailViewController *detailViewController;

@end
