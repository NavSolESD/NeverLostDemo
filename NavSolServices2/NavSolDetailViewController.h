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
    IBOutlet UITextField *serviceTextField;
    IBOutlet UITextView *detailsTextField;
    IBOutlet UIActivityIndicatorView *progressIndicator;
}

@property (strong, nonatomic) NavSolService *detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

- (void) populateTextView;
@end
