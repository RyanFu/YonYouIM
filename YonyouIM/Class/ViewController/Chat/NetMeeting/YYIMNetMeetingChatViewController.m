//
//  YYIMNetMeetingChatViewController.m
//  YonyouIM
//
//  Created by yanghaoc on 16/4/27.
//  Copyright © 2016年 yonyou. All rights reserved.
//

#import "YYIMNetMeetingChatViewController.h"
#import "YYIMColorHelper.h"
#import "YYIMNetMeetingChatCell.h"
#import "UIImageView+WebCache.h"
#import "UIImage+YYIMCategory.h"
#import "YYIMHeadPhonesManager.h"

@interface YYIMNetMeetingChatViewController ()

//------------------------view-----------------------------
//collectionView用于展示成员视图
@property (strong, nonatomic) UICollectionView *collectionVideoView;
//------------------------bottom view-----------------------------
@property (strong, nonatomic) UIView *audioMuteView;

@property (strong, nonatomic) UIView *cameraControlView;

@property (strong, nonatomic) UIView *speakererView;

@property (strong, nonatomic) UIButton *hangUpButton;
//------------------------buttons-----------------------------
//静音按钮组
@property (strong, nonatomic) UIButton *audioMuteButton;
//摄像头按钮
@property (strong, nonatomic) UIButton *cameraControlButton;
//------------------------label-----------------------------

@property (strong, nonatomic) UILabel *idLabel;

@property (strong, nonatomic) UILabel *channelLabel;

@property (strong, nonatomic) UIImageView *teleImageView;

@property (strong, nonatomic) UIImageView *topicImageView;

#pragma mark -
#pragma mark data

//------------------------data-----------------------------
//是否是管理员
@property (strong, nonatomic) YYNetMeetingMember *memberSelf;
//主屏幕视频用户id
@property (strong, nonatomic) NSString *mainUserid;
//当前房间里的人员集合
@property (strong, nonatomic) NSMutableArray *channelOnlineMenber;

@end

@implementation YYIMNetMeetingChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initCollectinView];
    
    //sdk默认是开启视频的，所以如果希望使用语音模式，需要主动关闭视频
    if (self.netMeeting.netMeetingMode == kYYIMNetMeetingModeAudio) {
        [self.cameraControlButton setSelected:NO];
    } else {
        [self.cameraControlButton setSelected:YES];
    }
    
    [[YYIMChat sharedInstance].chatManager setNetMeetingProfile:kYYIMNetMeetingProfileFree];
    [[YYIMChat sharedInstance].chatManager enableNetMeetingVideo];
    [[YYIMChat sharedInstance].chatManager enterNetMeeting:self.channelId];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadAllData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldKeepDelegate {
    return YES;
}

