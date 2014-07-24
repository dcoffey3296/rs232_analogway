//
//  ViewController.h
//  rs232
//
//  Created by Daniel Coffey on 7/21/14.
//  Copyright (c) 2014 Daniel Coffey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "inc/RscMgr.h"

#define BUFFER_LEN 1024

@interface mViewController : UIViewController <RscMgrDelegate> {
    RscMgr *rscMgr;
    UInt8 rxBuffer[BUFFER_LEN];
    UInt8 txBuffer[BUFFER_LEN];
}

// set up my buttons

@property (weak, nonatomic) IBOutlet UILabel *texty;
@property (weak, nonatomic) IBOutlet UILabel *connectLabel;
@property (weak, nonatomic) IBOutlet UILabel *debugText;

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;

- (IBAction)buttonPress:(id)sender;


@end

