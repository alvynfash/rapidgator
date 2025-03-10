#### Dart SDK for the Rapidgator service.

## Features

#### Login
- login

#### User
- getUserInfo

#### File
- getFileInfo
- copyFile
- moveFile
- renameFile
- uploadFile
- deleteFile
- downloadFile
- checkLinks
- createOneTimeLink
- getOneTimeLinkInfo

#### Folder
- createFolder
- getFolderInfo
- getFolderContent
- renameFolder
- copyFolder
- moveFolder
- deleteFolder
- changeFolderMode

#### Remote upload
- createRemoteUpload
- getRemoteUploadInfo
- deleteRemoteUpload

#### Trash can
- getTrashCanContent
- restoreTrashCanFiles
- emptyTrashCan

## Usage

```dart
final api = RapidGatorApi();

// login
await api.login(email: 'test@example.com', password: 'password');

// User
final userInfo = await api.getUserInfo();

// File
final fileInfo = await api.getFileInfo(fileId: 'file123');
final copyFileInfo = await api.copyFile(
    fileIds: ['file123', 'file456'],
    destinationFolderId: 'folder123',
);
final moveFileInfo = await api.moveFile(
    fileIds: ['file123', 'file456'],
    destinationFolderId: 'folder123',
);
final renameFileInfo = await api.renameFile(fileId: 'file123', newName: 'new_name.txt',);
final deleteFileInfo = await api.deleteFile(fileIds: ['file123', 'file456']);
final uploadFileInfo = await api.uploadFile(
    name: 'test.txt',
    size: 1023,
    hash: 'some_hash',
    folderId: 'folder123',
);
final downloadUrl = await api.downloadFile(fileId: 'file123');
final linksResult = await api.checkLinks(urls: ['https://rapidgator.net/file/123']);
final oneTimeLink = await api.createOneTimeLink(fileId: 'file123');
final oneTimeLinksInfo = await api.getOneTimeLinkInfo(linkIds: ['link123', 'link456']);

// Folder
final folderInfo = await api.createFolder(name: 'Test Folder', parentFolderId: 'parent456');
final folderInfo = await api.getFolderInfo(folderId: 'folder123');
final folderContentInfo = await api.getFolderContent(folderId: 'folderId');
final renameFolderInfo = await api.renameFolder(newName: 'new_folder_name', folderId: 'newFolderId');
final copyFolderInfo = await api.copyFolder(folderId: 'newFolderId', destinationFolderId: 'folder123');
final moveFolderInfo = await api.moveFolder(folderId: 'newFolderId', destinationFolderId: 'folder123');
final deleteFolderInfo = await api.deleteFolder(folderId: 'folderId');
final changefolderModeInfo =await api.changeFolderMode(folderId: 'folderId', mode: 0);

// Remote upload
final remoteUploadInfo = await api.createRemoteUpload(url: 'url');
final remoteUploadStatus = await api.getRemoteUploadInfo(jobId: 'job123');
final deleteRemoteUploadInfo = await api.deleteRemoteUpload(jobId: 'jobId');

// TrashCan
final trashCanContent = await api.getTrashCanContent(folderId: 'folder123');
final emptyTrashCan = await api.emptyTrashCan(fileIds: ['file123', 'file456']);
final restoreTrashCan = await api.restoreTrashCanFiles(fileIds: ['file123', 'file456']);
```
