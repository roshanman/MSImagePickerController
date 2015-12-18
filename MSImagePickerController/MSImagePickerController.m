//
//  MSImagePickerController.h
//  Example
//
//  Created by DamonDing on 17/12/14.
//  Copyright (c) 2015年 zxm. All rights reserved.
//


#import "MSImagePickerController.h"
#import <objc/runtime.h>

static char attachSelfKey;
@interface MSImagePickerController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
}

/**
 * 保存了所有的图片，内部使用。
 */
@property (nonatomic, readwrite, retain) NSMutableArray *allImages;

/**
 * 展示图片用的view，基类是UICollectionView
 */
@property (nonatomic, readonly, retain) Class PUCollectionView;

/**
 * 显示图片用的View。
 */
@property (nonatomic, readonly, retain) Class PUPhotoView;

/**
 * 确定按钮。
 */
@property (retain, nonatomic) UIBarButtonItem *doneButton;

/**
 * 原始的按钮。
 */
@property (retain, nonatomic) UIBarButtonItem *lastDoneButton;

/**
 * 当前选择的图片的indexPath
 */
@property (retain, nonatomic) NSIndexPath     *curIndexPath;

/**
 * 所有被选择图片的indexpath
 */
@property (retain, nonatomic) NSMutableArray  *indexPaths;

/**
 * 原始的PUCollectionView的代理对象
 */
@property (retain, nonatomic) id              lastDelegate;

/**
 * 当前显示的PUCollectionView
 */
@property (nonatomic, readwrite, weak) UICollectionView *collectionView;

@end

@implementation MSImagePickerController

- (id)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void) commonInit {
    self.delegate = self;
    self.maxImageCount = 0;
    self.doneButtonTitle = @"Done";
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // PUCollectionView代理对象的共同基类(PUPhotosGridViewController)。
        [self doMagicOperation:@"PUPhotosGridViewController"];
    });
}

- (void) doMagicOperation:(NSString*) className {
    Class targetClass = [NSClassFromString(className) class];
    
    Method m1 = class_getInstanceMethod([self class], @selector(override_collectionView:cellForItemAtIndexPath:));
    
    class_addMethod(targetClass, @selector(override_collectionView:cellForItemAtIndexPath:), method_getImplementation(m1), method_getTypeEncoding(m1));
    
    Method m2 = class_getInstanceMethod(targetClass, @selector(override_collectionView:cellForItemAtIndexPath:));
    Method m3 = class_getInstanceMethod(targetClass, @selector(collectionView:cellForItemAtIndexPath:));
    
    method_exchangeImplementations(m2, m3);
}

- (Class)PUPhotoView {
    return NSClassFromString(@"PUPhotoView");
}

- (Class)PUCollectionView {
    return NSClassFromString(@"PUCollectionView");
}

- (NSMutableArray*)indexPaths {
    if (_indexPaths == nil) {
        _indexPaths = [NSMutableArray new];
    }
    
    return _indexPaths;
}

- (NSArray*)images {
    return _allImages;
}

- (UIBarButtonItem*)doneButton {
    if (_doneButton == nil) {
        _doneButton = [[UIBarButtonItem alloc] initWithTitle:self.doneButtonTitle
                                                       style:UIBarButtonItemStyleDone
                                                      target:self
                                                      action:@selector(done:)];
    }
    
    return _doneButton;
}

- (void)done:(id)sender {
    if ([self.msDelegate respondsToSelector:@selector(imagePickerControllerdidFinish:)]) {
        [self.msDelegate imagePickerControllerdidFinish:self];
    }
}

-(UIView *)getPUCollectionView:(UIView *)v {
    for (UIView *i in v.subviews) {
        if ([i isKindOfClass:self.PUCollectionView]) {
            return i;
        }
    }
    
    return nil;
}

- (UIButton *)getIndicatorButton:(UIView *) v {
    for (id b in v.subviews) {
        if ([b isKindOfClass:[UIButton class]]) {
            return (UIButton *)b;
        }
    }
    
    return nil;
}

/**
 *  增加被选中的标记
 *
 *  @param v
 */
- (void)addIndicatorButton:(UIView *)v {
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = 15;
    
    [button setImage:[UIImage imageNamed:@"MSImagePickerController.bundle/AssetsPickerChecked"]
            forState:UIControlStateNormal];
    [v addSubview:button];
    
    [button setTranslatesAutoresizingMaskIntoConstraints:false];
    
    NSArray* cs1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(30)]-1-|"
                                                           options:0 metrics:nil
                                                             views:NSDictionaryOfVariableBindings(button)];
    
    NSArray* cs2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[button(30)]-1-|"
                                                           options:0 metrics:nil
                                                             views:NSDictionaryOfVariableBindings(button)];
    
    [v addConstraints:cs1];
    [v addConstraints:cs2];
    
    [button setSelected:true];
    button.hidden = false;
    
    [v updateConstraintsIfNeeded];
}


/**
 *  移除被选中的标记。
 *
 *  @param v
 */
- (void) removeIndicatorButton:(UIView*)v {
    for (UIView* b in v.subviews) {
        if ([b isKindOfClass:[UIButton class]]) {
            [b removeFromSuperview];
            return;
        }
    }
}

- (void) addCurrentImage:(UIImage*) image {
    NSInteger index = [self isCurIndexInIndexPaths];
    
    if (index == NSNotFound) {
        [self.allImages addObject:image];
        [self.indexPaths addObject:self.curIndexPath];
        
        UIView* cell = [self.collectionView cellForItemAtIndexPath:self.curIndexPath];
        [self addIndicatorButton:cell];
    }
}

