class APIException implements Exception {
  final String message;
  final String statusCode;

  const APIException({required this.message, required this.statusCode});
}

class CacheException implements Exception {
  final String message;

  const CacheException({required this.message});
}

class GeneralException implements Exception {
  final String message;

  const GeneralException({required this.message});
}
