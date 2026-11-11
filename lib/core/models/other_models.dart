class MedicineItem {
  final int id;
  final String name;
  final String dose;
  final String time;
  final String memberId;
  final bool stopped;
  final bool completed;

  const MedicineItem({
    required this.id,
    required this.name,
    required this.dose,
    required this.time,
    required this.memberId,
    this.stopped = false,
    this.completed = false,
  });

  MedicineItem copyWith({
    int? id,
    String? name,
    String? dose,
    String? time,
    String? memberId,
    bool? stopped,
    bool? completed,
  }) {
    return MedicineItem(
      id: id ?? this.id,
      name: name ?? this.name,
      dose: dose ?? this.dose,
      time: time ?? this.time,
      memberId: memberId ?? this.memberId,
      stopped: stopped ?? this.stopped,
      completed: completed ?? this.completed,
    );
  }
}

class AppointmentItem {
  final int id;
  final String title;
  final String provider;
  final String date;
  final String time;
  final String memberId;

  const AppointmentItem({
    required this.id,
    required this.title,
    required this.provider,
    required this.date,
    required this.time,
    required this.memberId,
  });
}

class InsurancePolicy {
  final int id;
  final String name;
  final String provider;
  final String policyNumber;
  final String coverAmount;
  final String expiryDate;

  const InsurancePolicy({
    required this.id,
    required this.name,
    required this.provider,
    required this.policyNumber,
    required this.coverAmount,
    required this.expiryDate,
  });
}

class EmergencyProfile {
  final String allergy;
  final String conditions;
  final String medicines;
  final String emergencyContact;
  final String contactPhone;

  const EmergencyProfile({
    required this.allergy,
    required this.conditions,
    required this.medicines,
    required this.emergencyContact,
    required this.contactPhone,
  });

  EmergencyProfile copyWith({
    String? allergy,
    String? conditions,
    String? medicines,
    String? emergencyContact,
    String? contactPhone,
  }) {
    return EmergencyProfile(
      allergy: allergy ?? this.allergy,
      conditions: conditions ?? this.conditions,
      medicines: medicines ?? this.medicines,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      contactPhone: contactPhone ?? this.contactPhone,
    );
  }
}
