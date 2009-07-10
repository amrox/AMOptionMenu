//
//  AppController.h
//  AMOptionMenuDemo
//
//  Created by Andy Mroczkowski on 7/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMOptionMenuDataSource;
@class AMOptionPopUpButton;

@interface AppController : NSObject {

	IBOutlet NSPopUpButton* popUpButton;
	
	IBOutlet NSMenuItem* testMenu;
	
	IBOutlet NSWindow* window;
	
	AMOptionMenuDataSource* ds;

}

- (IBAction) setBlue:(id)sender;
- (IBAction) setReallyAwesome:(id)sender;


@end
