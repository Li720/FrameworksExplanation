//
//  frameworks101Tests.m
//  frameworks101Tests
//
//  Created by Dev Floater 132 on 2017-03-06.
//  Copyright © 2017 lstai. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"

@interface frameworks101Tests : XCTestCase

@end

@implementation frameworks101Tests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    
    ViewController *viewController = [ViewController new];
    [viewController view];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
