class UnexpectedStateException implements Exception {
  UnexpectedStateException();

  @override
  String toString() {
    return 'UnexpectedStateException: Unexpected state';
  }
}