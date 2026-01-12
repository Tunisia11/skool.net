import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skool/cubits/auth/auth_cubit.dart';
import 'package:skool/cubits/auth/auth_state.dart';
import 'package:skool/models/user_model.dart';
import 'package:skool/models/student_model.dart';
import 'package:skool/screens/admin/admin_panel_page.dart';
import 'package:skool/screens/dashboard_page.dart';
import 'package:skool/screens/landing_page.dart';
import 'package:skool/screens/onboarding/quiz_intro_page.dart';
import 'package:skool/screens/onboarding/quiz_completion_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          if (state.user.role == UserRole.admin) {
            return const AdminPanelPage();
          }
          if (state.user.role == UserRole.student) {
            final student = state.user as StudentModel;
            if (student.learningProfile == null) {
              return const QuizIntroPage();
            } else {
              return const QuizCompletionPage();
            }
          }
          return const DashboardPage();
        } else if (state is AuthUnauthenticated) {
          return const LandingPage();
        }
        // AuthLoading or Initial
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
