import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../cubit/noc_scan_cubit.dart';
import '../widgets/status_chip.dart';
import 'noc_details_page.dart';

class NocScannerPage extends StatefulWidget {
  const NocScannerPage({super.key});

  @override
  State<NocScannerPage> createState() => _NocScannerPageState();
}

class _NocScannerPageState extends State<NocScannerPage> {
  final MobileScannerController _scannerController = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
    detectionSpeed: DetectionSpeed.normal,
    returnImage: false,
  );

  final TextEditingController _manualController = TextEditingController();
  final TextEditingController _baseUrlController = TextEditingController();

  bool _navigating = false;

  @override
  void initState() {
    super.initState();
    _baseUrlController.text = context.read<NocScanCubit>().state.baseUrl;
  }

  @override
  void dispose() {
    _manualController.dispose();
    _baseUrlController.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _openBaseUrlSheet() async {
    final cubit = context.read<NocScanCubit>();
    _baseUrlController.text = cubit.state.baseUrl;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 8,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Backend URL',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Use localhost for iOS simulator, 10.0.2.2 for Android emulator, or your laptop IP on a real device.',
                style: TextStyle(color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _baseUrlController,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'Base URL',
                  hintText: 'http://192.168.1.10:4000',
                  prefixIcon: Icon(Icons.link_outlined),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    cubit.updateBaseUrl(_baseUrlController.text);
                    Navigator.pop(context);
                  },
                  child: const Text('Save URL'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleDetection(BarcodeCapture capture) {
    if (capture.barcodes.isEmpty) return;

    final code = capture.barcodes.first.rawValue?.trim();
    if (code == null || code.isEmpty) return;

    context.read<NocScanCubit>().verifyScannedCode(code);
  }

  Future<void> _openDetailsIfNeeded(
    BuildContext context,
    NocScanState state,
  ) async {
    if (!state.canShowResult || _navigating) return;

    _navigating = true;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NocDetailsPage(detail: state.nocDetail!),
      ),
    );
    _navigating = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NocScanCubit, NocScanState>(
      listener: (context, state) async {
        if (state.status == NocScanStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
        }

        await _openDetailsIfNeeded(context, state);
      },
      builder: (context, state) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('LHS NOC Scanner'),
              actions: [
                IconButton(
                  tooltip: 'Backend URL',
                  onPressed: _openBaseUrlSheet,
                  icon: const Icon(Icons.settings_outlined),
                ),
              ],
              bottom: const TabBar(
                tabs: [
                  Tab(
                    text: 'Scan QR',
                    icon: Icon(Icons.qr_code_scanner_outlined),
                  ),
                  Tab(
                    text: 'Manual',
                    icon: Icon(Icons.keyboard_outlined),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFDBEAFE),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.cloud_done_outlined,
                              color: Color(0xFF1D4ED8),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Connected Backend',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  state.baseUrl,
                                  style: const TextStyle(
                                    color: Color(0xFF64748B),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (state.status == NocScanStatus.loading)
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildScannerTab(context, state),
                      _buildManualTab(context, state),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildScannerTab(BuildContext context, NocScanState state) {
    final isTorchOn = _scannerController.value.torchState == TorchState.on;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            height: 360,
            child: Stack(
              fit: StackFit.expand,
              children: [
                MobileScanner(
                  controller: _scannerController,
                  onDetect: _handleDetection,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.12),
                        Colors.transparent,
                        Colors.black.withOpacity(0.18),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: Row(
                    children: [
                      Expanded(
                        child: FilledButton.tonalIcon(
                          onPressed: () async {
                            await _scannerController.toggleTorch();
                            if (!context.mounted) return;

                            final value =
                                _scannerController.value.torchState;
                            context
                                .read<NocScanCubit>()
                                .setTorch(value == TorchState.on);

                            setState(() {});
                          },
                          icon: Icon(
                            isTorchOn
                                ? Icons.flash_on
                                : Icons.flash_off,
                          ),
                          label: Text(
                            isTorchOn ? 'Torch On' : 'Torch Off',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            await _scannerController.switchCamera();
                            if (!mounted) return;
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.cameraswitch_outlined,
                          ),
                          label: const Text('Flip'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const _HelperCard(),
      ],
    );
  }

  Widget _buildManualTab(BuildContext context, NocScanState state) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Manual NOC Verification',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Use this on simulator or desktop when camera scanning is not available.',
                  style: TextStyle(color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _manualController,
                  textInputAction: TextInputAction.search,
                  decoration: const InputDecoration(
                    labelText: 'NOC Number / QR Value',
                    hintText: 'NOC-20260402-0001',
                    prefixIcon: Icon(Icons.qr_code_2_outlined),
                  ),
                  onSubmitted: (_) {
                    context
                        .read<NocScanCubit>()
                        .verifyScannedCode(_manualController.text);
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: state.status == NocScanStatus.loading
                        ? null
                        : () {
                            context
                                .read<NocScanCubit>()
                                .verifyScannedCode(
                                  _manualController.text,
                                );
                          },
                    icon: const Icon(Icons.search_outlined),
                    label: const Text('Verify NOC'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _manualController.clear();
                      context.read<NocScanCubit>().clearResult();
                    },
                    icon: const Icon(Icons.refresh_outlined),
                    label: const Text('Reset'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (state.lastScannedCode != null &&
            state.lastScannedCode!.isNotEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Last Checked',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.lastScannedCode!,
                    style: const TextStyle(
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (state.nocDetail != null) ...[
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Plot ${state.nocDetail!.plotNo}',
                          ),
                        ),
                        StatusChip(status: state.nocDetail!.status),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _HelperCard extends StatelessWidget {
  const _HelperCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'How to test',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 8),
            Text('• Real phone: scan the QR directly from camera.'),
            SizedBox(height: 4),
            Text(
              '• iOS simulator: use the Manual tab because simulator camera scanning is not reliable.',
            ),
            SizedBox(height: 4),
            Text(
              '• Android emulator: you can still use Manual tab or configure webcam input if needed.',
            ),
          ],
        ),
      ),
    );
  }
}