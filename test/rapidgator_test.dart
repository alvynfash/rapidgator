import 'package:dio/dio.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:rapidgator/rapidgator.dart';
import 'package:rapidgator/models/user_info.dart';
import 'package:rapidgator/models/folder_info.dart';
import 'package:rapidgator/models/file_info.dart';
import 'package:rapidgator/models/check_link_response.dart';
import 'package:rapidgator/exceptions.dart';

@GenerateMocks([Dio])
import 'rapidgator_test.mocks.dart';

void main() {
  late RapidGatorApi api;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    api = RapidGatorApi(dio: mockDio);
  });

  group('Authentication', () {
    test('login should set token on successful login', () async {
      when(mockDio.post('/user/login',
              queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => Response(
                data: {
                  'response': {'token': 'test_token'}
                },
                statusCode: 200,
                requestOptions: RequestOptions(path: '/user/login'),
              ));

      await api.login(email: 'test@example.com', password: 'password');
      expect(api.token, equals('test_token'));
    });

    test('login should include 2FA code when provided', () async {
      when(mockDio.post('/user/login',
              queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => Response(
                data: {
                  'response': {'token': 'test_token'}
                },
                statusCode: 200,
                requestOptions: RequestOptions(path: '/user/login'),
              ));

      await api.login(
          email: 'test@example.com',
          password: 'password',
          twoFactorCode: '123456');

      verify(mockDio.post('/user/login', queryParameters: {
        'login': 'test@example.com',
        'password': 'password',
        'code': '123456',
      })).called(1);
    });

    test('login should throw exception on failed login', () async {
      when(mockDio.post('/user/login',
              queryParameters: anyNamed('queryParameters')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: '/user/login'),
        response: Response(
          data: {'details': 'Invalid credentials'},
          statusCode: 401,
          requestOptions: RequestOptions(path: '/user/login'),
        ),
      ));

      expect(() => api.login(email: 'test@example.com', password: 'wrong'),
          throwsA(isA<Exception>()));
    });
  });

  group('User info', () {
    test('getUserInfo should return user information when logged in', () async {
      api.setToken('test_token');

      when(mockDio.get('/user/info',
              queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => Response(
                data: {
                  'response': {
                    'user': {
                      'email': 'test@example.com',
                      'is_premium': true,
                      'premium_end_time': '2023-01-01',
                      'state': 1,
                      'state_label': 'Active',
                      'traffic': {'total': 1024, 'left': 512},
                      'storage': {'total': 1024, 'left': 512},
                      'upload': {'max_file_size': 1024, 'nb_pipes': 512},
                      'remote_upload': {
                        'max_nb_jobs': 1024,
                        'refresh_time': 512
                      },
                    }
                  }
                },
                statusCode: 200,
                requestOptions: RequestOptions(path: '/user/info'),
              ));

      final userInfo = await api.getUserInfo();

      expect(userInfo, isA<UserInfo>());
      expect(userInfo.email, equals('test@example.com'));
      expect(userInfo.isPremium, isTrue);
    });

    test('getUserInfo should throw exception when not logged in', () async {
      expect(() => api.getUserInfo(), throwsA(isA<Exception>()));
    });
  });

  group('Folder operations', () {
    setUp(() {
      api.setToken('test_token');
    });

    test('createFolder should create a folder and return folder info',
        () async {
      when(mockDio.post('/folder/create',
              queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => Response(
                data: {
                  'response': {
                    'folder': {
                      'folder_id': 'folder123',
                      'mode': 0,
                      'mode_label': 'Normal',
                      'parent_folder_id': 'parent456',
                      'name': 'Test Folder',
                      'url': 'http://example.com/folder123',
                      'nb_folders': 1,
                      'nb_files': 2,
                      'size_files': 1024,
                      'created_at': '2023-01-01',
                      'folders': [],
                    }
                  }
                },
                statusCode: 200,
                requestOptions: RequestOptions(path: '/folder/create'),
              ));

      final folderInfo = await api.createFolder(
        name: 'Test Folder',
        parentFolderId: 'parent456',
      );

      expect(folderInfo, isA<FolderInfo>());
      expect(folderInfo.folderId, equals('folder123'));
      expect(folderInfo.parentFolderId, equals('parent456'));
      expect(folderInfo.name, equals('Test Folder'));
      expect(folderInfo.url, equals('http://example.com/folder123'));
      expect(folderInfo.mode, equals(0));
    });

    test('getFolderInfo should return folder information', () async {
      when(mockDio.get('/folder/info',
              queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => Response(
                data: {
                  'response': {
                    'folder': {
                      'folder_id': 'folder123',
                      'mode': 0,
                      'mode_label': 'Normal',
                      'parent_folder_id': 'parent456',
                      'name': 'Test Folder',
                      'url': 'http://example.com/folder123',
                      'nb_folders': 1,
                      'nb_files': 2,
                      'size_files': 1024,
                      'created_at': '2023-01-01',
                      'folders': [],
                    }
                  }
                },
                statusCode: 200,
                requestOptions: RequestOptions(path: '/folder/info'),
              ));

      final folderInfo = await api.getFolderInfo(folderId: 'folder123');

      expect(folderInfo, isA<FolderInfo>());
      expect(folderInfo.folderId, equals('folder123'));
      expect(folderInfo.name, equals('Test Folder'));
    });
  });

  group('File operations', () {
    setUp(() {
      api.setToken('test_token');
    });

    test('getFileInfo should return file information', () async {
      when(mockDio.get('/file/info',
              queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => Response(
                data: {
                  'response': {
                    'file': {
                      'file_id': 'file123',
                      'mode': 0,
                      'mode_label': 'Normal',
                      'folder_id': 'folder456',
                      'name': 'test.txt',
                      'size': 1024,
                      'hash': 'abc123',
                      'created_at': '2023-01-01',
                      'url': 'http://example.com/file123',
                    }
                  }
                },
                statusCode: 200,
                requestOptions: RequestOptions(path: '/file/info'),
              ));

      final fileInfo = await api.getFileInfo(fileId: 'file123');

      expect(fileInfo, isA<FileInfo>());
      expect(fileInfo.fileId, equals('file123'));
      expect(fileInfo.name, equals('test.txt'));
      expect(fileInfo.size, equals(1024));
    });

    test('downloadFile should return download URL', () async {
      when(mockDio.post('/file/download',
              queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => Response(
                data: {
                  'response': {
                    'download_url': 'https://download.example.com/file123'
                  }
                },
                statusCode: 200,
                requestOptions: RequestOptions(path: '/file/download'),
              ));

      final downloadUrl = await api.downloadFile(fileId: 'file123');

      expect(downloadUrl, equals('https://download.example.com/file123'));
    });

    test('checkLinks should correctly validate URLs', () async {
      when(mockDio.get('/file/check_link',
              queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => Response(
                data: {
                  'response': [
                    {
                      'url': 'https://rapidgator.net/file/123',
                      'status': 'available',
                      'filename': 'test.txt',
                      'filesize': 1024,
                      'file_id': 'file123',
                    }
                  ]
                },
                statusCode: 200,
                requestOptions: RequestOptions(path: '/file/check_link'),
              ));

      final results =
          await api.checkLinks(urls: ['https://rapidgator.net/file/123']);

      expect(results.length, equals(1));
      expect(results[0], isA<CheckLinkResponse>());
      expect(results[0].url, equals('https://rapidgator.net/file/123'));
      expect(results[0].status, equals('available'));
    });

    test('checkLinks should throw exception if too many links provided', () {
      final tooManyUrls =
          List.generate(30, (i) => 'https://rapidgator.net/file/$i');
      expect(
          () => api.checkLinks(urls: tooManyUrls), throwsA(isA<Exception>()));
    });
  });

  group('Error handling', () {
    setUp(() {
      api.setToken('test_token');
    });

    test('API should throw NetworkException on network error', () async {
      when(mockDio.get('/user/info',
              queryParameters: anyNamed('queryParameters')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: '/user/info'),
        message: 'Network error',
      ));

      expect(() => api.getUserInfo(), throwsA(isA<NetworkException>()));
    });

    test('API should throw InvalidResponseException on invalid response',
        () async {
      when(mockDio.get('/file/check_link',
              queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => Response(
                data: {'response': 'Not a list'},
                statusCode: 200,
                requestOptions: RequestOptions(path: '/file/check_link'),
              ));

      expect(() => api.checkLinks(urls: ['https://example.com']),
          throwsA(isA<InvalidResponseException>()));
    });
  });
}
