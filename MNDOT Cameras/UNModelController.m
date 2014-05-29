//
//  UNModelController.m
//  MNDOT Cameras
//
//  Created by Rory Lonergan on 2/7/14.
//  Copyright (c) 2014 UGUF. All rights reserved.
//

#import "UNModelController.h"

#import "UNDataViewController.h"
#import "UNCamera.h"

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */

@interface UNModelController()
//@property (readonly, strong, nonatomic) NSArray *pageData;
@end

@implementation UNModelController {
    NSMutableArray *_cameras;
    NSString *_cameraBaseUrl;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // Create the data model.
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        _pageData = [[dateFormatter monthSymbols] copy];

        // Load from disk
        
        _cameraBaseUrl = @"http://video.dot.state.mn.us/video/image/metro/";
        UNCamera *camera1 = [[UNCamera alloc] initWithDisplayName:@"C917"
                                                              url:[NSURL URLWithString:@"http://video.dot.state.mn.us/video/image/metro/C917.jpg"]];
        UNCamera *camera2 = [[UNCamera alloc] initWithDisplayName:@"C919"
                                                              url:[NSURL URLWithString:@"http://video.dot.state.mn.us/video/image/metro/C919.jpg"]];
        if (camera1 && camera2) {
            _cameras = [@[camera1, camera2] mutableCopy];
        }
        else {
            NSLog(@"unable to create camera object");
        }

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleAddCameraNotification:)
                                                     name:@"addCamera"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleDeleteCameraNotification:)
                                                     name:@"deleteCamera"
                                                   object:nil];
    }
    return self;
}

- (UNDataViewController *)viewControllerAtIndex:(NSUInteger)index
                                     storyboard:(UIStoryboard *)storyboard {
    // Return the data view controller for the given index.
    if (([_cameras count] == 0) || (index >= [_cameras count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    UNDataViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"UNDataViewController"];
    dataViewController.dataObject = _cameras[index];
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(UNDataViewController *)viewController {
     // Return the index of the given data view controller.
     // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    return [_cameras indexOfObject:viewController.dataObject];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController:(UNDataViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController:(UNDataViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [_cameras count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (void)handleAddCameraNotification:(NSNotification *)notification {
    NSLog(@"notification: (%@)", notification);
    NSString *cameraName = notification.userInfo[@"cameraName"];
    if (cameraName) {
        NSString *url = [_cameraBaseUrl stringByAppendingFormat:@"%@.jpg", cameraName];
        NSLog(@"full camera URL: (%@)", url);
        UNCamera *camera = [[UNCamera alloc] initWithDisplayName:cameraName
                                                             url:[NSURL URLWithString:url]];
        if (camera) {
            [_cameras addObject:camera];
        }
        else {
            NSLog(@"couldn't make camera");
        }
    }
}

- (void)handleDeleteCameraNotification:(NSNotification *)notification {
    if (!notification) {
        NSLog(@"notification is nil");
        return;
    }
    if (!notification.userInfo) {
        NSLog(@"notification.userInfo is nil");
        return;
    }
    UNCamera *camera = notification.userInfo[@"camera"];
    if (!camera) {
        NSLog(@"no camera found in userInfo dictionary");
        return;
    }


    [_cameras removeObject:camera];
    NSLog(@"removing camera: (%@)", camera);
    // Reset to index 0
#warning ???
}

@end
