//
//  ViewController.m
//  frameworks101
//
//  Created by Dev Floater 132 on 2017-03-06.
//  Copyright © 2017 lstai. All rights reserved.
//

#import "ViewController.h"
#import <DyFrameworks101/DyFrameworks101.h>
#import "StLib.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[DClass new] dMethod];
    [[StLib new] sMethod];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
