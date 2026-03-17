require("dotenv").config();

const googleMapsKey =
  process.env.EXPO_PUBLIC_GOOGLE_MAPS_API_KEY ||
  process.env.GOOGLE_MAPS_API_KEY ||
  "";
const apiBaseURL = process.env.EXPO_PUBLIC_API_BASE_URL || "https://trip5-api.vercel.app";

export default {
  expo: {
    name: "Trip5",
    extra: {
      googleMapsApiKey: googleMapsKey,
      apiBaseURL,
    },
    slug: "trip5-expo",
    version: "1.0.0",
    orientation: "portrait",
    icon: "./assets/icon.png",
    userInterfaceStyle: "light",
    splash: {
      image: "./assets/splash-icon.png",
      resizeMode: "contain",
      backgroundColor: "#ffffff",
    },
    ios: {
      supportsTablet: true,
      bundleIdentifier: "com.trip5.app",
      infoPlist: {
        NSLocationWhenInUseUsageDescription:
          "Trip5 needs your location to set your pickup point on the map.",
      },
      config: {
        googleMapsApiKey: googleMapsKey,
      },
    },
    android: {
      package: "com.trip5.app",
      adaptiveIcon: {
        backgroundColor: "#E6F4FE",
        foregroundImage: "./assets/android-icon-foreground.png",
        backgroundImage: "./assets/android-icon-background.png",
        monochromeImage: "./assets/android-icon-monochrome.png",
      },
      config: {
        googleMaps: {
          apiKey: googleMapsKey,
        },
      },
    },
    web: {
      favicon: "./assets/favicon.png",
    },
    plugins: ["@react-native-community/datetimepicker"],
  },
};
