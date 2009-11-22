//
//  AMOptionMenu.m
//  AMOptionMenuDemo
//
//  Created by Andy Mroczkowski on 7/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AMOptionMenuDataSource.h"


NSString* const kAMOptionPopUpButtonTitle = @"kAMOptionPopUpButtonTitle";


@implementation AMOptionMenuItem

@synthesize identifier = _identifier;
@synthesize title = _title;
@synthesize shortTitle = _shortTitle;


+ (AMOptionMenuItem*) itemWithIdentifier:(NSString*)identifier title:(NSString*)title shortTitle:(NSString*)shortTitle
{
	AMOptionMenuItem* item = [[[AMOptionMenuItem alloc] init] autorelease];
	[item setIdentifier:identifier];
	[item setTitle:title];
	[item setShortTitle:shortTitle];
	return item;
}


+ (AMOptionMenuItem*) itemWithIdentifier:(NSString*)identifier title:(NSString*)title
{
	return [self itemWithIdentifier:identifier title:title shortTitle:nil];
}


- (void) dealloc
{
	[_identifier release];
	[_title release];
	[_shortTitle release];
	[super dealloc];
}


- (NSString*) titleForSummary
{
	if( [self shortTitle] )
		return [self shortTitle];
	return [self title];
}


@end

#pragma mark -

NSString* const kAMOptionMenuDataWillChange = @"kAMOptionMenuDataWillChange";
NSString* const kAMOptionMenuDataDidChange = @"kAMOptionMenuDataDidChange";


@interface AMOptionMenuDataSource ()

@property (nonatomic, retain) NSArray* groups;
@property (nonatomic, retain) NSDictionary* valuesDict;

- (NSArray*) optionValuesForGroupWithIdentifier:(NSString*)identifier;
- (NSMenuItem*) menuItemForGroup:(AMOptionMenuItem*)group;
- (NSMenuItem*) menuItemForOption:(AMOptionMenuItem*)option inGroup:(AMOptionMenuItem*)group;
- (void) choseOptionWithKeyPath:(NSString*)keypath;

@end

@implementation AMOptionMenuDataSource

@synthesize groups = _groups;
@synthesize valuesDict = _valuesDict;

- (id) init
{
	self = [super init];
	if (self != nil)
	{
		_groups = [[NSMutableDictionary alloc] init];
		_valuesDict = [[NSMutableDictionary alloc] init];
		_stateDict = [[NSMutableDictionary alloc] init];
	}
	return self;
}


- (void) dealloc
{
	[_groups release];
	[_valuesDict release];
	[super dealloc];
}


- (NSArray*) optionGroups
{
	return [NSArray arrayWithArray:_groups];
}


- (NSArray*) optionValuesForGroupWithIdentifier:(NSString*)identifier
{
	return [_valuesDict objectForKey:identifier];
}


- (NSArray*) createMenuItems
{
	NSMutableArray* array = [NSMutableArray array];
	for( AMOptionMenuItem* group in [self optionGroups] )
	{
		[array addObject:[self menuItemForGroup:group]];
		
		for( AMOptionMenuItem* value in [self optionValuesForGroupWithIdentifier:[group identifier]] )
		{
			[array addObject:[self menuItemForOption:value inGroup:group]];
		}
	}
	return array;
}

- (NSMenu*) createMenuWithTitle:(NSString*)title
{
	NSMenu* menu = [[NSMenu alloc] initWithTitle:title];
	[menu setAutoenablesItems:NO];

	for( NSMenuItem* item in [self createMenuItems] )
	{
		[menu addItem:item];
	}

	return [menu autorelease];
}


- (NSMenuItem*) menuItemForGroup:(AMOptionMenuItem*)group
{
	NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:[group title] action:nil keyEquivalent:@""];
	[menuItem setEnabled:NO];
	return [menuItem autorelease];
}


- (NSMenuItem*) menuItemForOption:(AMOptionMenuItem*)option inGroup:(AMOptionMenuItem*)group
{
	NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:[option title] action:@selector(optionChosen:) keyEquivalent:@""];

	[menuItem setIndentationLevel:1];
	[menuItem setTarget:self];
	[menuItem setEnabled:YES];
	
	NSString* keypath = [NSString stringWithFormat:@"%@.is%@", [group identifier], [option identifier]];
	[menuItem setRepresentedObject:keypath];

	NSDictionary *bindingOptions = nil;
	[menuItem bind:@"value" toObject:self withKeyPath:keypath options:bindingOptions];

	return [menuItem autorelease];
}


