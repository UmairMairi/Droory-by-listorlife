import 'package:flutter/material.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/string_helper.dart';
import '../../../../models/category_model.dart';

class CarModelSelectionScreen extends StatefulWidget {
  final List<CategoryModel> models;
  final CategoryModel? selectedModel; // For single-select mode
  final List<CategoryModel>? selectedModels; // For multi-select mode
  final String title;
  final String? brandName;
  final bool isMultiSelect; // New parameter to determine mode
  final bool showIcon; // Add this new parameter

  const CarModelSelectionScreen({
    Key? key,
    required this.models,
    this.selectedModel,
    this.selectedModels,
    this.title = "Select Model",
    this.brandName,
    this.isMultiSelect = false, // Default to single-select
    this.showIcon = true, // Default to showing icon
  }) : super(key: key);

  @override
  State<CarModelSelectionScreen> createState() =>
      _CarModelSelectionScreenState();
}

class _CarModelSelectionScreenState extends State<CarModelSelectionScreen> {
  late TextEditingController _searchController;
  late List<CategoryModel> _filteredModels;

  // For single-select mode
  CategoryModel? _selectedModel;

  // For multi-select mode
  late List<CategoryModel> _selectedModels;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredModels = List.from(widget.models);

    if (widget.isMultiSelect) {
      // Multi-select mode initialization
      _selectedModels = widget.selectedModels != null
          ? List.from(widget.selectedModels!)
          : [];
    } else {
      // Single-select mode initialization
      _selectedModel = widget.selectedModel;
    }

    _searchController.addListener(_filterModels);
  }

  void _filterModels() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredModels = List.from(widget.models);
      } else {
        _filteredModels = widget.models.where((model) {
          final modelName = model.name?.toLowerCase() ?? '';
          return modelName.contains(query);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildModelItem(CategoryModel model) {
    if (widget.isMultiSelect) {
      // Multi-select mode - show checkboxes
      final isSelected = _selectedModels.any((m) => m.id == model.id);

      return GestureDetector(
        onTap: () {
          setState(() {
            if (isSelected) {
              _selectedModels.removeWhere((m) => m.id == model.id);
            } else {
              _selectedModels.add(model);
            }
          });
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black.withOpacity(0.05) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.black : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.08),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Checkbox
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.grey.shade400,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      )
                    : null,
              ),
              const SizedBox(width: 16),

              // Model Icon (only show if showIcon is true)
              if (widget.showIcon) ...[
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Icon(
                    Icons.directions_car_outlined,
                    color: isSelected ? Colors.black : Colors.grey.shade600,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
              ],

              // Model Name
              Expanded(
                child: Text(
                  model.name ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.black : Colors.grey.shade800,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Single-select mode - show radio buttons (original behavior)
      final isSelected = _selectedModel?.id == model.id;

      return GestureDetector(
        onTap: () {
          setState(() {
            _selectedModel = model;
          });
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black.withOpacity(0.05) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.black : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.08),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Model Icon (only show if showIcon is true)
              if (widget.showIcon) ...[
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Icon(
                    Icons.directions_car_outlined,
                    color: isSelected ? Colors.black : Colors.grey.shade600,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
              ],

              // Model Name
              Expanded(
                child: Text(
                  model.name ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.black : Colors.grey.shade800,
                  ),
                ),
              ),

              // Selection indicator for single-select
              if (isSelected)
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
            ],
          ),
        ),
      );
    }
  }

  void _clearAllSelections() {
    setState(() {
      if (widget.isMultiSelect) {
        _selectedModels.clear();
      } else {
        _selectedModel = null;
      }
    });
  }

  void _handleApply() {
    if (widget.isMultiSelect) {
      // Return the list of selected models
      Navigator.pop(context, _selectedModels);
    } else {
      // Return the single selected model
      Navigator.pop(context, _selectedModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasSelections = widget.isMultiSelect
        ? _selectedModels.isNotEmpty
        : _selectedModel != null;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (widget.brandName != null)
              Text(
                widget.brandName!,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
          ],
        ),
        actions: [
          // Clear All button for multi-select mode
          if (widget.isMultiSelect && hasSelections)
            TextButton(
              onPressed: _clearAllSelections,
              child: Text(
                StringHelper.clearAll ?? "Clear All",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: StringHelper.search ?? "Search models...",
                hintStyle: TextStyle(color: Colors.grey.shade500),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey.shade600),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.black),
                ),
              ),
            ),
          ),

          // Selection count for multi-select mode
          if (widget.isMultiSelect)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    "${_selectedModels.length} ${StringHelper.selectModel ?? "models selected"}",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          // Models List
          Expanded(
            child: _filteredModels.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No models found",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Try searching with different keywords",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _filteredModels.length,
                    itemBuilder: (context, index) {
                      return _buildModelItem(_filteredModels[index]);
                    },
                  ),
          ),
        ],
      ),

      // Bottom Action Button
      bottomNavigationBar: hasSelections
          ? Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: SafeArea(
                child: ElevatedButton(
                  onPressed: _handleApply,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    widget.isMultiSelect
                        ? "${StringHelper.apply ?? "Apply"} (${_selectedModels.length})"
                        : "${StringHelper.select ?? "Select"} ${_selectedModel?.name}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
