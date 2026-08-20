Pod::Spec.new do |s|
  s.name         = 'FeatureKit'
  s.version      = '1.0.0'
  s.summary      = 'FeatureKit iOS feedback SDK'
  s.description  = <<-DESC
FeatureKit is a precompiled iOS SDK for integrating FeatureKit feedback and end-user identity capabilities into iOS applications.
  DESC

  s.homepage     = 'https://github.com/NicolasNC/FeatureKit-iOS'
  s.license      = { :type => 'Commercial', :text => 'Copyright 2026 NicolasNC. All rights reserved.' }
  s.author       = { 'NicolasNC' => 'NicolasNC' }

  s.platform     = :ios, '15.0'
  s.swift_version = '5.9'
  s.module_name  = 'FeatureKit'

  # Pin the first binary to the immutable commit that contains the tested ZIP.
  # Future versions should normally point to the matching GitHub Release asset.
  s.source = {
    :http => 'https://raw.githubusercontent.com/NicolasNC/FeatureKit-iOS/369fb45ac6ad27696e232a855fa850f11fbef363/FeatureKit.xcframework.zip'
  }

  s.vendored_frameworks = 'FeatureKit.xcframework'
  s.frameworks = 'Security'
end
