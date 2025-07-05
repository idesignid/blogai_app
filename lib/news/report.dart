// import 'package:flutter/material.dart';

// class ReportScreen extends StatefulWidget {
//   const ReportScreen({super.key});

//   @override
//   State<ReportScreen> createState() => _ReportScreenState();
// }

// class _ReportScreenState extends State<ReportScreen> {
//   final TextEditingController _reportController = TextEditingController();
//   String? _selectedReason;

//   // List of reasons to select for reporting
//   final List<String> _reportReasons = [
//     'Inappropriate Content',
//     'Spam',
//     'Harassment',
//     'False Information',
//     'Other',
//   ];

//   @override
//   void dispose() {
//     _reportController.dispose();
//     super.dispose();
//   }

//   void _submitReport() {
//     // Perform report submission logic here
//     final reportText = _reportController.text;
//     if (_selectedReason != null && reportText.isNotEmpty) {
//       // Submit the report (to backend or database)
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Report submitted successfully!')),
//       );
//       // Clear the form after submission
//       setState(() {
//         _selectedReason = null;
//         _reportController.clear();
//       });
//     } else {
//       // Show error if form is incomplete
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please complete the form')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Report Inappropriate Content'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Select a reason for reporting:',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               DropdownButtonFormField<String>(
//                 value: _selectedReason,
//                 hint: const Text('Choose a reason'),
//                 items: _reportReasons.map((reason) {
//                   return DropdownMenuItem<String>(
//                     value: reason,
//                     child: Text(reason),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedReason = value;
//                   });
//                 },
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Describe the issue:',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               TextField(
//                 controller: _reportController,
//                 maxLines: 5,
//                 decoration: const InputDecoration(
//                   hintText: 'Provide additional details...',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: _submitReport,
//                   child: const Text('Submit Report'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _ctrl = TextEditingController();
  String? _reason;
  final _reasons = [
    'Inappropriate Content',
    'Spam',
    'Harassment',
    'False Info',
    'Other'
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_reason != null && _ctrl.text.isNotEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Report submitted')));
      _ctrl.clear();
      setState(() => _reason = null);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please complete the form')));
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report Content')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Reason', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _reason,
            items: _reasons
                .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                .toList(),
            hint: const Text('Select reason'),
            onChanged: (v) => setState(() => _reason = v),
          ),
          const SizedBox(height: 16),
          const Text('Details', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _ctrl,
            maxLines: 4,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Describe the issue...'),
          ),
          const SizedBox(height: 24),
          Center(
              child: ElevatedButton(
                  onPressed: _submit, child: const Text('Submit')))
        ]),
      ),
    );
  }
}
