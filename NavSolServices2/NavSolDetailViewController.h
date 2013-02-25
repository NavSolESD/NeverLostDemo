//
//  NavSolDetailViewController.h
//  NavSolServices2
//
//  Created by ESD Developer on 2/21/13.
//  Copyright (c) 2013 Navigation Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavSolService.h"

@interface NavSolDetailViewController : UIViewController
{
    IBOutlet UITextView *detailsTextField;
    IBOutlet UIActivityIndicatorView *progressIndicator;
    IBOutlet UITextView *serviceTextField;
}

@property (strong, nonatomic) NavSolService *detailItem;

- (void) populateTextView;
- (IBAction)goButtonPushed:(UIButton *)sender;
@end
