/// Base class for all RapidGator API exceptions
abstract class RapidGatorException implements Exception {
  final String message;
  RapidGatorException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

/// Thrown when user attempts action without valid session
class NotLoggedInException extends RapidGatorException {
  NotLoggedInException() : super('No active login session');
}

/// Thrown for authentication failures
class LoginFailedException extends RapidGatorException {
  LoginFailedException(String details) : super('Login failed - $details');
}

/// Thrown for network-related issues
class NetworkException extends RapidGatorException {
  NetworkException(String message) : super('Network error - $message');
}

/// Thrown for unexpected API responses
class InvalidResponseException extends RapidGatorException {
  InvalidResponseException(String details)
      : super('Invalid API response - $details');
}

/// Thrown for business logic failures
class OperationFailedException extends RapidGatorException {
  OperationFailedException(String details)
      : super('Operation failed - $details');
}
