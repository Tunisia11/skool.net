import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skool/cubits/auth/auth_state.dart';
import 'package:skool/models/user_model.dart';
import 'package:skool/repositories/auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<dynamic>? _authStateSubscription;

  AuthCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    // Determine initial state based on current user
    _init();
  }

  void _init() {
    _authStateSubscription = _authRepository.authStateChanges.listen((user) async {
      if (user == null) {
         emit(AuthUnauthenticated());
      } else {
        // User is logged in to Firebase, but we need to fetch their profile data
        // We emit loading only if we are not already authenticated to avoid flickering
        if (state is! AuthAuthenticated) {
            emit(AuthLoading());
        }
        try {
          final userModel = await _authRepository.getCurrentUser();
          if (userModel != null) {
            emit(AuthAuthenticated(userModel));
          } else {
             // Auth exist but no firestore data? Edge case.
             // Maybe they are still registering or data is missing.
             // For now, treat as unauthenticated or handle appropriately.
             emit(AuthUnauthenticated());
          }
        } catch (e) {
          emit(AuthError(e.toString()));
        }
      }
    });
  }

  // Register
  Future<void> register({
    required String email,
    required String password,
    required Map<String, dynamic> userData,
    required UserRole role,
  }) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.register(
        email: email,
        password: password,
        userData: userData,
        role: role,
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // Update User Profile
  Future<void> updateUserProfile(UserModel user) async {
    // Optimistic update or wait for server? Waiting is safer for now.
    // Using AuthLoading might flicker, let's just do it silently or show loading if needed.
    // But since this is critical onboarding data, we should probably emit loading state.
    emit(AuthLoading());
    try {
      await _authRepository.updateUser(user);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
      // If error, revert to old state? Since we don't store it, we might be in trouble.
      // Ideally we should know the previous state.
      // But for simple flow, Error state is fine to show snackbar.
    }
  }

  // Login
  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.login(
        email: email,
        password: password,
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // Logout
  Future<void> logout() async {
    await _authRepository.logout();
    emit(AuthUnauthenticated());
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
