import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../widgets/responsive_wrapper.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _recoverPassword(String name) async {
    await Future.delayed(loginTime);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Future<String?> _authUser(LoginData data) async {
      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.login(
        identifier: data.name,
        password: data.password,
      );

      if (success) {
        return null;
      }

      return authProvider.authError ?? 'Login gagal';
    }

    return ResponsiveWrapper(
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlutterLogin(
                      title: 'Al Ittifaqiah',
                      onLogin: _authUser,
                      onRecoverPassword: _recoverPassword,
                      onSubmitAnimationCompleted: () {
                        Navigator.of(context).pushReplacementNamed('/home');
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/home');
                        },
                        child: const Text('Login as Guest'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
