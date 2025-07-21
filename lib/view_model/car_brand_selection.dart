import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/string_helper.dart';
import '../../../../models/category_model.dart';
import '../../../../widgets/app_text_field.dart';

class CarBrandSelectionScreen extends StatefulWidget {
  final List<CategoryModel> brands;
  final CategoryModel? selectedBrand;
  final String title;
  final bool showIcon;

  const CarBrandSelectionScreen({
    Key? key,
    required this.brands,
    this.selectedBrand,
    this.title = "Select Brand",
    this.showIcon = false,
  }) : super(key: key);

  @override
  State<CarBrandSelectionScreen> createState() =>
      _CarBrandSelectionScreenState();
}

class _CarBrandSelectionScreenState extends State<CarBrandSelectionScreen> {
  late TextEditingController _searchController;
  late List<CategoryModel> _filteredBrands;
  CategoryModel? _selectedBrand;

  // Bilingual brand mapping for search
  final Map<String, String> _brandMapping = {
    // Arabic to English
    'ألفا روميو': 'Alfa Romeo',
    'أستون مارتن': 'Aston Martin',
    'أودي': 'Audi',
    'أفاتار': 'Avatr',
    'بي إم دبليو': 'BMW',
    'بي واي دي': 'BYD',
    'بايك': 'Baic',
    'بنتلي': 'Bentley',
    'بيستون': 'Bestune',
    'بريليانس': 'Brilliance',
    'بوغاتي': 'Bugatti',
    'بيوك': 'Buick',
    'كاديلاك': 'Cadillac',
    'شانا': 'Chana',
    'شانجان': 'Changan',
    'شانغي': 'Changhe',
    'شيري': 'Chery',
    'شيفروليه': 'Chevrolet',
    'كرايسلر': 'Chrysler',
    'ستروين': 'Citroen',
    'كوبرا': 'Cupra',
    'دي إف إس كي': 'DFSK',
    'دايو': 'Daewoo',
    'دايهاتسو': 'Daihatsu',
    'دودج': 'Dodge',
    'فاو': 'Faw',
    'فيراري': 'Ferrari',
    'فيات': 'Fiat',
    'فورد': 'Ford',
    'جي إيه سي': 'GAC',
    'جي إم سي': 'GMC',
    'جيلي': 'Geely',
    'جريت وول': 'Great Wall',
    'هافال': 'Haval',
    'هوندا': 'Honda',
    'هامر': 'Hummer',
    'هيونداي': 'Hyundai',
    'إنفينيتي': 'Infiniti',
    'إيسوزو': 'Isuzu',
    'جاك': 'Jac',
    'جاكوار': 'Jaguar',
    'جيتور': 'Jetour',
    'جيب': 'Jeep',
    'كيا': 'Kia',
    'كينغ لونغ': 'King Long',
    'لادا': 'Lada',
    'لامبورغيني': 'Lamborghini',
    'لاند روفر': 'Land Rover',
    'لكزس': 'Lexus',
    'ليفان': 'Lifan',
    'لينكون': 'Lincoln',
    'لوتس': 'Lotus',
    'إم جي': 'MG',
    'ميني': 'MINI',
    'مازيراتي': 'Maserati',
    'مازدا': 'Mazda',
    'مكلارين': 'McLaren',
    'مرسيدس بنز': 'Mercedes-Benz',
    'ميتسوبيشي': 'Mitsubishi',
    'نيسان': 'Nissan',
    'أوبل': 'Opel',
    'بيجو': 'Peugeot',
    'بورش': 'Porsche',
    'بروتون': 'Proton',
    'رينو': 'Renault',
    'رولز رويس': 'Rolls Royce',
    'سينوفا': 'Senova',
    'سكودا': 'Skoda',
    'سوايست': 'Soueast',
    'سبيرانزا': 'Speranza',
    'سانج يونغ': 'Ssang Yong',
    'سوبارو': 'Subaru',
    'سوزوكي': 'Suzuki',
    'سيات': 'seat',
    'تيسلا': 'Tesla',
    'تويوتا': 'Toyota',
    'فولكس فاجن': 'Volkswagen',
    'فولفو': 'Volvo',
    'إكس بينغ': 'XPeng',
    'شاومي': 'Xiaomi',
    'زيكر': 'Zeekr',
    // 'زوتي': 'Zotye',
    "صنع آخر": 'Other Make'
  };

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredBrands = List.from(widget.brands);
    _selectedBrand = widget.selectedBrand;

