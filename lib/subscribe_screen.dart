import 'package:flutter/material.dart';
import 'main.dart';

class SubscribeScreen extends StatelessWidget {
  const SubscribeScreen({super.key});

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Confirm Subscription"),
          content: const Text("Are you sure you want to start your free trial?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text("Confirm"),
              onPressed: () {
                buySubscription();
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final backgroundColor = isDarkMode ? Colors.grey[800] : Colors.white;
    const String welcomeTitle = "📄 Welcome to EcoPDF!";
    const String welcomeSubtitle = """
Your smart, simple PDF companion:

• Read and Fill PDFs  
• Sign with your Finger or Digitally  
• Read Aloud for Hands-Free Use  
• Dark Mode & Mobile-Friendly View  
• Adjustable Font Sizes for Easy Reading

Try it FREE for 2 weeks!  
Only R5/month thereafter – via Google Pay.
""";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Subscribe"),
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(color: textColor),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/subscription_image.png'), // Use the same image as a background
            fit: BoxFit.cover, // Adjust the fit as needed
            opacity: 0.2
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                welcomeTitle,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                welcomeSubtitle,
                style: TextStyle(fontSize: 16, color: textColor),
                textAlign: TextAlign.center,
              ),
              const Spacer(), // Add space above the button
              ElevatedButton(
                onPressed: () => _showConfirmationDialog(context),
                child: const Text("Start Free Trial – R5/month after 2 weeks"),
              ),
            ],
          ),
            ),
      ),
      ),
    )
  }
}