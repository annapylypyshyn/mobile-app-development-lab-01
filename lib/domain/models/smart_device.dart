class SmartDevice {
  final String id;
  final String name;
  final String room;
  final String status;
  final String iconKey;
  final bool isActive;

  const SmartDevice({
    required this.id,
    required this.name,
    required this.room,
    required this.status,
    required this.iconKey,
    required this.isActive,
  });

  SmartDevice copyWith({
    String? name,
    String? room,
    String? status,
    String? iconKey,
    bool? isActive,
  }) {
    return SmartDevice(
      id: id,
      name: name ?? this.name,
      room: room ?? this.room,
      status: status ?? this.status,
      iconKey: iconKey ?? this.iconKey,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'room': room,
      'status': status,
      'iconKey': iconKey,
      'isActive': isActive,
    };
  }

  factory SmartDevice.fromJson(Map<String, dynamic> json) {
    return SmartDevice(
      id: json['id'] as String,
      name: json['name'] as String,
      room: json['room'] as String,
      status: json['status'] as String,
      iconKey: json['iconKey'] as String,
      isActive: json['isActive'] as bool,
    );
  }
}
