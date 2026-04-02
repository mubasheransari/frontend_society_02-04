import 'package:equatable/equatable.dart';

class NocDetail extends Equatable {
  const NocDetail({
    required this.nocNumber,
    required this.nocType,
    required this.status,
    required this.plotNo,
    required this.applicantName,
    this.plotMeasureSqYds,
    this.relationType,
    this.relationName,
    this.ownerType,
    this.cnic,
    this.duesClearedUpTo,
    this.buildingType,
    this.transferredName,
    this.remarks,
    this.issuedDate,
    this.signingAuthorityName,
    this.signingAuthorityDesignation,
    this.signingAuthorityOrganization,
  });

  final String nocNumber;
  final String nocType;
  final String status;
  final String plotNo;
  final String applicantName;
  final String? plotMeasureSqYds;
  final String? relationType;
  final String? relationName;
  final String? ownerType;
  final String? cnic;
  final String? duesClearedUpTo;
  final String? buildingType;
  final String? transferredName;
  final String? remarks;
  final String? issuedDate;
  final String? signingAuthorityName;
  final String? signingAuthorityDesignation;
  final String? signingAuthorityOrganization;

  factory NocDetail.fromJson(Map<String, dynamic> json) {
    final signingAuthority = json['signingAuthority'];
    final auth = signingAuthority is Map<String, dynamic> ? signingAuthority : <String, dynamic>{};

    return NocDetail(
      nocNumber: (json['nocNumber'] ?? json['qrValue'] ?? '').toString(),
      nocType: (json['nocType'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      plotNo: (json['plotNo'] ?? '').toString(),
      applicantName: (json['applicantName'] ?? '').toString(),
      plotMeasureSqYds: json['plotMeasureSqYds']?.toString(),
      relationType: json['relationType']?.toString(),
      relationName: json['relationName']?.toString(),
      ownerType: json['ownerType']?.toString(),
      cnic: json['cnic']?.toString(),
      duesClearedUpTo: json['duesClearedUpTo']?.toString(),
      buildingType: json['buildingType']?.toString(),
      transferredName: json['transferredName']?.toString(),
      remarks: json['remarks']?.toString(),
      issuedDate: json['issuedDate']?.toString(),
      signingAuthorityName: auth['name']?.toString(),
      signingAuthorityDesignation: auth['designation']?.toString(),
      signingAuthorityOrganization: auth['organization']?.toString(),
    );
  }

  @override
  List<Object?> get props => [
        nocNumber,
        nocType,
        status,
        plotNo,
        applicantName,
        plotMeasureSqYds,
        relationType,
        relationName,
        ownerType,
        cnic,
        duesClearedUpTo,
        buildingType,
        transferredName,
        remarks,
        issuedDate,
        signingAuthorityName,
        signingAuthorityDesignation,
        signingAuthorityOrganization,
      ];
}
