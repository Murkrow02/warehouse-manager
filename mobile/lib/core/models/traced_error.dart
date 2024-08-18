class TracedError
{
  final dynamic error;
  final StackTrace stackTrace;

  TracedError(this.error, this.stackTrace);
}