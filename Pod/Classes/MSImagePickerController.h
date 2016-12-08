//
//  MSImagePickerController.h
//  Example
//
//  Created by morenotepad on 17/12/14.
//  Copyright (c) 2015年 zxm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MSImagePickerControllerDelegate;

@interface MSImagePickerController : UIImagePickerController

@property (nonatomic, readonly, copy)    NSArray *images;
@property (nonatomic, readwrite, assign) NSInteger maxImageCount;
@property (nonatomic, readwrite, assign) NSString* doneButtonTitle;
@property (nonatomic, nullable, weak)    id<MSImagePickerControllerDelegate> msDelegate;

@end

@protocol MSImagePickerControllerDelegate<NSObject>

@optional
- (void)imagePickerControllerDidFinish   :(MSImagePickerController *)picker;
- (void)imagePickerControllerDidCancel   :(MSImagePickerController *)picker;
- (void)imagePickerControllerOverMaxCount:(MSImagePickerController *)picker;
- (BOOL)imagePickerController:(MSImagePickerController *)picker shouldSelectImage:(UIImage *)image;

@end
