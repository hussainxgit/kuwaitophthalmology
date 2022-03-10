class DataResponse {
  String? errorCode, successMessage;
  bool onError = false;
  bool onSuccess = false;
  Object? object;

  setError(String errorMessage) => {
        successMessage = null,
        onSuccess = false,
        object = null,
        onError = true,
        errorCode = errorMessage
      };

  setSuccess(String successMessage, [Object? object]) => {
        errorCode = null,
        onError = false,
        onSuccess = true,
        this.successMessage = successMessage,
        this.object = object
      };
}
