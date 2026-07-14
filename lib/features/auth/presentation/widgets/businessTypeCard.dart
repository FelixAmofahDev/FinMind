import 'package:finmind/core/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:finmind/core/theme/colors.dart';


class _BusinessTypeOption {
  const _BusinessTypeOption({
    required this.value,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String value;
  final String title;
  final String subtitle;
  final IconData icon;
}

class _BusinessTypeCard extends StatelessWidget {
  const _BusinessTypeCard({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final _BusinessTypeOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? AppColors.primary : AppColors.border;
    final backgroundColor = selected ? AppColors.primary.withValues(alpha: 0.06) : Colors.white;

    return InkWell(
       onTap: onTap,
       borderRadius: BorderRadius.circular(18),
       child: AnimatedContainer(
         duration: const Duration(milliseconds: 160),
         width: (MediaQuery.of(context).size.width - 20 - 20 - 18) / 2,
         padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
         decoration: BoxDecoration(
           color: backgroundColor,
           borderRadius: BorderRadius.circular(18),
           border: Border.all(color: borderColor, width: 1.3),
           boxShadow: selected
               ? const [
                   BoxShadow(
                     color: Color(0x12000000),
                     blurRadius: 18,
                     offset: Offset(0, 8),
                   ),
                 ]
               : null,
         ),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Row(
               children: [
                 Container(
                   width: 30,
                   height: 30,
                   decoration: BoxDecoration(
                     color: AppColors.primary.withValues(alpha: selected ? 0.14 : 0.09),
                     borderRadius: BorderRadius.circular(10),
                   ),
                   child: Icon(option.icon, color: AppColors.primary, size: 17),
                 ),
                 const Spacer(),
                 Container(
                   width: 18,
                   height: 18,
                   decoration: BoxDecoration(
                     shape: BoxShape.circle,
                     color: selected ? AppColors.primary : Colors.transparent,
                     border: Border.all(color: selected ? AppColors.primary : AppColors.border, width: 1.8),
                   ),
                   child: selected ? Icon(Icons.check, size: 10, color: Colors.white) : null,
                 ),
               ],
             ),
             const SizedBox(height: 10),
             Text(
               option.title,
               style: AppTextStyles.bodyLarge.copyWith(
                 fontWeight: FontWeight.w700,
                 color: AppColors.textPrimary,
                 fontSize: 13.5,
               ),
             ),
             const SizedBox(height: 3),
             Expanded(
               child: Text(
                 option.subtitle,
                 style: AppTextStyles.bodyMedium.copyWith(
                   fontSize: 11,
                   color: AppColors.textSecondary,
                   height: 1.3,
                 ),
               ),
             ),
           ],
         ),
       ),
     );
  }
}
