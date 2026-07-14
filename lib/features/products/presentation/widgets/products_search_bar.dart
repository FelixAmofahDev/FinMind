import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finmind/core/theme/colors.dart';
import 'package:finmind/core/theme/text_styles.dart';

import '../providers/products_provider.dart';

class ProductsSearchBar extends ConsumerStatefulWidget {
  const ProductsSearchBar({super.key});

  @override
  ConsumerState<ProductsSearchBar> createState() => _ProductsSearchBarState();
}

class _ProductsSearchBarState extends ConsumerState<ProductsSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: ref.read(productsSearchProvider));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(productsSearchProvider);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: _controller,
        onChanged: (value) =>
            ref.read(productsControllerProvider.notifier).updateSearch(value),
        decoration: InputDecoration(
          hintText: 'Search products by name',
          hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
          suffixIcon: query.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                  onPressed: () {
                    _controller.clear();
                    ref.read(productsControllerProvider.notifier).updateSearch('');
                  },
                ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}
