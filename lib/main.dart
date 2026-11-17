import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'providers/app_state.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/auth/auth_flow_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MediVaultApp());
}

class MediVaultApp extends StatefulWidget {
  const MediVaultApp({super.key});

  @override
  State<MediVaultApp> createState() => _MediVaultAppState();
}

class _MediVaultAppState extends State<MediVaultApp> {
  final AppState _appState = AppState();

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appState,
      builder: (context, _) {
        return MaterialApp(
          title: 'MediVault',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: _appState.isLoggedIn
              ? MainNavigationScreen(state: _appState)
              : AuthFlowScreen(
                  state: _appState,
                  onCompleted: () => _appState.login(
                    name: _appState.userName,
                    email: _appState.userEmail,
                  ),
                ),
        );
      },
    );
  }
}
