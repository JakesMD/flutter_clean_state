Simple but versatile state management for clean code.

## ✨ Features
Welcome to an enhanced state management experience with our package! Here's what you'll find inside:

* **CObservable**: Simplify value sharing and tracking by wrapping with CObservable. Paired with CObserver, it's a game-changer.
* **CObserver**: No more StatefulWidgets and repetitive code. Update only the widgets you need when a CObservable value changes.
* **CController**: Connect logic and UI effortlessly. Manage onInit and onDispose seamlessly, with CObservable's notifier for change updates.
* **CProvider**: Effortlessly share instances across your app. Like a friendly manager ensuring easy access.
* **CResult**: Handle outcomes smoothly with CResult. Streamline your workflow with a sleek switch statement.
* **CFutureController**: Manage async tasks gracefully. Let CFutureController handle progress and completion states.
* **User-Friendly**: Designed for Flutter newcomers, our package simplifies state management.


## 🚀 Getting started
Ready to dive in? Follow these steps to start enjoying the benefits of our package:

1. **Install it:**
```
flutter pub add clean_state
```

2. **Import it:**
``` dart
import 'package:clean_state/clean_state.dart';
```

3. **Enjoy**: Explore our versatile state management tools and transform your codebase into a cleaner, more organized masterpiece.

## 💥 Breaking Changes
### 2.0.0
  * Completely new implementation of CResult (thanks to [Andrea Birzzoto's article](https://codewithandrea.com/articles/flutter-exception-handling-try-catch-result-type)) that can be a success or a failure object.


## 👋 Additional Information
Did you know? This package started as a private project and is now open for wider testing! Your input matters, so don't hesitate to share your thoughts or report any issues on GitHub.

Ready to supercharge your state management? Dive into our documentation below powered by ChatGPT 😉

## 🕹 Usage
### CObservable: Sharing and Observing Made Simple
With CObservable, sharing and tracking changes has never been simpler. Wrap your value with CObservable to effortlessly track and broadcast its changes. But keep an eye out for the dynamic duo of CObservable and CObserver – they're about to level up your app!
``` dart
// Create an observable counter.
final counter = 5.cObserve;

// Subscribe to value changes.
final subscription = counter.stream.listen((value) => print(value));

// Update the counter's value.
counter.value = 10;
```

### CObserver: Effortless Widget Updates
Introducing CObserver, your go-to widget for keeping things fresh. No more grappling with StatefulWidgets or juggling boilerplate code. Say goodbye to rebuilding your whole page with setState! Instead, wrap CObserver around the widget that truly needs updating. Let's give it a whirl in the iconic counter app:

``` dart
class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  // 1. The star of the show – the value we're observing.
  final _counter = 0.cObserve;

  // 2. Updates the value.
  void _incrementCounter() => _counter.value++;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CObserver(
          // 3. Pop your widget into CObserver and let it know what to watch.
          observable: _counter,

          // 4. Your widget will be rebuilt whenever the value changes.
          builder: (context, counter) => Text('$counter'),
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
With CObserver by your side, updating widgets becomes a breeze. Say hello to simpler code and a happier you!

### CController: Simplifying Logic and UI Connection
Meet CController: the bridge between logic and UI made easy. It's like a helpful friend that brings onInit and onDispose to your class. Plus, it introduces notifier, a built-in CObservable to let others know when things change. For a cleaner codebase, explore the [Model-View-ViewModel](https://www.ramotion.com/blog/what-is-mvvm/) method. Ready to dive in? Let's use CController to level up our counter app:
``` dart

// 1. Create a new controller class.
class MyHomePageController extends CController {
  // 2. Place the counter value we'll observe inside.
  final counter = 0.cObserve;

  // 3. Updates the counter value.
  void incrementCounter() => counter.value++;

  // Not actually necessary here. But you get the idea.
  @override
  void onInit() {
    super.onInit();
    print('Controller initiated');
  }

  @override
  void onDispose() {
    print('Controller disposed');
    super.onDispose();
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  // 4. Initialize the controller.
  final controller = MyHomePageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CObserver(
          // 5. Update the text whenever the counter value changes.
          observable: controller.counter,
          builder: (context, counter) => Text('$counter'),
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
Ever needed the same controller instance in different places? CProvider has your back. It's like a friendly manager and widget combo that makes storing and retrieving object instances a breeze, ensuring they're easily accessible throughout your app.
``` dart
// Store the controller in a save place for later.
CProvider.register(MyHomePageController());

// Somewhere else in the app later on...
CProvider.fetch<MyHomePageController>();

// Once it's no longer needed...
CProvider.unregister<MyHomePageController>();
```
CProvider is your widget wonder, handling instance registration on construction and unregistration on disposal. If the instance is already registered, CProvider gracefully fetches it for you. Let's put this into action with our counter app:
``` dart
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Pop your widget into a CProvider and give it an instance to register.
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
    // 2. When this CProvider widget is disposed the instance will
    //    automatically be unregistered.
  }
}
```


### CResult: Simplify Your Outcome Handling
CResult simplifies the way you handle operation outcomes. Say goodbye to tangled if statements and embrace the elegance of a single switch statement. The concept is straightforward:

``` dart
// 1. Create an operation that returns a CResult.
CResult<int, Exception> divide(int dividend, int divisor) {
  try {
    // 2. Return a success if the operation succeeds.
    return CSuccess(dividend ~/ divisor, isEmpty: (value) => value == 0);
  } on Exception catch (exception) {
    // 3. Return a failure if the operation fails.
    return CFailure(exception);
  }
}

// 4. Run the operation.
final result = divide(10, 2);

// 5. Do something according to the result.
final handleResult = switch (result) {
  CSuccess(value: final value) => () => print('Result: $value'),
  CFailure(exception: final exception) => () => print('Error: $exception'),
};
handleResult();
```

### CFutureController: Your Asynchronous Task Companion
CFutureController comes to your rescue, making handling asynchronous tasks a breeze. Say goodbye to the mess of `isBusy = true` and `isBusy = false` all over your codebase. This hero manages progress and completion states for you, resulting in code that's cleaner and more organized.
``` dart
// 1. Make your asynchronous tasks return a CResult.
Future<CResult<String, Exception>> fetchData() async {
  await Future.delayed(const Duration(seconds: 3));
  return const CSuccess('Hello World');
}

class MyWidget extends StatelessWidget {
  MyWidget({super.key});

  // 2. Initialize a controller.
  final controller = CFutureController(onStateChange: (state) => print(state));

  // 3. Run a task in the controller.
  void load() async => await controller.run(fetchData);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: load,
      child: CObserver(
        // 4. Observe the controller for state changes.
        observable: controller.notifier,
        builder: (context, _) {
          // 5. Update your UI according to the current state.
          switch (controller.state) {
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