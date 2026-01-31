import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/models/user_model.dart';
import 'package:skool/models/registration_data.dart';

class CredentialsStep extends StatefulWidget {
  final RegistrationData registrationData;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPhoneNumberChanged;
  final ValueChanged<String> onPasswordChanged;
  final ValueChanged<UserRole> onRoleChanged;

  const CredentialsStep({
    super.key,
    required this.registrationData,
    required this.onEmailChanged,
    required this.onPhoneNumberChanged,
    required this.onPasswordChanged,
    required this.onRoleChanged,
  });

  @override
  State<CredentialsStep> createState() => _CredentialsStepState();
}

class _CredentialsStepState extends State<CredentialsStep> {
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  bool _obscurePassword = true;
  String? _phoneError;
  String? _emailError;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.registrationData.email ?? '');
    _phoneController = TextEditingController(text: widget.registrationData.phoneNumber ?? '');
    _passwordController = TextEditingController(text: widget.registrationData.password ?? '');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Validates email format
  String? _validateEmail(String value) {
    if (value.isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'البريد الإلكتروني غير صالح';
    }
    return null;
  }

  void _onEmailChanged(String value) {
    setState(() {
      _emailError = _validateEmail(value);
    });
    widget.onEmailChanged(value);
  }

  /// Validates Tunisian phone number format
  /// Valid formats: 8 digits starting with 2, 3, 4, 5, 7, or 9
  String? _validateTunisianPhone(String value) {
    if (value.isEmpty) {
      return 'رقم الهاتف مطلوب';
    }
    
    // Remove spaces and dashes
    final cleanNumber = value.replaceAll(RegExp(r'[\s\-]'), '');
    
    // Check if it's 8 digits
    if (cleanNumber.length != 8) {
      return 'رقم الهاتف يجب أن يكون 8 أرقام';
    }
    
    // Check if it starts with valid Tunisian prefixes
    // 2x - Tunisie Telecom fixed
    // 3x - Ooredoo mobile
    // 4x - Ooredoo mobile  
    // 5x - Ooredoo mobile
    // 7x - Tunisie Telecom mobile
    // 9x - Orange mobile
    final validPrefixes = ['2', '3', '4', '5', '7', '9'];
    if (!validPrefixes.contains(cleanNumber[0])) {
      return 'رقم هاتف تونسي غير صالح';
    }
    
    // Check if all characters are digits
    if (!RegExp(r'^\d+$').hasMatch(cleanNumber)) {
      return 'الرقم يجب أن يحتوي على أرقام فقط';
    }
    
    return null;
  }

  void _onPhoneChanged(String value) {
    setState(() {
      _phoneError = _validateTunisianPhone(value);
    });
    
    // Clean the number before saving (remove spaces/dashes)
    final cleanNumber = value.replaceAll(RegExp(r'[\s\-]'), '');
    widget.onPhoneNumberChanged(cleanNumber);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'معلومات الدخول',
            style: GoogleFonts.cairo(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'قم بإنشاء حسابك الجديد للدخول إلى المنصة',
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),

          // Email Field
          Text(
            'البريد الإلكتروني',
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _emailController,
            onChanged: _onEmailChanged,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'example@email.com',
              prefixIcon: const Icon(Icons.email_outlined),
              errorText: _emailError,
              errorStyle: GoogleFonts.cairo(fontSize: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: _emailError != null ? Colors.red : Colors.grey.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: _emailError != null ? Colors.red : AppColors.primary,
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Phone Number Field with Tunisian validation
          Text(
            'رقم الهاتف',
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _phoneController,
            onChanged: _onPhoneChanged,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d\s\-]')),
              LengthLimitingTextInputFormatter(11), // 8 digits + 3 spaces/dashes max
            ],
            decoration: InputDecoration(
              hintText: '55 123 456',
              hintStyle: GoogleFonts.cairo(color: Colors.grey),
              prefixIcon: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.phone_outlined),
                    const SizedBox(width: 8),
                    Text(
                      '+216',
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Container(
                      height: 24,
                      width: 1,
                      margin: const EdgeInsets.only(left: 12),
                      color: Colors.grey.withValues(alpha: 0.3),
                    ),
                  ],
                ),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 0),
              errorText: _phoneError,
              errorStyle: GoogleFonts.cairo(fontSize: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: _phoneError != null ? Colors.red : Colors.grey.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: _phoneError != null ? Colors.red : AppColors.primary,
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Password Field
          Text(
            'كلمة المرور',
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _passwordController,
            onChanged: widget.onPasswordChanged,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              hintText: 'كلمة المرور (6 أحرف على الأقل)',
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
