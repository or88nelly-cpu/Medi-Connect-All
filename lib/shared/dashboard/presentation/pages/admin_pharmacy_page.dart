import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/widgets/appbar/common_app_bar.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/dashboard/domain/entities/pharmacy_item_entity.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_pharmacy_bloc.dart';

class AdminPharmacyPage extends StatefulWidget {
  const AdminPharmacyPage({super.key});

  @override
  State<AdminPharmacyPage> createState() => _AdminPharmacyPageState();
}

class _AdminPharmacyPageState extends State<AdminPharmacyPage> {
  @override
  void initState() {
    super.initState();
    context.read<AdminPharmacyBloc>().add(LoadPharmacyItems());
  }

  void _showAddMedicineDialog() {
    final nameController = TextEditingController();
    final categoryController = TextEditingController();
    final stockController = TextEditingController();
    final buyPriceController = TextEditingController(text: '0.00');
    final sellPriceController = TextEditingController(text: '0.00');
    final dosageController = TextEditingController();
    final imageUrlController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Add New Medicine"),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Medicine Name",
                      hintText: "e.g., Paracetamol 500mg",
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? "Required field"
                        : null,
                  ),
                  SizedBox(height: 12.h),
                  TextFormField(
                    controller: categoryController,
                    decoration: const InputDecoration(
                      labelText: "Category",
                      hintText: "e.g., Analgesic, Antibiotic",
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? "Required field"
                        : null,
                  ),
                  SizedBox(height: 12.h),
                  TextFormField(
                    controller: dosageController,
                    decoration: const InputDecoration(
                      labelText: "Dosage (e.g. 500mg)",
                      hintText: "e.g., 500mg",
                    ),
                  ),
                  SizedBox(height: 12.h),
                  TextFormField(
                    controller: imageUrlController,
                    decoration: const InputDecoration(
                      labelText: "Image URL",
                      hintText: "e.g., https://unsplash.com/...",
                    ),
                  ),
                  SizedBox(height: 12.h),
                  TextFormField(
                    controller: stockController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Initial Stock",
                      hintText: "e.g., 100",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required field";
                      }
                      if (int.tryParse(value) == null) {
                        return "Must be a number";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12.h),
                  TextFormField(
                    controller: buyPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Buy Price (₹)",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required field";
                      }
                      if (double.tryParse(value) == null) {
                        return "Must be a number";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12.h),
                  TextFormField(
                    controller: sellPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Sell Price (₹)",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required field";
                      }
                      if (double.tryParse(value) == null) {
                        return "Must be a number";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  context.read<AdminPharmacyBloc>().add(
                    AddPharmacyItem({
                      'name': nameController.text.trim(),
                      'category': categoryController.text.trim(),
                      'stock': int.parse(stockController.text),
                      'buy_price': double.parse(buyPriceController.text),
                      'sell_price': double.parse(sellPriceController.text),
                      'dosage': dosageController.text.trim(),
                      'image_url': imageUrlController.text.trim(),
                    }),
                  );
                  Navigator.pop(ctx);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _showEditMedicineDialog(PharmacyItemEntity item) {
    final stockController = TextEditingController(text: item.stock.toString());
    final buyPriceController = TextEditingController(
      text: item.buyPrice.toStringAsFixed(2),
    );
    final sellPriceController = TextEditingController(
      text: item.sellPrice.toStringAsFixed(2),
    );
    final dosageController = TextEditingController(text: item.dosage);
    final imageUrlController = TextEditingController(text: item.imageUrl);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Edit ${item.name}"),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: stockController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Current Stock Level",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required field";
                      }
                      if (int.tryParse(value) == null) {
                        return "Must be a number";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12.h),
                  TextFormField(
                    controller: dosageController,
                    decoration: const InputDecoration(
                      labelText: "Dosage (e.g., 500mg)",
                    ),
                  ),
                  SizedBox(height: 12.h),
                  TextFormField(
                    controller: imageUrlController,
                    decoration: const InputDecoration(labelText: "Image URL"),
                  ),
                  SizedBox(height: 12.h),
                  TextFormField(
                    controller: buyPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Buy Price (₹)",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required field";
                      }
                      if (double.tryParse(value) == null) {
                        return "Must be a number";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12.h),
                  TextFormField(
                    controller: sellPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Sell Price (₹)",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required field";
                      }
                      if (double.tryParse(value) == null) {
                        return "Must be a number";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  context.read<AdminPharmacyBloc>().add(
                    EditPharmacyItem(item.id, {
                      'stock': int.parse(stockController.text),
                      'buy_price': double.parse(buyPriceController.text),
                      'sell_price': double.parse(sellPriceController.text),
                      'dosage': dosageController.text.trim(),
                      'image_url': imageUrlController.text.trim(),
                    }),
                  );
                  Navigator.pop(ctx);
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      customAppbar: CommonAppBar(
        title: "Pharmacy Inventory",
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primary),
            onPressed: _showAddMedicineDialog,
          ),
        ],
      ),
      body: BlocBuilder<AdminPharmacyBloc, AdminPharmacyState>(
        builder: (context, state) {
          if (state is AdminPharmacyLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AdminPharmacyError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: const TextStyle(color: AppColors.error),
                  ),
                  SizedBox(height: 12.h),
                  ElevatedButton(
                    onPressed: () => context.read<AdminPharmacyBloc>().add(
                      LoadPharmacyItems(),
                    ),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          if (state is AdminPharmacyLoaded) {
            final items = state.items;
            if (items.isEmpty) {
              return const Center(child: Text("No items found."));
            }

            return ListView.builder(
              padding: EdgeInsets.all(20.r),
              itemCount: items.length,
              itemBuilder: (context, idx) {
                final item = items[idx];
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    side: BorderSide(color: AppColors.border(context)),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12.r),
                    onTap: () => _showEditMedicineDialog(item),
                    child: Padding(
                      padding: EdgeInsets.all(16.r),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: item.imageUrl.isNotEmpty
                                ? Image.network(
                                    item.imageUrl,
                                    width: 48.w,
                                    height: 48.w,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              width: 48.w,
                                              height: 48.w,
                                              color: badgeColor.withValues(
                                                alpha: 0.1,
                                              ),
                                              child: Icon(
                                                Icons.medication_outlined,
                                                color: badgeColor,
                                              ),
                                            ),
                                  )
                                : Container(
                                    width: 48.w,
                                    height: 48.w,
                                    color: badgeColor.withValues(alpha: 0.1),
                                    child: Icon(
                                      Icons.medication_outlined,
                                      color: badgeColor,
                                    ),
                                  ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name +
                                      (item.dosage.isNotEmpty
                                          ? " (${item.dosage})"
                                          : ""),
                                  style: AppTextStyles.titleMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.sp,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text("Category: ${item.category}"),
                                Text("Current Stock: ${item.stock} units"),
                                SizedBox(height: 2.h),
                                Text(
                                  "Buy: ₹${item.buyPrice.toStringAsFixed(2)}  ·  Sell: ₹${item.sellPrice.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.textSecondary(context),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: badgeColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6.r),
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
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: AppColors.error,
                                  size: 18,
                                ),
                                onPressed: () {
                                  context.read<AdminPharmacyBloc>().add(
                                    DeletePharmacyItem(item.id),
                                  );
                                },
                              ),
                            ],
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
    );
  }
}
