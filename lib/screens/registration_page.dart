import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/app_colors.dart';
import 'package:skool/constants/registration_constants.dart';
import 'package:skool/cubits/auth/auth_cubit.dart';
import 'package:skool/cubits/auth/auth_state.dart';
import 'package:skool/models/registration_data.dart';
import 'package:skool/screens/registration_success_page.dart';
import 'package:skool/widgets/registration/shared/step_progress_indicator.dart';
import 'package:skool/widgets/registration/steps/additional_data_step.dart';
import 'package:skool/widgets/registration/steps/credentials_step.dart';
import 'package:skool/widgets/registration/steps/gender_selection_step.dart';
import 'package:skool/widgets/registration/steps/name_entry_step.dart';
import 'package:skool/widgets/web_video_background.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  int _currentStep = 0;

  RegistrationData _registrationData = const RegistrationData();

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    // Validate current step before proceeding
    if (_currentStep == 0 && !_registrationData.isStep1Valid()) {
      _showErrorSnackBar(RegistrationConstants.errorGenderRequired);
      return;
    }

    if (_currentStep == 1) {
      if (_nameController.text.isEmpty) {
        _showErrorSnackBar(RegistrationConstants.errorNameRequired);
        return;
      }
      if (_ageController.text.isEmpty) {
        _showErrorSnackBar(RegistrationConstants.errorAgeRequired);
        return;
      }
    }

    if (_currentStep == 2 && !_registrationData.isStep3Valid()) {
      _showErrorSnackBar('يرجى إكمال جميع البيانات المطلوبة');
      return;
    }

    if (_currentStep < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleRegistration() {
    if (!_registrationData.isStep4Valid()) {
      _showErrorSnackBar('يرجى إدخال بريد إلكتروني، رقم هاتف، وكلمة مرور صالحة (6 أحرف على الأقل)');
      return;
    }

    final userData = _registrationData.toJson();
    // Remove sensitive/auth fields from the general user data map stored in firestore
    // The repository handles mapping them to specific User models
    // But passing them is fine as the models take what they need.
    
    context.read<AuthCubit>().register(
      email: _registrationData.email!,
      password: _registrationData.password!,
      userData: userData,
      role: _registrationData.role,
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.cairo()),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _updateRegistrationData(RegistrationData data) {
    setState(() {
      _registrationData = data;
    });
  }

  String _getVideoPath() {
    if (_registrationData.gender == RegistrationConstants.genderMale) {
      return 'assets/kid.mp4';
    } else if (_registrationData.gender == RegistrationConstants.genderFemale) {
      return 'assets/girl.mp4';
    }
    return 'assets/kid.mp4'; // default
  }

  Widget _buildVideoSection({required bool isMobile}) {
    return _registrationData.gender != null
        ? WebVideoBackground(
            key: ValueKey(_registrationData.gender),
            videoPath: _getVideoPath(),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    Colors.black.withValues(alpha: 0.5),
                  ],
                ),
              ),
            ),
          )
        : Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withValues(alpha: 0.1),
                  AppColors.primary.withValues(alpha: 0.3),
                ],
              ),
            ),
            child: Center(
              child: Icon(
                Icons.person_outline,
                size: isMobile ? 60 : 120,
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => RegistrationSuccessPage(
                gender: _registrationData.gender,
                grade: _registrationData.grade,
              ),
            ),
          );
        } else if (state is AuthError) {
          _showErrorSnackBar(state.message);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: isMobile
            ? Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: _buildVideoSection(isMobile: true),
                  ),
                  Expanded(
                    child: _buildFormSection(isMobile: true),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: _buildVideoSection(isMobile: false),
                  ),
                  Expanded(
                    flex: 1,
                    child: _buildFormSection(isMobile: false),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildFormSection({required bool isMobile}) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 60),
      child: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 500),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   // Custom Progress Indicator supporting 4 steps
                  _buildProgressIndicator(isMobile),
                  
                  SizedBox(height: isMobile ? 24 : 40),

                  SizedBox(
                    height: isMobile ? 450 : 500,
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (index) {
                        setState(() {
                          _currentStep = index;
                        });
                      },
                      children: [
                        // Step 1: Gender
                        GenderSelectionStep(
                          selectedGender: _registrationData.gender,
                          onGenderChanged: (gender) {
                            _updateRegistrationData(
                              _registrationData.copyWith(gender: gender),
                            );
                          },
                        ),

                        // Step 2: Name & Age
                        NameEntryStep(
                          nameController: _nameController,
                          ageController: _ageController,
                          selectedGender: _registrationData.gender,
                          onNameChanged: (name) {
                             _updateRegistrationData(
                              _registrationData.copyWith(name: name),
                            );
                          },
                           onAgeChanged: (age) {
                             _updateRegistrationData(
                              _registrationData.copyWith(age: age),
                            );
                          },
                        ),

                        // Step 3: Education Data
                        AdditionalDataStep(
                          formKey: GlobalKey<FormState>(), // Individual key not needed as we use parent form or manual validation
                          registrationData: _registrationData,
                          onStateChanged: (state) {
                            _updateRegistrationData(
                              _registrationData.copyWith(state: state),
                            );
                          },
                          onGradeChanged: (grade) {
                            _updateRegistrationData(
                              _registrationData.copyWith(
                                grade: grade,
                                section: null,
                                bacSection: null,
                              ),
                            );
                          },
                          onSectionChanged: (section) {
                            _updateRegistrationData(
                              _registrationData.copyWith(
                                section: section,
                              ),
                            );
                          },
                          onBacSectionChanged: (bacSection) {
                            _updateRegistrationData(
                              _registrationData.copyWith(
                                bacSection: bacSection,
                              ),
                            );
                          },
                        ),

                        // Step 4: Credentials
                        CredentialsStep(
                          registrationData: _registrationData,
                          onEmailChanged: (email) {
                            _updateRegistrationData(
                              _registrationData.copyWith(email: email),
                            );
                          },
                          onPhoneNumberChanged: (phone) {
                            _updateRegistrationData(
                              _registrationData.copyWith(phoneNumber: phone),
                            );
                          },
                          onPasswordChanged: (password) {
                            _updateRegistrationData(
                              _registrationData.copyWith(password: password),
                            );
                          },
                          onRoleChanged: (role) {
                            _updateRegistrationData(
                              _registrationData.copyWith(role: role),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: isMobile ? 20 : 30),

                  // Navigation Buttons
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;
                      
                      return Row(
                        children: [
                          if (_currentStep > 0)
                            Expanded(
                              child: OutlinedButton(
                                onPressed: isLoading ? null : _previousStep,
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  side: const BorderSide(
                                    color: AppColors.primary,
                                  ),
                                ),
                                child: Text(
                                  RegistrationConstants.buttonBack,
                                  style: GoogleFonts.cairo(
                                    fontSize: isMobile ? 16 : 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                          if (_currentStep > 0) const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : (_currentStep == 3
                                      ? _handleRegistration
                                      : _nextStep),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
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
                                      _currentStep == 3
                                          ? RegistrationConstants.buttonRegister
                                          : RegistrationConstants.buttonNext,
                                      style: GoogleFonts.cairo(
                                        fontSize: isMobile ? 16 : 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  SizedBox(height: isMobile ? 12 : 20),

                  // Back to Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'لديك حساب بالفعل؟',
                        style: GoogleFonts.cairo(
                          fontSize: isMobile ? 13 : 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'تسجيل الدخول',
                          style: GoogleFonts.cairo(
                            fontSize: isMobile ? 13 : 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
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
      ),
    );
  }
  
  // Custom simple progress indicator since standard one might rely on fixed step count
  Widget _buildProgressIndicator(bool isMobile) {
    return Row(
      children: List.generate(4, (index) {
        final isActive = index <= _currentStep;
        return Expanded(
          child: Container(
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : Colors.grey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}
