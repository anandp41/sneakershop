enum Status {
  ordered,
  pickedup,
  transit,
  outfordelivery,
  delivered,
  cancelled,
}

extension StatusExtension on Status {
  static Status fromMap(String status) {
    switch (status) {
      case 'ordered':
        return Status.ordered;
      case 'pickedup':
        return Status.pickedup;
      case 'transit':
        return Status.transit;
      case 'outfordelivery':
        return Status.outfordelivery;
      case 'delivered':
        return Status.delivered;
      case 'cancelled':
        return Status.cancelled;
      default:
        throw Exception('Unknown status: $status');
    }
  }

  String toMap() {
    return toString().split('.').last;
  }
}
