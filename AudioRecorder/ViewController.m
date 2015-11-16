//
//  ViewController.m
//  AudioRecorder
//
//  Created on 2015/11/12.
//
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@property (nonatomic) AVAudioRecorder *recorder;

@property (nonatomic) AVAudioSession *session;

@property (nonatomic) AVAudioPlayer *player;

- (IBAction)recordSwitch:(id)sender;

- (IBAction)playClick:(id)sender;

@end

@implementation ViewController

@synthesize recorder;

@synthesize session;

@synthesize player;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSMutableDictionary *)setAudioRecorder
{
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
    [settings setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [settings setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [settings setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    [settings setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [settings setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [settings setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    
    return settings;
}

- (void)recordFile
{
    NSError *error = nil;
    self.session = [AVAudioSession sharedInstance];
    
    if (session.inputAvailable)
    {
        [session setCategory:AVAudioSessionCategoryPlayAndRecord
                       error:&error];
    }
    
    if (error != nil)
    {
        NSLog(@"Error when preparing audio session :%@", [error localizedDescription]);
    }
    
    [session setActive:YES
                 error:&error];
    
    if (error != nil) {
        NSLog(@"Error when enabling audio session :%@", [error localizedDescription]);
    }
    
    NSString *dir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [dir stringByAppendingPathComponent:@"test.caf"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    recorder = [[AVAudioRecorder alloc] initWithURL:url
                                           settings:[self setAudioRecorder]
                                              error:&error];
    
    if (error != nil)
    {
        NSLog(@"Error when preparing audio recorder :%@", [error localizedDescription]);
    }
    
    [recorder record];
}

- (void)stopRecord
{
    if (self.recorder != nil && self.recorder.isRecording)
    {
        [recorder stop];
        self.recorder = nil;
    }
}

- (void)playRecord
{
    NSError *error = nil;
    
    NSString *dir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [dir stringByAppendingPathComponent:@"test.caf"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]])
    {
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url
                                                             error:&error];
        if (error != nil)
        {
            NSLog(@"Error %@", [error localizedDescription]);
        }
        [self.player prepareToPlay];
        [self.player play];
    }
}


- (IBAction)recordSwitch:(id)sender
{
    UISwitch *recordSwitch = sender;
    if (recordSwitch.on)
    {
        [self recordFile];
    }
    else
    {
        [self stopRecord];
    }
}

- (IBAction)playClick:(id)sender
{
    [self playRecord];
}

@end