#pragma mark -
#pragma mark initView
- (void)initTopView {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 36, self.fullViewWidth, 70)];
    
    UIButton *camaraSwitch = [[UIButton alloc] initWithFrame:CGRectMake(self.fullViewWidth - 56, 0, 40, 40)];
    [camaraSwitch setImage:[UIImage imageNamed:@"icon_netmeeting_camera_switch"] forState:UIControlStateNormal];
    [camaraSwitch addTarget:self action:@selector(switchCamera) forControlEvents:UIControlEventTouchUpInside];
    [camaraSwitch setImageEdgeInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    
    [topView addSubview:camaraSwitch];
    
    UIButton *windowSwitch = [[UIButton alloc] initWithFrame:CGRectMake(self.fullViewWidth - 100, 0, 40, 40)];
    [windowSwitch setImage:[UIImage imageNamed:@"icon_neetmeeting_minimize"] forState:UIControlStateNormal];
    [windowSwitch addTarget:self action:@selector(minimize) forControlEvents:UIControlEventTouchUpInside];
    
    [topView addSubview:windowSwitch];
    
    NSString *channelIdShow = @"";
    CGFloat topSpace = 50.0f;
    
    if (self.netMeeting.netMeetingType == kYYIMNetMeetingTypeSingleChat && self.memberSelf.isModerator) {
        channelIdShow = @"等待对方加入...";
    } else if (self.netMeeting.netMeetingType == kYYIMNetMeetingTypeSingleChat && !self.memberSelf.isModerator) {
        channelIdShow = @"";
        topSpace = 6.0f;
    }
    
    self.channelLabel = [[UILabel alloc] init];
    [self.channelLabel setFont:[UIFont systemFontOfSize:18]];
    [self.channelLabel setTextColor:UIColorFromRGB(0xffffff)];
    [self.channelLabel setTextAlignment:NSTextAlignmentLeft];
    [self.channelLabel setText:channelIdShow];
    
    CGSize channelSize = [self.channelLabel sizeThatFits:CGSizeMake(self.fullViewWidth - 150, MAXFLOAT)];
    [self.channelLabel setFrame:CGRectMake(16, 6, channelSize.width, 28)];
    
    [topView addSubview:self.channelLabel];
    
    self.teleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, topSpace + 4, 12, 12)];
    [self.teleImageView setImage:[UIImage imageNamed:@"icon_netmeeting_tele"]];
    [topView addSubview:self.teleImageView];
    
    self.signalImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, topSpace + 4, 12, 12)];
    [self.signalImageView setImage:[UIImage imageNamed:@"icon_netmeeting_signal_good"]];
    [topView addSubview:self.signalImageView];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, topSpace, 100, 20)];
    [self.timeLabel setFont:[UIFont systemFontOfSize:14]];
    [self.timeLabel setTextColor:UIColorFromRGB(0xffffff)];
    [self.timeLabel setTextAlignment:NSTextAlignmentLeft];
    [self.timeLabel setText:@"00:00"];
    [topView addSubview:self.timeLabel];
    
    [self.view addSubview:topView];
}

