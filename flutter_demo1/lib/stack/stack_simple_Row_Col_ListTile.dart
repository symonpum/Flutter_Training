
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: RowColumnListTile()));
}

class RowColumnListTile extends StatelessWidget {
  const RowColumnListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Simple LisTiles: Contact Info"),
        backgroundColor: Colors.teal.shade600,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(
                Icons.person,
                size: 48,
                color: Colors.teal.shade600,
              ),
              title: Text(
                "Symon PUM",
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "Founder & CEO of KAT Consulting Co., Ltd.",
                style: TextStyle(color: Colors.teal.shade800, fontSize: 14),
              ),
            ),
            Divider(color: Colors.teal.shade600, thickness: 1.2, indent: 16, endIndent: 16),
            ListTile(
              leading: Icon(
                Icons.email,
                size: 48,
                color: Colors.teal.shade600,
              ),
              title: Text(
                "Email",
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "symon@kat-advisory.com",
                style: TextStyle(color: Colors.teal.shade800, fontSize: 14),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Colors.grey.shade800,
              ),
            ),
            Divider(color: Colors.teal.shade600, thickness: 1.2, indent: 16, endIndent: 16),
            ListTile(
              leading: Icon(
                Icons.phone,
                size: 48,
                color: Colors.teal.shade600,
              ),
              title: Text(
                "Phone",
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "+855 11 76 55 86",
                style: TextStyle(color: Colors.teal.shade800, fontSize: 14),
              ),
            ),
            Divider(color: Colors.teal.shade600, thickness: 1.2, indent: 16, endIndent: 16),
            ListTile(
              leading: Icon(
                Icons.location_on,
                size: 48,
                color: Colors.teal.shade600,
              ),
              title: Text(
                "Address",
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "No. 24, St. 1, Sangkat Dangkao, Khan Dangkao, Phnom Penh 120502, Cambodia.",
                style: TextStyle(color: Colors.teal.shade800, fontSize: 14),
              ),
            ),
            Divider(color: Colors.teal.shade600, thickness: 1.2, indent: 16, endIndent: 16),
            ListTile(
              leading: Icon(
                Icons.lock,
                size: 48,
                color: Colors.grey.shade600,
              ),
              title: Text(
                "Account Disabled",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "This options is Disabled by Admin.",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
