part of 'settings_screen.dart';

/// Mobile presentation of the Settings screen: a full-width column with a back
/// button, title and the account/actions cards. All data and actions are passed
/// in by [SettingsScreen].
class SettingsMobileView extends StatelessWidget {
  const SettingsMobileView({
    super.key,
    required this.email,
    required this.busy,
    required this.loggingOut,
    required this.deleting,
    required this.onBack,
    required this.onLogout,
    required this.onDeleteAccount,
  });

  final String? email;
  final bool busy;
  final bool loggingOut;
  final bool deleting;
  final VoidCallback onBack;
  final VoidCallback onLogout;
  final VoidCallback onDeleteAccount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FrostedCircleButton(
                icon: Icons.arrow_back,
                tooltip: 'Back',
                onTap: onBack,
              ),
              const SizedBox(width: 14),
              const Text(
                'Settings',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _AccountCard(email: email),
          const SizedBox(height: 16),
          _ActionsCard(
            busy: busy,
            loggingOut: loggingOut,
            deleting: deleting,
            onLogout: onLogout,
            onDeleteAccount: onDeleteAccount,
          ),
        ],
      ),
    );
  }
}
