#!/bin/bash

successful_packages=""

# Packages to get profiles for
packages="
com.android.vending
com.google.android.apps.messaging
com.google.android.apps.nexuslauncher
com.google.android.apps.turbo
com.google.android.calculator
com.google.android.calendar
com.google.android.contacts
com.google.android.deskclock
com.google.android.dialer
com.google.android.gm
com.google.android.gms
com.google.android.googlequicksearchbox
com.google.android.GoogleCamera
com.google.android.inputmethod.latin
com.google.android.settings.intelligence
"
get_profiles() {
  for packageName in $packages; do
    # Get current profile for package
    adb shell cmd package snapshot-profile $packageName
    if [ $? -eq 0 ]; then
      # Pull profile if generated
      adb pull /data/misc/profman/$packageName.prof
      # Add package to list if successful
      successful_packages="${successful_packages} $packageName"
    fi
  done
}

rename_profiles() {
  for packageId in $successful_packages; do
    # Rename profiles we generated to gapps
    # name so the build system reads them
    if [ "$packageId" == "com.android.vending" ]; then
      mv $packageId.prof Phonesky.prof
    elif [ "$packageId" == "com.google.android.apps.messaging" ]; then
      mv $packageId.prof PrebuiltBugle.prof
    elif [ "$packageId" == "com.google.android.apps.nexuslauncher" ]; then
      mv $packageId.prof NexusLauncherRelease.prof
    elif [ "$packageId" == "com.google.android.apps.turbo" ]; then
      mv $packageId.prof TurboPrebuilt.prof
    elif [ "$packageId" == "com.google.android.calculator" ]; then
      mv $packageId.prof CalculatorGooglePrebuilt.prof
    elif [ "$packageId" == "com.google.android.calendar" ]; then
      mv $packageId.prof CalendarGooglePrebuilt.prof
    elif [ "$packageId" == "com.google.android.contacts" ]; then
      mv $packageId.prof GoogleContacts.prof
    elif [ "$packageId" == "com.google.android.deskclock" ]; then
      mv $packageId.prof PrebuiltDeskClockGoogle.prof
    elif [ "$packageId" == "com.google.android.dialer" ]; then
      mv $packageId.prof GoogleDialer.prof
    elif [ "$packageId" == "com.google.android.gm" ]; then
      mv $packageId.prof PrebuiltGmail.prof
    elif [ "$packageId" == "com.google.android.gms" ]; then
      mv $packageId.prof PrebuiltGmsCore.prof
    elif [ "$packageId" == "com.google.android.googlequicksearchbox" ]; then
      mv $packageId.prof Velvet.prof
    elif [ "$packageId" == "com.google.android.GoogleCamera" ]; then
      mv $packageId.prof GoogleCamera.prof
    elif [ "$packageId" == "com.google.android.inputmethod.latin" ]; then
      mv $packageId.prof LatinIMEGooglePrebuilt.prof
    elif [ "$packageId" == "com.google.android.settings.intelligence" ]; then
      mv $packageId.prof SettingsIntelligenceGooglePrebuilt.prof
    fi
  done
}

get_profiles
rename_profiles

unset $successful_packages
