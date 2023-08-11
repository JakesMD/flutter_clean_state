import "dart:developer";

import "package:flutter/widgets.dart";
import "package:get_it/get_it.dart";

/// Central hub for managing global instances with easy access.
///
/// [CProvider] acts as a manager and widget for storing and retrieving
/// instances of various objects, streamlining their availability across your
/// app.
///
/// ### Example:
///
/// ``` dart
/// // AS A SERVICE:
///
/// // Store the controller in a save place for later.
/// CProvider.register(MyHomePageController());
///
/// // Somewhere else in the app later on...
/// CProvider.fetch<MyHomePageController>();
///
/// // Once it's no longer needed...
/// CProvider.unregister<MyHomePageController>();
///
/// // AS A WIDGET:
///
/// class MyHomePage extends StatelessWidget {
///   const MyHomePage({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     // 1. Pop your widget into a CProvider and give it an instance to register.
///     return CProvider(
///       instance: MyHomePageController(),
///       builder: (context, controller) => Scaffold(
///         body: Center(
///           child: CObserver(
///             observable: controller.counter,
///             builder: (context, counter) => Text('$counter'),
///           ),
///         ),
///         floatingActionButton: FloatingActionButton(
///           onPressed: controller.incrementCounter,
///           child: const Icon(Icons.add),
///         ),
///       ),
///     );
///     // 2. When this CProvider widget is disposed the instance will
///     //    automatically be unregistered.
///   }
/// }
/// ```
///
/// ### See also:
///  * [CController], base class providing lifecycle management for controllers.
///  * [CFutureController], for a controller that manages asynchronous tasks.
///  * [CObservable], for a class that makes values easy to share and observe.
///  * [CObserver], for a widget that updates its child whenever the value of a
///    [CObservable] changes.
///  * [CResult], for a representation of an operation's outcome.
class CProvider<T extends Object> extends StatefulWidget {
  /// The instance to store and utilize.
  final T instance;

  /// A function for building the child widget based on the stored instance.
  final Widget Function(BuildContext context, T instance) builder;

  /// An optional tag for identifying a specific instance.
  final String? tag;

  /// Creates a widget that automatically stores an instance of an object upon
  /// initialization and removes it when no longer needed.
  const CProvider({
    super.key,
    required this.instance,
    required this.builder,
    this.tag,
  });

  @override
  State<CProvider<T>> createState() => _CProviderState<T>();

  /// Stores an object instance for future retrieval.
  ///
  /// By providing a [tag], you can later retrieve a specific instance of the
  /// same type using the same tag.
  static T register<T extends Object>(T instance, {String? tag}) {
    if (GetIt.instance.isRegistered<T>(instanceName: tag)) {
      log(
        "An instance of $T (tag: $tag) is already registered. Using the registered instance instead.",
        name: "CProvider",
      );
      return fetch<T>(tag: tag);
    }

    GetIt.instance.registerSingleton<T>(
      instance,
      instanceName: tag,
    );

    log(
      "An instance of $T (tag: $tag) has been created and stored.",
      name: "CProvider",
    );

    return instance;
  }

  /// Unregisters a previously stored object instance.
  static void unregister<T extends Object>({String? tag}) {
    GetIt.instance.unregister<T>(instanceName: tag);
    log("An instance of $T (tag: $tag) has been deleted.", name: "CProvider");
  }

  /// Retrieves a previously stored object instance.
  static T fetch<T extends Object>({String? tag}) {
    final instance = GetIt.instance.get<T>(instanceName: tag);
    log("An instance of $T (tag: $tag) has been fetched.", name: "CProvider");
    return instance;
  }
}

class _CProviderState<T extends Object> extends State<CProvider<T>> {
  late T _instance;
  late bool wasAlreadyRegistered;

  @override
  void initState() {
    super.initState();
    wasAlreadyRegistered = GetIt.instance.isRegistered<T>(
      instanceName: widget.tag,
    );
    _instance = CProvider.register(widget.instance, tag: widget.tag);
  }

  @override
  void dispose() {
    if (!wasAlreadyRegistered) CProvider.unregister<T>(tag: widget.tag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _instance);
  }
}
