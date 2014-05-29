//
//  UNDataViewController.h
//  MNDOT Cameras
//
//  Created by Rory Lonergan on 2/7/14.
//  Copyright (c) 2014 UGUF. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UNCamera;

@interface UNDataViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
@property (strong, nonatomic) UNCamera *dataObject;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)addCamera:(id)sender;

@end
