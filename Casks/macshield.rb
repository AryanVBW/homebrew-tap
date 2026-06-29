cask "macshield" do
  version "1.1.0"
  sha256 "f96d560705d43f041872617b6145c8b4c9482b118eb5d9a4d4ff1190a293a1c7"

  url "https://github.com/AryanVBW/MacShield/releases/download/v#{version}/MacShield.dmg"
  name "MacShield"
  desc "Lock apps with Touch ID, Apple Watch, or a password"
  homepage "https://github.com/AryanVBW/MacShield"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :ventura

  app "MacShieldPRO.app"

  # MacShield ships without an Apple Developer ID / notarization, so macOS would
  # quarantine the download and Gatekeeper would block first launch ("damaged" or
  # "unidentified developer"). Ad-hoc sign the installed bundle and clear the
  # quarantine flag so the app launches normally after `brew install`.
  postflight do
    app_path = "#{appdir}/MacShieldPRO.app"
    system_command "/usr/bin/codesign",
                   args: ["--force", "--deep", "--sign", "-", app_path]
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", app_path]
  end

  uninstall launchctl: "com.macshield.keepalive",
            quit:      "com.macshield.app"

  zap trash: [
    "~/Library/Caches/com.macshield.app",
    "~/Library/HTTPStorages/com.macshield.app",
    "~/Library/LaunchAgents/com.macshield.keepalive.plist",
    "~/Library/Preferences/com.macshield.app.plist",
    "~/Library/Saved Application State/com.macshield.app.savedState",
  ]
end
