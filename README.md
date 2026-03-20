CleanSL Mobile Application
Project Overview
CleanSL is a comprehensive, smart waste management mobile ecosystem developed as part of a Software Development Group Project (SDGP). Built entirely with Flutter, the application bridges the gap between municipal waste collection services and local residents, ensuring a cleaner, greener, and more transparent city infrastructure.

The mobile application is architected to serve two distinct user bases with highly optimized interfaces:

The Resident Interface: Focused on real-time transparency, scheduling, and environmental impact tracking.

The Driver Interface: Focused on low-friction, high-speed reporting and route management for frontline workers.

Key Features
Resident Interface
Real-Time Truck Tracking: A live Google Maps integration that polls driver locations via a custom tracking service. It features custom UI markers, automatic camera bounding, and dynamic ETA calculations based on the truck's proximity.

Smart Home Dashboard: Includes a dynamic "Next Pickup" card that updates its progress bar and status text in real-time, switching seamlessly between scheduled states and active en-route tracking.

Collection Certificates & Impact Tracking: Every completed pickup generates a digital certificate. Residents can track their personal environmental footprint, viewing dynamic metrics like CO2 emissions prevented, energy saved, and water conserved based on the specific waste category (Organic, Recyclables, General).

Recent Activity Log: A filterable and searchable history of all user interactions. The intelligent routing system seamlessly navigates users to either their completed pickup certificates or the detailed status pages of their filed complaints.

Pickup Scheduling & Reminders: An interactive schedule page displaying in-progress, upcoming, and completed pickups, complete with custom blurred-background reminder dialogs to notify residents before the truck arrives.

Driver Interface
Voice-to-Action Reporting (Low Literacy UX): A highly accessible, one-tap voice recording module. Drivers can report operational issues (e.g., overflowing bins, blocked routes) without typing a single word.

Background Audio Processing: Audio is captured in high-quality WAV format, requesting native microphone permissions, and securely uploaded to a Render-hosted backend for transcription, with files stored via Supabase.

Report History: An integrated history screen that fetches past transcriptions from the backend and utilizes an audio player to allow drivers to listen to their previously submitted reports.

Driver Profile & Fleet Assignment: Dynamic profiles displaying the driver's Employee ID, active Assigned District, and Primary Vehicle details.

Route & Ward Selection: A streamlined, visual grid for drivers to select their active sector and launch their specific route paths (e.g., Bambalapitiya Route).

Technical Stack
Frontend Framework: Flutter (Dart)

Mapping & Geolocation: Google Maps Flutter

Audio Engine: record (for low-latency voice capture), audioplayers (for playback)

Networking & APIs: http package for REST API communication (Render backend integration)

Storage: Supabase (for audio file and asset storage)

State Management & Real-time: Stateful UI management combined with Stream Subscriptions and Timer-based polling for live map updates.

UI/UX & Theming: A strictly enforced custom AppTheme utilizing an 8pt grid system, responsive scaling utilities, and Google Fonts (Inter for body text, Roboto Slab for headers).

Project Structure Highlights
The project follows a feature-first, modular architecture to ensure maintainability across the SDGP team:

core/: Contains the global AppTheme, responsive utilities, and shared constants.

shared/widgets/: Reusable UI components like the CleanSlButton.

features/driver/: Encapsulates all driver-specific logic, UI, and data models (Voice Recording, Profile, Ward Selection).

features/resident/: Contains the resident dashboard, live tracking maps, scheduling, complaints, and activity logs.

Academic Context
This application is developed as the practical implementation for a 2nd-year Bsc (Hons) Computer Science Software Development Group Project (SDGP). It demonstrates the practical application of mobile UX design, real-time data handling, external API integration, and hardware-level feature access (Microphone and GPS).
