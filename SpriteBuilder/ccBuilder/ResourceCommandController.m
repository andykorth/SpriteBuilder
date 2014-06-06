#import "ResourceCommandController.h"

#import "ResourceManagerOutlineView.h"
#import "ResourceDeleteCommand.h"
#import "ResourceCreateKeyframesCommand.h"
#import "ResourceExportPackageCommand.h"
#import "ResourceShowInFinderCommand.h"
#import "ResourceOpenInExternalEditorCommand.h"
#import "ResourceToggleSmartSpriteSheetCommand.h"
#import "ResourceNewFileCommand.h"
#import "ResourceNewFolderCommand.h"
#import "ResourceNewPackageCommand.h"


@implementation ResourceCommandController

#pragma mark - Initialization

+ (id)sharedController
{
    static ResourceCommandController *sharedResourceActionController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedResourceActionController = [[self alloc] init];
    });
    return sharedResourceActionController;
}

- (NSArray *)selectedResources
{
    return _resourceManagerOutlineView.selectedResources;
}

- (void)showResourceInFinder:(id)sender
{
    ResourceShowInFinderCommand *command = [[ResourceShowInFinderCommand alloc] init];
    command.resources = [self selectedResources];
    [command execute];
}

- (void)openResourceWithExternalEditor:(id)sender
{
    ResourceOpenInExternalEditorCommand *command = [[ResourceOpenInExternalEditorCommand alloc] init];
    command.resources = [self selectedResources];
    [command execute];
}

- (void)toggleSmartSheet:(id)sender
{
    ResourceToggleSmartSpriteSheetCommand *command = [[ResourceToggleSmartSpriteSheetCommand alloc] init];
    command.resources = [self selectedResources];
    command.projectSettings = _projectSettings;
    [command execute];
}

- (void)createKeyFrameFromSelection:(id)sender
{
    ResourceCreateKeyframesCommand *command = [[ResourceCreateKeyframesCommand alloc] init];
    [command execute];
}

- (void)newFile:(id)sender
{
    ResourceNewFileCommand *command = [[ResourceNewFileCommand alloc] init];
    command.resources = [self selectedResources];
    command.outlineView = _resourceManagerOutlineView;
    command.windowForModals = _window;
    [command execute];
}

- (void)newFolder:(id)sender
{
    ResourceNewFolderCommand *command = [[ResourceNewFolderCommand alloc] init];
    command.resources = [self selectedResources];
    command.outlineView = _resourceManagerOutlineView;
    [command execute];
}

- (void)newPackage:(id)sender
{
    ResourceNewPackageCommand *command = [[ResourceNewPackageCommand alloc] init];
    command.projectSettings = _projectSettings;
    command.windowForModals = _window;
    [command execute];
}

- (void)deleteResource:(id)sender
{
    ResourceDeleteCommand *command = [[ResourceDeleteCommand alloc] init];
    command.resources = [self selectedResources];
    command.projectSettings = _projectSettings;
    command.outlineView = _resourceManagerOutlineView;
    [command execute];
}

- (void)exportPackage:(id)sender
{
    ResourceExportPackageCommand *command = [[ResourceExportPackageCommand alloc] init];
    command.resources = [self selectedResources];
    command.windowForModals = _window;
    [command execute];
}

@end