- (void)initBottonView {
    UIView *bottomVIew = [[UIView alloc] initWithFrame:CGRectMake(0, self.fullViewHeight - YM_NETMEETING_BOTTOM_HEIGHT, self.fullViewWidth, YM_NETMEETING_BOTTOM_HEIGHT)];
    [bottomVIew setBackgroundColor:UIColorFromRGBA(0x000000, 0.5)];
    
    //audioMuteView
    self.audioMuteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, YM_NETMEETING_IMAGE_SIZE, YM_NETMEETING_IMAGE_SIZE)];
    [self.audioMuteButton setImage:[UIImage imageNamed:@"icon_netmeeting_audio_normal"] forState:UIControlStateNormal];
    [self.audioMuteButton setImage:[UIImage imageNamed:@"icon_netmeeting_audio_highlight"] forState:UIControlStateSelected];
    [self.audioMuteButton addTarget:self action:@selector(didClickAudioMuteButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *audioMuteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, YM_NETMEETING_IMAGE_SIZE, YM_NETMEETING_VIEW_WIDTH, YM_NETMEETING_VIEW_HEIGHT - YM_NETMEETING_IMAGE_SIZE)];
    [audioMuteLabel setFont:[UIFont systemFontOfSize:14]];
    [audioMuteLabel setTextColor:UIColorFromRGB(0xffffff)];
    [audioMuteLabel setTextAlignment:NSTextAlignmentCenter];
    [audioMuteLabel setText:@"静音"];
    
    self.audioMuteView = [[UIView alloc] init];
    [self.audioMuteView addSubview:self.audioMuteButton];
    [self.audioMuteView addSubview:audioMuteLabel];
    
    //cameraControlView
    self.cameraControlButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, YM_NETMEETING_IMAGE_SIZE, YM_NETMEETING_IMAGE_SIZE)];
    [self.cameraControlButton setImage:[UIImage imageNamed:@"icon_netmeeting_camera_normal"] forState:UIControlStateNormal];
    [self.cameraControlButton setImage:[UIImage imageNamed:@"icon_netmeeting_camera_highlight"] forState:UIControlStateSelected];
    [self.cameraControlButton addTarget:self action:@selector(didClickCameraControlButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *cameraControlLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, YM_NETMEETING_IMAGE_SIZE, YM_NETMEETING_VIEW_WIDTH, YM_NETMEETING_VIEW_HEIGHT - YM_NETMEETING_IMAGE_SIZE)];
    [cameraControlLabel setFont:[UIFont systemFontOfSize:14]];
    [cameraControlLabel setTextColor:UIColorFromRGB(0xffffff)];
    [cameraControlLabel setTextAlignment:NSTextAlignmentCenter];
    [cameraControlLabel setText:@"视频"];
    
    self.cameraControlView = [[UIView alloc] init];
    [self.cameraControlView addSubview:self.cameraControlButton];
    [self.cameraControlView addSubview:cameraControlLabel];
    
    //speakererView
    self.speakererButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, YM_NETMEETING_IMAGE_SIZE, YM_NETMEETING_IMAGE_SIZE)];
    [self.speakererButton setImage:[UIImage imageNamed:@"icon_netmeeting_speaker_normal"] forState:UIControlStateNormal];
    [self.speakererButton setImage:[UIImage imageNamed:@"icon_netmeeting_speaker_highlight"] forState:UIControlStateSelected];
    [self.speakererButton addTarget:self action:@selector(didClickSpeakererButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //视频会议默认开启扬声器，语音默认关闭扬声器
    if (self.netMeeting.netMeetingMode == kYYIMNetMeetingModeAudio) {
        [self.speakererButton setSelected:NO];
    } else {
        [self.speakererButton setSelected:YES];
    }
    
    UILabel *speakererLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, YM_NETMEETING_IMAGE_SIZE, YM_NETMEETING_VIEW_WIDTH, YM_NETMEETING_VIEW_HEIGHT - YM_NETMEETING_IMAGE_SIZE)];
    [speakererLabel setFont:[UIFont systemFontOfSize:14]];
    [speakererLabel setTextColor:UIColorFromRGB(0xffffff)];
    [speakererLabel setTextAlignment:NSTextAlignmentCenter];
    [speakererLabel setText:@"免提"];
    
    self.speakererView = [[UIView alloc] init];
    [self.speakererView addSubview:self.speakererButton];
    [self.speakererView addSubview:speakererLabel];
    
    //hangUpButton
    self.hangUpButton = [[UIButton alloc] init];
    [self.hangUpButton setImage:[UIImage imageNamed:@"icon_netmeeting_reject"] forState:UIControlStateNormal];
    [self.hangUpButton addTarget:self action:@selector(didClickHangUpButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *childTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.fullViewWidth, YM_NETMEETING_BOTTOM_HEIGHT / 2)];
    [childTopView setBackgroundColor:[UIColor clearColor]];
    UIView *childbottomView = [[UIView alloc] initWithFrame:CGRectMake(0, YM_NETMEETING_BOTTOM_HEIGHT / 2, self.fullViewWidth, YM_NETMEETING_BOTTOM_HEIGHT / 2)];
    [childbottomView setBackgroundColor:[UIColor clearColor]];
    
    [childTopView addSubview:self.audioMuteView];
    [childTopView addSubview:self.cameraControlView];
    [childTopView addSubview:self.speakererView];
    
    [childbottomView addSubview:self.hangUpButton];
    
    [bottomVIew addSubview:childTopView];
    [bottomVIew addSubview:childbottomView];
    
    [self.view addSubview:bottomVIew];
}

- (void)layoutBottonView {
    //上三，下一
    self.audioMuteView.hidden = NO;
    self.cameraControlView.hidden = NO;
    self.speakererView.hidden = NO;
    
    CGFloat space1 = (self.fullViewWidth - 2 * YM_NETMEETING_VIEW_MARGIN - 3 * YM_NETMEETING_VIEW_WIDTH) / 2;
    
    [self.audioMuteView setFrame:CGRectMake(YM_NETMEETING_VIEW_MARGIN, 0, YM_NETMEETING_VIEW_WIDTH, YM_NETMEETING_VIEW_HEIGHT)];
    [self.cameraControlView setFrame:CGRectMake(YM_NETMEETING_VIEW_MARGIN + YM_NETMEETING_VIEW_WIDTH + space1, 0, YM_NETMEETING_VIEW_WIDTH, YM_NETMEETING_VIEW_HEIGHT)];
    [self.speakererView setFrame:CGRectMake(YM_NETMEETING_VIEW_MARGIN + 2 * (YM_NETMEETING_VIEW_WIDTH + space1), 0, YM_NETMEETING_VIEW_WIDTH, YM_NETMEETING_VIEW_HEIGHT)];
    
    [self.hangUpButton setFrame:CGRectMake((self.fullViewWidth - YM_NETMEETING_HANGUP_SIZE) / 2, 10, YM_NETMEETING_HANGUP_SIZE, YM_NETMEETING_HANGUP_SIZE)];
}

