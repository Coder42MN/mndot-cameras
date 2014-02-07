//
//  UNModelController.h
//  MNDOT Cameras
//
//  Created by Rory Lonergan on 2/7/14.
//  Copyright (c) 2014 UGUF. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UNDataViewController;

@interface UNModelController : NSObject <UIPageViewControllerDataSource>

- (UNDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(UNDataViewController *)viewController;

@end
