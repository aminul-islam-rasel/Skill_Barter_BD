// App Exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, {this.code});

  @override
  String toString() => message;
}

// Authentication Exceptions
class AuthException extends AppException {
  const AuthException(super.message, {super.code});
}

class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException() : super('Invalid email or password');
}

class UserNotFoundException extends AuthException {
  const UserNotFoundException() : super('User not found');
}

class EmailAlreadyInUseException extends AuthException {
  const EmailAlreadyInUseException() : super('Email is already in use');
}

class WeakPasswordException extends AuthException {
  const WeakPasswordException() : super('Password is too weak');
}

class NetworkException extends AuthException {
  const NetworkException()
    : super('Network error. Please check your connection');
}

class SessionExpiredException extends AuthException {
  const SessionExpiredException()
    : super('Session expired. Please login again');
}

// Database Exceptions
class DatabaseException extends AppException {
  const DatabaseException(super.message, {super.code});
}

class DocumentNotFoundException extends DatabaseException {
  const DocumentNotFoundException() : super('Document not found');
}

class DataParsingException extends DatabaseException {
  const DataParsingException() : super('Failed to parse data');
}

// Credit Exceptions
class CreditException extends AppException {
  const CreditException(super.message, {super.code});
}

class InsufficientCreditsException extends CreditException {
  const InsufficientCreditsException() : super('Insufficient credits');
}

class TransactionFailedException extends CreditException {
  const TransactionFailedException() : super('Transaction failed');
}

class InvalidCreditAmountException extends CreditException {
  const InvalidCreditAmountException() : super('Invalid credit amount');
}

// Validation Exceptions
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException(super.message, {this.fieldErrors});
}

// Permission Exceptions
class PermissionException extends AppException {
  const PermissionException(super.message, {super.code});
}

class UnauthorizedException extends PermissionException {
  const UnauthorizedException()
    : super('You are not authorized to perform this action');
}

// General Exceptions
class UnknownException extends AppException {
  const UnknownException([String message = 'An unknown error occurred'])
    : super(message);
}

class CacheException extends AppException {
  const CacheException(super.message, {super.code});
}
