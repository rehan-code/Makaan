import 'package:supabase_flutter/supabase_flutter.dart';

class Invite {
  final String id;
  final String inviterId;
  final String code;
  final bool isUsed;
  final DateTime createdAt;
  final DateTime? usedAt;

  Invite({
    required this.id,
    required this.inviterId,
    required this.code,
    required this.isUsed,
    required this.createdAt,
    this.usedAt,
  });

  factory Invite.fromJson(Map<String, dynamic> json) {
    return Invite(
      id: json['id'] as String,
      inviterId: json['inviter_id'] as String,
      code: json['code'] as String,
      isUsed: json['is_used'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      usedAt: json['used_at'] != null ? DateTime.parse(json['used_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'inviter_id': inviterId,
      'code': code,
      'is_used': isUsed,
      'created_at': createdAt.toIso8601String(),
      'used_at': usedAt?.toIso8601String(),
    };
  }
}
