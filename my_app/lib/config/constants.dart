enum Environment { dev, prod }

class Constants {
	// Set this flag to toggle environments easily
	static const Environment currentEnvironment = Environment.prod;

	static String get apiBaseUrl {
		switch (currentEnvironment) {
			case Environment.dev:
				return 'http://10.0.2.2:5000/api'; // Local Android emulator
			case Environment.prod:
				return 'https://vinyl-vault-app-production.up.railway.app/api';
		}
	}
}
