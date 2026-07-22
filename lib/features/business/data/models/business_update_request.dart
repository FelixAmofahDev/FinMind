class BusinessUpdateRequest {
  const BusinessUpdateRequest({
    this.name,
    this.type,
    this.ownerName,
    this.phoneNumber,
    this.locationRegion,
    this.locationDistrict,
  });

  final String? name;
  final String? type;
  final String? ownerName;
  final String? phoneNumber;
  final String? locationRegion;
  final String? locationDistrict;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (name != null && name!.trim().isNotEmpty) 'name': name!.trim(),
      if (type != null && type!.trim().isNotEmpty) 'type': type!.trim(),
      if (ownerName != null && ownerName!.trim().isNotEmpty) 'ownerName': ownerName!.trim(),
      if (phoneNumber != null && phoneNumber!.trim().isNotEmpty) 'phoneNumber': phoneNumber!.trim(),
      if (locationRegion != null && locationRegion!.trim().isNotEmpty) 'locationRegion': locationRegion!.trim(),
      if (locationDistrict != null && locationDistrict!.trim().isNotEmpty) 'locationDistrict': locationDistrict!.trim(),
    };
  }
}
