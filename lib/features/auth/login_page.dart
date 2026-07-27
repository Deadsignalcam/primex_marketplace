import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../services/primex_auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    this.role = 'member',
    this.onLoginSuccess,
  });

  final String role;
  final VoidCallback? onLoginSuccess;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;
  bool registerMode = false;
  bool obscurePassword = true;
  bool biometricAvailable = false;
  bool biometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadBiometricStatus();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadBiometricStatus() async {
    final supported = await PrimeXAuthService.deviceSupportsBiometrics();
    final enabled = await PrimeXAuthService.biometricLoginEnabled();

    if (!mounted) return;

    setState(() {
      biometricAvailable = supported;
      biometricEnabled = enabled;
    });
  }

  void _showMessage(
    String message, {
    bool error = false,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: error ? Colors.red.shade800 : Colors.green.shade700,
        ),
      );
  }

  void _finishLogin() {
    if (!mounted) return;

    widget.onLoginSuccess?.call();

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _run(
    Future<void> Function() action,
  ) async {
    if (loading) return;

    setState(() => loading = true);

    try {
      await action();
    } catch (error) {
      _showMessage(
        PrimeXAuthService.readableError(error),
        error: true,
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  Future<void> _emailAction() async {
    await _run(() async {
      UserCredential result;

      if (registerMode) {
        result = await PrimeXAuthService.registerWithEmail(
          email: emailController.text,
          password: passwordController.text,
        );

        _showMessage(
          'PrimeX account created. A verification email was sent.',
        );
      } else {
        result = await PrimeXAuthService.signInWithEmail(
          email: emailController.text,
          password: passwordController.text,
        );
      }

      if (result.user != null) {
        _finishLogin();
      }
    });
  }

  Future<void> _googleLogin() async {
    await _run(() async {
      final result = await PrimeXAuthService.signInWithGoogle();

      if (result.user != null) {
        _showMessage('Signed in securely with Google.');
        _finishLogin();
      }
    });
  }

  Future<void> _biometricLogin() async {
    await _run(() async {
      final user = PrimeXAuthService.currentUser;

      if (user == null) {
        throw FirebaseAuthException(
          code: 'no-saved-session',
          message:
              'Sign in with email or Google once before enabling biometric login.',
        );
      }

      final authenticated =
          await PrimeXAuthService.authenticateWithBiometrics();

      if (!authenticated) {
        throw FirebaseAuthException(
          code: 'biometric-failed',
          message: 'Biometric authentication was canceled or unsuccessful.',
        );
      }

      _showMessage('PrimeX unlocked securely.');
      _finishLogin();
    });
  }

  Future<void> _toggleBiometric(bool value) async {
    if (value) {
      if (PrimeXAuthService.currentUser == null) {
        _showMessage(
          'Sign in first, then turn on biometric login.',
          error: true,
        );
        return;
      }

      final enrolled = await PrimeXAuthService.hasEnrolledBiometrics();

      if (!enrolled) {
        _showMessage(
          'Set up Face ID, fingerprint, or device security in your device settings first.',
          error: true,
        );
        return;
      }

      final authenticated = await PrimeXAuthService.verifyDeviceOwner(
        reason:
            'Verify your identity to enable biometric login for PrimeX Marketplace.',
      );

      if (!authenticated) {
        _showMessage(
          'Biometric verification was not completed.',
          error: true,
        );
        return;
      }
    }

    await PrimeXAuthService.setBiometricLoginEnabled(value);

    if (!mounted) return;

    setState(() => biometricEnabled = value);

    _showMessage(
      value
          ? 'Biometric login is now enabled.'
          : 'Biometric login is now disabled.',
    );
  }

  Future<void> _resetPassword() async {
    await _run(() async {
      await PrimeXAuthService.sendPasswordReset(
        emailController.text,
      );

      _showMessage(
        'Password reset instructions were sent.',
      );
    });
  }

  InputDecoration _inputDecoration(
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.08),
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIconColor: const Color(0xFF00E5FF),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Colors.white24,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFF00E5FF),
          width: 1.5,
        ),
      ),
    );
  }

  Widget _button({
    required String text,
    required IconData icon,
    required VoidCallback? onPressed,
    bool outlined = false,
  }) {
    final child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            text,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );

    if (outlined) {
      return SizedBox(
        width: double.infinity,
        height: 52,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(
              color: Color(0xFF00E5FF),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: child,
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: const Color(0xFF00E5FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = PrimeXAuthService.currentUser;
    final size = MediaQuery.sizeOf(context);
    final mobile = size.width < 760;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/primex_neon_city_two_bg.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF063D64),
                    Color(0xFF02040A),
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),

          Container(
            color: Colors.black.withValues(alpha: mobile ? 0.34 : 0.46),
          ),

          // Large original PrimeX assistant.
          Positioned(
            right: mobile ? -118 : -35,
            top: mobile ? 18 : 28,
            child: IgnorePointer(
              child: Image.asset(
                'assets/images/primex_assistant_pro.png',
                width: mobile ? 470 : 650,
                height: mobile ? 520 : 720,
                fit: BoxFit.contain,
                alignment: Alignment.topRight,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(
                mobile ? 14 : 38,
                mobile ? 390 : 70,
                mobile ? 14 : size.width * 0.48,
                36,
              ),
              child: Align(
                alignment: mobile ? Alignment.topCenter : Alignment.centerLeft,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.78),
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(
                        color: const Color(0xFF00E5FF),
                        width: 1.4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              const Color(0xFF00E5FF).withValues(alpha: 0.28),
                          blurRadius: 32,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: AutofillGroup(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.hub_rounded,
                            size: 48,
                            color: Color(0xFF00E5FF),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'PRIME X',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 4,
                            ),
                          ),
                          const Text(
                            'MARKETPLACE',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF00E5FF),
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 3,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.role == 'affiliate'
                                ? 'Affiliate Access'
                                : widget.role == 'pro'
                                    ? 'PrimeX Pro Access'
                                    : widget.role == 'admin'
                                        ? 'Administration Access'
                                        : 'Buy • Sell • Connect',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 24),

                          TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            autofillHints: const [AutofillHints.email],
                            textInputAction: TextInputAction.next,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration(
                              'Email',
                              Icons.email_outlined,
                            ),
                          ),
                          const SizedBox(height: 14),

                          TextField(
                            controller: passwordController,
                            obscureText: obscurePassword,
                            autofillHints: registerMode
                                ? const [AutofillHints.newPassword]
                                : const [AutofillHints.password],
                            textInputAction: TextInputAction.done,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration(
                              'Password',
                              Icons.lock_outline,
                            ).copyWith(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscurePassword = !obscurePassword;
                                  });
                                },
                                icon: Icon(
                                  obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                            onSubmitted: (_) => _emailAction(),
                          ),
                          const SizedBox(height: 18),

                          _button(
                            text: registerMode
                                ? 'Create PrimeX Account'
                                : 'Sign In',
                            icon: registerMode
                                ? Icons.person_add_alt_1
                                : Icons.login,
                            onPressed: loading ? null : _emailAction,
                          ),

                          if (!registerMode) ...[
                            const SizedBox(height: 5),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: loading ? null : _resetPassword,
                                child: const Text('Forgot password?'),
                              ),
                            ),
                          ],

                          const SizedBox(height: 5),
                          const Row(
                            children: [
                              Expanded(
                                child: Divider(color: Colors.white24),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  'OR',
                                  style: TextStyle(color: Colors.white54),
                                ),
                              ),
                              Expanded(
                                child: Divider(color: Colors.white24),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),

                          _button(
                            text: 'Continue with Google',
                            icon: Icons.g_mobiledata_rounded,
                            onPressed: loading ? null : _googleLogin,
                            outlined: true,
                          ),

                          // Only one biometric login button.
                          if (biometricAvailable && !kIsWeb) ...[
                            const SizedBox(height: 12),
                            _button(
                              text: 'Unlock with Face ID / Biometrics',
                              icon: Icons.face_retouching_natural,
                              onPressed:
                                  loading || !biometricEnabled || user == null
                                      ? null
                                      : _biometricLogin,
                              outlined: true,
                            ),
                            const SizedBox(height: 5),
                            SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              value: biometricEnabled,
                              onChanged: loading ? null : _toggleBiometric,
                              activeThumbColor: const Color(0xFF00E5FF),
                              title: const Text(
                                'Enable biometric login',
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                user == null
                                    ? 'Sign in once before enabling'
                                    : 'Uses Face ID, fingerprint, PIN, or Windows Hello',
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],

                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: OutlinedButton.icon(
                              onPressed: null,
                              icon: const Icon(Icons.apple),
                              label: const Text('Apple Sign-In • Coming Soon'),
                              style: OutlinedButton.styleFrom(
                                disabledForegroundColor: Colors.white54,
                                side: const BorderSide(
                                  color: Colors.white24,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: loading
                                ? null
                                : () {
                                    setState(() {
                                      registerMode = !registerMode;
                                    });
                                  },
                            child: Text(
                              registerMode
                                  ? 'Already have an account? Sign in'
                                  : 'New to PrimeX? Create an account',
                            ),
                          ),

                          if (loading) ...[
                            const SizedBox(height: 10),
                            const CircularProgressIndicator(
                              color: Color(0xFF00E5FF),
                            ),
                          ],

                          const SizedBox(height: 8),
                          const Text(
                            'Secure authentication powered by Firebase',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
