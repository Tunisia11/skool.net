class ZoomConfig {
  // TODO: Replace with your actual Zoom SDK credentials
  // Get them from: https://marketplace.zoom.us

  /// Your Zoom SDK Key (Client ID)
  /// Steps to get:
  /// 1. Go to https://marketplace.zoom.us
  /// 2. Sign in or create account
  /// 3. Click "Develop" > "Build App"
  /// 4. Choose "Meeting SDK"
  /// 5. Copy your SDK Key and SDK Secret
  static const String sdkKey = 'YyMoPqetRyOoaxVrGaudaQ';

  /// Your Zoom SDK Secret (Client Secret)
  static const String sdkSecret = 'd1PZHSxBUx8Hs2rDuLUmpDU8uGGJEp4Z';

  /// Default meeting settings
  static const bool enableVideo = true;
  static const bool enableAudio = true;
  static const bool autoJoinAudio = true;
}
