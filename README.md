# Overview
This repo extends the workout tracking watchOS app from [WWDC1: Build a workout app for Apple Watch](https://www.youtube.com/watch?v=VxaBTbWwGTQ&t=2191s).

The app leverages SwiftUI and Apple's HealthKit APIs to track physical activity (distance, BPM, calories burned) during biking, walking and cycling workouts. I have extended the application further from the tutorial to implement:
- MVVM architecture.
- Tree-based dependency injection to allow for mocking/faking of the `WorkoutManager` class that interacts with HealthKit.
- Creation of a separate `WorkoutManager` Swift package that provides abstractions on HealthKit, such that the application target itself does not need to import or otherwise be concerned with HealthKit.
- Unit test coverage with the new Swift Testing framework.

## Demo

https://github.com/user-attachments/assets/804a044a-739b-4c4c-81ea-9168fe45ede2

