MSImagePickerController
=================
A subclass of UIImagePickerController that support multi select. (一个支持多选的UIImagePickerController的子类)

## Example
<img src="https://github.com/Jameson-zxm/MSImagePickerController/blob/master/demo.gif" width="220" height="395" />

## How it works
The PUCollectionView's superclass is UICollectionView, so i rest it's delegate and implemention the method
```objc
collectionView:shouldSelectItemAtIndexPath:
```
<img src="https://github.com/Jameson-zxm/MSImagePickerController/blob/master/howitworks.png" width="406" height="324" />

## Installation

```ruby
pod 'MSImagePickerController', :git => 'https://github.com/roshanman/MSImagePickerController.git'
```

### Import
```objc
#import "MSImagePickerController.h"
```
### Protocol Conformance
Conform to delegate.
```objc
@interface ViewController : UIViewController <MSImagePickerControllerDelegate>

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MSImagePickerController* picker = [[MSImagePickerController alloc] init];
    picker.msDelegate = self;
    picker.maxImageCount = 3;
    picker.doneButtonTitle = @"OK";
}

- (void)imagePickerControllerDidCancel:(MSImagePickerController *)picker; {
    NSLog(@"do cancel");
}

- (void)imagePickerControllerdidFinish:(MSImagePickerController *)picker {
    NSLog(@"%@", picker.images);
}

- (void)imagePickerControllerOverMaxCount:(MSImagePickerController *)picker {
    NSLog(@"over max count:%ld", picker.maxImageCount);
}
```

## Contact me
mail: morenotepad@163.com

## License
(The MIT License)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
