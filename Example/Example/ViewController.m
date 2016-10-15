//
//  ViewController.m
//  Demo
//
//  Created by DamonDing on 15/5/14.
//  Copyright (c) 2015年 zxm. All rights reserved.
//

#import "ViewController.h"
#import "MSImagePickerController.h"
#import <QuickLook/QLPreviewController.h>

@interface ViewController ()<MSImagePickerControllerDelegate, QLPreviewControllerDataSource>

@property (retain, nonatomic) NSArray* array;

@end

@implementation ViewController

- (void) viewDidAppear:(BOOL) animated {
    [self doPicker:self];
}

- (void) doPicker:(id)sender {
    MSImagePickerController* picker = [[MSImagePickerController alloc] init];
    picker.msDelegate = self;
    picker.maxImageCount = 3;
    picker.doneButtonTitle = @"OK";
    [self presentViewController:picker animated:true completion:nil];
}


- (void) uiimagepicker:(id)sender {
    UIImagePickerController* picker = [UIImagePickerController new];
    
    [self presentViewController:picker animated:true completion:nil];
}

#pragma mark - QLPreviewController Delegate method
/*!
 * @abstract Returns the number of items that the preview controller should preview.
 * @param controller The Preview Controller.
 * @result The number of items.
 */
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller; {
    return self.array.count;
}

/*!
 * @abstract Returns the item that the preview controller should preview.
 * @param panel The Preview Controller.
 * @param index The index of the item to preview.
 * @result An item conforming to the QLPreviewItem protocol.
 */
- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index; {
    NSString* path = [NSString stringWithFormat:@"%@/Documents/%ld.png", NSHomeDirectory(), (long)index];
    NSURL* url = [[NSURL alloc] initFileURLWithPath:path];
    
    return (id <QLPreviewItem>)url;
}

#pragma mark - MSImagePickerController Delegate method
- (void)imagePickerControllerDidCancel:(MSImagePickerController *)picker; {
    [picker dismissViewControllerAnimated:true completion:nil];
    NSLog(@"do cancel");
}

- (void)imagePickerControllerdidFinish:(MSImagePickerController *)picker {
    self.array = picker.images;
    
    int i = 0;
    for (UIImage* img in self.array) {
        NSData* data = UIImagePNGRepresentation(img);
        if (data != nil) {
            [data writeToFile:[NSString stringWithFormat:@"%@/Documents/%d.png", NSHomeDirectory(), i++]
                   atomically:true];
        }
    }
    
    [picker dismissViewControllerAnimated:true completion:^{
        QLPreviewController* ql = [[QLPreviewController alloc] init];
        ql.dataSource = self;
        
        [self presentViewController:ql
                           animated:true
                         completion:nil];
    }];
}

- (void)imagePickerControllerOverMaxCount:(MSImagePickerController *)picker; // 选择的图片超过上限的时候调用
{
    NSString* message = [NSString stringWithFormat:@"你最多只能选择%ld张图片。", picker.maxImageCount];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    
    [alert show];
}

//- (BOOL)imagePickerController:(MSImagePickerController *)picker shouldSelectImage:(UIImage*)image; // 是否可以选择该图片
//{
//    if (arc4random() % 2) {
//        NSString* message = [NSString stringWithFormat:@"你不能选择这张图片。"];
//
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil, nil];
//
//        [alert show];
//        return false;
//    }
//
//    return true;
//}

@end
