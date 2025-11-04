

class WorkflowResponse {
  String? documentId;
  String? screen;
  String? message;
  int? errorCode;
  int? code;
  String? step;
  List<String>? permissions;

  @override
  String toString() {
    return "documentId : ${documentId}, message: ${message}, code: ${code}, permissions: ${permissions}";
  }
}
