enum RequestStatus { initial, loading, fail, success, loadingMore }

extension RequestStatusX on RequestStatus {
  bool get isInitial => this == RequestStatus.initial;

  bool get isLoading => this == RequestStatus.loading;

  bool get isFail => this == RequestStatus.fail;

  bool get isSuccess => this == RequestStatus.success;

  bool get isLoadingMore => this == RequestStatus.loadingMore;
}
