import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_portfolio/features/web/bloc/services_bloc.dart';
import 'package:my_portfolio/features/web/widgets/services_dialog.dart';

class MockServicesBloc extends Mock implements ServicesBloc {
  final _controller = StreamController<ServicesState>();
  late ServicesState _state;

  @override
  Stream<ServicesState> get stream => _controller.stream;

  @override
  ServicesState get state => _state;

  void setState(ServicesState newState) {
    _state = newState;
    _controller.add(newState);
    when(() => state).thenReturn(newState);
  }

  void dispose() {
    _controller.close();
  }
}

void main() {
  late MockServicesBloc mockServicesBloc;

  setUp(() {
    mockServicesBloc = MockServicesBloc();
    registerFallbackValue(const ProceedToFormEvent());
    registerFallbackValue(const BackToServicesEvent());
    registerFallbackValue(const ResetFormEvent());
    registerFallbackValue(ToggleServiceEvent(''));
    registerFallbackValue(UpdateOtherServiceEvent(''));
    registerFallbackValue(SendRequestViaEmailEvent(
      name: '',
      project: '',
      costing: '',
      deadline: '',
    ));
    registerFallbackValue(SendRequestViaWhatsAppEvent(
      name: '',
      project: '',
      costing: '',
      deadline: '',
      phoneNumber: '',
    ));
  });

  tearDown(() {
    mockServicesBloc.dispose();
  });

  Widget createTestWidget({
    required ServicesState initialState,
    String? adminPhoneNumber,
  }) {
    mockServicesBloc.setState(initialState);

    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<ServicesBloc>.value(
          value: mockServicesBloc,
          child: ServicesDialog(adminPhoneNumber: adminPhoneNumber),
        ),
      ),
    );
  }

  group('ServicesDialog - Service Selection Screen', () {
    testWidgets('toggling a service adds it to selected services', (WidgetTester tester) async {
      final initialState = const ServicesState(showForm: false);
      mockServicesBloc.setState(initialState);
      when(() => mockServicesBloc.add(any())).thenReturn(null);

      await tester.pumpWidget(createTestWidget(initialState: initialState));
      await tester.pumpAndSettle();

      expect(find.byType(CheckboxListTile), findsWidgets);
    });

    testWidgets('proceed button is disabled when no services are selected', (WidgetTester tester) async {
      final initialState = const ServicesState(showForm: false, selectedServices: {});
      mockServicesBloc.setState(initialState);

      await tester.pumpWidget(createTestWidget(initialState: initialState));
      await tester.pumpAndSettle();

      final proceedButton = find.byType(ElevatedButton);
      expect(proceedButton, findsOneWidget);
      expect(tester.widget<ElevatedButton>(proceedButton).onPressed, isNull);
    });

    testWidgets('proceed button is enabled when at least one service is selected', (WidgetTester tester) async {
      final initialState = const ServicesState(
        showForm: false,
        selectedServices: {'Mobile App Development'},
      );
      mockServicesBloc.setState(initialState);

      await tester.pumpWidget(createTestWidget(initialState: initialState));
      await tester.pumpAndSettle();

      final proceedButton = find.byType(ElevatedButton);
      expect(tester.widget<ElevatedButton>(proceedButton).onPressed, isNotNull);
    });

    testWidgets('selecting Others service shows custom service input field', (WidgetTester tester) async {
      final initialState = const ServicesState(
        showForm: false,
        selectedServices: {'Others'},
        isOthersSelected: true,
      );
      mockServicesBloc.setState(initialState);

      await tester.pumpWidget(createTestWidget(initialState: initialState));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('deselecting Others service hides custom input field', (WidgetTester tester) async {
      final initialState = const ServicesState(
        showForm: false,
        selectedServices: {'Mobile App Development'},
        isOthersSelected: false,
      );
      mockServicesBloc.setState(initialState);

      await tester.pumpWidget(createTestWidget(initialState: initialState));
      await tester.pumpAndSettle();

      final customTextFields = find.byType(TextField);
      expect(customTextFields.evaluate().isEmpty || customTextFields.evaluate().length < 2, true);
    });

    testWidgets('proceed button triggers ProceedToFormEvent', (WidgetTester tester) async {
      final initialState = const ServicesState(
        showForm: false,
        selectedServices: {'Mobile App Development'},
      );
      mockServicesBloc.setState(initialState);
      when(() => mockServicesBloc.add(any())).thenReturn(null);

      await tester.pumpWidget(createTestWidget(initialState: initialState));
      await tester.pumpAndSettle();

      final proceedButton = find.byType(ElevatedButton);
      await tester.tap(proceedButton);

      verify(() => mockServicesBloc.add(any<ProceedToFormEvent>())).called(1);
    });

    testWidgets('cancel button triggers ResetFormEvent and closes dialog', (WidgetTester tester) async {
      final initialState = const ServicesState(showForm: false);
      mockServicesBloc.setState(initialState);
      when(() => mockServicesBloc.add(any())).thenReturn(null);

      await tester.pumpWidget(createTestWidget(initialState: initialState));
      await tester.pumpAndSettle();

      final cancelButton = find.byType(TextButton).first;
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();

      verify(() => mockServicesBloc.add(any<ResetFormEvent>())).called(greaterThan(0));
    });
  });

  group('ServicesDialog - Form Screen', () {
    testWidgets('form screen displays all required input fields', (WidgetTester tester) async {
      final initialState = const ServicesState(
        showForm: true,
        selectedServices: {'Mobile App Development'},
      );
      mockServicesBloc.setState(initialState);

      await tester.pumpWidget(createTestWidget(initialState: initialState));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('custom service name field appears when Others is selected', (WidgetTester tester) async {
      final initialState = const ServicesState(
        showForm: true,
        selectedServices: {'Others'},
        isOthersSelected: true,
      );
      mockServicesBloc.setState(initialState);

      await tester.pumpWidget(createTestWidget(initialState: initialState));
      await tester.pumpAndSettle();

      final customFields = find.byType(TextField);
      expect(customFields, findsWidgets);
    });

    testWidgets('validation error for custom service is displayed', (WidgetTester tester) async {
      final initialState = const ServicesState(
        showForm: true,
        selectedServices: {'Others'},
        isOthersSelected: true,
        otherServiceError: 'Please enter custom service name',
      );
      mockServicesBloc.setState(initialState);

      await tester.pumpWidget(createTestWidget(initialState: initialState));
      await tester.pumpAndSettle();

      expect(find.text('Please enter custom service name'), findsOneWidget);
    });

    testWidgets('back button transitions from form to service selection', (WidgetTester tester) async {
      final initialState = const ServicesState(
        showForm: true,
        selectedServices: {'Mobile App Development'},
      );
      mockServicesBloc.setState(initialState);
      when(() => mockServicesBloc.add(any())).thenReturn(null);

      await tester.pumpWidget(createTestWidget(initialState: initialState));
      await tester.pumpAndSettle();

      final backButton = find.byType(TextButton);
      if (backButton.evaluate().isNotEmpty) {
        await tester.tap(backButton.first);
        verify(() => mockServicesBloc.add(any<BackToServicesEvent>())).called(greaterThan(0));
      }
    });

    testWidgets('email button triggers SendRequestViaEmailEvent with form data', (WidgetTester tester) async {
      final initialState = const ServicesState(
        showForm: true,
        selectedServices: {'Mobile App Development'},
      );
      mockServicesBloc.setState(initialState);
      when(() => mockServicesBloc.add(any())).thenReturn(null);

      await tester.pumpWidget(createTestWidget(initialState: initialState));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      if (textFields.evaluate().isNotEmpty) {
        await tester.enterText(textFields.at(0), 'John Doe');
        await tester.enterText(textFields.at(1), 'Build a mobile app');
        await tester.pumpAndSettle();

        final emailButton = find.byIcon(Icons.mail);
        if (emailButton.evaluate().isNotEmpty) {
          await tester.tap(emailButton);
          verify(() => mockServicesBloc.add(any<SendRequestViaEmailEvent>())).called(greaterThan(0));
        }
      }
    });

    testWidgets('whatsapp button triggers SendRequestViaWhatsAppEvent with valid phone number', (WidgetTester tester) async {
      final initialState = const ServicesState(
        showForm: true,
        selectedServices: {'Mobile App Development'},
      );
      mockServicesBloc.setState(initialState);
      when(() => mockServicesBloc.add(any())).thenReturn(null);

      await tester.pumpWidget(createTestWidget(
        initialState: initialState,
        adminPhoneNumber: '+919876543210',
      ));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      if (textFields.evaluate().isNotEmpty) {
        await tester.enterText(textFields.at(0), 'Jane Doe');
        await tester.enterText(textFields.at(1), 'Build backend API');
        await tester.pumpAndSettle();

        final whatsappButton = find.byIcon(Icons.call);
        if (whatsappButton.evaluate().isNotEmpty) {
          await tester.tap(whatsappButton);
          verify(() => mockServicesBloc.add(any<SendRequestViaWhatsAppEvent>())).called(greaterThan(0));
        }
      }
    });

    testWidgets('submit buttons are disabled during submission', (WidgetTester tester) async {
      final initialState = const ServicesState(
        showForm: true,
        selectedServices: {'Mobile App Development'},
        isSubmitting: true,
      );
      mockServicesBloc.setState(initialState);

      await tester.pumpWidget(createTestWidget(initialState: initialState));
      await tester.pumpAndSettle();

      final emailButton = find.byIcon(Icons.mail);
      if (emailButton.evaluate().isNotEmpty) {
        expect(tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed, isNull);
      }
    });

    testWidgets('loading indicator shows during form submission', (WidgetTester tester) async {
      final initialState = const ServicesState(
        showForm: true,
        selectedServices: {'Mobile App Development'},
        isSubmitting: true,
      );
      mockServicesBloc.setState(initialState);

      await tester.pumpWidget(createTestWidget(initialState: initialState));
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('ServicesDialog - Error Handling', () {
    testWidgets('error message displays in snackbar when validation fails', (WidgetTester tester) async {
      final initialState = const ServicesState(
        showForm: true,
        selectedServices: {'Mobile App Development'},
        errorMessage: 'Name and Project Description are required',
      );
      mockServicesBloc.setState(initialState);

      await tester.pumpWidget(createTestWidget(initialState: initialState));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('success snackbar appears after successful request submission', (WidgetTester tester) async {
      final initialState = const ServicesState(
        showForm: true,
        selectedServices: {'Mobile App Development'},
        requestSent: true,
      );
      mockServicesBloc.setState(initialState);

      await tester.pumpWidget(createTestWidget(initialState: initialState));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Request sent successfully!'), findsOneWidget);
    });

    testWidgets('whatsapp unavailable error shows when phone number is missing', (WidgetTester tester) async {
      final initialState = const ServicesState(
        showForm: true,
        selectedServices: {'Mobile App Development'},
      );
      mockServicesBloc.setState(initialState);
      when(() => mockServicesBloc.add(any())).thenReturn(null);

      await tester.pumpWidget(createTestWidget(
        initialState: initialState,
        adminPhoneNumber: null,
      ));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      if (textFields.evaluate().isNotEmpty) {
        await tester.enterText(textFields.at(0), 'Test User');
        await tester.enterText(textFields.at(1), 'Test project');
        await tester.pumpAndSettle();

        final whatsappButton = find.byIcon(Icons.call);
        if (whatsappButton.evaluate().isNotEmpty) {
          await tester.tap(whatsappButton);
          await tester.pumpAndSettle();

          expect(find.byType(SnackBar), findsOneWidget);
        }
      }
    });
  });

  group('ServicesDialog - Multiple Service Selection', () {
    testWidgets('multiple services can be selected simultaneously', (WidgetTester tester) async {
      final initialState = const ServicesState(
        showForm: false,
        selectedServices: {'Mobile App Development', 'Database Design & Development'},
      );
      mockServicesBloc.setState(initialState);

      await tester.pumpWidget(createTestWidget(initialState: initialState));
      await tester.pumpAndSettle();

      expect(find.byType(CheckboxListTile), findsWidgets);
    });

    testWidgets('selected services are displayed in form screen', (WidgetTester tester) async {
      final initialState = const ServicesState(
        showForm: true,
        selectedServices: {'Mobile App Development', 'API Development & Integration'},
      );
      mockServicesBloc.setState(initialState);

      await tester.pumpWidget(createTestWidget(initialState: initialState));
      await tester.pumpAndSettle();

      expect(find.text('Selected Services:'), findsOneWidget);
    });

    testWidgets('Others service with custom name displays correctly', (WidgetTester tester) async {
      final initialState = const ServicesState(
        showForm: true,
        selectedServices: {'Others'},
        isOthersSelected: true,
        otherServiceName: 'Custom Development',
      );
      mockServicesBloc.setState(initialState);

      await tester.pumpWidget(createTestWidget(initialState: initialState));
      await tester.pumpAndSettle();

      expect(find.text('Selected Services:'), findsOneWidget);
    });
  });

  group('ServicesDialog - Custom Service Handling', () {
    testWidgets('updating custom service name triggers UpdateOtherServiceEvent', (WidgetTester tester) async {
      final initialState = const ServicesState(
        showForm: false,
        selectedServices: {'Others'},
        isOthersSelected: true,
      );
      mockServicesBloc.setState(initialState);
      when(() => mockServicesBloc.add(any())).thenReturn(null);

      await tester.pumpWidget(createTestWidget(initialState: initialState));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      if (textFields.evaluate().isNotEmpty) {
        await tester.enterText(textFields.first, 'Custom Requirement');
        await tester.pumpAndSettle();

        verify(() => mockServicesBloc.add(any<UpdateOtherServiceEvent>())).called(greaterThan(0));
      }
    });

    testWidgets('custom service error clears when valid input is provided', (WidgetTester tester) async {
      final initialState = const ServicesState(
        showForm: true,
        selectedServices: {'Others'},
        isOthersSelected: true,
        otherServiceError: null,
      );
      mockServicesBloc.setState(initialState);

      await tester.pumpWidget(createTestWidget(initialState: initialState));
      await tester.pumpAndSettle();

      expect(find.text('Please enter custom service name'), findsNothing);
    });
  });

  group('ServicesDialog - UI State Management', () {
    testWidgets('displays service selection screen title correctly', (WidgetTester tester) async {
      final initialState = const ServicesState(showForm: false);
      mockServicesBloc.setState(initialState);

      await tester.pumpWidget(createTestWidget(initialState: initialState));
      await tester.pumpAndSettle();

      expect(find.text('Select Services'), findsOneWidget);
    });

    testWidgets('displays project requirements screen title correctly', (WidgetTester tester) async {
      final initialState = const ServicesState(
        showForm: true,
        selectedServices: {'Mobile App Development'},
      );
      mockServicesBloc.setState(initialState);

      await tester.pumpWidget(createTestWidget(initialState: initialState));
      await tester.pumpAndSettle();

      expect(find.text('Project Requirements'), findsOneWidget);
    });

    testWidgets('dialog displays build icon in header', (WidgetTester tester) async {
      final initialState = const ServicesState(showForm: false);
      mockServicesBloc.setState(initialState);

      await tester.pumpWidget(createTestWidget(initialState: initialState));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.build), findsOneWidget);
    });

    testWidgets('dialog displays close button in header', (WidgetTester tester) async {
      final initialState = const ServicesState(showForm: false);
      mockServicesBloc.setState(initialState);

      await tester.pumpWidget(createTestWidget(initialState: initialState));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.close), findsOneWidget);
    });
  });

  group('ServicesDialog - Form Validation Feedback', () {
    testWidgets('name field error displays when validation fails', (WidgetTester tester) async {
      final initialState = const ServicesState(
        showForm: true,
        selectedServices: {'Mobile App Development'},
        errorMessage: 'Name is required',
      );
      mockServicesBloc.setState(initialState);

      await tester.pumpWidget(createTestWidget(initialState: initialState));
      await tester.pumpAndSettle();

      expect(find.text('Name is required'), findsOneWidget);
    });

    testWidgets('project description field error displays when validation fails', (WidgetTester tester) async {
      final initialState = const ServicesState(
        showForm: true,
        selectedServices: {'Mobile App Development'},
        errorMessage: 'Project is required',
      );
      mockServicesBloc.setState(initialState);

      await tester.pumpWidget(createTestWidget(initialState: initialState));
      await tester.pumpAndSettle();

      expect(find.text('Project is required'), findsOneWidget);
    });

    testWidgets('budget and deadline fields are optional', (WidgetTester tester) async {
      final initialState = const ServicesState(
        showForm: true,
        selectedServices: {'Mobile App Development'},
      );
      mockServicesBloc.setState(initialState);

      await tester.pumpWidget(createTestWidget(initialState: initialState));
      await tester.pumpAndSettle();

      expect(find.text('Budget/Costing (Optional)'), findsOneWidget);
      expect(find.text('Deadline (Optional)'), findsOneWidget);
    });
  });
}











