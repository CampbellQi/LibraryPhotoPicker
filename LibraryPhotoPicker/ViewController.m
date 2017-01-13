//
//  ViewController.m
//  LibraryPhotoPicker
//
//  Created by 冯万琦 on 2017/1/12.
//  Copyright © 2017年 yidian. All rights reserved.
//

#import "ViewController.h"
#import "WQCombinationPickerViewController.h"

@interface ViewController ()<WQCombinationPickerViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)chooseBtnClicked:(id)sender {
    WQCombinationPickerViewController *vc = [[WQCombinationPickerViewController alloc] init];
    vc.delegate = self;
    vc.maxSelCount = 1;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark- ODMCombinationPickerViewController delegate
-(void)imagePickerController:(WQCombinationPickerViewController *)picker didFinishPickingImageArray:(NSArray *)images {
    [picker dismissViewControllerAnimated:YES completion:^{
        for (UIImage *image in images) {
            self.imageView.image = image;
        }
        
    }];
}
-(void)imagePickerController:(WQCombinationPickerViewController *)picker didFinishPickingImage:(UIImage *)image {
    [picker dismissViewControllerAnimated:YES completion:^{
        self.imageView.image = image;
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
