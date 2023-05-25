#!/bin/bash

cd app-framework-ios/paystub-ios 
echo "Installing pods for Pay & Hours" 
pod install
cd ..
echo "Installing pods for app-framework"
pod install
cd ..
cd paystub-ios
echo "Installing pods for Pay & Hours"
pod install
cd ..
echo "Installing pods for The Core Project"
pod install
git add .
git commit -m "project initialization"
git push origin main
git branch develop
git checkout develop
git push origin develop
open *.xcworkspace