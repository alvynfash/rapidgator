import 'package:dio/dio.dart';
import 'package:rapidgator/exceptions.dart';
import 'models/user_info.dart';
import 'models/folder_info.dart';
import 'models/file_info.dart';
import 'models/check_link_response.dart';
import 'models/remote_upload_job.dart';
import 'models/trash_can_content.dart';
import 'models/one_time_link_info.dart';

/// Main client for interacting with the RapidGator API.
class RapidGatorApi {
  final Dio _dio;
  String? _token;
  String? get token => _token;

  int maximum_list_size = 25;

  /// Creates a new instance of the RapidGator API client.
  ///
  /// Optionally, a custom [Dio] instance can be provided.
  RapidGatorApi({Dio? dio})
      : _dio =
            dio ?? Dio(BaseOptions(baseUrl: 'https://rapidgator.net/api/v2')) {
    // _dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  void setToken(String token) {
    _token = token;
  }

  void _checkLogin() {
    if (_token == null) throw Exception('User is not logged in.');
  }

  void _checkList(int size) {
    if (size > maximum_list_size) {
      throw Exception('Maximum of 25 items can be checked per request.');
    }
  }

  /// Makes a standard API request and returns a Map.
  Future<Map<String, dynamic>> _apiRequest({
    required String endpoint,
    required Map<String, dynamic> params,
    bool isPost = false,
  }) async {
    try {
      final response = isPost
          ? await _dio.post(endpoint, queryParameters: params)
          : await _dio.get(endpoint, queryParameters: params);

      if (response.statusCode == 200) {
        return response.data['response'];
      } else {
        throw InvalidResponseException(response.data['details']);
      }
    } on DioException catch (e) {
      throw NetworkException(e.response?.data['details'] ?? e.message);
    }
  }

  /// Makes an API request and returns a List of Maps.
  Future<List<Map<String, dynamic>>> _apiListRequest({
    required String endpoint,
    required Map<String, dynamic> params,
    bool isPost = false,
  }) async {
    try {
      final response = isPost
          ? await _dio.post(endpoint, queryParameters: params)
          : await _dio.get(endpoint, queryParameters: params);

      if (response.statusCode == 200) {
        final responseData = response.data['response'];
        if (responseData is List) {
          return responseData
              .map((item) => Map<String, dynamic>.from(item))
              .toList();
        } else {
          throw InvalidResponseException('Invalid response format.');
        }
      } else {
        throw InvalidResponseException(response.data['details']);
      }
    } on DioException catch (e) {
      throw NetworkException(e.response?.data['details'] ?? e.message);
    }
  }

