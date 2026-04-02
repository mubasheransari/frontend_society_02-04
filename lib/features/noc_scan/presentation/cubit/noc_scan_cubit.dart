import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/api/api_client.dart';
import '../../data/models/noc_detail.dart';
import '../../data/noc_repository.dart';

part 'noc_scan_state.dart';

class NocScanCubit extends Cubit<NocScanState> {
  NocScanCubit({required this.repository, required String initialBaseUrl})
      : super(NocScanState(baseUrl: initialBaseUrl));

  final NocRepository repository;

  bool _busy = false;

  Future<void> verifyScannedCode(String rawCode) async {
    final code = rawCode.trim();
    if (code.isEmpty || _busy || code == state.lastScannedCode) return;

    _busy = true;
    emit(
      state.copyWith(
        status: NocScanStatus.loading,
        lastScannedCode: code,
        clearError: true,
      ),
    );

    try {
      final detail = await repository.verifyNoc(code);
      emit(
        state.copyWith(
          status: NocScanStatus.success,
          nocDetail: detail,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: NocScanStatus.failure,
          errorMessage: error.toString().replaceFirst('Exception: ', ''),
          clearDetail: true,
        ),
      );
    } finally {
      _busy = false;
    }
  }

  void updateBaseUrl(String value) {
    final cleaned = value.trim();
    if (cleaned.isEmpty) return;
    repository.apiClient.updateBaseUrl(cleaned);
    emit(
      state.copyWith(
        baseUrl: cleaned,
        status: NocScanStatus.initial,
        clearDetail: true,
        clearError: true,
        clearLastScannedCode: true,
      ),
    );
  }

  void setTorch(bool isOn) => emit(state.copyWith(isTorchOn: isOn));

  void clearResult() {
    emit(
      state.copyWith(
        status: NocScanStatus.initial,
        clearDetail: true,
        clearError: true,
        clearLastScannedCode: true,
      ),
    );
  }
}
