import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VoiceRecordField extends StatelessWidget {
  final VoidCallback onRecord;
  final VoidCallback onStop;
  final bool isRecording;

  const VoiceRecordField({
    super.key,
    required this.onRecord,
    required this.onStop,
    required this.isRecording,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            isRecording ? Icons.mic : Icons.mic_none,
            color: isRecording ? Colors.red : Colors.grey,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isRecording ? 'جاري التسجيل...' : 'اضغط لبدء التسجيل',
            ),
          ),
          IconButton(
            icon: Icon(isRecording ? Icons.stop : Icons.play_arrow),
            onPressed: isRecording ? onStop : onRecord,
          ),
        ],
      ),
    );
  }
}
