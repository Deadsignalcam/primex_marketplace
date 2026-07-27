import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class PropertyTransactionCenterPage extends StatefulWidget {
  final String listingId;
  final String listingTitle;
  final String sellerId;
  final String sellerName;
  final String propertyPrice;
  final String propertyLocation;

  const PropertyTransactionCenterPage({
    super.key,
    required this.listingId,
    required this.listingTitle,
    required this.sellerId,
    required this.sellerName,
    required this.propertyPrice,
    required this.propertyLocation,
  });

  @override
  State<PropertyTransactionCenterPage> createState() =>
      _PropertyTransactionCenterPageState();
}

class _PropertyTransactionCenterPageState
    extends State<PropertyTransactionCenterPage> {
  final offerAmount = TextEditingController();
  final earnestMoney = TextEditingController();
  final downPayment = TextEditingController();

  final closingProviderName = TextEditingController();
  final closingProviderEmail = TextEditingController();
  final closingProviderPhone = TextEditingController();

  final attorneyName = TextEditingController();
  final titleCompanyName = TextEditingController();
  final escrowReference = TextEditingController();
  final notes = TextEditingController();

  String purchaseMethod = 'cash_purchase';
  String depositMethod = 'title_company_escrow';
  String currency = 'USD';
  String transactionStatus = 'offer_submitted';

  DateTime? expectedClosingDate;

  final List<PlatformFile> selectedDocuments = [];
  bool saving = false;

  static const purchaseMethods = <String, String>{
    'cash_purchase': 'Cash Purchase',
    'mortgage_financing': 'Mortgage Financing',
    'owner_financing': 'Owner Financing',
    'private_lender': 'Private Lender',
    'international_wire': 'International Wire',
    'commercial_purchase': 'Commercial Purchase',
    'land_purchase': 'Land Purchase',
  };

  static const depositMethods = <String, String>{
    'title_company_escrow': 'Licensed Title Company Escrow',
    'attorney_trust': 'Real Estate Attorney Trust Account',
    'licensed_escrow': 'Licensed Escrow Company',
    'certified_bank_check': 'Certified Bank Check',
    'domestic_wire': 'Domestic Bank Wire',
    'international_wire': 'International Bank Wire',
    'cash_closing': 'Cash Closing Where Legally Permitted',
  };

  static const currencies = <String>[
    'USD',
    'CAD',
    'EUR',
    'GBP',
    'AUD',
    'NZD',
    'JPY',
    'MXN',
    'BRL',
    'CHF',
    'SGD',
    'AED',
  ];

  static const statuses = <String, String>{
    'offer_submitted': 'Offer Submitted',
    'offer_accepted': 'Offer Accepted',
    'proof_of_funds_verified': 'Proof of Funds Verified',
    'purchase_agreement_signed': 'Purchase Agreement Signed',
    'escrow_opened': 'Escrow Opened',
    'deposit_received': 'Deposit Received by Closing Provider',
    'title_search': 'Title Search in Progress',
    'closing_scheduled': 'Closing Scheduled',
    'closing_complete': 'Closing Completed',
    'deed_submitted': 'Deed Submitted for Recording',
    'deed_recorded': 'Deed Recorded',
    'sold': 'Property Sold',
  };

  @override
  void dispose() {
    offerAmount.dispose();
    earnestMoney.dispose();
    downPayment.dispose();
    closingProviderName.dispose();
    closingProviderEmail.dispose();
    closingProviderPhone.dispose();
    attorneyName.dispose();
    titleCompanyName.dispose();
    escrowReference.dispose();
    notes.dispose();
    super.dispose();
  }

  InputDecoration decoration(String label, {String? helper}) {
    return InputDecoration(
      labelText: label,
      helperText: helper,
      labelStyle: const TextStyle(color: Colors.white70),
      helperStyle: const TextStyle(color: Colors.white38),
      filled: true,
      fillColor: const Color(0xFF07111F),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFF00E5FF),
          width: 2,
        ),
      ),
    );
  }

  Widget sectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF00E5FF)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget field(
    TextEditingController controller,
    String label, {
    int lines = 1,
    TextInputType? keyboardType,
    String? helper,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: TextField(
        controller: controller,
        maxLines: lines,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: decoration(label, helper: helper),
      ),
    );
  }

  Future<void> pickDocuments() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'jpg',
        'jpeg',
        'png',
        'doc',
        'docx',
      ],
    );

    if (result == null) return;

    setState(() {
      selectedDocuments.addAll(result.files);
    });
  }

  Future<List<Map<String, dynamic>>> uploadDocuments({
    required String uid,
    required String transactionId,
  }) async {
    final uploaded = <Map<String, dynamic>>[];

    for (final file in selectedDocuments) {
      final Uint8List? bytes = file.bytes;
      if (bytes == null) continue;

      final safeName = file.name.replaceAll(
        RegExp(r'[^a-zA-Z0-9._-]'),
        '_',
      );

      final ref = FirebaseStorage.instance
          .ref()
          .child('property_transactions')
          .child(uid)
          .child(transactionId)
          .child(
            '${DateTime.now().millisecondsSinceEpoch}_$safeName',
          );

      await ref.putData(bytes);
      final url = await ref.getDownloadURL();

      uploaded.add({
        'name': file.name,
        'url': url,
        'sizeBytes': file.size,
        'uploadedAt': Timestamp.now(),
      });
    }

    return uploaded;
  }

  Future<void> chooseClosingDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate:
          expectedClosingDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 730),
      ),
    );

    if (selected != null) {
      setState(() => expectedClosingDate = selected);
    }
  }

  Future<void> saveTransaction() async {
    if (saving) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Sign in before opening a property transaction.',
          ),
        ),
      );
      return;
    }

    if (offerAmount.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter the proposed purchase amount.'),
        ),
      );
      return;
    }

    if (closingProviderName.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Enter the title company, attorney, or licensed escrow provider.',
          ),
        ),
      );
      return;
    }

    setState(() => saving = true);

    try {
      final transactionRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('property_transactions')
          .doc();

      final uploadedDocuments = await uploadDocuments(
        uid: user.uid,
        transactionId: transactionRef.id,
      );

      await transactionRef.set({
        'transactionId': transactionRef.id,
        'listingId': widget.listingId,
        'listingTitle': widget.listingTitle,
        'propertyPrice': widget.propertyPrice,
        'propertyLocation': widget.propertyLocation,
        'buyerId': user.uid,
        'buyerEmail': user.email ?? '',
        'buyerName': user.displayName ?? user.email ?? 'PrimeX Buyer',
        'sellerId': widget.sellerId,
        'sellerName': widget.sellerName,
        'purchaseMethod': purchaseMethod,
        'purchaseMethodLabel':
            purchaseMethods[purchaseMethod] ?? purchaseMethod,
        'depositMethod': depositMethod,
        'depositMethodLabel': depositMethods[depositMethod] ?? depositMethod,
        'currency': currency,
        'offerAmount': offerAmount.text.trim(),
        'earnestMoney': earnestMoney.text.trim(),
        'downPayment': downPayment.text.trim(),
        'closingProviderName': closingProviderName.text.trim(),
        'closingProviderEmail': closingProviderEmail.text.trim(),
        'closingProviderPhone': closingProviderPhone.text.trim(),
        'titleCompanyName': titleCompanyName.text.trim(),
        'attorneyName': attorneyName.text.trim(),
        'escrowReference': escrowReference.text.trim(),
        'expectedClosingDate': expectedClosingDate == null
            ? null
            : Timestamp.fromDate(expectedClosingDate!),
        'status': transactionStatus,
        'statusLabel': statuses[transactionStatus] ?? transactionStatus,
        'documents': uploadedDocuments,
        'notes': notes.text.trim(),
        'primeXHoldsFunds': false,
        'fundsRecipientType': 'licensed_closing_provider',
        'platformPurpose': 'transaction_tracking_and_document_management',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Property transaction opened successfully.',
          ),
        ),
      );

      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to open transaction: $error',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => saving = false);
      }
    }
  }

  Widget timelinePreview() {
    final entries = statuses.entries.toList();
    final currentIndex = entries.indexWhere(
      (entry) => entry.key == transactionStatus,
    );

    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFF07111F),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: List.generate(entries.length, (index) {
          final reached = index <= currentIndex;
          final entry = entries[index];

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Icon(
                    reached ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: reached ? Colors.greenAccent : Colors.white30,
                    size: 20,
                  ),
                  if (index < entries.length - 1)
                    Container(
                      width: 2,
                      height: 24,
                      color: reached ? Colors.greenAccent : Colors.white24,
                    ),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Text(
                    entry.value,
                    style: TextStyle(
                      color: reached ? Colors.white : Colors.white38,
                      fontWeight: reached ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Property Transaction Center'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xEE07111F),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF00E5FF),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.listingTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.propertyLocation,
                  style: const TextStyle(
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.propertyPrice,
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          sectionTitle(
            'Purchase Information',
            Icons.real_estate_agent,
          ),
          DropdownButtonFormField<String>(
            initialValue: purchaseMethod,
            dropdownColor: const Color(0xFF07111F),
            style: const TextStyle(color: Colors.white),
            decoration: decoration('Purchase Method'),
            items: purchaseMethods.entries
                .map(
                  (entry) => DropdownMenuItem(
                    value: entry.key,
                    child: Text(entry.value),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                purchaseMethod = value ?? 'cash_purchase';
              });
            },
          ),
          const SizedBox(height: 11),
          DropdownButtonFormField<String>(
            initialValue: currency,
            dropdownColor: const Color(0xFF07111F),
            style: const TextStyle(color: Colors.white),
            decoration: decoration('Transaction Currency'),
            items: currencies
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() => currency = value ?? 'USD');
            },
          ),
          const SizedBox(height: 11),
          field(
            offerAmount,
            'Purchase Offer Amount',
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
          ),
          field(
            earnestMoney,
            'Earnest Money Amount',
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
          ),
          field(
            downPayment,
            'Down Payment Amount',
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
          ),
          sectionTitle(
            'Escrow and Closing Provider',
            Icons.account_balance,
          ),
          DropdownButtonFormField<String>(
            initialValue: depositMethod,
            dropdownColor: const Color(0xFF07111F),
            style: const TextStyle(color: Colors.white),
            decoration: decoration('Deposit Method'),
            items: depositMethods.entries
                .map(
                  (entry) => DropdownMenuItem(
                    value: entry.key,
                    child: Text(entry.value),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                depositMethod = value ?? 'title_company_escrow';
              });
            },
          ),
          const SizedBox(height: 11),
          field(
            closingProviderName,
            'Closing Provider Name',
            helper: 'Licensed title company, attorney, or escrow provider.',
          ),
          field(
            titleCompanyName,
            'Title Company',
          ),
          field(
            attorneyName,
            'Real Estate Attorney',
          ),
          field(
            closingProviderEmail,
            'Closing Provider Email',
            keyboardType: TextInputType.emailAddress,
          ),
          field(
            closingProviderPhone,
            'Closing Provider Phone',
            keyboardType: TextInputType.phone,
          ),
          field(
            escrowReference,
            'Escrow or Closing Reference Number',
          ),
          OutlinedButton.icon(
            onPressed: chooseClosingDate,
            icon: const Icon(Icons.event),
            label: Text(
              expectedClosingDate == null
                  ? 'Select Expected Closing Date'
                  : 'Closing: '
                      '${expectedClosingDate!.month}/'
                      '${expectedClosingDate!.day}/'
                      '${expectedClosingDate!.year}',
            ),
          ),
          sectionTitle(
            'Documents and Proof',
            Icons.folder_copy,
          ),
          OutlinedButton.icon(
            onPressed: pickDocuments,
            icon: const Icon(Icons.upload_file),
            label: const Text(
              'Upload Proof of Funds / Escrow Receipt / Deed',
            ),
          ),
          if (selectedDocuments.isNotEmpty) ...[
            const SizedBox(height: 9),
            ...selectedDocuments.asMap().entries.map(
                  (entry) => ListTile(
                    dense: true,
                    leading: const Icon(
                      Icons.description,
                      color: Colors.cyanAccent,
                    ),
                    title: Text(
                      entry.value.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.redAccent,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedDocuments.removeAt(entry.key);
                        });
                      },
                    ),
                  ),
                ),
          ],
          field(
            notes,
            'Transaction Notes',
            lines: 5,
          ),
          sectionTitle(
            'Transaction Progress',
            Icons.timeline,
          ),
          DropdownButtonFormField<String>(
            initialValue: transactionStatus,
            dropdownColor: const Color(0xFF07111F),
            style: const TextStyle(color: Colors.white),
            decoration: decoration('Current Status'),
            items: statuses.entries
                .map(
                  (entry) => DropdownMenuItem(
                    value: entry.key,
                    child: Text(entry.value),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                transactionStatus = value ?? 'offer_submitted';
              });
            },
          ),
          const SizedBox(height: 13),
          timelinePreview(),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: Colors.orangeAccent),
            ),
            child: const Text(
              'PrimeX Marketplace does not hold real-estate '
              'purchase funds and does not provide legal, title, '
              'escrow, or closing services. Deposits and purchase '
              'funds must be sent directly to a licensed title '
              'company, attorney trust account, licensed escrow '
              'provider, financial institution, or other legally '
              'authorized closing professional.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                height: 1.35,
              ),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 55,
            child: ElevatedButton.icon(
              onPressed: saving ? null : saveTransaction,
              icon: const Icon(Icons.verified_user),
              label: Text(
                saving ? 'Opening Transaction...' : 'Open Property Transaction',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00E5FF),
                foregroundColor: Colors.black,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
