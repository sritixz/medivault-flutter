import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/app_state.dart';
import '../widgets/common_widgets.dart';

class AuthFlowScreen extends StatefulWidget {
  final AppState state;
  final VoidCallback onCompleted;
  final bool isSessionExpiredPreview;

  const AuthFlowScreen({
    super.key,
    required this.state,
    required this.onCompleted,
    this.isSessionExpiredPreview = false,
  });

  @override
  State<AuthFlowScreen> createState() => _AuthFlowScreenState();
}

class _AuthFlowScreenState extends State<AuthFlowScreen> {
  late String _stage; // 'welcome', 'email', 'verify', 'profile', 'ready', 'expired'
  int _currentSlide = 0;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  String _errorMessage = '';
  DateTime? _codeDeadline;
  int _secondsRemaining = 300;
  Timer? _countdownTimer;

  final List<Map<String, dynamic>> _slides = [
    {
      'title': 'Your family’s health. All together.',
      'subtitle': 'A thoughtful home for prescriptions, reports and the people you care about.',
      'icon': Icons.family_restroom,
      'tone': 'mint',
    },
    {
      'title': 'Paper records. A clearer story.',
      'subtitle': 'Scan, organise and find important health documents whenever you need them.',
      'icon': Icons.document_scanner_outlined,
      'tone': 'blue',
    },
    {
      'title': 'Share only what you choose.',
      'subtitle': 'Select the records, choose the person and stay in control of access.',
      'icon': Icons.share_outlined,
      'tone': 'peach',
    },
  ];

