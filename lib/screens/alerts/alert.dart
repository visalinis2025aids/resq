enum AlertStatus { live, pending, resolved }

class SafetyAlert {
  final String id;
  final String title;
  final String time;
  final String location;
  final AlertStatus status;

  SafetyAlert({
    required this.id,
    required this.title,
    required this.time,
    required this.location,
    required this.status,
  });

  String get statusText {
    switch (status) {
      case AlertStatus.live:
        return 'Live';
      case AlertStatus.pending:
        return 'Pending';
      case AlertStatus.resolved:
        return 'Resolved';
    }
  }
}