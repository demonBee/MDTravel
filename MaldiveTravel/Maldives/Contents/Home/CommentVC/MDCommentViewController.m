//
//  MDCommentViewController.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/17.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDCommentViewController.h"
#import "MDTouchShowImageView.h"
#import "MDTextView.h"
#import "TZImagePickerController.h"

@interface MDCommentViewController ()<UITextViewDelegate,TZImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet MDTextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIButton *hideNmaeBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (nonatomic,strong)UILabel * photoLabel;

@property (nonatomic,assign)BOOL isHiddeName;
@property (nonatomic,strong)NSMutableArray * photoArr;
@property (nonatomic,strong)NSMutableArray * picUrlArr;
@property (nonatomic,assign)NSInteger picUpCount;
@property (nonatomic,assign)NSInteger selectPhotoCount;

@property (nonatomic,assign)CGFloat conformCount;
@property (nonatomic,assign)CGFloat serviceCount;

//tag:相册展示按钮1-4;描述相符:10-14;服务态度15-19

@end

@implementation MDCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发表评论";
    [self makeUI];
    [self.commentTextView becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.alpha = 1.f;
}

- (void)makeUI{
    self.photoArr = [NSMutableArray arrayWithCapacity:0];
    self.conformCount = 5.f;
    self.serviceCount = 5.f;
    
    self.photoLabel = [[UILabel alloc]initWithFrame:CGRectMake(70.f + 10.f, CGRectGetMaxY(self.commentTextView.frame) + 30.f + 64.f, 45.f, 20.f)];
    self.photoLabel.text = @"发照片";
    self.photoLabel.textColor = [UIColor lightGrayColor];
    self.photoLabel.font = [UIFont systemFontOfSize:15.f];
    [self.view addSubview:self.photoLabel];
    
    self.sendBtn.layer.cornerRadius = 5.f;
    self.sendBtn.layer.masksToBounds = YES;
    
    self.commentTextView.placeholder = @"亲,写下您对该酒店的印象吧。(超过100字并附照片可升级为游记获取更多积分哟)";
    self.commentTextView.placeholderColor = [UIColor lightGrayColor];
    
    for (int i = 10; i <= 19; i++) {
        MDTouchShowImageView * imageView = [self.view viewWithTag:i];
        imageView.touchBlock = ^(NSInteger imgTag,CGFloat commentCount){
            if (imgTag <=14) {
                //描述相符
                self.conformCount = imgTag - 10 + commentCount;
                for (NSInteger j = 10; j<= 14; j++) {
                    if (j!=imgTag) {
                        MDTouchShowImageView * likeImageView = [self.view viewWithTag:j];
                        if (j<imgTag) {
                            likeImageView.image = [UIImage imageNamed:@"icon-like"];
                        }else{
                            likeImageView.image = [UIImage imageNamed:@"icon-dislike"];
                        }
                    }
                }
            }else{
                //服务态度
                self.serviceCount = imgTag - 15 + commentCount;
                for (NSInteger j = 15; j<= 19; j++) {
                    if (j!=imgTag) {
                        MDTouchShowImageView * likeImageView = [self.view viewWithTag:j];
                        if (j<imgTag) {
                            likeImageView.image = [UIImage imageNamed:@"icon-like"];
                        }else{
                            likeImageView.image = [UIImage imageNamed:@"icon-dislike"];
                        }
                    }
                }
            }
            
        };
    }
    
}

- (void)setCameraImage:(UIImage *)cameraImage{
    if (!cameraImage)return;
    if (self.photoArr.count == 4||self.photoArr.count - 1 >= self.selectPhotoCount) {
        [self.photoArr replaceObjectAtIndex:self.selectPhotoCount withObject:cameraImage];
    }else{
        [self.photoArr addObject:cameraImage];
    }
    [self photoSet];
}
- (void)makeLocalImagePicker{
    TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:4 - self.selectPhotoCount delegate:self];
    imagePickerVC.allowPickingVideo = NO;
    [imagePickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto) {
        NSMutableArray * photoTempArr = [NSMutableArray arrayWithCapacity:0];
        for (NSInteger i = self.selectPhotoCount; i < photos.count + self.selectPhotoCount; i++) {
            if (i < self.photoArr.count) {
                [self.photoArr replaceObjectAtIndex:i withObject:photos[i - self.selectPhotoCount]];
            }else{
                [photoTempArr addObject:photos[i - self.selectPhotoCount]];
            }
        }
        [self.photoArr addObjectsFromArray:photoTempArr];
        [self photoSet];
    }];
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)photoSet{
    self.photoLabel.x = 70.f * (self.photoArr.count >= 4?self.photoArr.count:(self.photoArr.count + 1)) + 10.f;
    if (self.photoArr.count < 4) {
        UIButton * btn = [self.view viewWithTag:self.photoArr.count + 1];
        btn.hidden = NO;
    }
    
    for (int i = 1; i <= self.photoArr.count; i++) {
        UIButton * btn = [self.view viewWithTag:i];
        btn.hidden = NO;
        [btn setImage:self.photoArr[i-1] forState:UIControlStateNormal];
    }
    
}

