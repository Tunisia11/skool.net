import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/cubits/auth/auth_cubit.dart';
import 'package:skool/cubits/auth/auth_state.dart';
import 'package:skool/screens/dashboard_page.dart';
import 'package:skool/screens/registration_page.dart';
import 'package:skool/screens/registration_page.dart';
import 'package:skool/widgets/web_video_background.dart';
import 'package:skool/widgets/auth_wrapper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'يرجى إدخال البريد الإلكتروني وكلمة المرور',
            style: GoogleFonts.cairo(),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<AuthCubit>().login(email: email, password: password);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const AuthWrapper()),
            (route) => false,
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message, style: GoogleFonts.cairo()),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: isMobile
            ? Column(
                children: [
                  // Video Section - Compact on mobile
                  SizedBox(
                    height: 200,
                    child: _buildVideoSection(),
                  ),
                  // Login Form Section
                  Expanded(
                    child: _buildFormSection(context, isMobile: true),
                  ),
                ],
              )
            : Row(
                children: [
                  // Left side - Login Form (50%)
                  Expanded(
                    flex: 1,
                    child: _buildFormSection(context, isMobile: false),
                  ),
                  // Right side - Video Display (50%)
                  Expanded(
                    flex: 1,
                    child: _buildVideoSection(),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildVideoSection() {
    return kIsWeb
        ? WebVideoBackground(
            videoPath: 'assets/bgvedio.mp4',
            child: Stack(
              children: [
                // Dark overlay for better logo visibility
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.3),
                  ),
                ),
                // Logo on top
                Center(
                  child: Image.asset(
                    'assets/logo.png',
                    width: 700,
                    height: 700,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          )
        : Container(
            color: const Color(0xFF1A237E),
            child: Center(
              child: Image.asset(
                'assets/logo.png',
                width: 500,
                height: 500,
                fit: BoxFit.contain,
              ),
            ),
          );
  }

  Widget _buildFormSection(BuildContext context, {required bool isMobile}) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 60),
      child: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 350),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'تسجيل الدخول',
                  style: GoogleFonts.cairo(
                    fontSize: isMobile ? 24 : 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: isMobile ? 8 : 10),
                Text(
                  'مرحبًا بك مجددًا! الرجاء إدخال بياناتك',
                  style: GoogleFonts.cairo(
                    fontSize: isMobile ? 14 : 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: isMobile ? 30 : 40),

                // Social Login
                _socialButton(
                  context,
                  icon: FontAwesomeIcons.google,
                  text: 'المتابعة باستخدام Google',
                  color: Colors.red,
                  isMobile: isMobile,
                ),

                SizedBox(height: isMobile ? 20 : 30),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Text(
                        'أو',
                        style: GoogleFonts.cairo(
                          fontSize: isMobile ? 13 : 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                SizedBox(height: isMobile ? 20 : 30),

                // Email Field
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'البريد الإلكتروني',
                    labelStyle: GoogleFonts.cairo(fontSize: isMobile ? 14 : 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                ),
                SizedBox(height: isMobile ? 16 : 20),

                // Password Field
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'كلمة السر',
                    labelStyle: GoogleFonts.cairo(fontSize: isMobile ? 14 : 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),

                SizedBox(height: isMobile ? 5 : 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'نسيت كلمة السر؟',
                      style: GoogleFonts.cairo(
                        fontSize: isMobile ? 13 : 14,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: isMobile ? 20 : 30),

                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'دخول',
                                style: GoogleFonts.cairo(
                                  fontSize: isMobile ? 16 : 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    );
                  },
                ),

                SizedBox(height: isMobile ? 16 : 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ليس لديك حساب؟',
                      style: GoogleFonts.cairo(
                        fontSize: isMobile ? 13 : 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegistrationPage(),
                          ),
                        );
                      },
                      child: Text(
                        'سجل الآن',
                        style: GoogleFonts.cairo(
                          fontSize: isMobile ? 13 : 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialButton(
    BuildContext context, {
    required IconData icon,
    required String text,
    required Color color,
    required bool isMobile,
  }) {
    return InkWell(
      onTap: () {
        // Mock social login or implement later
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                text,
                style: GoogleFonts.cairo(
                  fontSize: isMobile ? 14 : 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
