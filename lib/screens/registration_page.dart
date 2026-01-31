import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skool/constants/registration_constants.dart';
import 'package:skool/constants/registration_constants.dart';
import 'package:skool/cubits/auth/auth_cubit.dart';
import 'package:skool/cubits/auth/auth_state.dart';
import 'package:skool/models/registration_data.dart';
import 'package:skool/screens/registration_success_page.dart';
import 'package:skool/widgets/registration/sections/registration_footer.dart';
import 'package:skool/widgets/registration/sections/registration_nav_bar.dart';
import 'package:skool/widgets/registration/sections/registration_progress_indicator.dart';
import 'package:skool/widgets/registration/sections/registration_video_section.dart';
import 'package:skool/widgets/registration/steps/additional_data_step.dart';
import 'package:skool/widgets/registration/steps/credentials_step.dart';
import 'package:skool/widgets/registration/steps/gender_selection_step.dart';
import 'package:skool/widgets/registration/steps/name_entry_step.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
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
    // Step 0: Name & Age validation
    if (_currentStep == 0) {
      final name = _nameController.text.trim();
      final age = _ageController.text.trim();
      if (name.isEmpty) {
        _showError(RegistrationConstants.errorNameRequired);
        return;
      }
      if (name.length < 3) {
        _showError('الاسم يجب أن يكون 3 أحرف على الأقل');
        return;
      }
      if (age.isEmpty) {
        _showError(RegistrationConstants.errorAgeRequired);
        return;
      }
      final ageNum = int.tryParse(age);
      if (ageNum == null || ageNum < 5 || ageNum > 100) {
        _showError('العمر يجب أن يكون بين 5 و 100');
        return;
      }
    }

    // Step 1: Gender validation
    if (_currentStep == 1 && !_registrationData.isStep1Valid()) {
      _showError(RegistrationConstants.errorGenderRequired);
      return;
    }

    // Step 2: Education data validation
    if (_currentStep == 2 && !_registrationData.isStep3Valid()) {
      _showError('يرجى إكمال جميع البيانات المطلوبة');
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
      _showError('يرجى إدخال بريد إلكتروني، رقم هاتف، وكلمة مرور صالحة (6 أحرف على الأقل)');
      return;
    }

    context.read<AuthCubit>().register(
      email: _registrationData.email!,
      password: _registrationData.password!,
      userData: _registrationData.toJson(),
      role: _registrationData.role,
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.cairo()),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _updateData(RegistrationData data) {
    setState(() => _registrationData = data);
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
          _showError(state.message);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: isMobile
            ? Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: RegistrationVideoSection(
                      selectedGender: _registrationData.gender,
                      age: int.tryParse(_ageController.text),
                      isMobile: true,
                    ),
                  ),
                  Expanded(child: _buildForm(isMobile: true)),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: RegistrationVideoSection(
                      selectedGender: _registrationData.gender,
                      age: int.tryParse(_ageController.text),
                      isMobile: false,
                    ),
                  ),
                  Expanded(child: _buildForm(isMobile: false)),
                ],
              ),
      ),
    );
  }

  Widget _buildForm({required bool isMobile}) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 60),
      child: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RegistrationProgressIndicator(currentStep: _currentStep),
                SizedBox(height: isMobile ? 24 : 40),
                SizedBox(
                  height: isMobile ? 450 : 500,
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (i) => setState(() => _currentStep = i),
                    children: [
                      NameEntryStep(
                        nameController: _nameController,
                        ageController: _ageController,
                        selectedGender: _registrationData.gender,
                        onNameChanged: (n) => _updateData(_registrationData.copyWith(name: n)),
                        onAgeChanged: (a) => _updateData(_registrationData.copyWith(age: a)),
                      ),
                      GenderSelectionStep(
                        selectedGender: _registrationData.gender,
                        age: int.tryParse(_ageController.text),
                        onGenderChanged: (g) => _updateData(_registrationData.copyWith(gender: g)),
                      ),
                      AdditionalDataStep(
                        formKey: GlobalKey<FormState>(),
                        registrationData: _registrationData,
                        onStateChanged: (s) => _updateData(_registrationData.copyWith(state: s)),
                        onGradeChanged: (g) => _updateData(_registrationData.copyWith(grade: g, section: null, bacSection: null)),
                        onSectionChanged: (s) => _updateData(_registrationData.copyWith(section: s)),
                        onBacSectionChanged: (b) => _updateData(_registrationData.copyWith(bacSection: b)),
                      ),
                      CredentialsStep(
                        registrationData: _registrationData,
                        onEmailChanged: (e) => _updateData(_registrationData.copyWith(email: e)),
                        onPhoneNumberChanged: (p) => _updateData(_registrationData.copyWith(phoneNumber: p)),
                        onPasswordChanged: (p) => _updateData(_registrationData.copyWith(password: p)),
                        onRoleChanged: (r) => _updateData(_registrationData.copyWith(role: r)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isMobile ? 20 : 30),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return RegistrationNavBar(
                      currentStep: _currentStep,
                      isLoading: state is AuthLoading,
                      onPrevious: _previousStep,
                      onNext: _currentStep == 3 ? _handleRegistration : _nextStep,
                      isMobile: isMobile,
                    );
                  },
                ),
                SizedBox(height: isMobile ? 12 : 20),
                RegistrationFooter(isMobile: isMobile),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
