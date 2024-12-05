import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/invite.dart';
import '../../services/invite_service.dart';

class InvitePage extends StatefulWidget {
  const InvitePage({super.key});

  @override
  State<InvitePage> createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  List<Invite> _invites = [];
  bool _isLoading = false;
  int _monthlyInviteCount = 0;

  @override
  void initState() {
    super.initState();
    _loadInvites();
  }

  Future<void> _loadInvites() async {
    setState(() => _isLoading = true);
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return;

      final invites = await InviteService.getInvites(userId);
      final monthlyCount = await InviteService.getMonthlyInviteCount(userId);

      if (mounted) {
        setState(() {
          _invites = invites;
          _monthlyInviteCount = monthlyCount;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading invites: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _createInvite() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return;

      final invite = await InviteService.createInvite(userId);
      if (invite != null) {
        await _loadInvites();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _copyInviteCode(String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invite code copied to clipboard'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadInvites,
              child: SafeArea(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Share Makaan with your friends!',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'New users need an invite code to join. You can invite up to 5 friends per month. You have ${5 - _monthlyInviteCount} invites remaining this month.',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (_monthlyInviteCount < 5)
                              ElevatedButton.icon(
                                onPressed: _createInvite,
                                icon: const Icon(Icons.add),
                                label: const Text('Generate New Invite Code'),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 48),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (_invites.isEmpty)
                      const SliverFillRemaining(
                        child: Center(
                          child: Text('No invites yet'),
                        ),
                      )
                    else
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final invite = _invites[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: ListTile(
                                title: Text(
                                  invite.code,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                subtitle: Text(
                                  invite.isUsed
                                      ? 'Used on ${invite.usedAt?.toString().split(' ')[0]}'
                                      : 'Created on ${invite.createdAt.toString().split(' ')[0]}',
                                ),
                                trailing: invite.isUsed
                                    ? const Icon(Icons.check_circle, color: Colors.green)
                                    : IconButton(
                                        icon: const Icon(Icons.copy),
                                        onPressed: () => _copyInviteCode(invite.code),
                                      ),
                              ),
                            );
                          },
                          childCount: _invites.length,
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