- (IBAction)photoBtnAction:(UIButton *)sender {
    self.selectPhotoCount = sender.tag - 1;
    [self makePhotoTake];
}

- (IBAction)hideBtnAction:(id)sender {
    self.isHiddeName = !self.isHiddeName;
    if (self.isHiddeName) {
        self.hideNmaeBtn.backgroundColor = [UIColor redColor];
    }else{
        self.hideNmaeBtn.backgroundColor = [UIColor colorWithHexString:@"#d6d6d6"];
    }
}
- (IBAction)sendCommentBtnAction:(id)sender {
    [self canSendComment];
}

- (void)canSendComment{
    if ([self.commentTextView.text isEqualToString:@""]) {
        [self showHUDWithStr:@"请填写评价" withSuccess:NO];
        return;
    }
    [self.view setUserInteractionEnabled:NO];
    [self.navigationController.navigationBar setUserInteractionEnabled:NO];
    if (self.photoArr.count <=0) {
        [self requestSendCommentAfterSendPic];
        return;
    }else{
        self.picUrlArr = [self.photoArr mutableCopy];
        for (NSInteger i = 0; i < self.photoArr.count; i++) {
            [self requestSendCommentPicWithIndex:i];
        }
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSLog(@"%zi",textView.text.length);
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        [self canSendComment];
    }
    
    return YES;
}

#pragma mark - HTTP
- (void)requestSendCommentPicWithIndex:(NSInteger)index{
    NSDictionary * pragram = @{@"uid":[UserSession instance].token,@"name":@"File"};
    [[HttpObject manager]postPhotoWithType:MaldivesType_COMMENT_PHOTO withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        self.picUpCount++;
        [self.picUrlArr replaceObjectAtIndex:index withObject:responsObj[@"data"]];
        if (self.picUpCount >= self.photoArr.count) {
            [self requestSendCommentAfterSendPic];
        }
    } failur:^(id errorData, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",errorData);
        MyLog(@"Error is %@",error);
        [self showHUDWithStr:@"Faild" withSuccess:NO];
        [self.view setUserInteractionEnabled:YES];
        [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    } withPhoto:UIImagePNGRepresentation(self.photoArr[index])];
    
}

- (void)requestSendCommentAfterSendPic{
    NSString * sendCount = [NSString stringWithFormat:@"%.1f",(self.conformCount + self.serviceCount)/2];
    NSString * pic = @"";
    if (self.photoArr.count > 0) {
        pic = [NSString stringWithFormat:@"%@",self.picUrlArr[0]];
        for (int i = 1; i < self.photoArr.count; i++) {
            pic = [NSString stringWithFormat:@"%@,%@",pic,self.picUrlArr[i]];
        }
    }
    
    NSDictionary * pragram = @{@"id":self.idd,@"uid":[UserSession instance].token,@"con":self.commentTextView.text,@"pic":pic,@"fen":sendCount,@"anony":[NSString stringWithFormat:@"%zi",self.isHiddeName]};
    [[HttpObject manager]getDataWithType:self.isEvent?MaldivesType_EVENT_COMMENT_ADD:MaldivesType_HOTEL_COMMENT_ADD withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        //请求成功,获取积分
        [self showHUDWithStr:responsObj[@"errorMessage"] withSuccess:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.view setUserInteractionEnabled:YES];
            [self.navigationController.navigationBar setUserInteractionEnabled:YES];
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failur:^(id errorData, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",errorData);
        MyLog(@"Error is %@",error);
        [self.view setUserInteractionEnabled:YES];
        [self showHUDWithStr:@"评论失败" withSuccess:NO];
        [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    }];
}



@end
