import 'package:flutter/material.dart';


class DashboardHeader extends StatelessWidget {
  const DashboardHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Row(
        children: [
          // TODO: replace with real avatar (initials / photo)
          const CircleAvatar(
            radius: 21,
            backgroundColor: Color(0xFFEF9F27),
            child: Text('A', style: TextStyle(fontWeight: FontWeight.w800)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TODO: dynamic greeting ("Good morning" / afternoon / evening)
                Text('Good morning',
                    style: TextStyle(fontSize: 12.5, color: Colors.grey.shade500)),
                // TODO: bind to signed-in user's name
                 Text('Akosua',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          // TODO: wrap with unread-count badge / onTap -> notifications
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE7EBF0)),
            ),
            child: const Icon(Icons.notifications_outlined, size: 20),
          ),
        ],
      ),
    );
  }
}