    _searchController.addListener(_filterBrands);
  }

  void _filterBrands() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredBrands = List.from(widget.brands);
      } else {
        _filteredBrands = widget.brands.where((brand) {
          final brandName = brand.name?.toLowerCase() ?? '';

          // Direct match with current brand name
          if (brandName.contains(query)) {
            return true;
          }

          // Get the corresponding name in other language
          String? otherLanguageName;

          // If brand is in Arabic, get English equivalent
          if (_brandMapping.containsKey(brand.name)) {
            otherLanguageName = _brandMapping[brand.name]?.toLowerCase();
          } else {
            // If brand is in English, find Arabic equivalent
            for (var entry in _brandMapping.entries) {
              if (entry.value.toLowerCase() == brand.name?.toLowerCase()) {
                otherLanguageName = entry.key.toLowerCase();
                break;
              }
            }
          }

          // Check if query matches the other language name
          if (otherLanguageName != null && otherLanguageName.contains(query)) {
            return true;
          }

          return false;
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getBrandLogoPath(String? brandName) {
    if (brandName == null) return 'assets/icons/car_brands/default.svg';

    // Convert Arabic to English if needed
    String englishBrandName = _brandMapping[brandName] ?? brandName;

    // Convert brand name to lowercase and remove spaces/hyphens for file naming
    String normalizedName = englishBrandName
        .toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll('-', '_');

    return 'assets/icons/car_brands/$normalizedName.svg';
  }

  Widget _buildBrandItem(CategoryModel brand) {
    final isSelected = _selectedBrand?.id == brand.id;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedBrand = brand;
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
            // Brand Logo - only show if showIcon is true
            if (widget.showIcon) ...[
              Container(
                width: 62,
                height: 62,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: SvgPicture.asset(
                  _getBrandLogoPath(brand.name),
                  fit: BoxFit.contain,
                  // Removed colorFilter to keep natural logo colors
                  placeholderBuilder: (context) => Icon(
                    Icons.directions_car,
                    color: isSelected ? Colors.black : Colors.grey.shade600,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
            const SizedBox(width: 16),

            // Brand Name
            Expanded(
              child: Text(
                brand.name ?? '',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.black : Colors.grey.shade800,
                ),
              ),
            ),

            // Selection indicator
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

  Widget _buildGridBrandItem(CategoryModel brand) {
    final isSelected = _selectedBrand?.id == brand.id;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedBrand = brand;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Brand Logo
            Container(
              width: 60,
              height: 60,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: SvgPicture.asset(
                _getBrandLogoPath(brand.name),
                fit: BoxFit.contain,
                // Removed colorFilter to keep natural logo colors
                placeholderBuilder: (context) => Icon(
                  Icons.directions_car,
                  color: isSelected ? Colors.black : Colors.grey.shade600,
                  size: 32,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Brand Name
            Flexible(
              child: Text(
                brand.name ?? '',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.black : Colors.grey.shade800,
                  height: 1.2,
                ),
              ),
            ),

            // Selection indicator
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 12,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        // Removed the "OK" button from actions
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
                hintText: "${StringHelper.search}",
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

          // View Toggle Buttons (Optional - you can remove this if you prefer one layout)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Text(
                //   "${_filteredBrands.length}: ${StringHelper.brand}",
                //   style: TextStyle(
                //     color: Colors.grey.shade600,
                //     fontSize: 14,
                //   ),
                // ),
              ],
            ),
          ),

          // Brands List/Grid
          Expanded(
            child: _filteredBrands.isEmpty
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
                          "No brands found",
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
                    itemCount: _filteredBrands.length,
                    itemBuilder: (context, index) {
                      return _buildBrandItem(_filteredBrands[index]);
                    },
                  ),
          ),
        ],
      ),

      // Bottom Action Button
      bottomNavigationBar: _selectedBrand != null
          ? Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: SafeArea(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, _selectedBrand);
                  },
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
                    "${StringHelper.select} ${_selectedBrand?.name}",
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