- (void)initCollectinView {
    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    [collectionViewLayout setItemSize:CGSizeMake(80, 80)];
    [collectionViewLayout setMinimumInteritemSpacing:0];
    [collectionViewLayout setMinimumLineSpacing:0];
    [collectionViewLayout setSectionInset:UIEdgeInsetsZero];
    [collectionViewLayout setScrollDirection:(UICollectionViewScrollDirectionHorizontal)];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20.0f, self.fullViewHeight - 260, self.fullViewWidth - 40, 80) collectionViewLayout:collectionViewLayout];
    [collectionView setDelegate:self];
    [collectionView setDataSource:self];
    [collectionView setAllowsMultipleSelection:NO];
    [collectionView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:collectionView];
    self.collectionVideoView = collectionView;
    
    // 注册Cell nib
    [self.collectionVideoView registerNib:[UINib nibWithNibName:@"YYIMNetMeetingChatCell" bundle:nil] forCellWithReuseIdentifier:@"YYIMNetMeetingChatCell"];
}

#pragma mark -
#pragma mark action

- (void)didClickAudioMuteButton:(UIButton *)btn {
    self.memberSelf = [[YYIMChat sharedInstance].chatManager getNetMeetingMemberWithChannelId:self.channelId memberId:[[YYIMConfig sharedInstance] getUser]];
    
    BOOL mute = !btn.selected;
    
    [self.audioMuteButton setSelected:mute];
    [[YYIMChat sharedInstance].chatManager muteNetMeetingLocalAudioStream:mute];
    if (mute) {
        [[YYIMChat sharedInstance].chatManager closeNetMeetingAudio:self.channelId];
    } else {
        [[YYIMChat sharedInstance].chatManager openNetMeetingAudio:self.channelId];
    }
    
}

- (void)didClickCameraControlButton:(UIButton *)btn {
    BOOL showVideo = !btn.selected;
    
    [self.cameraControlButton setSelected:showVideo];
    [[YYIMChat sharedInstance].chatManager muteNetMeetingLocalVideoStream:!showVideo];
    
    if (showVideo) {
        [[YYIMChat sharedInstance].chatManager openNetMeetingVideo:self.channelId];
    } else {
        [[YYIMChat sharedInstance].chatManager closeNetMeetingVideo:self.channelId];
    }
}

- (void)didClickHangUpButton {
    if (self.memberSelf.isModerator) {
        [[YYIMChat sharedInstance].chatManager endNetMeeting:self.channelId];
    } else {
        [[YYIMChat sharedInstance].chatManager exitNetMeeting:self.channelId];
    }
    
    [self closeView];
}

#pragma mark -
#pragma mark collectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.channelOnlineMenber.count > 1) {
        return self.channelOnlineMenber.count - 1;
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YYIMNetMeetingChatCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YYIMNetMeetingChatCell" forIndexPath:indexPath];
    // Get info
    YYNetMeetingMember *member = [self.channelOnlineMenber objectAtIndex:indexPath.row + 1] ;
    [cell setImageRadius:20];
    [cell setChannelMember:member];
    
    if (member.inviteState == kYYIMNetMeetingInviteStateJoined) {
        if ([member.memberId isEqualToString:[[YYIMConfig sharedInstance] getUser]]) {
            [[YYIMChat sharedInstance].chatManager setupNetMeetingLocalVideo:cell.videoView userId:member.memberId];
        } else {
            [[YYIMChat sharedInstance].chatManager setupNetMeetingRemoteVideo:cell.videoView userId:member.memberId];
        }
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YYNetMeetingMember *member = [self.channelOnlineMenber objectAtIndex:indexPath.row + 1] ;
    
    if (member.inviteState != kYYIMNetMeetingInviteStateJoined) {
        return;
    }
    
    self.mainUserid = member.memberId;
    [self.channelOnlineMenber exchangeObjectAtIndex:0 withObjectAtIndex:indexPath.row + 1];
    
    [self updateMainInfoView:member];
    
    if (member.enableVideo) {
        [self showMainVidio];
        [self updateMainVideo:member.memberId];
    } else {
        [self hideMainVidio];
    }
    
    [self.collectionVideoView reloadItemsAtIndexPaths:@[indexPath]];
}

