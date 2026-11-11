import 'package:flutter/material.dart';
import '../core/models/family_member.dart';
import '../core/models/medical_record.dart';
import '../core/models/other_models.dart';
import '../core/data/mock_data.dart';

class AppState extends ChangeNotifier {
  final List<FamilyMember> _members = List.from(MockData.initialMembers);
  final List<MedicalRecord> _records = List.from(MockData.initialRecords);
  final List<MedicineItem> _medicines = List.from(MockData.initialMedicines);
  final List<AppointmentItem> _appointments = List.from(MockData.initialAppointments);
  final List<InsurancePolicy> _policies = List.from(MockData.initialPolicies);
  final Map<String, EmergencyProfile> _emergencies = Map.from(MockData.initialEmergencies);

  String _selectedMemberId = 'all';
  String _selectedCategory = 'All records';
  String _searchQuery = '';
  final Set<int> _takenMedicines = {};

  // Getters
  List<FamilyMember> get members => _members;
  List<MedicalRecord> get records => _records;
  List<MedicineItem> get medicines => _medicines;
  List<AppointmentItem> get appointments => _appointments;
  List<InsurancePolicy> get policies => _policies;
  String get selectedMemberId => _selectedMemberId;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  Set<int> get takenMedicines => _takenMedicines;

  FamilyMember? get activeMember {
    if (_selectedMemberId == 'all') return _members.first;
    return _members.firstWhere(
      (m) => m.id == _selectedMemberId,
      orElse: () => _members.first,
    );
  }

  // Filtered records
  List<MedicalRecord> get visibleRecords {
    return _records.where((r) {
      final matchesMember = _selectedMemberId == 'all' || r.memberId == _selectedMemberId;
      final matchesCat = _selectedCategory == 'All records' || r.category == _selectedCategory;
      final query = _searchQuery.toLowerCase().trim();
      final memberName = _members.firstWhere((m) => m.id == r.memberId, orElse: () => _members.first).name.toLowerCase();
      final matchesSearch = query.isEmpty ||
          r.title.toLowerCase().contains(query) ||
          r.provider.toLowerCase().contains(query) ||
          r.category.toLowerCase().contains(query) ||
          memberName.contains(query);
      return matchesMember && matchesCat && matchesSearch;
    }).toList();
  }

  // Active home records
  List<MedicalRecord> get homeRecords {
    return _records.where((r) => !r.archived && (_selectedMemberId == 'all' || r.memberId == _selectedMemberId)).toList();
  }

  // Home medicines
  List<MedicineItem> get homeMedicines {
    return _medicines.where((m) => !m.stopped && !m.completed && (_selectedMemberId == 'all' || m.memberId == _selectedMemberId)).toList();
  }

  // Actions
  void setMember(String memberId) {
    _selectedMemberId = memberId;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleMedicineTaken(int medicineId) {
    if (_takenMedicines.contains(medicineId)) {
      _takenMedicines.remove(medicineId);
    } else {
      _takenMedicines.add(medicineId);
    }
    notifyListeners();
  }

  void addRecord(MedicalRecord record) {
    _records.insert(0, record);
    notifyListeners();
  }

  void toggleBookmark(int recordId) {
    final index = _records.indexWhere((r) => r.id == recordId);
    if (index != -1) {
      _records[index] = _records[index].copyWith(bookmarked: !_records[index].bookmarked);
      notifyListeners();
    }
  }

  void toggleArchive(int recordId) {
    final index = _records.indexWhere((r) => r.id == recordId);
    if (index != -1) {
      _records[index] = _records[index].copyWith(archived: !_records[index].archived);
      notifyListeners();
    }
  }

  void deleteRecord(int recordId) {
    _records.removeWhere((r) => r.id == recordId);
    notifyListeners();
  }

  void addMember(FamilyMember member) {
    _members.add(member);
    notifyListeners();
  }

  void addMedicine(MedicineItem item) {
    _medicines.add(item);
    notifyListeners();
  }

  void addAppointment(AppointmentItem item) {
    _appointments.add(item);
    notifyListeners();
  }

  EmergencyProfile getEmergencyProfile(String memberId) {
    return _emergencies[memberId] ??
        const EmergencyProfile(
          allergy: 'None known',
          conditions: 'None reported',
          medicines: 'None',
          emergencyContact: 'Not added',
          contactPhone: 'Not added',
        );
  }

  void updateEmergencyProfile(String memberId, EmergencyProfile profile) {
    _emergencies[memberId] = profile;
    notifyListeners();
  }
}
