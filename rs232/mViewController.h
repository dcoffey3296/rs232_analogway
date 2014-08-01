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
    
    // globals
    NSString *lastResult;
    NSNumber *lastScreen1;
    NSNumber *lastScreen2;
    
    BOOL screen1Frozen;
    BOOL screen2Frozen;
    BOOL screen1Logo;
    BOOL screen2Logo;
    
    NSDictionary *lookup;
}


// set up my buttons
//@property (weak, nonatomic) IBOutlet UILabel *texty;
@property (weak, nonatomic) IBOutlet UILabel *connectLabel;
//@property (weak, nonatomic) IBOutlet UILabel *debugText;

//@property (weak, nonatomic) IBOutlet UIButton *button1;

- (IBAction)buttonPress:(id)sender;
- (void) turnButton: (UIButton*) button color:(NSString*) color;





@end

