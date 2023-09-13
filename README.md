Simple but versatile state management for clean code.

## ✨ Features
- **CObservable**: Easily share and track values with CObservable. Pair it with CObserver for efficient value updates.
- **CObserver**: Eliminate StatefulWidgets and repetitive code. Update only the necessary widgets when CObservable values change.
- **CStreamObservable**: Easily share and track stream events with CStreamObservable.
- **CStreamObserver**: A convenience widget for updating widgets when CStreamObservable values change.
- **CController**: Connect logic and UI effortlessly. Manage onInit and onDispose with CObservable's notifier for change updates.
- **CProvider**: Share instances across your app effortlessly, making them easily accessible.
- **CResult**: Streamline outcome handling with a sleek switch statement.
- **CFutureController**: Gracefully manage asynchronous tasks, handling progress and completion states.


## 🚀 Getting started
To get started with Clean State, follow these steps:

1. **Install it:**
   ```bash
   flutter pub add clean_state
   ```
2. **Import it:**
   ```dart
   import 'package:clean_state/clean_state.dart';
   ```
3. **Explore**: Start using our versatile state management tools to improve your codebase's organization.


## 💥 Breaking Changes

### v2.0.0
- Completely revamped CResult implementation, inspired by [Andrea Birzzoto's article](https://codewithandrea.com/articles/flutter-exception-handling-try-catch-result-type). CResult can now represent both success and failure objects.


## 👋 Additional Information
Did you know? This package started as a private project and is now open for wider testing! Your feedback matters; please share your thoughts or report issues on GitHub.

Ready to enhance your state management? Dive into our comprehensive documentation below below powered by ChatGPT 😉


## 🕹 Usage

### CObservable: Simplify Value Sharing and Tracking
With CObservable, tracking and sharing value changes becomes a breeze. Wrap your values with CObservable to effortlessly broadcast changes:

```dart
final counter = 5.cObserve;                 // Create an observable counter.
final subscription = counter.stream.listen( // Subscribe to value changes.
  (value) => print(value),
); 
counter.value = 10;                         // Update the counter's value from anywhere.
final result = counter.value;               // Fetch the counter's value from anywhere.
```


### CObserver: Effortless Widget Updates
CObserver simplifies widget updates. No more StatefulWidgets or boilerplate code. Update only the necessary widgets when values change. Here's an example for the iconic counter app:

```dart
class MyHomePage extends StatelessWidget {
  final _counter = 0.cObserve;                  // 1. Turn the value into an observable.
  void _incrementCounter() => _counter.value++; // 2. Update the value.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CObserver(        // 3. Wrap the widget to update into CObserver.
          observable: _counter,  // 4. Provide the observable to watch.
          builder: (context, counter) => Text('$counter'), // 5. The widget will be rebuilt whenever the value changes.
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

### CStreamObservable: Simplify Stream Event Sharing and Tracking
With CStreamObservable, tracking and sharing stream events becomes a breeze. Wrap your Stream with CStreamObservable to effortlessly broadcast changes:

```dart
final stream = Stream.periodic( // Create an observable stream.
  const Duration(seconds: 1),
  (x) => x,
).take(5).cObserve;
final result = stream.value;   // Fetch the stream's latest value from anywhere.
```

### CStreamObserver: Stream-Powered Widget Updates
CStreamObserver is merly a convenience widget. No different than an ordinary StreamBuilder:

```dart
class Example extends StatelessWidget {
  final _stream = Stream.periodic(
    const Duration(seconds: 1),
    (x) => x,
  ).take(5).cObserve;

  @override
  Widget build(BuildContext context) {
    return CStreamObserver(
      observable: _stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) return Text('${snapshot.data}');
        return const Text('Nothing here.');
      },
    );
  }
}
```


### CController: Simplifying Logic and UI Connection
CController bridges logic and UI effortlessly. It includes onInit and onDispose and introduces a built-in CObservable for change notifications:

```dart
class MyHomePageController extends CController {
  var counter = 0;

  void incrementCounter() {
     counter++;
     notify();
  }

  @override
  void onInit() {
    super.onInit();
    print('Controller initialized.');
  }
}

class MyHomePage extends StatelessWidget {
  final controller = MyHomePageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CObserver(
          observable: controller.notifier,
          builder: (context, _) => Text('${controller.counter}'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.incrementCounter,
        child: const Icon(Icons.add),
      ),
    );
  }
}
```


### CProvider: Effortless Sharing of Instances
CProvider simplifies instance sharing across your app:

```dart
CProvider.register(MyHomePageController());   // Store the controller for later.
CProvider.fetch<MyHomePageController>();      // Fetch the controller from anywhere.
CProvider.unregister<MyHomePageController>(); // Remove the controller once it's no longer needed.
```

The CProvider widget handles instance registration and unregistration, making instances easily accessible:

```dart
return CProvider(
  instance: MyHomePageController(),
  builder: (context, controller) => Scaffold(
    body: Center(
      child: CObserver(
        observable: controller.counter,
        builder: (context, counter) => Text('$counter'),
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: controller.incrementCounter,
      child: const Icon(Icons.add),
    ),
  ),
);
```


### CResult: Simplify Outcome Handling
CResult simplifies outcome handling, replacing complex if statements with a switch statement:

```dart
CResult<int, Exception> divide(int dividend, int divisor) { // 1. Create an operation that returns a CResult.
  try {
    return CSuccess(dividend ~/ divisor, isEmpty: (value) => value == 0); // 2. Return a success...
  } on Exception catch (exception) {
    return CFailure(exception); // 3. Or a failure.
  }
}

final result = divide(10, 2); // 4. Run the operation.

final handleResult = switch (result) { // 5. Do something according to the result.
  CSuccess(value: final value) => () => print('Result: $value'),
  CFailure(exception: final exception) => () => print('Error: $exception'),
};
handleResult();
```


### CFutureController: Your Asynchronous Task Companion
CFutureController simplifies handling asynchronous tasks, managing progress and completion states:

```dart
Future<CResult<String, Exception>> fetchData() async { // 1. Make your asynchronous tasks return a CResult.
  await Future.delayed(const Duration(seconds: 3));
  return const CSuccess('Hello World');
}

class MyWidget extends StatelessWidget {
  final controller = CFutureController(                 // 2. Initialize a controller.
    onStateChange: (state) => print(state),
  );
  void load() async => await controller.run(fetchData); // 3. Run a task in the controller.
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: load,
      child: CObserver( // 4. Observe the controller for state changes.
        observable: controller.notifier,
        builder: (context, _) { 
          switch (controller.state) {  // 5. Update your UI according to the current state.
            case CFutureState.fail:
              return const Text('Error');
            case CFutureState.inProgress:
              return const Text('Loading');
            case CFutureState.success:
              return const Text('Success');
          }
        },
      ),
    );
  }
}
```