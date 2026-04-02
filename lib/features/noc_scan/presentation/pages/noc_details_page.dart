import 'package:flutter/material.dart';

import '../../data/models/noc_detail.dart';
import '../widgets/detail_tile.dart';
import '../widgets/status_chip.dart';

class NocDetailsPage extends StatelessWidget {
  const NocDetailsPage({super.key, required this.detail});

  final NocDetail detail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NOC Details')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  detail.nocType.isEmpty ? 'NOC' : detail.nocType,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  detail.nocNumber,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          StatusChip(status: detail.status),
                        ],
                      ),
                      const SizedBox(height: 18),
                      DetailTile(label: 'Plot No', value: detail.plotNo, icon: Icons.home_work_outlined),
                      const SizedBox(height: 10),
                      DetailTile(label: 'Applicant Name', value: detail.applicantName, icon: Icons.person_outline),
                      const SizedBox(height: 10),
                      DetailTile(
                        label: 'Relation',
                        value: [detail.relationType, detail.relationName]
                            .whereType<String>()
                            .where((e) => e.trim().isNotEmpty)
                            .join(' '),
                        icon: Icons.family_restroom_outlined,
                      ),
                      const SizedBox(height: 10),
                      DetailTile(label: 'Owner Type', value: detail.ownerType ?? '', icon: Icons.badge_outlined),
                      const SizedBox(height: 10),
                      DetailTile(label: 'Plot Measure', value: detail.plotMeasureSqYds ?? '', icon: Icons.square_foot_outlined),
                      const SizedBox(height: 10),
                      DetailTile(label: 'CNIC', value: detail.cnic ?? '', icon: Icons.credit_card_outlined),
                      const SizedBox(height: 10),
                      DetailTile(label: 'Dues Cleared Up To', value: detail.duesClearedUpTo ?? '', icon: Icons.event_available_outlined),
                      const SizedBox(height: 10),
                      DetailTile(label: 'Building Type', value: detail.buildingType ?? '', icon: Icons.apartment_outlined),
                      const SizedBox(height: 10),
                      DetailTile(label: 'Transferred Name', value: detail.transferredName ?? '', icon: Icons.swap_horiz_outlined),
                      const SizedBox(height: 10),
                      DetailTile(label: 'Remarks', value: detail.remarks ?? '', icon: Icons.notes_outlined),
                      const SizedBox(height: 10),
                      DetailTile(label: 'Issued Date', value: detail.issuedDate ?? '', icon: Icons.calendar_month_outlined),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Signing Authority',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 12),
                      DetailTile(label: 'Name', value: detail.signingAuthorityName ?? ''),
                      const SizedBox(height: 10),
                      DetailTile(label: 'Designation', value: detail.signingAuthorityDesignation ?? ''),
                      const SizedBox(height: 10),
                      DetailTile(label: 'Organization', value: detail.signingAuthorityOrganization ?? ''),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
