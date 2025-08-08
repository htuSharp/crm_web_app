# PharmaCRM - Professional CRM System

A comprehensive Customer Relationship Management (CRM) system built with Flutter for the pharmaceutical industry. This application provides efficient management of medical representatives, doctors, medical facilities, stockists, and more.

## 🌟 Features

- **Data Management System**: Comprehensive management of:
  - Medical Specialties
  - Headquarters/Regional Offices
  - Area Management
  - Medical Representatives (MR)
  - Medical Facilities
  - Doctors Database
  - Stockist Management

- **Professional UI**: Modern, responsive design with company-oriented interface
- **Search Functionality**: Real-time search across all data sections
- **Validation System**: Robust duplicate checking and field validation
- **Dashboard**: Overview of activities and key metrics
- **Activity Logging**: Track all system activities
- **Inventory Management**: Track medical supplies and equipment
- **Invoice Management**: Handle billing and invoicing
- **MR Planning**: Manage medical representative schedules and territories

## 🚀 Live Demo

Visit the live application: [PharmaCRM on GitHub Pages](https://yourusername.github.io/crm_web_app/)

## 🛠️ Technology Stack

- **Framework**: Flutter (Web)
- **Language**: Dart
- **Architecture**: Clean Architecture with Service Layer
- **State Management**: StatefulWidget with Provider pattern
- **UI Components**: Material Design 3
- **Deployment**: GitHub Pages with GitHub Actions CI/CD

## 📱 Screenshots

![Dashboard](screenshots/dashboard.png)
![Data Management](screenshots/data-management.png)
![MR Management](screenshots/mr-management.png)

## 🏃‍♂️ Getting Started

### Prerequisites

- Flutter SDK (3.24.0 or higher)
- Dart SDK
- Web browser (Chrome recommended)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/crm_web_app.git
cd crm_web_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the application:
```bash
flutter run -d chrome
```

### Building for Production

```bash
flutter build web --release  html
```

## 🏗️ Project Structure

```
lib/
├── main.dart                 # Application entry point
├── routes/                   # App routing configuration
├── pages/                    # UI pages
│   ├── dashboard_page.dart
│   ├── home_page.dart
│   └── datamanagement/
├── models/                   # Data models
├── services/                 # Business logic services
├── widgets/                  # Reusable UI components
├── providers/                # State management
├── constants/                # App constants
└── theme/                    # App theming
```

## 🔧 Configuration

### GitHub Pages Deployment

The application is automatically deployed to GitHub Pages using GitHub Actions. The workflow is configured in `.github/workflows/deploy.yml`.

To deploy to your own GitHub Pages:

1. Fork this repository
2. Enable GitHub Pages in repository settings
3. Set source to "GitHub Actions"
4. Push changes to the `main` branch

### Environment Variables

No environment variables are required for basic functionality.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## 📋 API Documentation

### Service Classes

- `AreaManagementService`: Manages geographical areas and territories
- `MRManagementService`: Handles medical representative data
- `MedicalManagementService`: Manages medical facilities
- `DoctorManagementService`: Maintains doctor database
- `StockistManagementService`: Handles stockist information
- `SpecialtyManagementService`: Manages medical specialties
- `HeadquartersManagementService`: Regional office management

Each service provides CRUD operations with validation and duplicate checking.

## 🐛 Known Issues

- Search functionality is case-sensitive in some browsers
- Large datasets may cause performance issues (pagination planned)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Your Name**
- GitHub: [@yourusername](https://github.com/yourusername)
- LinkedIn: [Your LinkedIn](https://linkedin.com/in/yourprofile)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design team for the design system
- GitHub for free hosting via GitHub Pages

## 📞 Support

For support, email your-email@example.com or create an issue in this repository.

---

**Built with ❤️ for the pharmaceutical industry**