#pragma mark -
#pragma mark YYIMChatDelegate

- (void)didJoinNetMeetingSuccessed:(NSString *)channelId elapsed:(NSInteger)elapsed {
    if (self.netMeeting.netMeetingMode == kYYIMNetMeetingModeAudio) {
        YYIMLogDebug(@"HeadPhone-音频模式默认需要关闭扬声器");
        self.speakerCommand = NO;
        [[YYIMChat sharedInstance].chatManager setNetMeetingEnableSpeakerphone:NO];
    } else {
        self.speakerCommand = YES;
    }
    
    //sdk默认是开启视频的，所以如果希望使用语音模式，需要主动关闭视频
    if (self.netMeeting.netMeetingMode == kYYIMNetMeetingModeAudio) {
        [[YYIMChat sharedInstance].chatManager closeNetMeetingVideo:self.channelId];
        [[YYIMChat sharedInstance].chatManager muteNetMeetingLocalVideoStream:YES];
        [self.cameraControlButton setSelected:NO];
    } else {
        [self.cameraControlButton setSelected:YES];
    }
}

/**
 *  会议中有人进入
 *
 *  @param userId 成员id
 */
- (void)didNetMeetingMemberEnter:(NSString *)userId {
    BOOL isExist = NO;
    
    for (YYNetMeetingMember *member in self.channelOnlineMenber) {
        if ([member.memberId isEqualToString:userId]) {
            isExist = YES;
            break;
        }
    }
    
    if (isExist) {
        [self updateMember:userId];
    }
    
    if (self.memberSelf.isModerator) {
        self.channelLabel.hidden = YES;
        
        [self.teleImageView setFrame:CGRectMake(16, 16, 12, 12)];
        [self.signalImageView setFrame:CGRectMake(30, 16, 12, 12)];
        [self.timeLabel setFrame:CGRectMake(44, 12, 100, 20)];
    }
}

/**
 *  会议中有人退出
 *
 *  @param userId 成员id
 */
- (void)didNetMeetingMemberExit:(NSString *)userId {
    [self closeView];
}

/**
 *  拒绝参加会议
 *
 *  @param userId 成员id
 */
- (void)didNetMeetingMemberRefuse:(NSString *)userId {
    [self closeView];
}

- (void)didNetMeetingInviteTimeout:(NSString *)channelId userId:(NSString *)userId {
    //单聊的时候如果对方响应超时也要退出
    if ([self.channelId isEqualToString:channelId]) {
        [self closeView];
    }
}

/**
 *  因为忙而不能接听
 *
 *  @param userId 成员id
 */
- (void)didNetMeetingMemberBusy:(NSString *)userId {
    self.netMeeting = [[YYIMChat sharedInstance].chatManager getNetMeetingWithChannelId:self.channelId];
    [self closeView];
}

/**
 *  通知频道成员改变语音状态
 *
 *  @param enable  是否开启
 *  @param userIds 成员id集合
 */
- (void)didNetMeetingMembersEnableAudio:(BOOL)enable userId:(NSString *)userId {
    if ([self.memberSelf.memberId isEqualToString:userId]) {
        [self updateMuteAudioStatus];
    }
    
    [self updateMember:userId];
}

/**
 *  通知频道成员改变视频状态
 *
 *  @param enable  是否开启
 *  @param userIds 成员id集合
 */
