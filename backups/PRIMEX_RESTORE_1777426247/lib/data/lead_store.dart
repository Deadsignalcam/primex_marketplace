class LeadItem {
  final String name;
  final String phone;
  final String email;
  final String property;
  final String message;

  LeadItem({
    required this.name,
    required this.phone,
    required this.email,
    required this.property,
    required this.message,
  });
}

class LeadStore {
  static final List<LeadItem> leads = [];

  static void add(LeadItem lead) {
    leads.insert(0, lead);
  }
}
