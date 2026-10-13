#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Boot animation
TARGET_SCREEN_HEIGHT := 2400
TARGET_SCREEN_WIDTH := 1080

# Screen
TARGET_SCREEN_DENSITY := 400

# AAPT
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := 400dpi
PRODUCT_AAPT_PREBUILT_DPI := xxxhdpi xxhdpi xhdpi hdpi

# Shipping API level
PRODUCT_SHIPPING_API_LEVEL := 31

# Device Framework Compatibility Matrix
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE := $(LOCAL_PATH)/framework_compatibility_matrix.xml

# Inherit from motorola sm6375-common
MOTOROLA_MEDIA_PROFILES_DIR := device/motorola/rhodec/media
$(call inherit-product, device/motorola/sm6375-common/common.mk)

# Overlays
PRODUCT_PACKAGES += \
    FrameworksResDevice \
    LineageApertureAppDevice \
    LineageSystemUIDevice \
    SettingsResRhodec \
    SystemUIResDevice \
    WifiResDevice

# Audio
PRODUCT_PACKAGES += \
    firmware_aw_cali.bin_symlink

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/audio/audio_io_policy.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_io_policy.conf \
    $(LOCAL_PATH)/audio/audio_platform_info.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_platform_info.xml \
    $(LOCAL_PATH)/audio/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    $(LOCAL_PATH)/audio/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    $(LOCAL_PATH)/audio/mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths.xml

# FM
TARGET_HAS_FM := true

PRODUCT_PACKAGES += \
    FM2

# Init
PRODUCT_PACKAGES += \
    init.mmi.overlay.rc \
    init.oem.fingerprint2.sh

# NFC
PRODUCT_PACKAGES += \
    android.hardware.nfc@1.2-service \
    com.android.nfc_extras \
    Tag

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.nfc.hce.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hce.xml \
    frameworks/native/data/etc/android.hardware.nfc.hcef.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hcef.xml \
    frameworks/native/data/etc/android.hardware.nfc.uicc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.uicc.xml \
    frameworks/native/data/etc/android.hardware.nfc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.xml \
    frameworks/native/data/etc/com.nxp.mifare.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.nxp.mifare.xml

DEVICE_SKUS := b d dn n

PRODUCT_COPY_FILES += \
$(foreach DEVICE_SKU, b d, \
    $(LOCAL_PATH)/permissions/unavail.android.hardware.nfc.hce.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_$(DEVICE_SKU)/unavail.android.hardware.nfc.hce.xml \
    $(LOCAL_PATH)/permissions/unavail.android.hardware.nfc.hcef.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_$(DEVICE_SKU)/unavail.android.hardware.nfc.hcef.xml \
    $(LOCAL_PATH)/permissions/unavail.android.hardware.nfc.uicc.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_$(DEVICE_SKU)/unavail.android.hardware.nfc.uicc.xml \
    $(LOCAL_PATH)/permissions/unavail.android.hardware.nfc.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_$(DEVICE_SKU)/unavail.android.hardware.nfc.xml)

# Power
$(call soong_config_set,qtipower,tap_to_wake_node,/sys/devices/platform/soc/4a80000.spi/spi_master/spi0/spi0.0/touchscreen/primary/double_tap_enabled)

# Sensors
PRODUCT_PACKAGES += \
    sensors.rhodec

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/sensors/hals.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/hals.conf

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += $(LOCAL_PATH)

# Lights
PRODUCT_PACKAGES += \
    android.hardware.light-service.lineage

# WiFi firmware symlinks
PRODUCT_PACKAGES += \
    firmware_WCNSS_mot_cfg.ini_symlink

# Inherit from vendor blobs
$(call inherit-product, vendor/motorola/rhodec/rhodec-vendor.mk)

# Touch firmware for recovery
PRODUCT_COPY_FILES += \
    vendor/motorola/rhodec/proprietary/vendor/firmware/tm_novatek_ts_fw.bin:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/vendor/firmware/tm_novatek_ts_fw.bin \
    vendor/motorola/rhodec/proprietary/vendor/firmware/tm_novatek_ts_mp.bin:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/vendor/firmware/tm_novatek_ts_mp.bin

# Global Chipone firmware must also be available before vendor is mounted.
PRODUCT_COPY_FILES += \
    vendor/motorola/rhodec/proprietary/vendor/firmware/ICNL9922.bin:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/vendor/firmware/ICNL9922.bin

# Use the global stock Wi-Fi configuration instead of the common default.
PRODUCT_COPY_FILES := $(filter-out %:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/WCNSS_qcom_cfg.ini,$(PRODUCT_COPY_FILES))
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/wifi/WCNSS_qcom_cfg.ini:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/WCNSS_qcom_cfg.ini
