import 'package:flutter/material.dart';

/// Service Model
class ServiceItem {
  final IconData icon;
  final String title;
  final String description;

  const ServiceItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}

/// Services List (Dynamic - Used everywhere)
const List<ServiceItem> servicesList = [
  ServiceItem(
    icon: Icons.phone_android,
    title: 'Mobile App Development',
    description: 'Native Android & iOS apps using Flutter',
  ),
  ServiceItem(
    icon: Icons.storage,
    title: 'Database Design & Development',
    description: 'MySQL, PostgreSQL, SQLite, Firebase',
  ),
  ServiceItem(
    icon: Icons.api,
    title: 'API Development & Integration',
    description: 'REST APIs, GraphQL, Backend Services',
  ),
  ServiceItem(
    icon: Icons.map,
    title: 'Google Maps API Integration',
    description: 'Location services, Maps, Geocoding',
  ),
  ServiceItem(
    icon: Icons.payment,
    title: 'Payment Gateway Integration',
    description: 'Razorpay, CCAvenue, Stripe integration',
  ),
  ServiceItem(
    icon: Icons.cloud,
    title: 'Firebase Integration',
    description: 'Auth, Database, Storage, Analytics',
  ),
  ServiceItem(
    icon: Icons.design_services,
    title: 'UI/UX Design',
    description: 'Modern, responsive, user-friendly designs',
  ),
  ServiceItem(
    icon: Icons.publish,
    title: 'App Store Deployment',
    description: 'Play Store & App Store publishing',
  ),
  ServiceItem(
    icon: Icons.support,
    title: 'Maintenance & Support',
    description: 'Bug fixes, updates, ongoing support',
  ),
  ServiceItem(
    icon: Icons.lightbulb,
    title: 'Consultation',
    description: 'Technical advice, project planning',
  ),
  ServiceItem(
    icon: Icons.add_circle_outline,
    title: 'Others',
    description: 'Enter your custom service requirement',
  ),
];
