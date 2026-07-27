import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PrimeXAiService {
  PrimeXAiService._();

  static final PrimeXAiService instance = PrimeXAiService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late final GenerativeModel _model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-2.5-flash',
    systemInstruction: Content.system(_systemInstruction),
  );

  static const String _systemInstruction = '''
You are PrimeX AI, the official assistant for PrimeX Marketplace.

PrimeX Marketplace connects users with marketplace listings, vehicles,
real estate, jobs, professional services, businesses, property inspection
assignments and disaster deployment opportunities.

Your responsibilities:
1. Help users search and understand PrimeX content.
2. Help sellers draft honest titles and descriptions.
3. Help employers improve job postings.
4. Help applicants understand qualifications and prepare applications.
5. Help inspectors organize field notes and draft reports.
6. Detect suspicious, discriminatory, sexual, fraudulent or unsafe content.
7. Never invent property facts, vehicle history, inspection findings,
licenses, certifications, prices or employment guarantees.
8. Never claim that a user will receive a job, payment, contract or approval.
9. Never expose private phone numbers, addresses, emails or account data.
10. Clearly label suggestions as AI-generated and subject to user review.
11. Do not provide legal, medical, financial or insurance determinations.
12. Encourage users to independently verify important information.

PrimeX does not allow scams, fraud, hate, discrimination, sexual content,
illegal activity or exploitation of minors.

Respond clearly and professionally.
''';

  Future<String> ask({
    required String prompt,
    String module = 'general',
    Map<String, dynamic>? context,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw StateError('Please sign in before using PrimeX AI.');
    }

    final cleanedPrompt = prompt.trim();

    if (cleanedPrompt.isEmpty) {
      throw ArgumentError('Enter a question or request.');
    }

    final fullPrompt = _buildPrompt(
      prompt: cleanedPrompt,
      module: module,
      context: context,
    );

    await _saveMessage(
      uid: user.uid,
      role: 'user',
      text: cleanedPrompt,
      module: module,
    );

    try {
      final response = await _model.generateContent([
        Content.text(fullPrompt),
      ]);

      final text = response.text?.trim();

      if (text == null || text.isEmpty) {
        throw StateError('PrimeX AI returned an empty response.');
      }

      await _saveMessage(
        uid: user.uid,
        role: 'assistant',
        text: text,
        module: module,
      );

      await _logUsage(
        uid: user.uid,
        module: module,
        success: true,
      );

      return text;
    } catch (error) {
      await _logUsage(
        uid: user.uid,
        module: module,
        success: false,
        error: error.toString(),
      );

      rethrow;
    }
  }

  Future<String> writeListing({
    required String category,
    required String itemName,
    required String condition,
    required String location,
    String details = '',
    String price = '',
  }) {
    return ask(
      module: 'marketplace_writer',
      prompt: '''
Create an accurate PrimeX Marketplace listing.

Category: $category
Item: $itemName
Condition: $condition
Location: $location
Price: $price
Seller details: $details

Return:
TITLE:
DESCRIPTION:
KEY FEATURES:
BUYER QUESTIONS TO EXPECT:
SAFETY OR VERIFICATION REMINDERS:

Do not invent specifications or condition details.
''',
    );
  }

  Future<String> improveJobPosting({
    required String title,
    required String company,
    required String location,
    required String description,
    String pay = '',
    String employmentType = '',
  }) {
    return ask(
      module: 'jobs_employer',
      prompt: '''
Improve this PrimeX job posting.

Title: $title
Company: $company
Location: $location
Pay: $pay
Employment type: $employmentType
Current description:
$description

Return:
IMPROVED TITLE:
JOB SUMMARY:
RESPONSIBILITIES:
QUALIFICATIONS:
PAY AND SCHEDULE:
LOCATION OR TRAVEL:
HOW TO APPLY:

Do not add qualifications, pay or benefits that were not supplied.
Use inclusive and nondiscriminatory language.
''',
    );
  }

  Future<String> calculateJobMatch({
    required String jobDescription,
    required String applicantExperience,
    String certifications = '',
    String location = '',
    String availability = '',
  }) {
    return ask(
      module: 'jobs_match',
      prompt: '''
Compare this applicant information with the job.

JOB:
$jobDescription

APPLICANT EXPERIENCE:
$applicantExperience

CERTIFICATIONS:
$certifications

LOCATION:
$location

AVAILABILITY:
$availability

Return:
MATCH SCORE: Give a cautious 0-100 estimate.
STRONG MATCHES:
POSSIBLE GAPS:
QUESTIONS TO ASK:
APPLICATION IMPROVEMENTS:
DISCLAIMER:

Do not promise employment and do not infer protected characteristics.
''',
    );
  }

  Future<String> prepareInspectionReport({
    required String inspectionType,
    required String fieldNotes,
    String propertyLocation = '',
  }) {
    return ask(
      module: 'inspection_assistant',
      prompt: '''
Organize these inspection notes into a professional draft.

Inspection type: $inspectionType
Property location: $propertyLocation
Field notes:
$fieldNotes

Return:
INSPECTION SUMMARY:
OBSERVATIONS:
VISIBLE CONDITIONS:
PHOTOS STILL NEEDED:
FOLLOW-UP QUESTIONS:
DRAFT REPORT NOTES:
IMPORTANT LIMITATIONS:

Do not determine coverage, causation, code compliance, liability,
repair cost or structural safety. Do not invent observations.
''',
    );
  }

  Future<String> safetyReview({
    required String content,
    required String contentType,
  }) {
    return ask(
      module: 'safety_review',
      prompt: '''
Review this proposed PrimeX $contentType:

$content

Return:
DECISION: APPROVE, REVIEW or REJECT
RISK LEVEL: LOW, MEDIUM or HIGH
REASONS:
SUSPICIOUS CLAIMS:
PRIVATE INFORMATION:
RECOMMENDED CHANGES:

Check for fraud, scams, discrimination, sexual content, threats,
illegal goods, external-contact evasion and exploitation.
''',
    );
  }

  String _buildPrompt({
    required String prompt,
    required String module,
    Map<String, dynamic>? context,
  }) {
    final buffer = StringBuffer()
      ..writeln('PrimeX module: $module')
      ..writeln();

    if (context != null && context.isNotEmpty) {
      buffer
        ..writeln('Verified application context:')
        ..writeln(context)
        ..writeln();
    }

    buffer
      ..writeln('User request:')
      ..writeln(prompt);

    return buffer.toString();
  }

  Future<void> _saveMessage({
    required String uid,
    required String role,
    required String text,
    required String module,
  }) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('ai_messages')
        .add({
      'role': role,
      'text': text,
      'module': module,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _logUsage({
    required String uid,
    required String module,
    required bool success,
    String? error,
  }) async {
    await _firestore.collection('ai_activity').add({
      'uid': uid,
      'module': module,
      'success': success,
      'error': error,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
