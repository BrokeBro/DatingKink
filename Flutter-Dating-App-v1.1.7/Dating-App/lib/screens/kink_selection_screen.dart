import 'dart:math';
import 'package:dating_app/constants/constants.dart';
import 'package:flutter/material.dart';

class KinkSelectionScreen extends StatefulWidget {
  final List<String>? initialSelectedKinks;

  const KinkSelectionScreen({super.key, this.initialSelectedKinks});

  @override
  KinkSelectionScreenState createState() => KinkSelectionScreenState();
}

class KinkSelectionScreenState extends State<KinkSelectionScreen> {
  late List<String> _selectedKinks;
  List<String> _filteredKinks = [];
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectedKinks = widget.initialSelectedKinks ?? [];
    _filteredKinks = List.from(KINK_CATEGORIES);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _filterKinks(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredKinks = List.from(KINK_CATEGORIES);
      } else {
        _filteredKinks = KINK_CATEGORIES
            .where((kink) => kink.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _toggleKink(String kink) {
    setState(() {
      if (_selectedKinks.contains(kink)) {
        _selectedKinks.remove(kink);
      } else {
        _selectedKinks.add(kink);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Kinks'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(_selectedKinks);
            },
            child: Text(
              'Done (${_selectedKinks.length})',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterKinks,
              decoration: InputDecoration(
                hintText: 'Search kinks...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterKinks('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
            ),
          ),

          // Selected count indicator
          if (_selectedKinks.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.check_circle,
                      color: Theme.of(context).primaryColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '${_selectedKinks.length} selected',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedKinks.clear();
                      });
                    },
                    child: const Text('Clear All'),
                  ),
                ],
              ),
            ),

          // Word cloud
          Expanded(
            child: _filteredKinks.isEmpty
                ? const Center(
                    child: Text(
                      'No kinks found',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _filteredKinks.map((kink) {
                        final isSelected = _selectedKinks.contains(kink);
                        final random = Random(kink.hashCode);
                        final fontSize = 14.0 + random.nextDouble() * 8;

                        return GestureDetector(
                          onTap: () => _toggleKink(kink),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey[300]!,
                                width: 1.5,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      )
                                    ]
                                  : [],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  kink,
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    color:
                                        isSelected ? Colors.white : Colors.black87,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                                if (isSelected) ...[
                                  const SizedBox(width: 6),
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
          ),

          // Bottom action bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _selectedKinks.isEmpty
                        ? 'Select at least one kink to continue'
                        : 'Tap kinks to select/deselect',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _selectedKinks.isEmpty
                          ? null
                          : () {
                              Navigator.of(context).pop(_selectedKinks);
                            },
                      child: Text(
                        'Continue (${_selectedKinks.length})',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
