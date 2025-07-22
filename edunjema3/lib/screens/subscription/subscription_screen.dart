import 'package:flutter/material.dart';
import 'package:edunjema3/utils/constants.dart';
import 'package:edunjema3/widgets/custom_button.dart';
import 'package:http/http.dart' as http; // Import http package
import 'dart:convert'; // Import for jsonEncode

/// A screen for users to view and manage their subscription plans.
class SubscriptionScreen extends StatelessWidget {
  /// Creates a [SubscriptionScreen] instance.
  const SubscriptionScreen({super.key});

  // Function to initiate M-Pesa STK Push
  Future<void> _initiateMpesaPayment(BuildContext context, double amount, String phoneNumber) async {
    // In a real app, you'd get the phone number from the user's profile or input
    // For demonstration, let's use a placeholder.
    // Ensure the phone number is in the format 2547XXXXXXXX
    if (!phoneNumber.startsWith('254') || phoneNumber.length != 12) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid Kenyan phone number (e.g., 2547XXXXXXXX).')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Initiating M-Pesa STK Push...')),
    );

    try {
      // Replace with your actual backend endpoint for M-Pesa
      final response = await http.post(
        Uri.parse('https://your-backend-ai-api.com/api/mpesa-stk-push'), // Your Vercel Edge Function URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'amount': amount,
          'phoneNumber': phoneNumber,
          'transactionDesc': 'edunjema3 Subscription Payment',
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['customerMessage'] ?? 'STK Push initiated successfully! Check your phone.')),
        );
        // TODO: You might want to navigate to a loading screen or show a success dialog
        // and then poll your backend for transaction status or wait for a callback.
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['error'] ?? 'Failed to initiate M-Pesa payment.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error initiating payment: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription Plans'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.mediumPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose Your Plan',
              style: AppConstants.headline5.copyWith(color: AppConstants.primaryColor),
            ),
            const SizedBox(height: AppConstants.mediumPadding),
            _buildSubscriptionCard(
              context,
              'Free Plan',
              'Ksh 0 / month',
              [
                'Limited lesson plan generations (e.g., 3 per month)',
                'Limited notes generations (e.g., 5 per month)',
                'Basic support',
              ],
              isCurrent: true, // Example: assuming free plan is current by default
            ),
            const SizedBox(height: AppConstants.mediumPadding),
            _buildSubscriptionCard(
              context,
              'Premium Plan',
              'Ksh 299 / month',
              [
                'Unlimited lesson plan generations',
                'Unlimited notes generations',
                'Priority support',
                'Access to new features',
                'Offline access (coming soon)',
              ],
              isRecommended: true,
              buttonText: 'Upgrade to Premium',
              onButtonPressed: () {
                // Example: Use a dummy phone number for testing in sandbox
                // In a real app, get the user's actual phone number.
                _initiateMpesaPayment(context, 299.0, '254700000000'); // Replace with actual user phone number
              },
            ),
            const SizedBox(height: AppConstants.largePadding),
            Text(
              'Why Upgrade?',
              style: AppConstants.headline6.copyWith(color: AppConstants.primaryColor),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              'Unlock the full potential of edunjema3 with unlimited access to AI-powered lesson planning and notes generation, ensuring you have all the resources you need to excel in your teaching journey.',
              style: AppConstants.bodyText1.copyWith(color: AppConstants.mutedTextColor),
            ),
            const SizedBox(height: AppConstants.largePadding),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionCard(
      BuildContext context,
      String title,
      String price,
      List<String> features, {
        bool isCurrent = false,
        bool isRecommended = false,
        String? buttonText,
        VoidCallback? onButtonPressed,
      }) {
    return Card(
      elevation: isRecommended ? 8 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.mediumPadding),
        side: isRecommended
            ? const BorderSide(color: AppConstants.accentColor, width: 3)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: AppConstants.headline5.copyWith(color: AppConstants.primaryColor),
                ),
                if (isCurrent)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.smallPadding, vertical: AppConstants.smallPadding / 2),
                    decoration: BoxDecoration(
                      color: AppConstants.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppConstants.smallPadding),
                    ),
                    child: Text(
                      'Current Plan',
                      style: AppConstants.bodyText2.copyWith(color: AppConstants.primaryColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                if (isRecommended && !isCurrent)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.smallPadding, vertical: AppConstants.smallPadding / 2),
                    decoration: BoxDecoration(
                      color: AppConstants.accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppConstants.smallPadding),
                    ),
                    child: Text(
                      'Recommended',
                      style: AppConstants.bodyText2.copyWith(color: AppConstants.accentColor, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              price,
              style: AppConstants.headline4.copyWith(color: AppConstants.accentColor),
            ),
            const SizedBox(height: AppConstants.mediumPadding),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: features
                  .map((feature) => Padding(
                        padding: const EdgeInsets.only(bottom: AppConstants.smallPadding / 2),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, color: AppConstants.primaryColor, size: 18),
                            const SizedBox(width: AppConstants.smallPadding),
                            Expanded(
                              child: Text(
                                feature,
                                style: AppConstants.bodyText1,
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
            if (buttonText != null && onButtonPressed != null && !isCurrent) ...[
              const SizedBox(height: AppConstants.largePadding),
              Center(
                child: CustomButton(
                  text: buttonText,
                  onPressed: onButtonPressed,
                  color: isRecommended ? AppConstants.accentColor : AppConstants.primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: AppConstants.largePadding, vertical: AppConstants.mediumPadding),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