- (void) removeCurrentImage {
    NSInteger index = [self isCurIndexInIndexPaths];
    
    if (index != NSNotFound) {
        [self.allImages removeObjectAtIndex:index];
        [self.indexPaths removeObjectAtIndex:index];
        
        UIView* cell = [self.collectionView cellForItemAtIndexPath:self.curIndexPath];
        [self removeIndicatorButton:cell];
    }
}

- (NSMutableArray*) allImages {
    if (_allImages == nil) {
        _allImages = [NSMutableArray new];
    }

    return _allImages;
}

- (void) clearStatus {
    self.curIndexPath = nil;
    self.lastDelegate = nil;
    self.collectionView = nil;
    [self.allImages removeAllObjects];
    [self.indexPaths removeAllObjects];
}



/**
 * 查找当前的indexPath是否已经被添加过。
 */
- (NSInteger) isCurIndexInIndexPaths {
    for (int i = 0; i < self.indexPaths.count; i++) {
        if (((NSIndexPath*)self.indexPaths[i]).row == self.curIndexPath.row &&
            ((NSIndexPath*)self.indexPaths[i]).section == self.curIndexPath.section) {
            return i;
        }
    }
    
    return NSNotFound;
}

#pragma mark - UICollectionViewDataSource method
/**
 *  注意，这个函数的self指针指向的是PUCollectionView的代理对象上。因为我已经将这个函数添加上去了。
 *  重写这个函数是因为cell的重用机制导致选择标记可能会错误的被使用。所以需要在cell被重用时重新添加或删除标记。
 *
 *  @return
 */
- (UICollectionViewCell *)override_collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath; {
    MSImagePickerController* picker = (MSImagePickerController*)objc_getAssociatedObject(self, &attachSelfKey);
    
    // 调用原始的collectionView:cellForItemAtIndexPath:函数去获得cell。
    UICollectionViewCell* cell = [self performSelector:@selector(override_collectionView:cellForItemAtIndexPath:)
                                            withObject:collectionView
                                            withObject:indexPath];
    
    if (picker != nil) {
        picker.curIndexPath = indexPath;
        if ([picker isCurIndexInIndexPaths] != NSNotFound) {
            UIButton* indicatorButton = [picker getIndicatorButton:cell];
            
            if (indicatorButton == nil) { // 如果cell已经有选择标记了就不用在添加了。
                [picker addIndicatorButton:cell];
            }
        } else {
            [picker removeIndicatorButton:cell];
        }
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate method
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    self.curIndexPath = indexPath;
    self.collectionView = collectionView;

    UIView *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    UIButton *indicatorButton = [self getIndicatorButton:cell];
    
    // 没有选择标记说明此时是打算选择这个图片，检查上限。
    if (indicatorButton == nil) {
        if ([self.images count] >= self.maxImageCount && self.maxImageCount != 0) { // 选择图片已经超过上限。
            if ([self.msDelegate respondsToSelector:@selector(imagePickerControllerOverMaxCount:)]) {
                [self.msDelegate imagePickerControllerOverMaxCount:self];
            }

            return NO;
        }
    }
    
    // 调用原始的collectionView:shouldSelectItemAtIndexPath:
    SEL sel = NSSelectorFromString([NSString stringWithFormat:@"%s", sel_getName(_cmd)]);
    if ([self.lastDelegate respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.lastDelegate performSelector:sel withObject:collectionView withObject:indexPath];
#pragma clang diagnostic pop
    }

    return YES;
}

#pragma mark - UINavigationControllerDelegate method
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated; {
    UIView *collection = [self getPUCollectionView:viewController.view];
    
    // 有可能改变确定按钮，需要禁用。I will fix it later.
    self.interactivePopGestureRecognizer.enabled = NO;
    
    // 进入的不是图片展示画面
    if (!collection) {
        return;
    }
    
    [self clearStatus];
    
    /**
     *  重新设置PUCollectionView的代理对象
     */
    self.lastDelegate = [collection valueForKey:@"delegate"];
    [collection setValue:self forKey:@"delegate"];
    
    // 将self指针attach到PUCollectionView的代理对象上。
    objc_setAssociatedObject(self.lastDelegate, &attachSelfKey, self, OBJC_ASSOCIATION_ASSIGN);
    
    self.lastDoneButton = viewController.navigationItem.rightBarButtonItem;
}

#pragma mark - UIImagePikcerControllerDelegate method
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo; {
    NSInteger idx = [self isCurIndexInIndexPaths];
    
    if (idx == NSNotFound) {
        if ([self.msDelegate respondsToSelector:@selector(imagePickerController:shouldSelectImage:)]) {
            if ([self.msDelegate imagePickerController:self shouldSelectImage:image]) {
                [self addCurrentImage:image];
            } else {
                return;
            }
        } else {
            [self addCurrentImage:image];
        }
    } else {
        [self removeCurrentImage];
    }
    
    if (self.images.count == 1) {// 选择第一张图片的时候改变按钮
        picker.topViewController.navigationItem.rightBarButtonItem = self.doneButton;
    } else if (self.images.count == 0) {
        picker.topViewController.navigationItem.rightBarButtonItem = self.lastDoneButton;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker; {
    if ([self.msDelegate respondsToSelector:@selector(imagePickerControllerDidCancel:)]) {
        [self.msDelegate imagePickerControllerDidCancel:self];
    }
}

#pragma mark - dealloc
- (void)dealloc
{
    self.lastDelegate = nil;
}

@end
