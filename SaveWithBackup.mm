//
//  SaveWithBackup.mm
//  SaveWithBackup
//
//  Created by deVbug on 11. 4. 8..
//  Copyright 2011 deVbug All rights reserved.
//

#import "SaveWithBackup.h"
#import "CodaPlugInsController.h"

#import "TSDocument.h"

#define BACKUP_DIR	@"/CodaSaveBackup/"


@class TSDocument, TSTabController, TSWrapperViewController, TSNodeWrapper, PCNode;


@implementation SaveWithBackup

- (id)initWithPlugInController:(CodaPlugInsController*)inController bundle:(NSBundle*)aBundle
{
	if ( (self = [super init]) != nil )
	{
		controller = inController;
		[controller registerActionWithTitle:NSLocalizedString(@"Save with Backup", @"Save with Backup") 
					  underSubmenuWithTitle:nil
									 target:self 
								   selector:@selector(safetySave:)
						  representedObject:nil
							  keyEquivalent:@"^$S"						// Ctrl + Shift + S
								 pluginName:@"SaveWithBackup"];
	}
	return self;
}


- (NSString*)name
{
	return @"SaveWithBackup";
}

- (NSString *) getSite:(BOOL)isRemote {
	NSMutableString *str = [NSMutableString stringWithFormat:@""];
	
	if (!isRemote) {
		[str appendString:@"localstorage"];
		return str;
	}
	
	if ([controller apiVersion] < 2) return @"";
	
	CodaTextView *tview = [controller focusedTextView:self];
	if (tview == nil) return @"";
	
	if ([controller apiVersion] < 4) return @"";
	
	NSMutableString *temp = [NSMutableString stringWithFormat:@""];
	
	if ([tview siteNickname] != nil)
		[temp appendString:[tview siteNickname]];
	else if ([tview siteURL] != nil)
		[temp appendString:[tview siteURL]];
	else if ([tview siteLocalURL] != nil)
		[temp appendString:[tview siteLocalURL]];
	
	if ([temp length] == 0) {
		[str appendString:@"unknownstorage"];
	} else {
		[temp replaceOccurrencesOfString:@"/" withString:@"_" options:(NSStringCompareOptions)nil range:NSMakeRange(0, [temp length])];
		[temp replaceOccurrencesOfString:@":" withString:@"_" options:(NSStringCompareOptions)nil range:NSMakeRange(0, [temp length])];
		[temp replaceOccurrencesOfString:@";" withString:@"_" options:(NSStringCompareOptions)nil range:NSMakeRange(0, [temp length])];
		[temp replaceOccurrencesOfString:@"\t" withString:@"_" options:(NSStringCompareOptions)nil range:NSMakeRange(0, [temp length])];
		[temp replaceOccurrencesOfString:@"\r" withString:@"_" options:(NSStringCompareOptions)nil range:NSMakeRange(0, [temp length])];
		[temp replaceOccurrencesOfString:@"\n" withString:@"_" options:(NSStringCompareOptions)nil range:NSMakeRange(0, [temp length])];
		[temp replaceOccurrencesOfString:@"\a" withString:@"_" options:(NSStringCompareOptions)nil range:NSMakeRange(0, [temp length])];
		[temp replaceOccurrencesOfString:@"\f" withString:@"_" options:(NSStringCompareOptions)nil range:NSMakeRange(0, [temp length])];
		[str appendString:temp];
	}
	
	return str;
}

- (void) safetySave:(id)sender {
	if ([controller apiVersion] < 2) return;
	
	CodaTextView *tview = [controller focusedTextView:self];
	if (tview == nil) return;
	
	if ([controller apiVersion] < 4) {
		[tview save];
		return;
	}
	
	NSArray *pathComponents = [[tview path] pathComponents];
	NSString *name = [pathComponents lastObject];
	
	bool isRemote = YES;
	NSString *temp = @"~";
	NSMutableString *str = [[NSMutableString alloc] initWithString:[temp stringByExpandingTildeInPath]];
	[str appendFormat:BACKUP_DIR];
		
	/*if ([tview siteRemotePath] != nil) {
		if (NO == [[tview siteRemotePath] hasPrefix:@"/"])
			[str appendString:@"/"];
		
		[str appendString:[tview siteRemotePath]];
		
		if (NO == [str hasSuffix:@"/"])
			[str appendString:@"/"];
		
		[str appendString:name];
	}
	else if ([tview siteLocalPath] != nil) {
		if (NO == [[tview siteLocalPath] hasPrefix:@"/"])
			[str appendString:@"/"];
		
		[str appendString:[tview siteLocalPath]];
		
		if (NO == [str hasSuffix:@"/"])
			[str appendString:@"/"];
		
		[str appendString:name];
	}*/
	
	NSArray *documents = [[NSDocumentController sharedDocumentController] documents];
	NSInteger i = 0;

	for (TSDocument *document in documents) {
		if (i > 0) break;
		
		if (document != nil) {
			TSTabController *tab = document.selectedTabController;
			TSWrapperViewController *wrapview = [tab activeViewController];
			TSNodeWrapper *node = [wrapview wrapper];
			PCNode *remoteNode = [node remoteNode];
			
			if (remoteNode) {
				isRemote = [remoteNode isRemote];
				[str appendString:[self getSite:isRemote]];
				
				NSString *lastRemotePath = [remoteNode displayPath];
				
				if (lastRemotePath) {
					if (NO == [lastRemotePath hasPrefix:@"/"])
						[str appendString:@"/"];
					
					[str appendString:lastRemotePath];
				}
			} else
				isRemote = NO;
		} else
			isRemote = NO;
		
		i++;
	}
	
	if (!isRemote && [tview path] != nil) {
		[str appendString:[self getSite:isRemote]];
		
		if (NO == [[tview path] hasPrefix:@"/"])
			[str appendString:@"/"];
		
		[str appendString:[tview path]];
	}
	else if (!isRemote || i == 0) {
		// do nothing.. just save..
		[tview save];
		
		[str release];
		
		return;
	}
	
	if (NO == [str hasSuffix:@"/"])
		[str appendString:@"/"];
	
	
	char *path = NULL;
	path = (char *)malloc([str length] * 4);
	sprintf(path, "mkdir -p \"%s\"", [str UTF8String]);
	system(path);
	free(path);
	
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] initWithDateFormat:@"%Y%m%d-%H%M%S" allowNaturalLanguage:NO];
	
	NSString *theDate = [dateFormat stringFromDate:[NSDate date]];
	
	NSString *fullpath = [NSString stringWithFormat:@"%@%@_%@", str, theDate, name];
	
	NSFileHandle *writeFile;
	NSData *data = [[tview string] dataUsingEncoding:NSUTF8StringEncoding];
	
	[[NSFileManager defaultManager] createFileAtPath:fullpath contents:nil attributes:nil];
	
	writeFile = [NSFileHandle fileHandleForWritingAtPath:fullpath];
	if (writeFile != nil) {
		[writeFile writeData:data];
		[writeFile closeFile];
	}
	
	[tview save];
	
	//[tview insertText:fullpath];
	
	[dateFormat release];
	[str release];
}

@end