- (void)didNetMeetingMembersEnableVideo:(BOOL)enable userId:(NSString *)userId {
    [self updateMember:userId];
}

#pragma mark -
#pragma mark private method

- (void)loadAllData {
    [self loadChannelData];
    [self layoutBottonView];
    [self loadChannelMemberData];
    [self updateMuteAudioStatus];
    [self loadVideoView];
}

- (void)loadChannelData {
    self.netMeeting = [[YYIMChat sharedInstance].chatManager getNetMeetingWithChannelId:self.channelId];
    
    self.memberSelf = [[YYIMChat sharedInstance].chatManager getNetMeetingMemberWithChannelId:self.channelId memberId:[[YYIMConfig sharedInstance] getUser]];
}

- (void)loadChannelMemberData {
    self.memberSelf = [[YYIMChat sharedInstance].chatManager getNetMeetingMemberWithChannelId:self.channelId memberId:[[YYIMConfig sharedInstance] getUser]];
    
    if (!self.mainUserid) {
        self.mainUserid = [[YYIMConfig sharedInstance] getUser];
    }
    
    //更新当前的成员
    NSArray *array = [[YYIMChat sharedInstance].chatManager getNetMeetingMembersWithChannelId:self.channelId];
    
    NSMutableArray *filterArray = [NSMutableArray array];
    
    for (YYNetMeetingMember *entity in array) {
        if (entity.inviteState == kYYIMNetMeetingInviteStateJoined || entity.inviteState == kYYIMNetMeetingInviteStateInviting) {
            [filterArray addObject:entity];
        }
    }
    
    if (!self.channelOnlineMenber) {
        self.channelOnlineMenber = [[NSMutableArray alloc] initWithArray:filterArray];
        
        //刚进入会议，如果不是唯一一个会议里的人，需要将自己放在第一个。
        if (self.channelOnlineMenber.count > 1) {
            NSInteger myIndex = -1;
            
            for (int i = 0; i < self.channelOnlineMenber.count; i++) {
                YYNetMeetingMember *member = [self.channelOnlineMenber objectAtIndex:i];
                
                if ([member.memberId isEqualToString:[[YYIMConfig sharedInstance] getUser]]) {
                    myIndex = i;
                    break;
                }
            }
            
            if (myIndex > 0) {
                [self.channelOnlineMenber exchangeObjectAtIndex:0 withObjectAtIndex:myIndex];
            }
        }
    } else {
        NSMutableArray *deleteIds = [NSMutableArray array];
        NSMutableArray *addIds = [NSMutableArray array];
        
        for (YYNetMeetingMember *member in self.channelOnlineMenber) {
            BOOL isExist = NO;
            
            for (YYNetMeetingMember *newMember in filterArray) {
                if ([newMember.memberId isEqualToString:member.memberId]) {
                    [self copyMember:member newMember:newMember];
                    
                    isExist = YES;
                    break;
                }
            }
            
            if (!isExist) {
                [deleteIds addObject:member.memberId];
            }
        }
        
        for (YYNetMeetingMember *newMember in filterArray) {
            BOOL isExist = NO;
            
            for (YYNetMeetingMember *member in self.channelOnlineMenber) {
                if ([newMember.memberId isEqualToString:member.memberId]) {
                    isExist = YES;
                    break;
                }
            }
            
            if (!isExist) {
                [addIds addObject:newMember.memberId];
            }
        }
        
        
        if (deleteIds.count > 0) {
            NSMutableArray *deleteArray = [NSMutableArray array];
            
            for (YYNetMeetingMember *member in self.channelOnlineMenber) {
                if ([deleteIds containsObject:member.memberId]) {
                    [deleteArray addObject:member];
                }
            }
            
            if (deleteArray.count > 0) {
                for (YYNetMeetingMember *member in deleteArray) {
                    [self.channelOnlineMenber removeObject:member];
                }
            }
        }
        
        if (addIds.count > 0) {
            for (NSString *addId in addIds) {
                [self.channelOnlineMenber addObject:[[YYIMChat sharedInstance].chatManager getNetMeetingMemberWithChannelId:self.channelId memberId:addId]];
            }
        }
        
        //如果主页面的人不在了，需要有人顶替
        if ([deleteIds containsObject:self.mainUserid]) {
            if (self.channelOnlineMenber.count > 0) {
                self.mainUserid = [self.channelOnlineMenber objectAtIndex:0];
            } else {
                self.mainUserid = nil;
            }
        }
    }
}

