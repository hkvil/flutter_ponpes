import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import '../repository/auth_repository.dart';
import '../widgets/responsive_wrapper.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) async {
    final repo = AuthRepository();
    return await repo.login(identifier: data.name, password: data.password);
  }

  Future<String?> _recoverPassword(String name) async {
    await Future.delayed(loginTime);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FlutterLogin(
                title: 'Al Ittifaqiah',
                onLogin: _authUser,
                onRecoverPassword: _recoverPassword,
                onSubmitAnimationCompleted: () {
                  Navigator.of(context).pushReplacementNamed('/home');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/home');
                },
                child: Text('Login as Guest'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
