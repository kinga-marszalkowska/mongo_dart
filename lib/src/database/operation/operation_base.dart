import 'package:mongo_dart/src/database/utils/map_keys.dart';

enum Aspect {
  readOperation,
  skipSession,
  writeOperation,
  retryable,
  executeWithSelection
}

class OperationBase {
  Map<String, Object> options;
  Set<Aspect> _aspects;

  OperationBase(Map<String, Object> options) {
    this.options = Map.from(options ?? {});
  }

  bool hasAspect(Aspect aspect) =>
      _aspects != null && _aspects.contains(aspect);

  Object get session => options[keySession];

  // Todo check if this was the meaning of:
  //   Object.assign(this.options, { session });
  set session(Object value) => options[keySession] = value;

  void clearSession() => options.remove(keySession);

  bool get canRetryRead => true;

  Future<Map<String, Object>> execute() async => throw UnsupportedError(
      '"execute" must be implemented for OperationBase subclasses');

  void defineAspects(aspects) {
    if (aspects is Aspect) {
      _aspects = {aspects};
    } else {
      _aspects = {...aspects};
    }
  }
}