- (void)updateMuteAudioStatus {
    self.memberSelf = [[YYIMChat sharedInstance].chatManager getNetMeetingMemberWithChannelId:self.channelId memberId:[[YYIMConfig sharedInstance] getUser]];
    
    if (self.memberSelf.enableAudio) {
        [self.audioMuteButton setSelected:NO];
        [[YYIMChat sharedInstance].chatManager muteNetMeetingLocalAudioStream:NO];
    } else {
        [self.audioMuteButton setSelected:YES];
        [[YYIMChat sharedInstance].chatManager muteNetMeetingLocalAudioStream:YES];
    }
}

/**
 *  加载视频控制
 */
- (void)loadVideoView {
    YYNetMeetingMember *member = [[YYIMChat sharedInstance].chatManager getNetMeetingMemberWithChannelId:self.channelId memberId:self.mainUserid];
    [self updateMainInfoView:member];
    
    if (member.enableVideo) {
        [self showMainVidio];
        [self updateMainVideo:member.memberId];
        [self.collectionVideoView reloadData];
    } else {
        [self hideMainVidio];
        [self.collectionVideoView reloadData];
    }
}

/**
 *  更新主视图
 */
- (void)updateMainVideo:(NSString *)userId{
    if ([userId isEqualToString:[[YYIMConfig sharedInstance] getUser]]) {
        [[YYIMChat sharedInstance].chatManager setupNetMeetingLocalVideo:self.videoMainView userId:userId];
    } else {
        [[YYIMChat sharedInstance].chatManager setupNetMeetingRemoteVideo:self.videoMainView userId:userId];
    }
}

- (NSString *)getMainViewUserId {
    return self.mainUserid;
}

- (void)copyMember:(YYNetMeetingMember *)oldMember newMember:(YYNetMeetingMember *)newMember {
    [oldMember setEnableAudio:newMember.enableAudio];
    [oldMember setEnableVideo:newMember.enableVideo];
    [oldMember setForbidAudio:newMember.forbidAudio];
    [oldMember setMemberRole:newMember.memberRole];
    [oldMember setInviteState:newMember.inviteState];
}

- (void)updateMember:(NSString *)userId {
    YYNetMeetingMember *oldMember;
    
    for (YYNetMeetingMember *member in self.channelOnlineMenber) {
        if ([member.memberId isEqualToString:userId]) {
            oldMember = member;
            break;
        }
    }
    
    if (oldMember) {
        YYNetMeetingMember *member = [[YYIMChat sharedInstance].chatManager getNetMeetingMemberWithChannelId:self.channelId memberId:userId];
        
        BOOL isUpdateVideo = oldMember.enableVideo != member.enableVideo;
        BOOL isInviteStateChange = oldMember.inviteState != member.inviteState;
        
        [self copyMember:oldMember newMember:member];
        
        if ([self.mainUserid isEqualToString:oldMember.memberId]) {
            [self updateMainInfoView:oldMember];
            
            if (isUpdateVideo) {
                if (oldMember.enableVideo) {
                    [self showMainVidio];
                    [self updateMainVideo:oldMember.memberId];
                } else {
                    [self hideMainVidio];
                }
                
                [[NetMeetingDispatch sharedInstance] showWindowDetail:self.mainUserid channelId:self.channelId];
            }
        } else {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.channelOnlineMenber indexOfObject:oldMember] - 1 inSection:0];
            
            if (isUpdateVideo || isInviteStateChange) {
                [self.collectionVideoView reloadItemsAtIndexPaths:@[indexPath]];
            } else {
                //获取cell，只更新cell
                UICollectionViewCell *cell = [self.collectionVideoView cellForItemAtIndexPath:indexPath];
                [(YYIMNetMeetingChatCell *)cell setChannelMember:oldMember];
            }
        }
    }
}

@end