  @override
  void initState() {
    super.initState();
    _stage = widget.isSessionExpiredPreview ? 'expired' : 'welcome';
    _emailController.text = widget.state.userEmail;
    _nameController.text = widget.state.userName;
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _emailController.dispose();
    _codeController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _countdownTimer?.cancel();
    _codeDeadline = DateTime.now().add(const Duration(minutes: 5));
    _secondsRemaining = 300;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        final remaining = _codeDeadline!.difference(DateTime.now()).inSeconds;
        if (remaining <= 0) {
          timer.cancel();
          setState(() {
            _secondsRemaining = 0;
            _errorMessage = 'This code has expired. Resend a code to try again.';
          });
        } else {
          setState(() {
            _secondsRemaining = remaining;
          });
        }
      }
    });
  }

  void _verifyCode() {
    final code = _codeController.text.trim();
    if (_secondsRemaining <= 0) {
      setState(() => _errorMessage = 'This code has expired. Resend a code to try again.');
      return;
    }
    if (code != '123456') {
      setState(() => _errorMessage = 'That code does not match. Try the demo code 123456.');
      return;
    }

    setState(() {
      _errorMessage = '';
      _stage = 'profile';
    });
  }

  void _completeAuth() {
    final name = _nameController.text.trim().isNotEmpty ? _nameController.text.trim() : 'Vikram Sharma';
    final email = _emailController.text.trim().isNotEmpty ? _emailController.text.trim() : 'vikram@example.com';

    widget.state.login(name: name, email: email);
    widget.onCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _stage != 'welcome'
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _errorMessage = '';
                    if (_stage == 'verify') {
                      _stage = 'email';
                    } else if (_stage == 'profile') {
                      _stage = 'verify';
                    } else {
                      _stage = 'welcome';
                    }
                  });
                },
              )
            : null,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
            const Text(
              'MediVault',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
          ],
        ),
        actions: [
          if (_stage != 'welcome')
            TextButton(
              onPressed: () {
                // Skip to workspace
                widget.onCompleted();
              },
              child: const Text('Skip'),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: _buildCurrentStage(),
        ),
      ),
    );
  }

  Widget _buildCurrentStage() {
    switch (_stage) {
      case 'welcome':
        return _buildWelcomeStage();
      case 'email':
        return _buildEmailStage();
      case 'verify':
        return _buildVerifyStage();
      case 'profile':
        return _buildProfileStage();
      case 'ready':
        return _buildReadyStage();
      case 'expired':
        return _buildExpiredStage();
      default:
        return _buildWelcomeStage();
    }
  }

  Widget _buildWelcomeStage() {
    final slide = _slides[_currentSlide];
    final toneStyle = ToneStyle.getTone(slide['tone']);

    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            color: toneStyle.background,
            shape: BoxShape.circle,
            border: Border.all(color: toneStyle.borderColor, width: 2),
          ),
          child: Icon(slide['icon'] as IconData, size: 68, color: toneStyle.textColor),
        ),
        const SizedBox(height: 32),
        // Dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_slides.length, (index) {
            final isCurrent = _currentSlide == index;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isCurrent ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: isCurrent ? AppColors.primary : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
        const SizedBox(height: 24),
        Text(
          slide['title'] as String,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, height: 1.25),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          slide['subtitle'] as String,
          style: const TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant, height: 1.4),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 48),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () {
              if (_currentSlide < _slides.length - 1) {
                setState(() => _currentSlide++);
              } else {
                setState(() => _stage = 'email');
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _currentSlide < _slides.length - 1 ? 'Next' : 'Get started',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, size: 18),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => setState(() => _stage = 'email'),
          child: const Text(
            'I already have an account',
            style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary),
          ),
        ),
        TextButton(
          onPressed: widget.onCompleted,
          child: const Text(
            'Explore sample workspace',
            style: TextStyle(color: AppColors.onSurfaceVariant),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailStage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const StatusBadge(text: 'WELCOME BACK', tone: 'mint'),
        const SizedBox(height: 12),
        const Text(
          'Your health space awaits.',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        const Text(
          'Enter your email address to continue.',
          style: TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant),
        ),
        const SizedBox(height: 28),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email address',
            hintText: 'you@example.com',
            prefixIcon: Icon(Icons.email_outlined),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.toneCreamBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.toneCreamBorder),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline, size: 20, color: AppColors.toneCreamText),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Design preview: no real email will be sent. Use demo code 123456 on the next screen.',
                  style: TextStyle(fontSize: 12, color: AppColors.toneCreamText, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () {
              if (_emailController.text.trim().isNotEmpty) {
                _codeController.clear();
                _errorMessage = '';
                _startTimer();
                setState(() => _stage = 'verify');
              }
            },
            child: const Text(
              'Continue with email',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerifyStage() {
    final minutes = (_secondsRemaining / 60).floor();
    final seconds = _secondsRemaining % 60;
    final timeStr = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.toneBlueBg,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.toneBlueBorder),
          ),
          child: const Icon(Icons.mark_email_read_outlined, color: AppColors.primary, size: 32),
        ),
        const SizedBox(height: 16),
        const Text(
          'Check your email',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(
          'Enter the 6-digit code for ${_emailController.text.trim()}',
          style: const TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant),
        ),
        TextButton(
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          onPressed: () => setState(() => _stage = 'email'),
          child: const Text('Change email address', style: TextStyle(fontSize: 13)),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _codeController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: 8),
          decoration: const InputDecoration(
            hintText: '123456',
            counterText: '',
          ),
        ),
        if (_errorMessage.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            _errorMessage,
            style: const TextStyle(color: AppColors.error, fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Expires in $timeStr',
              style: TextStyle(
                fontSize: 12,
                color: _secondsRemaining < 60 ? AppColors.error : AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {
                _codeController.clear();
                _errorMessage = '';
                _startTimer();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Demo code reset! Use 123456 to continue.')),
                );
              },
              child: const Text('Resend code'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: _verifyCode,
            child: const Text(
              'Verify & continue',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileStage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.toneMintBg,
          child: const Text(
            'VS',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.toneMintText),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Make it your health space.',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        const Text(
          'Start with a few personal details.',
          style: TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant),
        ),
        const SizedBox(height: 28),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Your full name',
            prefixIcon: Icon(Icons.person_outline),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email address',
            prefixIcon: Icon(Icons.email_outlined),
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () {
              setState(() => _stage = 'ready');
            },
            child: const Text(
              'Create preview profile',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReadyStage() {
    final firstName = _nameController.text.trim().split(' ').first;

    return Center(
      child: Column(
        children: [
          const SizedBox(height: 32),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.toneMintBg,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.toneMintBorder, width: 2),
            ),
            child: const Icon(Icons.check, size: 48, color: AppColors.toneMintText),
          ),
          const SizedBox(height: 24),
          Text(
            'You’re ready, $firstName.',
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start with your first health record or add a family member.',
            style: TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              icon: const Icon(Icons.folder_open),
              label: const Text('Go to Health Locker', style: TextStyle(fontWeight: FontWeight.w700)),
              onPressed: _completeAuth,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: _completeAuth,
              child: const Text('Go to Home Dashboard', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpiredStage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const StatusBadge(text: 'SESSION RECOVERY PREVIEW', tone: 'cream'),
        const SizedBox(height: 12),
        const Text(
          'Let’s get you signed in again.',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        const Text(
          'Verify your email to continue. Your current workspace remains available while you complete these preview steps.',
          style: TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant, height: 1.4),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () {
              setState(() => _stage = 'email');
            },
            child: const Text('Verify my email', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: widget.onCompleted,
            child: const Text('Return to workspace', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ),
      ],
    );
  }
}
