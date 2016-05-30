//
//  CWPresentationController.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/5/15.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "CWPresentationController.h"

@implementation CWPresentationController
- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    if (self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController]) {
        
        presentingViewController.preferredContentSize = CGSizeMake(300, 300);
    }
    
    return self;
    
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return self;
}

@end
