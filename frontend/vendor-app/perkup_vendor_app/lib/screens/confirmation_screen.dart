import 'package:flutter/material.dart';
import 'package:perkup_vendor_app/models/login/login_response.dart';
import 'package:perkup_vendor_app/providers/perk_provider.dart';
import 'package:perkup_vendor_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ConfirmationScreen extends StatefulWidget {
  final int perkId;
  final int userId;

  const ConfirmationScreen({
    super.key,
    required this.perkId,
    required this.userId,
  });

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  Map<String, dynamic>? perkDetails;
  Map<String, dynamic>? userDetails;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final perkProvider = Provider.of<PerkProvider>(context, listen: false);
    // try {
    // Load user token
    LoginResponse? user = await LoginResponse.loadFromPreferences();
    String? token = user?.token;

    // Fetch user and perk details using their respective providers
    final userResult = await userProvider.getUserById(widget.userId);
    final perkResult = await perkProvider.getPerkById(widget.perkId, token!);

    setState(() {
      userDetails = userResult!.toJson();
      perkDetails = perkResult!.toJson();
    });
    // } catch (error) {
    //   setState(() {
    //     errorMessage = 'Error fetching details: $error';
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmation'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (perkDetails == null || userDetails == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Text(
          errorMessage ?? 'Error fetching details',
        ),
      );
    }

    return _buildDetails();
  }

  Widget _buildDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(
            title: 'Perk',
            value: perkDetails?['perkName'] ?? 'N/A',
          ),
          const SizedBox(height: 10),
          _buildDetailRow(
            title: 'Description',
            value: perkDetails?['description'] ?? 'N/A',
          ),
          const SizedBox(height: 20),
          _buildDetailRow(
            title: 'Customer',
            value: userDetails?['displayName'] ?? 'N/A',
          ),
          const SizedBox(height: 10),
          _buildDetailRow(
            title: 'Email',
            value: userDetails?['email'] ?? 'N/A',
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () =>
                Navigator.popUntil(context, (route) => route.isFirst),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({required String title, required String value}) {
    return RichText(
      text: TextSpan(
        text: '$title: ',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
