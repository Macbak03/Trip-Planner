part of 'auth_screen.dart';

/// Web presentation of the Auth screen: a full-screen brand image with the
/// sign-in form floating centered on top (no split layout). Pieces come from
/// the shared components in [AuthScreen].
class AuthWebView extends StatelessWidget {
  const AuthWebView({super.key, required this.viewModel});

  final AuthViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/background_web.png', fit: BoxFit.cover),
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _AuthLogo(),
                  const SizedBox(height: 40),
                  _AuthTabBar(viewModel: viewModel),
                  const SizedBox(height: 20),
                  _AuthCard(viewModel: viewModel),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
