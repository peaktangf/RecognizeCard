//
//  RecognizeCardViewController.m
//  RecognizeCard
//
//  Created by 谭高丰 on 16/8/31.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "RecognizeCardViewController.h"
#import "RecogizeCardManager.h"

@interface RecognizeCardViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    UIImagePickerController *imgagePickController;
}

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
- (IBAction)cameraAction:(id)sender;
- (IBAction)photoAction:(id)sender;

@end

@implementation RecognizeCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    
    imgagePickController = [[UIImagePickerController alloc] init];
    imgagePickController.delegate = self;
    imgagePickController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    imgagePickController.allowsEditing = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//拍照
- (IBAction)cameraAction:(id)sender {
    
    //判断是否可以打开照相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imgagePickController.sourceType = UIImagePickerControllerSourceTypeCamera;
        //设置摄像头模式（拍照，录制视频）为拍照
        imgagePickController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        [self presentViewController:imgagePickController animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设备不能打开相机" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
}

//相册
- (IBAction)photoAction:(id)sender {
    imgagePickController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imgagePickController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    UIImage *srcImage = nil;
    //判断资源类型
    if ([mediaType isEqualToString:@"public.image"]){
        srcImage = info[UIImagePickerControllerEditedImage];
        self.imgView.image = srcImage;
        //识别身份证
        self.textLabel.text = @"图片插入成功，正在识别中...";
        [[RecogizeCardManager recognizeCardManager] recognizeCardWithImage:srcImage compleate:^(NSString *text) {
            if (text != nil) {
                self.textLabel.text = [NSString stringWithFormat:@"识别结果：%@",text];
            }else {
                self.textLabel.text = @"请选择照片";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"照片识别失败，请选择清晰、没有复杂背景的身份证照片重试！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                [alert show];
            }
        }];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//进入拍摄页面点击取消按钮
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