- (void) optionChosen:(id)sender
{
	// ???: the visual check next to the selected item did not update correctly without deferring to the next run loop
	//[self choseOptionWithKeyPath:[sender representedObject]];

	[self performSelector:@selector(choseOptionWithKeyPath:) withObject:[sender representedObject] afterDelay:0.0];
}


- (void) choseOptionWithKeyPath:(NSString*)keypath
{
	NSLog( @"--------- choseOptionWithKeyPath: %@ ---------", keypath );
	[self setValue:[NSNumber numberWithBool:YES] forKeyPath:keypath];
}


- (id) valueForUndefinedKey:(NSString*)key
{
	if( [_valuesDict objectForKey:key] )
	{
		id val = [_stateDict objectForKey:key];
		NSLog( @"valueForUndefinedKey: %@ = %@", key, val );
		return val;
	}
	
	return [super valueForUndefinedKey:key];
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
	if( [_valuesDict objectForKey:key] )
	{
		NSLog( @"settingValue:%@ forKey:%@", value, key );
		[self willChangeValueForKey:@"summaryString"];
		[_stateDict setObject:value forKey:key];
		[self didChangeValueForKey:@"summaryString"];
		return;
	}
	[super setValue:value forUndefinedKey:key];
}


- (id) valueForKeyPath:(NSString*)keyPath
{
	NSArray* keyPathComponents = [keyPath componentsSeparatedByString:@"."];
	
	if( [keyPathComponents count] == 2 )
	{
		NSString* groupKey = [keyPathComponents objectAtIndex:0];
		NSString* optionKey = [keyPathComponents objectAtIndex:1];

		if( [_valuesDict objectForKey:groupKey] )
		{
			NSString* valueWithIsPrefix = [NSString stringWithFormat:@"is%@", [_stateDict objectForKey:groupKey]];
			if( [valueWithIsPrefix isEqual:optionKey] )
			{
				NSLog( @"valueForKeyPath:%@ is YES", keyPath );
				return [NSNumber numberWithBool:YES];
			}
			else
			{
				NSLog( @"valueForKeyPath:%@ is NO", keyPath );
				return [NSNumber numberWithBool:NO];				
			}
		}
	}
	return [super valueForKeyPath:keyPath];
}


- (void)setValue:(id)value forKeyPath:(NSString*)keyPath
{
	NSLog( @"settin value:%@ forKeyPath:%@", value, keyPath );
	NSArray* keyPathComponents = [keyPath componentsSeparatedByString:@"."];
	if( [keyPathComponents count] == 2 )
	{
		NSString* sectionKey = [keyPathComponents objectAtIndex:0];
		NSString* optionKey = [keyPathComponents objectAtIndex:1];		
		
		if( [optionKey hasPrefix:@"is"] )
		{
			NSString* option = [optionKey substringFromIndex:2];
			
			if( [_valuesDict objectForKey:sectionKey] )
			{
				if( [value boolValue] )
				{
					[self setValue:option forKey:sectionKey];
				}
				return;
			}
		}
	}
	[super setValue:value forKeyPath:keyPath];
}


- (NSString*) summaryString
{
	NSMutableString* string = [NSMutableString string];
	for( AMOptionMenuItem* group in _groups )
	{
		if( [string length] )
			[string appendString:@" | "];
		
		// TODO: make nicer
		NSString* optionId = [self valueForKey:[group identifier]];
		
		NSString* title = nil;
		for( AMOptionMenuItem* menuItem in [_valuesDict objectForKey:[group identifier]] )
		{
			if( [[menuItem identifier] isEqualToString:optionId] )
			{
				title = [menuItem titleForSummary];
				break;
			}
		}		
		[string appendFormat:@"%@", title];
	}
	return [NSString stringWithString:string];
}


- (void) setOptionGroups:(NSArray*)groups andValues:(NSDictionary*)values
{
	[[NSNotificationCenter defaultCenter] postNotificationName:kAMOptionMenuDataWillChange object:self];
	
	[self setGroups:groups];
	[self setValuesDict:values];
	
	for( NSString* groupId in [[self valuesDict] allKeys] )
	{
		if( ![_stateDict objectForKey:groupId] )
		{
			NSString* valueId = [[[[self valuesDict] objectForKey:groupId] objectAtIndex:0] identifier];
			[_stateDict setObject:valueId forKey:groupId];
		}
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kAMOptionMenuDataDidChange object:self];
}


- (NSDictionary*) state
{
	return [[_stateDict copy] autorelease];
}

@end

