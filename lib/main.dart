import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/api/api_client.dart';
import 'core/config/app_config.dart';
import 'core/theme/app_theme.dart';
import 'features/noc_scan/data/noc_repository.dart';
import 'features/noc_scan/presentation/cubit/noc_scan_cubit.dart';
import 'features/noc_scan/presentation/pages/noc_scanner_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final apiClient = ApiClient(baseUrl: AppConfig.defaultBaseUrl);

  runApp(MyApp(apiClient: apiClient));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.apiClient});

  final ApiClient apiClient;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => NocRepository(apiClient: apiClient),
      child: BlocProvider(
        create: (context) => NocScanCubit(
          repository: context.read<NocRepository>(),
          initialBaseUrl: apiClient.baseUrl,
        ),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'LHS NOC Scanner',
          theme: AppTheme.light,
          home: const NocScannerPage(),
        ),
      ),
    );
  }
}
