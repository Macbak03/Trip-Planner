part of 'auth_screen.dart';

/// Mobile presentation of the Auth screen: the brand, tab bar and glass card
/// stacked vertically with the original tall spacing. Pieces come from the
/// shared components in [AuthScreen].
class AuthMobileView extends StatelessWidget {
  const AuthMobileView({super.key, required this.viewModel});

  final AuthViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 48),
        const _AuthLogo(),
        const SizedBox(height: 120),
        _AuthTabBar(viewModel: viewModel),
        const SizedBox(height: 20),
        _AuthCard(viewModel: viewModel),
        const SizedBox(height: 32),
      ],
    );
  }
}
