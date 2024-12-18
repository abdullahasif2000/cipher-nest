import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MaliciousLinkDetectorScreen extends StatefulWidget {
  const MaliciousLinkDetectorScreen({super.key});

  @override
  State<MaliciousLinkDetectorScreen> createState() =>
      _MaliciousLinkDetectorScreenState();
}

class _MaliciousLinkDetectorScreenState
    extends State<MaliciousLinkDetectorScreen> {
  final TextEditingController _linkController = TextEditingController();
  String _result = '';

  // Function to check URL using Google Safe Browsing
  Future<bool> _checkWithGoogleSafeBrowsing(String url) async {
    final apiKey = 'AIzaSyACflUeaCYVHqJQaFQ7Sn85jEXMWHwFA-Q'; // Your Google API Key
    final apiUrl =
        'https://safebrowsing.googleapis.com/v4/threatMatches:find?key=$apiKey';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "client": {
          "clientId": "your-app-id",
          "clientVersion": "1.0.0"
        },
        "threatInfo": {
          "threatTypes": ["MALWARE", "SOCIAL_ENGINEERING"],
          "platformTypes": ["ANY_PLATFORM"],
          "threatEntryTypes": ["URL"],
          "threatEntries": [
            {"url": url}
          ]
        }
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['matches'] != null) {
        return true; // URL is malicious
      }
    }
    return false; // URL is safe
  }

  // Function to check URL using VirusTotal
  Future<bool> _checkWithVirusTotal(String url) async {
    final apiKey = 'b5312179940ba629791455634cc8ced6b0902d94b42b9d28dc784019b30bec1f'; // Your VirusTotal API Key
    final baseUrl = 'https://www.virustotal.com/api/v3/urls/';
    final encodedUrl = base64Url.encode(utf8.encode(url)); // Encode URL to base64

    final response = await http.get(
      Uri.parse(baseUrl + encodedUrl),
      headers: {
        'x-apikey': apiKey,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final maliciousCount =
      data['data']['attributes']['last_analysis_stats']['malicious'];

      if (maliciousCount > 0) {
        return true; // URL is malicious
      }
    }
    return false; // URL is safe
  }

  // Combined function to check both APIs
  Future<void> _checkLink() async {
    final url = _linkController.text.trim();
    bool isMalicious = false;

    // Check with Google Safe Browsing
    bool googleSafeBrowsingResult = await _checkWithGoogleSafeBrowsing(url);
    if (googleSafeBrowsingResult) {
      isMalicious = true;
    }

    // Check with VirusTotal if it's not flagged already
    if (!isMalicious) {
      bool virusTotalResult = await _checkWithVirusTotal(url);
      if (virusTotalResult) {
        isMalicious = true;
      }
    }

    // Set result message
    setState(() {
      _result = isMalicious
          ? 'The link is malicious!'
          : 'The link is safe.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Malicious Link Detector'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _linkController,
              decoration: InputDecoration(
                labelText: 'Paste a link',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkLink,
              child: const Text('Check Link'),
            ),
            const SizedBox(height: 20),
            Text(
              _result,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _result.contains('malicious') ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
