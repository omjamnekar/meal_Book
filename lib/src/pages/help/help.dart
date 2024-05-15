import 'package:flutter/material.dart';

class HelpAndSupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help and Support'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Get Help',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text('Live Chat Support'),
              subtitle: Text('Available 24/7'),
              onTap: () {
                // Implement live chat support functionality
              },
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Call Support'),
              subtitle: Text('1-800-123-4567'),
              onTap: () {
                // Implement call support functionality
              },
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Email Support'),
              subtitle: Text('support@example.com'),
              onTap: () {
                // Implement email support functionality
              },
            ),
            Divider(),
            Text(
              'Resources',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('FAQs'),
              onTap: () {
                // Implement FAQ page navigation
              },
            ),
            ListTile(
              leading: Icon(Icons.description),
              title: Text('Terms of Service'),
              onTap: () {
                // Implement Terms of Service page navigation
              },
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip),
              title: Text('Privacy Policy'),
              onTap: () {
                // Implement Privacy Policy page navigation
              },
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HelpAndSupportPage(),
  ));
}
