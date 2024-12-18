import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_progress_trackers/core/services/injection_container.dart';
import 'package:fitness_progress_trackers/features/user_profile_management/presentation/cubit/user_profile_management_cubit.dart';
import 'package:fitness_progress_trackers/features/user_profile_management/presentation/auth_page.dart';
import 'package:fitness_progress_trackers/features/workout_logging/presentation/cubit/workout_logging_cubit.dart';
import 'package:fitness_progress_trackers/features/workout_logging/presentation/workout_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize dependency injection
  await init();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => serviceLocator<UserCubit>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<WorkoutCubit>(),
        ),
      ],
      child: MaterialApp(
        title: 'FITNESS TRACKER',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 77, 10, 45),
          ),
          useMaterial3: true,
        ),
        home: const AuthOrHome(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthOrHome extends StatefulWidget {
  const AuthOrHome({super.key});

  @override
  State<AuthOrHome> createState() => _AuthOrHomeState();
}

class _AuthOrHomeState extends State<AuthOrHome> {
  bool isLoggedIn = false;
  String? userId;

  void handleAuth(String userId) {
    setState(() {
      isLoggedIn = true;
      this.userId = userId;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoggedIn) {
      // Passing a static userId here to avoid parameter issues:
      return AuthPage(onLoginSuccess: () => handleAuth('exampleUserId'));
    }
    return HomePage(userId: userId!);
  }
}

class HomePage extends StatefulWidget {
  final String userId;
  const HomePage({super.key, required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      WorkoutPage(
        userId: widget.userId,
        username: '',
      ), // Pass userId here
      const Center(
        child: Text('Insert Progress Page here'),
      ),
      const Center(
        child: Text('Insert Profile Page here'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: "Workouts",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes_outlined),
            label: "Meals",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
