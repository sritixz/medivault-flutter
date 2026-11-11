import '../models/family_member.dart';
import '../models/medical_record.dart';
import '../models/other_models.dart';

class MockData {
  static const List<String> categories = [
    'All records',
    'Prescriptions',
    'Lab reports',
    'Specialist records',
    'Vaccinations',
    'Dental',
    'Radiology & imaging',
    'Consultation notes',
    'Discharge summaries',
    'Bills & payments',
    'Surgery & procedures',
    'Insurance documents',
    'Allergy & condition',
    'Other medical',
  ];

  static List<FamilyMember> initialMembers = [
    const FamilyMember(
      id: 'vikram',
      name: 'Vikram Sharma',
      shortName: 'Vikram',
      relation: 'Self',
      age: 40,
      initials: 'VS',
      color: 'mint',
      bloodGroup: 'B+',
    ),
    const FamilyMember(
      id: 'pooja',
      name: 'Pooja Sharma',
      shortName: 'Pooja',
      relation: 'Wife',
      age: 37,
      initials: 'PS',
      color: 'peach',
      bloodGroup: 'O+',
    ),
    const FamilyMember(
      id: 'aarav',
      name: 'Aarav Sharma',
      shortName: 'Aarav',
      relation: 'Son',
      age: 8,
      initials: 'AS',
      color: 'blue',
      bloodGroup: 'B+',
    ),
    const FamilyMember(
      id: 'deepak',
      name: 'Deepak Sharma',
      shortName: 'Deepak',
      relation: 'Father',
      age: 68,
      initials: 'DS',
      color: 'lilac',
      bloodGroup: 'B+',
    ),
  ];

  static List<MedicalRecord> initialRecords = [
    const MedicalRecord(
      id: 1,
      title: 'General physician prescription',
      category: 'Prescriptions',
      memberId: 'vikram',
      provider: 'Dr. Ananya Roy',
      date: '2026-11-02',
      type: 'PDF',
      notes: 'Follow-up prescription. Review medicines with your doctor.',
    ),
    const MedicalRecord(
      id: 2,
      title: 'Complete blood count',
      category: 'Lab reports',
      memberId: 'vikram',
      provider: 'City Diagnostics',
      date: '2026-10-28',
      type: 'PDF',
      notes: 'Sample report. Results belong in the attached document.',
    ),
    const MedicalRecord(
      id: 3,
      title: 'Dental consultation notes',
      category: 'Dental',
      memberId: 'pooja',
      provider: 'Dr. Meera Shah',
      date: '2026-10-25',
      type: 'PDF',
      notes: 'Routine dental consultation and follow-up notes.',
    ),
    const MedicalRecord(
      id: 4,
      title: 'Influenza vaccination record',
      category: 'Vaccinations',
      memberId: 'aarav',
      provider: 'Family Health Clinic',
      date: '2026-10-20',
      type: 'PDF',
      notes: 'Sample vaccination entry. Confirm dates against original record.',
    ),
    const MedicalRecord(
      id: 5,
      title: 'Knee X-ray report',
      category: 'Radiology & imaging',
      memberId: 'deepak',
      provider: 'City Imaging Centre',
      date: '2026-10-18',
      type: 'PDF',
      notes: 'Radiology report and consultation notes.',
    ),
    const MedicalRecord(
      id: 6,
      title: 'Annual health checkup',
      category: 'Lab reports',
      memberId: 'pooja',
      provider: 'City Diagnostics',
      date: '2026-10-15',
      type: 'PDF',
      notes: 'Annual health test record.',
    ),
  ];

  static List<MedicineItem> initialMedicines = [
    const MedicineItem(
      id: 1,
      name: 'Metformin 500 mg',
      dose: '1 tablet · After lunch',
      time: '14:00',
      memberId: 'vikram',
    ),
    const MedicineItem(
      id: 2,
      name: 'Vitamin D supplement',
      dose: 'As prescribed · After breakfast',
      time: '09:00',
      memberId: 'deepak',
    ),
  ];

  static List<AppointmentItem> initialAppointments = [
    const AppointmentItem(
      id: 1,
      title: 'Annual health review',
      provider: 'Dr. Ananya Roy',
      date: '2026-11-10',
      time: '10:30',
      memberId: 'vikram',
    ),
  ];

  static List<InsurancePolicy> initialPolicies = [
    const InsurancePolicy(
      id: 1,
      name: 'Family health policy',
      provider: 'Sample insurer',
      policyNumber: 'MV-DEMO-2026',
      coverAmount: '5,00,000',
      expiryDate: '2027-03-31',
    ),
  ];

  static Map<String, EmergencyProfile> initialEmergencies = {
    'vikram': const EmergencyProfile(
      allergy: 'Penicillin',
      conditions: 'Type 2 diabetes',
      medicines: 'Metformin 500 mg',
      emergencyContact: 'Pooja Sharma',
      contactPhone: '+91 98765 43210',
    ),
  };
}
