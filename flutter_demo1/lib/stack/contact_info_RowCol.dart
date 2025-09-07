import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: RowColumnSimple()));
}

class RowColumnSimple extends StatelessWidget {
  const RowColumnSimple({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Simple Row\Column: Contact Info"),
        backgroundColor: Colors.teal.shade600,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.person, size: 48, color: Colors.teal.shade600),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Symon PUM",
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Founder & CEO of KAT Consulting Co., Ltd.",
                        style: TextStyle(
                          color: Colors.teal.shade800,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.teal.shade600,
            thickness: 1.2,
            indent: 16,
            endIndent: 16,
          ),
          //Email Row with Icon ">" on the Right
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.email, size: 48, color: Colors.teal.shade600),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email :",
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "symon@khits.asia",
                        style: TextStyle(
                          color: Colors.teal.shade800,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 24,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.teal.shade600,
            thickness: 1.2,
            indent: 16,
            endIndent: 16,
          ),
          //Phone Number Row
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.phone, size: 48, color: Colors.teal.shade600),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mobile :",
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "+855 11 76 55 86",
                        style: TextStyle(
                          color: Colors.teal.shade800,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.teal.shade600,
            thickness: 1.2,
            indent: 16,
            endIndent: 16,
          ),
          //Locaton Address Row
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.location_on, size: 48, color: Colors.teal.shade600),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Address :",
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Villa No.24, St. #1, Sambour, Sangkat Dangkao, Khan Dangkao, Phnom Penh 120502, Cambodia",
                        style: TextStyle(
                          color: Colors.teal.shade800,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.teal.shade600,
            thickness: 1.2,
            indent: 16,
            endIndent: 16,
          ),
          //Disable Row:
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300, // Light grey background
                borderRadius: BorderRadius.circular(
                  8,
                ), // Optional: rounded corners
              ),
              padding: const EdgeInsets.all(12.0), // Inner padding
              child: Row(
                children: [
                  Icon(
                    Icons.lock,
                    size: 48,
                    color: Colors.grey.shade500,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Account Disabled",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Please contact support to Enable your account.",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
