import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finmind/app/router/routes.dart';
import 'package:finmind/core/theme/colors.dart';
import 'package:finmind/features/auth/domain/entities/signup_draft.dart';
import 'package:finmind/features/auth/presentation/providers/auth_provider.dart';
import 'package:finmind/shared/widgets/primary_button.dart';

import '../widgets/auth_choice_card.dart';
import '../widgets/auth_flow_scaffold.dart';
import '../widgets/auth_sample_field.dart';

class SignupBusinessPage extends ConsumerStatefulWidget {
  const SignupBusinessPage({super.key});

  @override
  ConsumerState<SignupBusinessPage> createState() => _SignupBusinessPageState();
}

class _SignupBusinessPageState extends ConsumerState<SignupBusinessPage> {
  late final TextEditingController _shopNameController;
  int _selectedBusinessType = 0;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(authProvider).value?.signupDraft ?? const SignupDraft();
    _shopNameController = TextEditingController(text: draft.businessName);
    _selectedBusinessType = draft.businessType == 'supermarket' ? 1 : 0;
  }

  @override
  void dispose() {
    _shopNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthFlowScaffold(
      title: 'Create account',
      stepIndex: 0,
      stepCount: 4,
      onBack: () => Navigator.of(context).pop(),
      subtitle: 'Step 1 of 4 - the basics.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Tell us about your shop',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          AuthSampleField(
            label: 'Shop name',
            value: '',
            controller: _shopNameController,
            readOnly: false,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 15),
          Text(
            'What kind of business?',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 7),
          AuthChoiceCard(
            title: 'Provision store',
            subtitle: 'Pick the closest - it is only used to personalise your app, not your accounting.',
            icon: Icons.storefront_rounded,
            accentColor: AppColors.primary,
            selected: _selectedBusinessType == 0,
            onTap: () => setState(() => _selectedBusinessType = 0),
          ),
          const SizedBox(height: 12),
          AuthChoiceCard(
            title: 'Supermarket',
            subtitle: 'Alternative business type shown in the prototype.',
            icon: Icons.shopping_bag_rounded,
            accentColor: AppColors.secondary,
            selected: _selectedBusinessType == 1,
            onTap: () => setState(() => _selectedBusinessType = 1),
          ),
          const SizedBox(height: 14),
          Text(
            'Pick the closest - it is only used to personalise your app, not your accounting.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Continue',
            onPressed: () {
              ref.read(authProvider.notifier).updateSignupDraft(
                    (ref.read(authProvider).value?.signupDraft ?? const SignupDraft()).copyWith(
                      businessName: _shopNameController.text.trim(),
                      businessType: _selectedBusinessType == 1 ? 'supermarket' : 'provision_store',
                    ),
                  );
              Navigator.of(context).pushNamed(AppRoutes.signupLocation);
            },
            expanded: true,
          ),
        ],
      ),
    );
  }
}
