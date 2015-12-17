//
//  MSImagePickerController.h
//  Example
//
//  Created by DamonDing on 17/12/14.
//  Copyright (c) 2015年 zxm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MSImagePickerControllerDelegate;

/**
 *  这个类只应该用在需要选择多个图片的时候使用，不应用在选择单个图片或视频的情况下。
 */
@interface MSImagePickerController : UIImagePickerController

/**
 * 保存了选择的所有图片
 */
@property (nonatomic, readonly, copy) NSArray *images;

/**
 * 代理
 */
@property (nonatomic, readwrite, weak) id<MSImagePickerControllerDelegate> msDelegate;

/**
 * 选择图片的上限, 默认是0(没有限制)
 */
@property (nonatomic, readwrite, assign) NSInteger maxImageCount;

/**
 * 确定按钮的文字,默认是"Done"
 */
@property (nonatomic, readwrite, assign) NSString* doneButtonTitle;

@end


@protocol MSImagePickerControllerDelegate<NSObject>

@optional
- (BOOL)imagePickerController:(MSImagePickerController *)picker shouldSelectImage:(UIImage*)image; // 是否可以选择该图片

- (void)imagePickerControllerdidFinish   :(MSImagePickerController *)picker; // 选择图片并点击确定按钮的时候调用
- (void)imagePickerControllerDidCancel   :(MSImagePickerController *)picker; // 点击取消按钮的时候调用
- (void)imagePickerControllerOverMaxCount:(MSImagePickerController *)picker; // 选择的图片超过上限的时候调用

@end
