import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:list_and_life/view_model/car_brand_selection.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/string_helper.dart';
import 'package:list_and_life/base/utils/utils.dart';
import 'package:list_and_life/widgets/app_text_field.dart';
import 'package:list_and_life/widgets/multi_select_category.dart';
import 'package:list_and_life/widgets/phone_form_verification_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:list_and_life/widgets/sell_form_location_screen.dart';
import '../../../../base/helpers/dialog_helper.dart';
import '../../../../base/helpers/image_picker_helper.dart';
import '../../../../models/category_model.dart';
import '../../../../models/product_detail_model.dart';
import '../../../../res/assets_res.dart';
import '../../../../view_model/sell_forms_vm.dart';
import '../../../../widgets/app_map_widget.dart';
import '../../../../widgets/common_dropdown.dart';
import '../../../../widgets/image_view.dart';

class JobSellForm extends BaseView<SellFormsVM> {
  final String? type;
  final CategoryModel? category;
  final CategoryModel? subCategory;
  final CategoryModel? subSubCategory;
  final List<CategoryModel>? brands;
  final ProductDetailModel? item;

  const JobSellForm({
    required this.type,
    required this.category,
    required this.subCategory,
    this.subSubCategory,
    this.item,
    required this.brands,
    super.key,
  });

  @override
  Widget build(BuildContext context, SellFormsVM viewModel) {
    if (item != null && !viewModel.hasInitializedForEdit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.updateTextFieldsItems(item: item);
        viewModel.hasInitializedForEdit = true;
      });
    }

    // Submit form method - moved inside build to access viewModel and context
    void submitForm() {
      // Check phone verification first
      if (!viewModel.isPhoneVerified ||
          viewModel.currentPhone == null ||
          viewModel.currentPhone!.isEmpty) {
        DialogHelper.showToast(message: StringHelper.phoneRequired);
        return;
      }

      // Validate the form
      if (viewModel.formKey.currentState?.validate() != true) {
        return;
      }

      // Additional validations specific to Job form
      // Check if at least one salary field is filled - this is now handled by FormField validation
      // No need for additional check here since FormField will catch it

      if (viewModel.adTitleTextController.text.trim().isEmpty) {
        DialogHelper.showToast(message: StringHelper.adTitleIsRequired);
        return;
      }
      if (viewModel.adTitleTextController.text.trim().length < 10) {
        DialogHelper.showToast(message: StringHelper.adLength);
        return;
      }
      if (viewModel.descriptionTextController.text.trim().isEmpty) {
        DialogHelper.showToast(message: StringHelper.descriptionIsRequired);
        return;
      }
      if (viewModel.addressTextController.text.trim().isEmpty) {
        DialogHelper.showToast(message: StringHelper.locationIsRequired);
        return;
      }

      // Show loading
      DialogHelper.showLoading();

      // Call appropriate method based on whether it's edit or add
      if (viewModel.isEditProduct) {
        viewModel.editProduct(
          productId: item?.id,
          category: category,
          subCategory: subCategory,
          subSubCategory: subSubCategory,
          brand: viewModel.selectedBrand,
          models: viewModel.selectedModel,
          onSuccess: () {
            Navigator.pop(context);
          },
        );
      } else {
        viewModel.addProduct(
          category: category,
          subCategory: subCategory,
          subSubCategory: subSubCategory,
          brand: viewModel.selectedBrand,
          models: viewModel.selectedModel,
        );
      }
    }

    return Form(
      key: viewModel.formKey,
      child: SingleChildScrollView(
        // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Type Radio Buttons
            FormField<String?>(
              initialValue: viewModel.lookingForController.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return StringHelper.pleaseSelectUserType;
                }
                return null;
              },
              builder: (field) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          StringHelper.usertype,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          '*',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _buildUserTypeOption(
                          context: context,
                          title: StringHelper.lookingJob,
                          icon: Icons.work_outline,
                          isSelected: viewModel.lookingForController.text ==
                              "I am looking job",
                          onTap: () {
                            field.didChange("I am looking job");
                            field.validate();
                            viewModel.lookingForController.text =
                                "I am looking job";
                            viewModel.notifyListeners();
                          },
                        ),
                        _buildUserTypeOption(
                          context: context,
                          title: StringHelper.hiringJob,
                          icon: Icons.business_center_outlined,
                          isSelected: viewModel.lookingForController.text ==
                              "I am hiring",
                          onTap: () {
                            field.didChange("I am hiring");
                            field.validate();
                            viewModel.lookingForController.text = "I am hiring";
                            viewModel.notifyListeners();
                          },
                        ),
                      ],
                    ),
                    if (field.hasError)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          field.errorText!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),

            // Specialty Dropdown (if available)
            if (brands?.isNotEmpty ?? false) ...[
              FormField<CategoryModel?>(
                initialValue: viewModel.selectedBrand,
                validator: (value) {
                  if (value == null) {
                    return StringHelper.pleaseSelectSpecialty;
                  }
                  return null;
                },
                builder: (field) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Custom Specialty Selection Field
                      GestureDetector(
                        onTap: () async {
                          final CategoryModel? selectedBrand =
                              await Navigator.push<CategoryModel>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CarBrandSelectionScreen(
                                brands: brands ?? [],
                                selectedBrand: viewModel.selectedBrand,
                                title: StringHelper.specialty ??
                                    "Select Specialty",
                                showIcon: false,
                              ),
                            ),
                          );

                          if (selectedBrand != null) {
                            field.didChange(selectedBrand);
                            field.validate();
                            viewModel.getModels(brandId: selectedBrand.id);
                            viewModel.selectedBrand = selectedBrand;
                            viewModel.brandTextController.text =
                                selectedBrand.name ?? '';
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: field.hasError
                                  ? Colors.red
                                  : Colors.grey.shade300,
                              width: field.hasError ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    StringHelper.specialty,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    '*',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  // Specialty Name or Placeholder
                                  Expanded(
                                    child: Text(
                                      viewModel.selectedBrand?.name ??
                                          StringHelper.select,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight:
                                            viewModel.selectedBrand != null
                                                ? FontWeight.w500
                                                : FontWeight.w400,
                                        color: viewModel.selectedBrand != null
                                            ? Colors.black
                                            : Colors.grey.shade500,
                                      ),
                                    ),
                                  ),

                                  // Dropdown Arrow
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.grey.shade600,
                                    size: 24,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Error Text
                      if (field.hasError)
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 8),
                          child: Text(
                            field.errorText!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
            ],

            // Position Type with Radio Buttons
            FormField<String?>(
              initialValue: viewModel.jobPositionTextController.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return StringHelper.pleaseSelectPositionType;
                }
                return null;
              },
              builder: (field) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          StringHelper.positionType,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          '*',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _buildSelectionOption(
                          context: context,
                          title: StringHelper.contract, // Will show "Freelance"
                          icon: Icons.description_outlined,
                          value: "Freelance", // ✅ Changed from "Contract"
                          isSelected:
                              viewModel.jobPositionTextController.text ==
                                  "Freelance",
                          onTap: () {
                            field.didChange(
                                "Freelance"); // ✅ Changed from "Contract"
                            field.validate();
                            viewModel.jobPositionTextController.text =
                                "Freelance"; // ✅ Changed
                            viewModel.notifyListeners();
                          },
                        ),
                        _buildSelectionOption(
                          context: context,
                          title: StringHelper.fullTime,
                          icon: Icons.schedule,
                          value: "Full Time",
                          isSelected:
                              viewModel.jobPositionTextController.text ==
                                  "Full Time",
                          onTap: () {
                            field.didChange("Full Time");
                            field.validate();
                            viewModel.jobPositionTextController.text =
                                "Full Time";
                            viewModel.notifyListeners();
                          },
                        ),
                        _buildSelectionOption(
                          context: context,
                          title: StringHelper.partTime,
                          icon: Icons.timelapse,
                          value: "Part time",
                          isSelected:
                              viewModel.jobPositionTextController.text ==
                                  "Part time",
                          onTap: () {
                            field.didChange("Part time");
                            field.validate();
                            viewModel.jobPositionTextController.text =
                                "Part time";
                            viewModel.notifyListeners();
                          },
                        ),
                        _buildSelectionOption(
                          context: context,
                          title:
                              StringHelper.temporary, // Will show "Internship"
                          icon: Icons.access_time,
                          value: "Internship", // ✅ Changed from "Temporary"
                          isSelected:
                              viewModel.jobPositionTextController.text ==
                                  "Internship",
                          onTap: () {
                            field.didChange(
                                "Internship"); // ✅ Changed from "Temporary"
                            field.validate();
                            viewModel.jobPositionTextController.text =
                                "Internship"; // ✅ Changed
                            viewModel.notifyListeners();
                          },
                        ),
                      ],
                    ),
                    if (field.hasError)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          field.errorText!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),

            // Work Setting with Icons
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  StringHelper.workSetting,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildSelectionOption(
                      context: context,
                      title: StringHelper.remote,
                      icon: Icons.home_work_outlined,
                      value: "Remote",
                      isSelected: viewModel.workSettingTextController.text == "Remote",
                      onTap: () {
                        viewModel.workSettingTextController.text = "Remote";
                        viewModel.notifyListeners();
                      },
                    ),
                    _buildSelectionOption(
                      context: context,
                      title: StringHelper.officeBased,
                      icon: Icons.business_outlined,
                      value: "Office-based",
                      isSelected: viewModel.workSettingTextController.text ==
                          "Office-based",
                      onTap: () {
                        viewModel.workSettingTextController.text =
                            "Office-based";
                        viewModel.notifyListeners();
                      },
                    ),
                    _buildSelectionOption(
                      context: context,
                      title: StringHelper.mixOfficeBased,
                      icon: Icons.sync_alt,
                      value: "Mixed (Home & Office)",
                      isSelected: viewModel.workSettingTextController.text ==
                          "Mixed (Home & Office)",
                      onTap: () {
                        viewModel.workSettingTextController.text =
                            "Mixed (Home & Office)";
                        viewModel.notifyListeners();
                      },
                    ),
                    _buildSelectionOption(
                      context: context,
                      title: StringHelper.fieldBased,
                      icon: Icons.explore_outlined,
                      value: "Field-based",
                      isSelected: viewModel.workSettingTextController.text ==
                          "Field-based",
                      onTap: () {
                        viewModel.workSettingTextController.text =
                            "Field-based";
                        viewModel.notifyListeners();
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Work Experience Selection
            FormField<String?>(
              initialValue: viewModel.workExperienceTextController.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return StringHelper.pleaseSelectWorkExperience;
                }
                return null;
              },
              builder: (field) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          StringHelper.workExperience,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          '*',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _buildSelectionOption(
                          context: context,
                          title: StringHelper.noExperience,
                          value: Utils.setCommon(StringHelper.noExperience),
                          isSelected:
                              viewModel.workExperienceTextController.text ==
                                  Utils.setCommon(StringHelper.noExperience),
                          onTap: () {
                            field.didChange(
                                Utils.setCommon(StringHelper.noExperience));
                            field.validate();
                            viewModel.workExperienceTextController.text =
                                Utils.setCommon(StringHelper.noExperience);
                            viewModel.notifyListeners();
                          },
                          fontSize: 12,
                          useEllipsis: true,
                        ),
                        _buildSelectionOption(
                          context: context,
                          title: StringHelper.oneToThreeYears,
                          value: Utils.setCommon(StringHelper.oneToThreeYears),
                          isSelected:
                              viewModel.workExperienceTextController.text ==
                                  Utils.setCommon(StringHelper.oneToThreeYears),
                          onTap: () {
                            field.didChange(
                                Utils.setCommon(StringHelper.oneToThreeYears));
                            field.validate();
                            viewModel.workExperienceTextController.text =
                                Utils.setCommon(StringHelper.oneToThreeYears);
                            viewModel.notifyListeners();
                          },
                        ),
                        _buildSelectionOption(
                          context: context,
                          title: StringHelper.threeToFiveYears,
                          value: Utils.setCommon(StringHelper.threeToFiveYears),
                          isSelected: viewModel
                                  .workExperienceTextController.text ==
                              Utils.setCommon(StringHelper.threeToFiveYears),
                          onTap: () {
                            field.didChange(
                                Utils.setCommon(StringHelper.threeToFiveYears));
                            field.validate();
                            viewModel.workExperienceTextController.text =
                                Utils.setCommon(StringHelper.threeToFiveYears);
                            viewModel.notifyListeners();
                          },
                        ),
                        _buildSelectionOption(
                          context: context,
                          title: StringHelper.fiveToTenYears,
                          value: Utils.setCommon(StringHelper.fiveToTenYears),
                          isSelected:
                              viewModel.workExperienceTextController.text ==
                                  Utils.setCommon(StringHelper.fiveToTenYears),
                          onTap: () {
                            field.didChange(
                                Utils.setCommon(StringHelper.fiveToTenYears));
                            field.validate();
                            viewModel.workExperienceTextController.text =
                                Utils.setCommon(StringHelper.fiveToTenYears);
                            viewModel.notifyListeners();
                          },
                        ),
                        _buildSelectionOption(
                          context: context,
                          title: StringHelper.tenPlusYears,
                          value: Utils.setCommon(StringHelper.tenPlusYears),
                          isSelected:
                              viewModel.workExperienceTextController.text ==
                                  Utils.setCommon(StringHelper.tenPlusYears),
                          onTap: () {
                            field.didChange(
                                Utils.setCommon(StringHelper.tenPlusYears));
                            field.validate();
                            viewModel.workExperienceTextController.text =
                                Utils.setCommon(StringHelper.tenPlusYears);
                            viewModel.notifyListeners();
                          },
                        ),
                      ],
                    ),
                    if (field.hasError)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          field.errorText!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),

            // Work Education Selection
            FormField<String?>(
              initialValue: viewModel.workEducationTextController.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return StringHelper.pleaseSelectWorkEducation;
                }
                return null;
              },
              builder: (field) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          StringHelper.workEducation,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          '*',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _buildSelectionOption(
                          context: context,
                          title: StringHelper.noEducation,
                          icon: Icons.not_interested,
                          value: Utils.setCommon(StringHelper.noEducation),
                          isSelected:
                              viewModel.workEducationTextController.text ==
                                  Utils.setCommon(StringHelper.noEducation),
                          onTap: () {
                            field.didChange(
                                Utils.setCommon(StringHelper.noEducation));
                            field.validate();
                            viewModel.workEducationTextController.text =
                                Utils.setCommon(StringHelper.noEducation);
                            viewModel.notifyListeners();
                          },
                        ),
                        _buildSelectionOption(
                          context: context,
                          title: StringHelper.student,
                          icon: Icons.person_outline,
                          value: Utils.setCommon(StringHelper.student),
                          isSelected:
                              viewModel.workEducationTextController.text ==
                                  Utils.setCommon(StringHelper.student),
                          onTap: () {
                            field.didChange(
                                Utils.setCommon(StringHelper.student));
                            field.validate();
                            viewModel.workEducationTextController.text =
                                Utils.setCommon(StringHelper.student);
                            viewModel.notifyListeners();
                          },
                        ),
                        _buildSelectionOption(
                          context: context,
                          title: StringHelper.highSchool,
                          icon: Icons.school_outlined,
                          value: Utils.setCommon(StringHelper.highSchool),
                          isSelected:
                              viewModel.workEducationTextController.text ==
                                  Utils.setCommon(StringHelper.highSchool),
                          onTap: () {
                            field.didChange(
                                Utils.setCommon(StringHelper.highSchool));
                            field.validate();
                            viewModel.workEducationTextController.text =
                                Utils.setCommon(StringHelper.highSchool);
                            viewModel.notifyListeners();
                          },
                        ),
                        _buildSelectionOption(
                          context: context,
                          title: StringHelper.diploma,
                          icon: Icons.card_membership,
                          value: Utils.setCommon(StringHelper.diploma),
                          isSelected:
                              viewModel.workEducationTextController.text ==
                                  Utils.setCommon(StringHelper.diploma),
                          onTap: () {
                            field.didChange(
                                Utils.setCommon(StringHelper.diploma));
                            field.validate();
                            viewModel.workEducationTextController.text =
                                Utils.setCommon(StringHelper.diploma);
                            viewModel.notifyListeners();
                          },
                        ),
                        _buildSelectionOption(
                          context: context,
                          title: StringHelper.bDegree,
                          icon: Icons.school,
                          value: Utils.setCommon(StringHelper.bDegree),
                          isSelected:
                              viewModel.workEducationTextController.text ==
                                  Utils.setCommon(StringHelper.bDegree),
                          onTap: () {
                            field.didChange(
                                Utils.setCommon(StringHelper.bDegree));
                            field.validate();
                            viewModel.workEducationTextController.text =
                                Utils.setCommon(StringHelper.bDegree);
                            viewModel.notifyListeners();
                          },
                        ),
                        _buildSelectionOption(
                          context: context,
                          title: StringHelper.mDegree,
                          icon: Icons.account_balance,
                          value: Utils.setCommon(StringHelper.mDegree),
                          isSelected:
                              viewModel.workEducationTextController.text ==
                                  Utils.setCommon(StringHelper.mDegree),
                          onTap: () {
                            field.didChange(
                                Utils.setCommon(StringHelper.mDegree));
                            field.validate();
                            viewModel.workEducationTextController.text =
                                Utils.setCommon(StringHelper.mDegree);
                            viewModel.notifyListeners();
                          },
                        ),
                        _buildSelectionOption(
                          context: context,
                          title: StringHelper.phd,
                          icon: Icons.workspace_premium,
                          value: Utils.setCommon(StringHelper.phd),
                          isSelected:
                              viewModel.workEducationTextController.text ==
                                  Utils.setCommon(StringHelper.phd),
                          onTap: () {
                            field.didChange(Utils.setCommon(StringHelper.phd));
                            field.validate();
                            viewModel.workEducationTextController.text =
                                Utils.setCommon(StringHelper.phd);
                            viewModel.notifyListeners();
                          },
                        ),
                      ],
                    ),
                    if (field.hasError)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          field.errorText!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),

            // Salary Period Dropdown
            CommonDropdown(
              title: StringHelper.salaryPeriod,
              titleColor: Colors.black,
              hint: viewModel.jobSalaryTextController.text,
              onSelected: (String? value) {
                viewModel.jobSalaryTextController.text = value ?? "";
              },
              options: [
                StringHelper.hourly,
                StringHelper.weekly,
                StringHelper.monthly,
                StringHelper.yearly
              ],
            ),
            const SizedBox(height: 20),

            // Updated Salary Range Fields - At least one required
            FormField<bool>(
              validator: (value) {
                bool hasSalaryFrom =
                    viewModel.jobSalaryFromController.text.trim().isNotEmpty;
                bool hasSalaryTo =
                    viewModel.jobSalaryToController.text.trim().isNotEmpty;

                if (!hasSalaryFrom && !hasSalaryTo) {
                  return StringHelper.pleaseEnterAtLeastOneSalary;
                }
                return null;
              },
              builder: (field) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            title: StringHelper.salaryFrom,
                            titleColor: Colors.black,
                            hint: StringHelper.enter,
                            controller: viewModel.jobSalaryFromController,
                            keyboardType: TextInputType.number,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(7),
                              FilteringTextInputFormatter.deny(
                                  RegExp(viewModel.regexToRemoveEmoji)),
                            ],
                            onChanged: (value) {
                              // Trigger validation when field changes
                              field.didChange(true);
                              field.validate();
                            },
                            // Completely disable individual validation
                            validator: (_) => null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppTextField(
                            title: StringHelper.salaryTo,
                            titleColor: Colors.black,
                            hint: StringHelper.enter,
                            controller: viewModel.jobSalaryToController,
                            keyboardType: TextInputType.number,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(8),
                              FilteringTextInputFormatter.deny(
                                  RegExp(viewModel.regexToRemoveEmoji)),
                            ],
                            onChanged: (value) {
                              // Trigger validation when field changes
                              field.didChange(true);
                              field.validate();
                            },
                            // Completely disable individual validation
                            validator: (_) => null,
                          ),
                        ),
                      ],
                    ),
                    if (field.hasError)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          field.errorText!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),

            // Ad Title Field
            AppTextField(
              title: "${StringHelper.adTitle} *",
              titleColor: Colors.black,
              hint: StringHelper.enter,
              controller: viewModel.adTitleTextController,
              minLines: 1,
              maxLines: 4,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.deny(
                    RegExp(viewModel.regexToRemoveEmoji)),
                LengthLimitingTextInputFormatter(65),
              ],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return StringHelper.adTitleIsRequired;
                }
                if (value.trim().length < 10) {
                  return StringHelper.adLength;
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Description Field
            AppTextField(
              title: "${StringHelper.describeWhatYouAreSelling} *",
              titleColor: Colors.black,
              hint: StringHelper.enter,
              controller: viewModel.descriptionTextController,
              maxLines: 4,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.deny(
                    RegExp(viewModel.regexToRemoveEmoji)),
              ],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return StringHelper.descriptionIsRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Location Field
            AppTextField(
              title: "${StringHelper.location} *",
              titleColor: Colors.black,
              hint: StringHelper.select,
              readOnly: true,
              controller: viewModel.addressTextController,
              suffix: Icon(Icons.location_on, color: Colors.grey.shade600),
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              onTap: () async {
                Map<String, dynamic>? returnedLocationData =
                    await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SellFormLocationScreen(viewModel: viewModel)),
                );

                if (returnedLocationData != null &&
                    returnedLocationData.isNotEmpty) {
                  viewModel
                      .handleLocationSelectedFromAdForm(returnedLocationData);
                }
              },
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return StringHelper.locationIsRequired;
                }
                return null;
              },
              inputFormatters: [
                FilteringTextInputFormatter.deny(
                    RegExp(viewModel.regexToRemoveEmoji)),
              ],
              maxLines: 2,
            ),
            const SizedBox(height: 20),

            // Phone Verification Widget
            PhoneVerificationWidget(
              onPhoneStatusChanged: (isVerified, phone) {
                viewModel.updatePhoneVerificationStatus(isVerified, phone);
              },
              onAutoSubmit: () {
                submitForm();
              },
            ),
            const SizedBox(height: 20),

            // How to Connect Section
            Text(
              StringHelper.howToConnect,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            MultiSelectCategory(
              choiceString: viewModel.communicationChoice,
              onSelectedCommunicationChoice: (CommunicationChoice value) {
                viewModel.communicationChoice = value.name;
              },
            ),
            const SizedBox(height: 24),

            // Submit Button
            GestureDetector(
              onTap: submitForm,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black,
                      Colors.black.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  viewModel.isEditProduct
                      ? (viewModel.adStatus == "deactivate"
                          ? StringHelper.updateRepublish
                          : StringHelper.updateNow)
                      : StringHelper.postNow,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Helper method to build user type option
  Widget _buildUserTypeOption({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: (context.width - 52) / 2, // Adjust for padding and spacing
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: isSelected ? Colors.black.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.black : Colors.grey.shade300,
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.black : Colors.grey.shade700,
                size: 20,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.black : Colors.grey.shade800,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Generic helper method for selection options
  Widget _buildSelectionOption({
    required BuildContext context,
    required String title,
    required String value,
    required bool isSelected,
    required VoidCallback onTap,
    IconData? icon,
    double? fontSize,
    bool useEllipsis = false,
  }) {
    return SizedBox(
      width: (context.width - 52) / 2,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: isSelected ? Colors.black.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.black : Colors.grey.shade300,
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: isSelected ? Colors.black : Colors.grey.shade700,
                  size: 20,
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  title, // Display the localized title
                  style: TextStyle(
                    fontSize: fontSize ?? 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.black : Colors.grey.shade800,
                  ),
                  overflow: useEllipsis
                      ? TextOverflow.ellipsis
                      : TextOverflow.ellipsis,
                  textAlign: icon == null ? TextAlign.center : TextAlign.start,
                ),
              ),
              if (icon == null) const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}
