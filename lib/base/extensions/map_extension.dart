import 'package:flutter/material.dart';

extension MapExtension<K, V> on Map<K, V> {
  void addIf(dynamic condition, K key, V value) {
    if (condition is bool && condition) {
      this[key] = value;
    }
  }

  void addAllIf(dynamic condition, Map<K, V> values) {
    if (condition is bool && condition) {
      addAll(values);
    }
  }
}
