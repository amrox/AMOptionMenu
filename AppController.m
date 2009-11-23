//
//  AppController.m
//  AMOptionMenuDemo
//
//  Created by Andy Mroczkowski on 7/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"

#import "AMOptionMenuDataSource.h"

#import "AMOptionPopUpButton.h"
#import "AMOptionPopUpButtonCell.h"

@implementation AppController


- (void) awakeFromNib  // TODO: fix awake from nib timing
{
	NSLog( @"awakeFromNib" );
}


-(void)applicationDidFinishLaunching:(NSNotification*)aNotification
//- (void) awakeFromNib  // TODO: fix awake from nib timing
{	
	ds = [[AMOptionMenuDataSource alloc] init];
	
	// -- uncomment the following to add separators between sections
	//ds.shouldSeparateSections = YES;
	
	NSArray* sections = [NSArray arrayWithObjects:
						 [AMOptionMenuItem itemWithIdentifier:@"Color" title:@"Color"],
						 [AMOptionMenuItem itemWithIdentifier:@"Dinosaurs" title:@"Dinosaurs"],
						 nil];
	
	
	NSMutableDictionary* valuesDict = [NSMutableDictionary dictionary];
	NSArray* colorOptions = [NSArray arrayWithObjects:
							 [AMOptionMenuItem itemWithIdentifier:@"Red" title:@"Red"],
							 [AMOptionMenuItem itemWithIdentifier:@"Green" title:@"Green"],
							 [AMOptionMenuItem itemWithIdentifier:@"Blue" title:@"Blue"],
							 nil];
	[valuesDict setObject:colorOptions forKey:@"Color"];
	
	
	NSArray* dinosaurOptions = [NSArray arrayWithObjects:
								[AMOptionMenuItem itemWithIdentifier:@"Awesome" title:@"Awesome"],
								[AMOptionMenuItem itemWithIdentifier:@"ReallyAwesome" title:@"Really Awesome" shortTitle:@"R. Awe."],
								nil];
	[valuesDict setObject:dinosaurOptions forKey:@"Dinosaurs"];

	
	[ds setOptionGroups:sections andValues:valuesDict];
	
	[popUpButton setOptionMenuDataSource:ds];
		
	[testMenu setSubmenu:[ds createMenuWithTitle:@"Things"]];
	

	NSRect myFrame = NSMakeRect( 10, 10, 300, 30);
	AMOptionPopUpButton* myPopupButton = [[AMOptionPopUpButton alloc] initWithFrame:myFrame pullsDown:YES];
	[myPopupButton setOptionMenuDataSource:ds];
	[[window contentView] addSubview:myPopupButton];
}


- (IBAction) setBlue:(id)sender
{
	[ds setValue:@"Blue" forKeyPath:@"Color"];
}


- (IBAction) setReallyAwesome:(id)sender
{
	[ds setValue:[NSNumber numberWithBool:YES] forKeyPath:@"Dinosaurs.isReallyAwesome"];
}



@end
