import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.space24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Who are you?",
                style: Theme.of(context).textTheme.displayMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.space8),
              Text(
                "Select your role to continue",
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.space48),
              
              // Resident Role Card
              _buildRoleOption(
                context, 
                title: "I am a Resident", 
                subtitle: "Access home features",
                icon: Icons.home_work_outlined,
                route: '/resident-auth'
              ),
              
              const SizedBox(height: AppTheme.space24),
              
              // Driver Role Card
              _buildRoleOption(
                context, 
                title: "I am a Driver", 
                subtitle: "Deliveries and pickups",
                icon: Icons.moped_outlined,
                route: '/driver-login'
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleOption(BuildContext context, {
    required String title, 
    required String subtitle, 
    required IconData icon, 
    required String route
  }) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.space24),
          child: Row(
            children: [
              Icon(icon, size: 40, color: AppTheme.secondaryColor1),
              const SizedBox(width: AppTheme.space16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
                    Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}