//
//  BLDetailTableViewController.m
//  WeShot
//
//  Created by bo LI on 12/14/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import "BLShotDetailTableViewController.h"
#import "BLDetailCommentCell.h"
#import "BLDetailNoCommentCell.h"
#import "BLShot.h"
#import "BLShotComment.h"
#import "BLShotsTool.h"
#import "BLShotsParams.h"
#import "BLDribbbleAPI.h"
#import "BLDetailHeaderView.h"

#import "NSString+BLExtension.h"
#import "NSString+BLNumber.h"
#import "BLProfileViewController.h"

#import <DALabeledCircularProgressView.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <YLGIFImage.h>
#import <YLImageView.h>

#define HTMLSTYLE @"<head><style>p{font-size: 14px;color: gray; line-height:130%}a{color:red; text-decoration: none;}</style></head>"
#define HTMLSTYLE2 @"<head><style>p{font-size: 15px;color: gray; line-height:130%}a{color:red; text-decoration: none;}</style></head>"

@interface BLShotDetailTableViewController ()<UITextViewDelegate>

@property (weak,nonatomic) BLDetailHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray* comments;
@property (nonatomic, weak) UIScrollView* scrollView;

@end

@implementation BLShotDetailTableViewController
static NSString* headerViewID = @"BLDetailHeaderView";
static NSString* commentCellID = @"BLDetailCommentCell";
static NSString* noCommentCellID = @"BLDetailNoCommentCell";

- (NSMutableArray*)comments {
    if (_comments == nil) {
        _comments = [NSMutableArray array];
    }
    return _comments;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAllComments];
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //NSLog(@"view will Appear");
}

- (void) setupTableView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = BLGlobalBg;
    self.navigationItem.title = @"SHOT";
    //add Header View
    NSArray* nibView = [[NSBundle mainBundle] loadNibNamed:headerViewID owner:nil options:nil];
    BLDetailHeaderView *headerView = [nibView firstObject];
    self.tableView.tableHeaderView = headerView;
    self.headerView = headerView;
    
    [self setupheaderViewContent];
    [headerView.likeBtn addTarget:self action:@selector(likeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [BLShotsTool islikeShotWithUserID:self.shot.sid success:^(id responseObject) {
            [headerView.likeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        headerView.likeBtn.tag = 1;
    } failure:^(NSError *error) {
        [headerView.likeBtn setImage:[UIImage imageNamed:@"redunlike"] forState:UIControlStateNormal];
        headerView.likeBtn.tag = 0;
    }];
}

- (void)setupheaderViewContent {
    _headerView.username.text = self.shot.user.username;
    NSString* shotImageURLStr = self.shot.images.hidpi?self.shot.images.hidpi:self.shot.images.normal;
    NSString* avatorImageUrlStr = self.shot.user.avatar_url;
    NSString* locationTitle = self.shot.user.location ? self.shot.user.location : @"unknow";
    [_headerView.location setTitle:locationTitle forState:UIControlStateNormal];
    
    if (self.shot.animated) {
        _headerView.shotImage.hidden = YES;
        _headerView.GifImageView.hidden = NO;
        _headerView.progressView.hidden = NO;
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:shotImageURLStr] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            //NSLog(@"receive size %zd",receivedSize);
            [_headerView.progressView setProgress:1.0*receivedSize/expectedSize animated:YES];
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _headerView.progressView.hidden = YES;
                _headerView.GifImageView.image = [YLGIFImage imageWithData:data];
            });
        }];
        
    } else {
        _headerView.shotImage.hidden = NO;
        _headerView.GifImageView.hidden = YES;
        [_headerView.shotImage sd_setImageWithURL:[NSURL URLWithString:shotImageURLStr] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            _headerView.progressView.hidden = NO;
            [_headerView.progressView setProgress:1.0*receivedSize/expectedSize animated:YES];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            _headerView.progressView.hidden = YES;
            
        }];
    }
    
    [_headerView.headImgView sd_setImageWithURL:[NSURL URLWithString:avatorImageUrlStr]
                        placeholderImage:nil];
    _headerView.shotTitle.text = self.shot.title;
    NSString* commentHTMLStr = [NSString stringWithFormat:@"%@%@",HTMLSTYLE2,self.shot.detailContent];
    if (self.shot.detailContent){
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSAttributedString * strAtt = [[NSAttributedString alloc]
                                           initWithData: [commentHTMLStr dataUsingEncoding:NSUnicodeStringEncoding]
                                           options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                           documentAttributes: nil
                                           error: nil
                                           ];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_headerView.shotdetail setContentInset:UIEdgeInsetsMake(-10, -5, -15, -5)];
                _headerView.shotdetail.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor redColor]};
                _headerView.shotdetail.delegate = self;
                self.tableView.tableHeaderView.height = 140 + 3*ScreenSize.width/4 +[strAtt boundingRectWithSize:CGSizeMake(ScreenSize.width-32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
                _headerView.shotdetail.attributedText = strAtt;
                [self.tableView.tableHeaderView layoutIfNeeded];
            });
            
        });
        
    }
    
    
    _headerView.create_time_label.text = [NSString stringWithDate:self.shot.created_at];
    
    _headerView.shotInfo.text = [NSString stringWithFormat:@"%@ comments    %@ views    %@ likes",[NSString stringWithIntger:self.shot.comments_count], [NSString stringWithIntger:self.shot.views_count], [NSString stringWithIntger:self.shot.likes_count]];
    [_headerView.headBtn addTarget:self action:@selector(headerBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void) loadAllComments{
    BLShotsParams* params = [[BLShotsParams alloc]init];
    params.access_token = OAuth2_CLIENT_ACCESS_TOKEN;
    NSString* pageStr = [NSString stringWithFormat:@"page=1&per_page=%zd",PER_PAGE];
    
    [BLShotsTool commentWithURLStr:self.shot.comments_url Params:params pageStr:pageStr Success:^(NSArray *shotsArray) {
        [self.comments addObjectsFromArray:shotsArray];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"comment:%@",error.localizedDescription);
    }];
}





