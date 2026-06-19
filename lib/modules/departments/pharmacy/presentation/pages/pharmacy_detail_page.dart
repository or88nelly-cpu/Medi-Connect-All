import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:medi_connect/core/common_widgets/common_app_bar.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/dash_board/domain/entities/pharmacy_item_entity.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/admin/admin_pharmacy_bloc.dart';
import 'package:medi_connect/modules/departments/pharmacy/presentation/bloc/pharmacy_bloc.dart';

class PharmacyDetailPage extends StatefulWidget {
  const PharmacyDetailPage({super.key});

  @override
  State<PharmacyDetailPage> createState() => _PharmacyDetailPageState();
}

class _PharmacyDetailPageState extends State<PharmacyDetailPage> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<AdminPharmacyBloc>().add(LoadPharmacyItems());
  }

  void _showQuickEditStockDialog(
    BuildContext context,
    PharmacyItemEntity item,
  ) async {
    final pharmacyBloc = context.read<AdminPharmacyBloc>();
    final messenger = ScaffoldMessenger.of(context);

    final newStock = await showDialog<int>(
      context: context,
      builder: (ctx) => _StockEditDialog(item: item),
    );

    if (newStock != null && mounted) {
      pharmacyBloc.add(UpdatePharmacyItemStock(item.id, newStock));
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            "Updated stock level for ${item.name} to $newStock units.",
          ),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => GetIt.I<PharmacyBloc>()..add(LoadPharmacyStats()),
      child: DefaultTabController(
        length: 2,
        child: CustomScaffold(
          customAppbar: CommonAppBar(
            title: "Pharmacy Department",
            bottom: TabBar(
              labelColor: AppColors.primary,
              unselectedLabelColor: isDark
                  ? Colors.white70
                  : AppColors.textSecondary(context),
              indicatorColor: AppColors.primary,
              tabs: const [
                Tab(icon: Icon(Icons.analytics_outlined), text: "Insights"),
                Tab(icon: Icon(Icons.inventory_2_outlined), text: "Inventory"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              // Tab 1: Operational Insights
              BlocBuilder<PharmacyBloc, PharmacyState>(
                builder: (context, state) {
                  if (state is PharmacyLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PharmacyError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    );
                  } else if (state is PharmacyLoaded) {
                    final stats = state.stats;
                    return SingleChildScrollView(
                      padding: EdgeInsets.all(20.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Department Operational Insights",
                            style: AppTextStyles.titleMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: isDark
                                  ? Colors.white
                                  : AppColors.textPrimary(context),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16.w,
                                  mainAxisSpacing: 16.h,
                                  childAspectRatio: 1.3,
                                ),
                            itemCount: stats.length,
                            itemBuilder: (context, index) {
                              final key = stats.keys.elementAt(index);
                              final val = stats[key];
                              final displayKey = key
                                  .split('_')
                                  .map((word) {
                                    if (word == 'pct') return '%';
                                    if (word == 'min' || word == 'mins') {
                                      return 'Mins';
                                    }
                                    return word[0].toUpperCase() +
                                        word.substring(1);
                                  })
                                  .join(' ');

                              return Card(
                                elevation: 0,
                                color: isDark
                                    ? AppColors.terminalDarkCard
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  side: BorderSide(
                                    color: isDark
                                        ? AppColors.terminalDarkBorder
                                        : AppColors.border(context),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12.r),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        displayKey,
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: isDark
                                              ? Colors.white70
                                              : AppColors.textSecondary(
                                                  context,
                                                ),
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        val.toString(),
                                        style: AppTextStyles.titleLarge
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primary,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              // Tab 2: Medicine Inventory & Stock Management
              Padding(
                padding: EdgeInsets.all(20.r),
                child: Column(
                  children: [
                    TextField(
                      onChanged: (val) => setState(() => _searchQuery = val),
                      style: TextStyle(
                        color: isDark
                            ? Colors.white
                            : AppColors.textPrimary(context),
                      ),
                      decoration: InputDecoration(
                        hintText: "Search medicine by name or category...",
                        hintStyle: TextStyle(
                          color: isDark
                              ? Colors.white54
                              : AppColors.textSecondary(context),
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: isDark
                              ? Colors.white54
                              : AppColors.textSecondary(context),
                        ),
                        filled: true,
                        fillColor: isDark
                            ? AppColors.terminalDarkCard
                            : Colors.white,
                        contentPadding: EdgeInsets.all(12.r),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(
                            color: AppColors.border(context),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Expanded(
                      child: BlocBuilder<AdminPharmacyBloc, AdminPharmacyState>(
                        builder: (context, state) {
                          if (state is AdminPharmacyLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (state is AdminPharmacyError) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    state.message,
                                    style: const TextStyle(
                                      color: AppColors.error,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  ElevatedButton(
                                    onPressed: () => context
                                        .read<AdminPharmacyBloc>()
                                        .add(LoadPharmacyItems()),
                                    child: const Text("Retry"),
                                  ),
                                ],
                              ),
                            );
                          }

                          if (state is AdminPharmacyLoaded) {
                            final filteredItems = state.items.where((item) {
                              final query = _searchQuery.toLowerCase();
                              return item.name.toLowerCase().contains(query) ||
                                  item.category.toLowerCase().contains(query);
                            }).toList();

                            if (filteredItems.isEmpty) {
                              return Center(
                                child: Text(
                                  "No matching medicines found.",
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white54
                                        : AppColors.textSecondary(context),
                                  ),
                                ),
                              );
                            }

                            return ListView.builder(
                              itemCount: filteredItems.length,
                              itemBuilder: (context, idx) {
                                final item = filteredItems[idx];
                                Color badgeColor;
                                switch (item.status) {
                                  case 'In Stock':
                                    badgeColor = AppColors.success;
                                    break;
                                  case 'Low Stock':
                                    badgeColor = AppColors.warning;
                                    break;
                                  default:
                                    badgeColor = AppColors.error;
                                }

                                return Card(
                                  margin: EdgeInsets.only(bottom: 12.h),
                                  elevation: 0,
                                  color: isDark
                                      ? AppColors.terminalDarkCard
                                      : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    side: BorderSide(
                                      color: AppColors.border(context),
                                    ),
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12.r),
                                    onTap: () => _showQuickEditStockDialog(
                                      context,
                                      item,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(16.r),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                            child: item.imageUrl.isNotEmpty
                                                ? Image.network(
                                                    item.imageUrl,
                                                    width: 48.w,
                                                    height: 48.w,
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) => Container(
                                                          width: 48.w,
                                                          height: 48.w,
                                                          color: badgeColor
                                                              .withValues(
                                                                alpha: 0.1,
                                                              ),
                                                          child: Icon(
                                                            Icons
                                                                .medication_outlined,
                                                            color: badgeColor,
                                                          ),
                                                        ),
                                                  )
                                                : Container(
                                                    width: 48.w,
                                                    height: 48.w,
                                                    color: badgeColor
                                                        .withValues(alpha: 0.1),
                                                    child: Icon(
                                                      Icons.medication_outlined,
                                                      color: badgeColor,
                                                    ),
                                                  ),
                                          ),
                                          SizedBox(width: 16.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.name +
                                                      (item.dosage.isNotEmpty
                                                          ? " (${item.dosage})"
                                                          : ""),
                                                  style: AppTextStyles
                                                      .titleMedium
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15.sp,
                                                        color:
                                                            AppColors.textPrimary(
                                                              context,
                                                            ),
                                                      ),
                                                ),
                                                SizedBox(height: 4.h),
                                                Text(
                                                  "Category: ${item.category}",
                                                  style: TextStyle(
                                                    color: isDark
                                                        ? Colors.white70
                                                        : AppColors.textPrimary(
                                                            context,
                                                          ),
                                                  ),
                                                ),
                                                Text(
                                                  "Stock: ${item.stock} units",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: item.stock == 0
                                                        ? AppColors.error
                                                        : (AppColors.textPrimary(
                                                            context,
                                                          )),
                                                  ),
                                                ),
                                                SizedBox(height: 2.h),
                                                Text(
                                                  "Price: ₹${item.sellPrice.toStringAsFixed(2)}",
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color:
                                                        AppColors.textSecondary(
                                                          context,
                                                        ),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8.w,
                                              vertical: 4.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: badgeColor.withValues(
                                                alpha: 0.1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(6.r),
                                            ),
                                            child: Text(
                                              item.status,
                                              style: TextStyle(
                                                color: badgeColor,
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StockEditDialog extends StatefulWidget {
  final PharmacyItemEntity item;
  const _StockEditDialog({required this.item});

  @override
  State<_StockEditDialog> createState() => _StockEditDialogState();
}

class _StockEditDialogState extends State<_StockEditDialog> {
  late int _stock;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _stock = widget.item.stock;
    _controller = TextEditingController(text: _stock.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: isDark ? AppColors.terminalDarkCard : Colors.white,
      title: Text(
        "Quick Edit Stock",
        style: TextStyle(color: AppColors.textPrimary(context)),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Modify stock quantity for ${widget.item.name}.",
            style: TextStyle(
              fontSize: 13.sp,
              color: isDark ? Colors.white70 : AppColors.textSecondary(context),
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.remove_circle_outline,
                  size: 36,
                  color: AppColors.error,
                ),
                onPressed: () {
                  if (_stock > 0) {
                    setState(() {
                      _stock--;
                      _controller.text = _stock.toString();
                    });
                  }
                },
              ),
              SizedBox(width: 16.w),
              SizedBox(
                width: 80.w,
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? Colors.white
                        : AppColors.textPrimary(context),
                  ),
                  onChanged: (val) {
                    final parsed = int.tryParse(val);
                    if (parsed != null && parsed >= 0) {
                      setState(() {
                        _stock = parsed;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.border(context)),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              IconButton(
                icon: const Icon(
                  Icons.add_circle_outline,
                  size: 36,
                  color: AppColors.success,
                ),
                onPressed: () {
                  setState(() {
                    _stock++;
                    _controller.text = _stock.toString();
                  });
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, _stock);
          },
          child: const Text("Update"),
        ),
      ],
    );
  }
}
