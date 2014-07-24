//
//  ViewController.m
//  rs232
//
//  Created by Daniel Coffey on 7/21/14.
//  Copyright (c) 2014 Daniel Coffey. All rights reserved.
//

#import "mViewController.h"

@interface mViewController ()

@end

@implementation mViewController

@synthesize texty;
@synthesize connectLabel;
@synthesize debugText;
@synthesize button1;
@synthesize button2;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Create and initialize our RedparkSerialCable Manager for communicating
    // with the serial cable.
    rscMgr = [[RscMgr alloc] init];
    
    // Set this as our delegate so we can receive evevnts
    [rscMgr setDelegate:self];
    
    // set defaults for analog_way
    [rscMgr setBaud:115200];
    [rscMgr setDataSize:(DataSizeType)8];
//    [rscMgr	setParity:(ParityType)value];
    [rscMgr setStopBits:(StopBitsType)1];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (IBAction)touchbutton1:(id)sender {
//    NSString *s1 = @"0,1,1,1PRinp0,1PUscu0,1GCtak";
//    uint8_t *someInt = (uint8_t *)[s1 UTF8String];
//    [rscMgr write:someInt Length:[s1 length]];
//    texty.text = s1;
//}

    
- (IBAction)buttonPress:(id)sender {
    NSDictionary *lookup = @{
         [NSNumber numberWithInt:0] : @"??0",
         [NSNumber numberWithInt:11] : @"0,1,1,1PRinp0,1PUscu0,1GCtak",
         [NSNumber numberWithInt:12] : @"1,1,1,1PRinp1,1PUscu1,1GCtak",
         [NSNumber numberWithInt:13] : @"??13",
         [NSNumber numberWithInt:14] : @"??14",
         [NSNumber numberWithInt:21] : @"??21",
         [NSNumber numberWithInt:22] : @"??22",
         [NSNumber numberWithInt:23] : @"??23",
         [NSNumber numberWithInt:24] : @"??24"
    };

    NSInteger clicked = [sender tag];
    NSLog(@"Button clicked %d, string: %@", clicked, lookup[[NSNumber numberWithInt:clicked]]);
    uint8_t *someInt = (uint8_t *)[lookup[[NSNumber numberWithInt:clicked]] UTF8String];
    [rscMgr write:someInt Length:[lookup[[NSNumber numberWithInt:clicked]] length]];
    texty.text = lookup[[NSNumber numberWithInt:clicked]];
}


#pragma mark - RscMgrDelegate methods

- (void) cableConnected:(NSString *)protocol {
    connectLabel.text = @"Connected";

    [rscMgr setBaud:115200];
    [rscMgr open];
}

- (void) cableDisconnected {
    connectLabel.text = @"Not Connected";
    
}

- (void) portStatusChanged {
    
}

- (void) readBytesAvailable:(UInt32)numBytes {
}

- (BOOL) rscMessageReceived:(UInt8 *)msg TotalLength:(int)len {
    return FALSE;
}

- (void) didReceivePortConfig {
}


@end