#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count ?: 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Comment cell
    if (self.comments.count == 0) {
        BLDetailNoCommentCell* cell = [tableView dequeueReusableCellWithIdentifier:noCommentCellID];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:noCommentCellID owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        return cell;
    }
    
    BLDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellID];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:commentCellID owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    BLShotComment* comment = self.comments[indexPath.row];
    [cell.userImage sd_setImageWithURL:[NSURL URLWithString:comment.user.avatar_url] placeholderImage:nil];
    cell.username.text = comment.user.username;
    cell.headerBtn.tag = indexPath.row;
    [cell.headerBtn addTarget:self action:@selector(commentheaderBtn:) forControlEvents:UIControlEventTouchUpInside];

    cell.comment.delegate = self;
    NSString* commentHTMLStr = [NSString stringWithFormat:@"%@%@",HTMLSTYLE,comment.body];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSAttributedString * strAtt = [[NSAttributedString alloc]
                                           initWithData: [commentHTMLStr dataUsingEncoding:NSUnicodeStringEncoding]
                                           options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                           documentAttributes: nil
                                           error: nil
                                           ];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.comment.attributedText = strAtt;
            });
            
        });
        
    return cell;
}

- (void)headerBtn{
    BLProfileViewController* vc = [[BLProfileViewController alloc]init];
    vc.userid = [NSString stringWithFormat:@"%ld",(long)self.shot.user.uid];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)commentheaderBtn:(UIButton*)sender {
    BLProfileViewController* vc = [[BLProfileViewController alloc]init];
    BLShotComment* comment = self.comments[sender.tag];
    vc.userid = [NSString stringWithFormat:@"%ld",(long)comment.user.uid];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //if (indexPath.row == 0) {
      //  return self.shot.detailCellHeight;
    //}
    if (self.comments.count == 0) {
        return 30;
    }
    BLShotComment* shotComent = self.comments[indexPath.row];
    return shotComent.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)likeBtn:(UIButton*)sender{
    if (sender.tag) {
        sender.tag = 0;
        [self.headerView.likeBtn setImage:[UIImage imageNamed:@"redunlike"] forState:UIControlStateNormal];
        [BLShotsTool unlikeShotWithUserID:self.shot.sid success:^(id responseObject) {
            
        } failure:^(NSError *error) {
            sender.tag = 1;
            [self.headerView.likeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
            NSLog(@"unlike btn fail:%@",error.localizedDescription);
        }];
    } else {
        sender.tag = 1;
        [self.headerView.likeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        [BLShotsTool likeShotWithUserID:self.shot.sid success:^(id responseObject) {
            
        } failure:^(NSError *error) {
            sender.tag = 0;
            [self.headerView.likeBtn setImage:[UIImage imageNamed:@"redunlike"] forState:UIControlStateNormal];
            NSLog(@"like btn fail:%@",error.localizedDescription);
        }];
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    if ([[URL host] isEqualToString:@"dribbble.com"]) {
        NSString* userID = [[[URL absoluteString] componentsSeparatedByString:@"/"] lastObject];
        BLProfileViewController *vc = [BLProfileViewController new];
        vc.userid = userID;
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    } else {
        return YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
    // Dispose of any resources that can be recreated.
}

@end
