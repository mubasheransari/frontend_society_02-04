part of 'noc_scan_cubit.dart';

enum NocScanStatus { initial, loading, success, failure }

class NocScanState extends Equatable {
  const NocScanState({
    required this.baseUrl,
    this.status = NocScanStatus.initial,
    this.nocDetail,
    this.errorMessage,
    this.lastScannedCode,
    this.isTorchOn = false,
  });

  final String baseUrl;
  final NocScanStatus status;
  final NocDetail? nocDetail;
  final String? errorMessage;
  final String? lastScannedCode;
  final bool isTorchOn;

  bool get canShowResult => status == NocScanStatus.success && nocDetail != null;

  NocScanState copyWith({
    String? baseUrl,
    NocScanStatus? status,
    NocDetail? nocDetail,
    String? errorMessage,
    String? lastScannedCode,
    bool? isTorchOn,
    bool clearDetail = false,
    bool clearError = false,
    bool clearLastScannedCode = false,
  }) {
    return NocScanState(
      baseUrl: baseUrl ?? this.baseUrl,
      status: status ?? this.status,
      nocDetail: clearDetail ? null : (nocDetail ?? this.nocDetail),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      lastScannedCode: clearLastScannedCode ? null : (lastScannedCode ?? this.lastScannedCode),
      isTorchOn: isTorchOn ?? this.isTorchOn,
    );
  }

  @override
  List<Object?> get props => [baseUrl, status, nocDetail, errorMessage, lastScannedCode, isTorchOn];
}
