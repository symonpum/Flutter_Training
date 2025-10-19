import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: ContactInfoPage()));
}

class ContactInfoPage extends StatelessWidget {
  const ContactInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Functions RowCol: Contact Info"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRowItem(
              icon: Icons.person,
              title: "Symon PUM",
              subtitle: "Founder & CEO of KAT Consulting Co., Ltd.",
            ),
            _addDivider(),
            _buildRowItem(
              icon: Icons.email,
              title: "Email",
              subtitle: "symon@kat-advisory.com",
              enableRightArrowIcon: true,
            ),
            _addDivider(),
            _buildRowItem(
              icon: Icons.phone,
              title: "Phone",
              subtitle: "+855 11 76 55 86",
            ),
            _addDivider(),
            _buildRowItem(
              icon: Icons.location_on,
              title: "Address",
              subtitle:
                  "No. 24, St. 1, Sangkat Dangkao, Khan Dangkao, Phnom Penh 120502, Cambodia.",
            ),
            _addDivider(),
            _buildRowItem(
              icon: Icons.lock,
              title: "Account Disabled",
              subtitle: "This option is Disabled by Admin.",
              isDisabled: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _addDivider() {
    return Divider(
      color: Colors.teal.shade600,
      thickness: 1.2,
      indent: 16,
      endIndent: 16,
    );
  }

  Widget _buildVerticalText(
    String title,
    String subtitle, {
    bool isDisabled = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDisabled ? Colors.grey.shade500 : Colors.black87,
          ),
        ),
        SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: isDisabled ? Colors.grey.shade400 : Colors.teal.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildRowItem({
    required IconData icon,
    required String title,
    required String subtitle,
    bool isDisabled = false,
    bool enableRightArrowIcon = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: isDisabled ? Colors.grey.shade200 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 48,
              color: isDisabled ? Colors.grey.shade400 : Colors.teal,
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildVerticalText(
                title,
                subtitle,
                isDisabled: isDisabled,
              ),
            ),
            if (enableRightArrowIcon)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 24,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
