//
//  ViewController.m
//  pics
//
//  Created by Agasy on 01.02.13.
//  Copyright (c) 2013 Agasy. All rights reserved.
//

#import "ViewController.h"
#import "PicsView.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet PicsView *pv;
@property (weak, nonatomic) IBOutlet UISlider *sl;
@property (weak, nonatomic) IBOutlet UISwitch *sw;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reszie:nil];
    [self sw:nil];
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)reszie:(id)sender {
    CGRect rect=self.pv.frame;
    rect.size.height=(1+self.sl.value)*rect.size.width;
    self.pv.frame=rect;
}
- (IBAction)sw:(id)sender {
    self.pv.reverse=self.sw.on;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
