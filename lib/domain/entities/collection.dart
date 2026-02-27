import 'package:equatable/equatable.dart';

class Collection extends Equatable {
  final int? id;
  final String name;
  final bool isActive;
  final double customIntervalFactor;

  const Collection({
    this.id,
    required this.name,
    this.isActive = true,
    this.customIntervalFactor = 1.0,
  });

  @override
  List<Object?> get props => [id, name, isActive, customIntervalFactor];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isActive': isActive ? 1 : 0,
      'customIntervalFactor': customIntervalFactor,
    };
  }

  factory Collection.fromMap(Map<String, dynamic> map) {
    return Collection(
      id: map['id'] as int?,
      name: map['name'] as String,
      isActive: (map['isActive'] as int?) == 1,
      customIntervalFactor: (map['customIntervalFactor'] as double?) ?? 1.0,
    );
  }
}
