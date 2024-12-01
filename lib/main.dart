import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'presentation/sign_in/sign_in_view_model.dart';
import 'presentation/sign_in/sign_in_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignInViewModel()),
      ],
      child: const AutoMakerApp(),
    ),
  );
}
