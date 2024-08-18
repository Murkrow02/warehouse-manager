import '../../../../core/models/serializable.dart';

class Supplier implements Serializable {
  final int id;
  final String name;
  final String contactDetails;
  final String paymentDetails;

  Supplier({
    this.id = 0,
    this.name = "",
    this.contactDetails = "",
    this.paymentDetails = "",
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['id'],
      name: json['name'],
      contactDetails: json['contact_details'],
      paymentDetails: json['payment_details'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'contact_details': contactDetails,
      'payment_details': paymentDetails,
    };
  }
}
