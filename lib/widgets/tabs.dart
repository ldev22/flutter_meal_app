import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_app/widgets/categories_screen.dart';
import 'package:meal_app/widgets/filters.dart';
import 'package:meal_app/widgets/main_drawer.dart';
import 'package:meal_app/widgets/meals.dart';
import 'package:meal_app/providers/meals_provider.dart';
import 'package:meal_app/providers/favourites_provider.dart';

import 'package:meal_app/providers/filters_provider.dart';

// const kInitialFilters = {
//   Filter.glutenFree: false,
//   Filter.lactoseFree: false,
//   Filter.vegatarian: false,
//   Filter.vegan: false
// };

class TabsScreen extends ConsumerStatefulWidget {
  TabsScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectPageIndex = 0;

  // final List<Meal> _favouriteMeals = [];

  //Map<Filter, bool> _selectedFilters = kInitialFilters;
  // void _showInfoMessage(String message) {
  //   ScaffoldMessenger.of(context).clearSnackBars();
  //   ScaffoldMessenger.of(context)
  //       .showSnackBar(SnackBar(content: Text(message)));
  // }

  // void _toggleMealFavouriteStatus(Meal meal) {
  //   final isExisting = _favouriteMeals.contains(meal);
  //   setState(() {
  //     if (isExisting) {
  //       _favouriteMeals.remove(meal);
  //       _showInfoMessage('Meal is no longer a favourite');
  //     } else {
  //       _favouriteMeals.add(meal);
  //       _showInfoMessage('Meal added as favourite');
  //     }
  //   });
  // }

  void _selectPage(int index) {
    setState(() {
      _selectPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      await Navigator.of(context).push<Map<Filter, bool>>(MaterialPageRoute(
        builder: (ctx) => FiltersScreen(),
      ));
      // setStat() {
      //   _selectedFilters = result ?? kInitialFilters;
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    final meals = ref.watch(mealsProvider);
    final activeFilters = ref.watch(filtersProvider);
    final availableMeals = meals.where((meal) {
      if (activeFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }

      if (activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }

      if (activeFilters[Filter.vegatarian]! && !meal.isVegetarian) {
        return false;
      }

      if (activeFilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();
    Widget activePage = CategoriesScreen(
      // onToggleFavourite: _toggleMealFavouriteStatus,
      availableMeals: availableMeals,
    );
    var activePageTitle = 'Categories';
    if (_selectPageIndex == 1) {
      final favouritMeals = ref.watch(favouriteMealsProvider);
      activePage = MealsScreen(
        meals: favouritMeals,
      );
      activePageTitle = 'Your Favourites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectPageIndex,
        onTap: _selectPage,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favourites')
        ],
      ),
    );
  }
}
