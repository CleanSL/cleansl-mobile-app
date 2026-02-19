import 'package:flutter/material.dart';
import 'theme/app-theme.dart'; // Importing our custom design system

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CleanSL',
      
      // THIS is the line that applies our brand guidelines globally
      theme: AppTheme.lightTheme, 
      
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.space24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: AppTheme.space24),
                  
                  Text(
                    'Design System Active',
                    style: Theme.of(context).textTheme.displaySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.space16),
                  
                  Text(
                    'If this heading is Roboto Slab, this text is Inter, and the background is Cream (#FFF5DB), your theme is ready to commit.',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.space32),
                  
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Figma Styled Button'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}