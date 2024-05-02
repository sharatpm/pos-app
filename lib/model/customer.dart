class Customer {
  final int id;
  final int vendorId;
  final String name;
  final String phoneNumber;
  final String email;
  final String address;

  Customer({
    required this.id,
    required this.vendorId,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.address,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'vendorId': vendorId,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
    };
  }

  @override
  String toString() {
    return 'Custmer{id: $id, vendorId: $vendorId, name: $name, phoneNumber: $phoneNumber, email: $email, address: $address}';
  }
}
