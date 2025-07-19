import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Consumer<AuthService>(
            builder: (context, authService, child) {
              final user = authService.currentUser;
              if (user == null) {
                return const Center(
                  child: Text('No user data available'),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Profile Header
                  Container(
                    padding: const EdgeInsets.all(AppConstants.paddingLarge),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppConstants.primaryColor, AppConstants.accentColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: Text(
                            user.displayName?.isNotEmpty == true 
                                ? user.displayName![0].toUpperCase()
                                : user.email[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppConstants.primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppConstants.paddingMedium),
                        Text(
                          user.displayName ?? 'Teacher',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          user.email,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: AppConstants.paddingMedium),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.paddingMedium,
                            vertical: AppConstants.paddingSmall,
                          ),
                          decoration: BoxDecoration(
                            color: user.hasActivePremium 
                                ? AppConstants.successColor
                                : AppConstants.warningColor,
                            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                          ),
                          child: Text(
                            user.hasActivePremium ? 'Premium Member' : 'Free Plan',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppConstants.paddingXLarge),
                  
                  // Usage Statistics
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.paddingLarge),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Usage Statistics',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppConstants.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppConstants.paddingMedium),
                          _buildStatRow(
                            'Lesson Plans Generated',
                            user.generatedPlansCount.toString(),
                            Icons.description,
                          ),
                          const Divider(),
                          _buildStatRow(
                            'Member Since',
                            _formatDate(user.registeredAt),
                            Icons.calendar_today,
                          ),
                          if (!user.hasActivePremium) ...[
                            const Divider(),
                            _buildStatRow(
                              'Free Plans Remaining',
                              '${AppConstants.freePlanLimit - user.generatedPlansCount}',
                              Icons.free_breakfast,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppConstants.paddingLarge),
                  
                  // Sign Out Button
                  CustomButton(
                    text: 'Sign Out',
                    onPressed: () => _showLogoutDialog(context, authService),
                    icon: Icons.logout,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingSmall),
      child: Row(
        children: [
          Icon(icon, color: AppConstants.primaryColor),
          const SizedBox(width: AppConstants.paddingMedium),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: AppConstants.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppConstants.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showLogoutDialog(BuildContext context, AuthService authService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Go back to home
              authService.signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.errorColor,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
