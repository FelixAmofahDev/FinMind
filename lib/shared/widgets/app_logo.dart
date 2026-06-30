import 'package:flutter/material.dart';
import 'package:finmind/app/config/app_constants.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Icon(Icons.trending_up_rounded, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Text(
          AppConfig.appName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 20,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );

  }}
  