//
//  headers.h
//  SaveWithBackup
//
//  Created by Harry deVbug on 12. 5. 24..
//  Copyright (c) 2012년 deVbug. All rights reserved.
//

#ifndef SaveWithBackup_headers_h
#define SaveWithBackup_headers_h

@class PCNode, TSDocument, TSNodeWrapper, TSWrapperViewController, TSTabController;

@interface PCNode : NSObject
- (BOOL)isRemote;
- (NSString *)displayPath;
@end

@interface TSDocument : NSDocument
- (TSTabController *)selectedTabController;
@end

@interface TSNodeWrapper : NSDocument
- (PCNode *)remoteNode;
@end

@interface TSWrapperViewController : NSResponder
- (TSNodeWrapper *)wrapper;
@end

@interface TSTabController : NSObject
- (TSWrapperViewController *)activeViewController;
@end

#endif
