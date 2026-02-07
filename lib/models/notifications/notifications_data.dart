class NotificationData {
  final int serviceId;
  final int offerId;
  final int providerId;
  final String price;

  NotificationData({
    required this.serviceId,
    required this.offerId,
    required this.providerId,
    required this.price,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      serviceId: json['service_id'],
      offerId: json['offer_id'],
      providerId: json['provider_id'],
      price: json['price'],
    );
  }
}
