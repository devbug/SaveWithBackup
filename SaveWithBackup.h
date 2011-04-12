//
//  SaveWithBackup.h
//  SaveWithBackup
//
//  Created by deVbug on 11. 4. 8..
//  Copyright 2011 deVbug All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import "CodaPluginsController.h"

@class CodaPlugInsController;


@interface SaveWithBackup : NSObject <CodaPlugIn>
{
	CodaPlugInsController* controller;
}

- (id)initWithPlugInController:(CodaPlugInsController*)controller bundle:(NSBundle*)aBundle;

@end
