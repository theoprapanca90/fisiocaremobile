import 'package:get/get.dart';
import '../features/auth/views/login_screen.dart';
import '../features/auth/views/register_patient_screen.dart';
import '../features/auth/views/register_therapist_screen.dart';
import '../features/patient/views/patient_dashboard_screen.dart';
import '../features/patient/views/education_screen.dart';
import '../features/patient/views/exercise_screen.dart';
import '../features/patient/views/schedule_screen.dart';
import '../features/patient/views/profile_screen.dart';
import '../features/therapist/views/therapist_dashboard_screen.dart';
import '../features/therapist/views/therapist_profile_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String registerPatient = '/register-patient';
  static const String registerTherapist = '/register-therapist';
  static const String patientDashboard = '/patient-dashboard';
  static const String education = '/education';
  static const String exercise = '/exercise';
  static const String schedule = '/schedule';
  static const String patientProfile = '/patient-profile';
  static const String therapistDashboard = '/therapist-dashboard';
  static const String therapistProfile = '/therapist-profile';

  static final List<GetPage> pages = [
    GetPage(
      name: login,
      page: () => const LoginScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: registerPatient,
      page: () => const RegisterPatientScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: registerTherapist,
      page: () => const RegisterTherapistScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: patientDashboard,
      page: () => const PatientDashboardScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: education,
      page: () => const EducationScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: exercise,
      page: () => const ExerciseScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: schedule,
      page: () => const ScheduleScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: patientProfile,
      page: () => const PatientProfileScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: therapistDashboard,
      page: () => const TherapistDashboardScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: therapistProfile,
      page: () => const TherapistProfileScreen(),
      transition: Transition.rightToLeft,
    ),
  ];
}
