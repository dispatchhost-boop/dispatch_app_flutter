import 'error.dart';

class Payload {
  String? type;
  Map<Object?, Object?>? data;
  Error? error;

  @override
  String toString() {
    return 'Payload{type: $type, data: $data, error: $error}';
  }
}
