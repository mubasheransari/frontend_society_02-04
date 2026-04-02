import '../../../core/api/api_client.dart';
import 'models/noc_detail.dart';

class NocRepository {
  const NocRepository({required this.apiClient});

  final ApiClient apiClient;

  Future<NocDetail> verifyNoc(String identifier) async {
    final safeIdentifier = Uri.encodeComponent(identifier.trim());
    final json = await apiClient.get('/api/noc/verify/$safeIdentifier');

    final isSuccess = json['isSuccess'] == true;
    final message = (json['message'] ?? 'Unable to verify NOC.').toString();

    if (!isSuccess) {
      throw Exception(message);
    }

    final result = json['result'];
    if (result is! Map<String, dynamic>) {
      throw const FormatException('NOC data is missing in API response.');
    }

    return NocDetail.fromJson(result);
  }
}
