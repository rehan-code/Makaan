import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../models/invite.dart';

class InviteService {
  static final _supabase = Supabase.instance.client;

  // Generate a unique invite code
  static String _generateInviteCode(String userId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final data = userId + timestamp;
    final bytes = utf8.encode(data);
    final hash = sha256.convert(bytes);
    return hash.toString().substring(0, 8).toUpperCase();
  }

  // Get the number of invites sent this month
  static Future<int> getMonthlyInviteCount(String userId) async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    final response = await _supabase
        .from('invites')
        .select('id')
        .eq('inviter_id', userId)
        .gte('created_at', startOfMonth.toIso8601String())
        .lte('created_at', endOfMonth.toIso8601String());

    return (response as List).length;
  }

  // Create a new invite
  static Future<Invite?> createInvite(String userId) async {
    final inviteCount = await getMonthlyInviteCount(userId);
    if (inviteCount >= 5) {
      throw Exception('You have reached your limit of 5 invites for this month. The limit will reset at the start of next month.');
    }

    final code = _generateInviteCode(userId);
    final now = DateTime.now().toIso8601String();
    
    final response = await _supabase.from('invites').insert({
      'inviter_id': userId,
      'code': code,
      'is_used': false,
      'created_at': now,
    }).select();

    if (response != null && (response as List).isNotEmpty) {
      return Invite.fromJson(response.first);
    }
    return null;
  }

  // Get all invites for a user
  static Future<List<Invite>> getInvites(String userId) async {
    final response = await _supabase
        .from('invites')
        .select()
        .eq('inviter_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((data) => Invite.fromJson(data)).toList();
  }

  // Validate and use an invite code
  static Future<bool> useInviteCode(String code) async {
    final response = await _supabase
        .from('invites')
        .select()
        .eq('code', code)
        .eq('is_used', false)
        .single();

    if (response != null) {
      await _supabase
          .from('invites')
          .update({
            'is_used': true,
            'used_at': DateTime.now().toIso8601String(),
          })
          .eq('id', response['id']);
      return true;
    }
    return false;
  }
}
