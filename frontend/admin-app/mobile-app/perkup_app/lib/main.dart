import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/network/api_service.dart';
import 'data/repository/auth_repository.dart';
import 'logic/bloc/auth_bloc.dart';
import 'presentation/screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            authRepository: AuthRepository(
              apiService: ApiService(),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        home: LoginScreen(),
      ),
    );
  }
}
