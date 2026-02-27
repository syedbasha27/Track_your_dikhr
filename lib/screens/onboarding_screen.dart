import 'package:flutter/material.dart';
import '../config/routes.dart';
import '../config/theme.dart';
import '../constants/app_strings.dart';

/// Onboarding screen shown to new users before sign-up / login
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBeige,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Crescent moon icon
              const Text(
                '☽',
                style: TextStyle(fontSize: 64),
              ),
              const SizedBox(height: 16),
              const Text(
                AppStrings.appName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryDarkGreen,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                AppStrings.appSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: AppTheme.textMuted,
                ),
              ),
              const SizedBox(height: 32),
              // Feature cards
              _FeatureCard(
                icon: '🕌',
                title: AppStrings.featureSalahTitle,
                description: AppStrings.featureSalahDesc,
              ),
              const SizedBox(height: 10),
              _FeatureCard(
                icon: '📿',
                title: AppStrings.featureDhikrTitle,
                description: AppStrings.featureDhikrDesc,
              ),
              const SizedBox(height: 10),
              _FeatureCard(
                icon: '🪞',
                title: AppStrings.featureMuhasabahTitle,
                description: AppStrings.featureMuhasabahDesc,
              ),
              const SizedBox(height: 10),
              _FeatureCard(
                icon: '✨',
                title: AppStrings.featureNoorTitle,
                description: AppStrings.featureNoorDesc,
              ),
              const Spacer(flex: 3),
              // CTA button
              ElevatedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.signup),
                child: const Text(AppStrings.beginJourney),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.login),
                child: const Text(
                  'Already have an account? Login',
                  style: TextStyle(color: AppTheme.textMuted),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                AppStrings.privacyFooter,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textMuted,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