  /// Logs in the user and sets the access token.
  ///
  /// Throws an exception if the login fails.
  Future<void> login({
    required String email,
    required String password,
    String? twoFactorCode,
  }) async {
    try {
      final response = await _apiRequest(
        endpoint: '/user/login',
        params: {
          'login': email,
          'password': password,
          if (twoFactorCode != null) 'code': twoFactorCode,
        },
        isPost: true,
      );
      setToken(response['token']);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  /// Retrieves user information.
  ///
  /// Throws an exception if the user is not logged in.
  Future<UserInfo> getUserInfo() async {
    _checkLogin();
    final response = await _apiRequest(
      endpoint: '/user/info',
      params: {'token': _token!},
    );
    return UserInfo.fromJson(response['user']);
  }

  /// Creates a folder.
  ///
  /// Throws an exception if the user is not logged in.
  Future<FolderInfo> createFolder({
    required String name,
    String? parentFolderId,
  }) async {
    _checkLogin();
    final response = await _apiRequest(
      endpoint: '/folder/create',
      params: {
        'token': _token!,
        'name': name,
        if (parentFolderId != null) 'folder_id': parentFolderId,
      },
      isPost: true,
    );
    return FolderInfo.fromJson(response['folder']);
  }

  /// Retrieves folder information.
  ///
  /// Throws an exception if the user is not logged in.
  Future<FolderInfo> getFolderInfo({String? folderId}) async {
    _checkLogin();
    final response = await _apiRequest(
      endpoint: '/folder/info',
      params: {
        'token': _token!,
        if (folderId != null) 'folder_id': folderId,
      },
    );
    return FolderInfo.fromJson(response['folder']);
  }

  /// Retrieves folder content.
  ///
  /// Throws an exception if the user is not logged in.
  Future<List<FolderInfo>> getFolderContent({
    String? folderId,
    int page = 1,
    int perPage = 500,
    String sortColumn = 'name',
    String sortDirection = 'ASC',
  }) async {
    _checkLogin();
    final response = await _apiListRequest(
      endpoint: '/folder/content',
      params: {
        'token': _token!,
        if (folderId != null) 'folder_id': folderId,
        'page': page,
        'per_page': perPage,
        'sort_column': sortColumn,
        'sort_direction': sortDirection,
      },
    );
    return response.map((item) => FolderInfo.fromJson(item)).toList();
  }

  /// Renames a folder.
  ///
  /// Throws an exception if the user is not logged in.
  Future<FolderInfo> renameFolder({
    required String folderId,
    required String newName,
  }) async {
    _checkLogin();
    final response = await _apiRequest(
      endpoint: '/folder/rename',
      params: {
        'token': _token!,
        'folder_id': folderId,
        'name': newName,
      },
      isPost: true,
    );
    return FolderInfo.fromJson(response['folder']);
  }

  /// Copies a folder.
  ///
  /// Throws an exception if the user is not logged in.
  Future<Map<String, dynamic>> copyFolder({
    required String folderId,
    required String destinationFolderId,
  }) async {
    _checkLogin();
    return await _apiRequest(
      endpoint: '/folder/copy',
      params: {
        'token': _token!,
        'folder_id': folderId,
        'folder_id_dest': destinationFolderId,
      },
      isPost: true,
    );
  }

  /// Moves a folder.
  ///
  /// Throws an exception if the user is not logged in.
  Future<Map<String, dynamic>> moveFolder({
    required String folderId,
    required String destinationFolderId,
  }) async {
    _checkLogin();
    return await _apiRequest(
      endpoint: '/folder/move',
      params: {
        'token': _token!,
        'folder_id': folderId,
        'folder_id_dest': destinationFolderId,
      },
      isPost: true,
    );
  }

  /// Deletes a folder.
  ///
  /// Throws an exception if the user is not logged in.
  Future<Map<String, dynamic>> deleteFolder({
    required String folderId,
  }) async {
    _checkLogin();
    return await _apiRequest(
      endpoint: '/folder/delete',
      params: {
        'token': _token!,
        'folder_id': folderId,
      },
      isPost: true,
    );
  }

  /// Changes folder mode.
  ///
  /// Throws an exception if the user is not logged in.
  Future<FolderInfo> changeFolderMode({
    required String folderId,
    required int mode,
  }) async {
    _checkLogin();
    final response = await _apiRequest(
      endpoint: '/folder/change_mode',
      params: {
        'token': _token!,
        'folder_id': folderId,
        'mode': mode,
      },
      isPost: true,
    );
    return FolderInfo.fromJson(response['folder']);
  }

  /// Uploads a file.
  ///
  /// Throws an exception if the user is not logged in.
  Future<Map<String, dynamic>> uploadFile({
    required String name,
    required String hash,
    required int size,
    String? folderId,
  }) async {
    _checkLogin();
    return await _apiRequest(
      endpoint: '/file/upload',
      params: {
        'token': _token!,
        'name': name,
        'hash': hash,
        'size': size,
        if (folderId != null) 'folder_id': folderId,
      },
      isPost: true,
    );
  }

  /// Retrieves upload session info.
  ///
  /// Throws an exception if the user is not logged in.
  Future<Map<String, dynamic>> getUploadInfo({
    required String uploadId,
  }) async {
    _checkLogin();
    return await _apiRequest(
      endpoint: '/file/upload_info',
      params: {
        'token': _token!,
        'upload_id': uploadId,
      },
    );
  }

  /// Downloads a file.
  ///
  /// Throws an exception if the user is not logged in.
  Future<String> downloadFile({
    required String fileId,
  }) async {
    _checkLogin();
    final response = await _apiRequest(
      endpoint: '/file/download',
      params: {
        'token': _token!,
        'file_id': fileId,
      },
      isPost: true,
    );
    return response['download_url'];
  }

  /// Retrieves file information.
  ///
  /// Throws an exception if the user is not logged in.
  Future<FileInfo> getFileInfo({
    required String fileId,
  }) async {
    _checkLogin();
    final response = await _apiRequest(
      endpoint: '/file/info',
      params: {
        'token': _token!,
        'file_id': fileId,
      },
    );
    return FileInfo.fromJson(response['file']);
  }

  /// Renames a file.
  ///
  /// Throws an exception if the user is not logged in.
  Future<FileInfo> renameFile({
    required String fileId,
    required String newName,
  }) async {
    _checkLogin();
    final response = await _apiRequest(
      endpoint: '/file/rename',
      params: {
        'token': _token!,
        'file_id': fileId,
        'name': newName,
      },
      isPost: true,
    );
    return FileInfo.fromJson(response['file']);
  }

  /// Copies a file.
  ///
  /// [fileIds]: A list of file Id's to copy.
  ///
  /// Throws an exception if the user is not logged in.
  Future<Map<String, dynamic>> copyFile({
    required List<String> fileIds,
    required String destinationFolderId,
  }) async {
    _checkList(fileIds.length);
    _checkLogin();
    final fileIdParam = fileIds.join(',');
    return await _apiRequest(
      endpoint: '/file/copy',
      params: {
        'token': _token!,
        'file_id': fileIdParam,
        'folder_id_dest': destinationFolderId,
      },
      isPost: true,
    );
  }

  /// Moves a file.
  ///
  /// [fileIds]: A list of file Id's to move.
  ///
  /// Throws an exception if the user is not logged in.
  Future<Map<String, dynamic>> moveFile({
    required List<String> fileIds,
    required String destinationFolderId,
  }) async {
    _checkList(fileIds.length);
    _checkLogin();
    final fileIdParam = fileIds.join(',');
    return await _apiRequest(
      endpoint: '/file/move',
      params: {
        'token': _token!,
        'file_id': fileIdParam,
        'folder_id_dest': destinationFolderId,
      },
      isPost: true,
    );
  }

  /// Deletes a file.
  ///
  /// [fileIds]: A list of file Id's to delete.
  ///
  /// Throws an exception if the user is not logged in.
  Future<Map<String, dynamic>> deleteFile({
    required List<String> fileIds,
  }) async {
    _checkList(fileIds.length);
    _checkLogin();
    final fileIdParam = fileIds.join(',');
    return await _apiRequest(
      endpoint: '/file/delete',
      params: {
        'token': _token!,
        'file_id': fileIdParam,
      },
      isPost: true,
    );
  }

  /// Changes file mode.
  ///
  /// Throws an exception if the user is not logged in.
  Future<FileInfo> changeFileMode({
    required String fileId,
    required int mode,
  }) async {
    _checkLogin();
    final response = await _apiRequest(
      endpoint: '/file/change_mode',
      params: {
        'token': _token!,
        'file_id': fileId,
        'mode': mode,
      },
      isPost: true,
    );
    return FileInfo.fromJson(response['file']);
  }

  /// Checks the status of download links.
  ///
  /// [urls]: A list of URLs to check (maximum 25 links per request).
  ///
  /// Throws an exception if:
  /// - The user is not logged in.
  /// - More than 25 links are provided.
  Future<List<CheckLinkResponse>> checkLinks({
    required List<String> urls,
  }) async {
    _checkList(urls.length);
    _checkLogin();

    final urlParam = urls.join(',');

    final response = await _apiListRequest(
      endpoint: '/file/check_link',
      params: {
        'token': _token!,
        'url': urlParam,
      },
    );

    return response.map((item) => CheckLinkResponse.fromJson(item)).toList();
  }

  /// Creates a one-time download link.
  ///
  /// Throws an exception if the user is not logged in.
  Future<OneTimeLinkInfo> createOneTimeLink({
    required String fileId,
    String? callbackUrl,
    bool notify = false,
  }) async {
    _checkLogin();
    final response = await _apiRequest(
      endpoint: '/file/onetimelink_create',
      params: {
        'token': _token!,
        'file_id': fileId,
        if (callbackUrl != null) 'url': callbackUrl,
        'notify': notify ? 1 : 0,
      },
      isPost: true,
    );
    return OneTimeLinkInfo.fromJson(response['link']);
  }

  /// Retrieves one-time link info.
  ///
  /// Throws an exception if the user is not logged in.
  Future<List<OneTimeLinkInfo>> getOneTimeLinkInfo({
    List<String>? linkIds,
  }) async {
    if (linkIds != null) {
      _checkList(linkIds.length);
    }

    _checkLogin();
    final response = await _apiListRequest(
      endpoint: '/file/onetimelink_info',
      params: {
        'token': _token!,
        if (linkIds != null) 'link_id': linkIds.join(','),
      },
    );
    return response.map((item) => OneTimeLinkInfo.fromJson(item)).toList();
  }

  /// Retrieves trash can content.
  ///
  /// Throws an exception if the user is not logged in.
  Future<List<TrashCanContent>> getTrashCanContent({
    String? folderId,
    int page = 1,
    int perPage = 500,
    String sortColumn = 'name',
    String sortDirection = 'ASC',
  }) async {
    _checkLogin();
    final response = await _apiListRequest(
      endpoint: '/trashcan/content',
      params: {
        'token': _token!,
        if (folderId != null) 'folder_id': folderId,
        'page': page,
        'per_page': perPage,
        'sort_column': sortColumn,
        'sort_direction': sortDirection,
      },
    );
    return response.map((item) => TrashCanContent.fromJson(item)).toList();
  }

  /// Restores files from the trash can.
  ///
  /// Throws an exception if the user is not logged in.
  Future<Map<String, dynamic>> restoreTrashCanFiles({
    List<String>? fileIds,
  }) async {
    _checkLogin();
    return await _apiRequest(
      endpoint: '/trashcan/restore',
      params: {
        'token': _token!,
        if (fileIds != null) 'file_id': fileIds.join(','),
      },
      isPost: true,
    );
  }

  /// Empties the trash can.
  ///
  /// Throws an exception if the user is not logged in.
  Future<Map<String, dynamic>> emptyTrashCan({
    List<String>? fileIds,
  }) async {
    _checkLogin();
    return await _apiRequest(
      endpoint: '/trashcan/empty',
      params: {
        'token': _token!,
        if (fileIds != null) 'file_id': fileIds.join(','),
      },
      isPost: true,
    );
  }

  /// Creates a remote upload job.
  ///
  /// Throws an exception if the user is not logged in.
  Future<Map<String, dynamic>> createRemoteUpload({
    required String url,
  }) async {
    _checkLogin();
    return await _apiRequest(
      endpoint: '/remote/create',
      params: {
        'token': _token!,
        'url': url,
      },
      isPost: true,
    );
  }

  /// Retrieves remote upload job info.
  ///
  /// Throws an exception if the user is not logged in.
  Future<List<RemoteUploadJob>> getRemoteUploadInfo({String? jobId}) async {
    _checkLogin();
    final response = await _apiListRequest(
      endpoint: '/remote/info',
      params: {
        'token': _token!,
        if (jobId != null) 'job_id': jobId,
      },
    );
    return response.map((item) => RemoteUploadJob.fromJson(item)).toList();
  }

  /// Deletes a remote upload job.
  ///
  /// Throws an exception if the user is not logged in.
  Future<Map<String, dynamic>> deleteRemoteUpload({
    required String jobId,
  }) async {
    _checkLogin();
    return await _apiRequest(
      endpoint: '/remote/delete',
      params: {
        'token': _token!,
        'job_id': jobId,
      },
      isPost: true,
    );
  }
}
