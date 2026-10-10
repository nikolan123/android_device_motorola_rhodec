#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

from pathlib import Path

from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.fixups_lib import (
    lib_fixups,
    lib_fixups_user_type,
)
from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

namespace_imports = [
    'device/motorola/rhodec',
    'hardware/motorola',
    'vendor/motorola/sm6375-common',
    'vendor/qcom/opensource/display',
]

lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
}

blob_fixups: blob_fixups_user_type = {
    'vendor/lib64/libBSTSWAD.so': blob_fixup()
        .clear_symbol_version('AHardwareBuffer_allocate')
        .clear_symbol_version('AHardwareBuffer_describe')
        .clear_symbol_version('AHardwareBuffer_lock')
        .clear_symbol_version('AHardwareBuffer_lockPlanes')
        .clear_symbol_version('AHardwareBuffer_release')
        .clear_symbol_version('AHardwareBuffer_unlock'),
    (
        'vendor/lib64/camera/components/com.qti.node.dewarp.so',
        'vendor/lib64/camera/components/com.vidhance.node.ica.so',
        'vendor/lib64/camera/components/com.vidhance.node.processing.so'
    ): blob_fixup()
        .replace_needed('libui.so', 'libui-v34.so'),
    'vendor/lib64/libmot_chi_desktop_helper.so': blob_fixup()
        .add_needed('libgui_shim_vendor.so'),
    (
        'vendor/lib/ese_spi_nxp.so',
        'vendor/lib64/ese_spi_nxp.so',
    ): blob_fixup()
        .add_needed('libbase_shim.so'),
    'vendor/lib64/sensors.moto.so': blob_fixup()
        .add_needed('libbase_shim.so'),
}  # fmt: skip

module = ExtractUtilsModule(
    'rhodec',
    'motorola',
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
    namespace_imports=namespace_imports,
    # Preserve installed global firmware; never generate radio/bootloader updates.
    add_firmware_proprietary_file=False,
    add_generated_carriersettings=True,
)

if __name__ == '__main__':
    utils = ExtractUtils.device_with_common(
        module, 'sm6375-common', module.vendor
    )
    utils.run()
    # Attach the stock init file to the selected prebuilt service. A copy rule
    # conflicts with the source service's init_rc installation target.
    bp_path = Path(module.vendor_path) / 'Android.bp'
    bp = bp_path.read_text()
    marker = '    name: "android.hardware.nfc@1.2-service",\n'
    assert bp.count(marker) == 1
    bp = bp.replace(marker, marker + '    init_rc: ["proprietary/vendor/etc/init/android.hardware.nfc@1.2-service.rhodec.rc"],\n')
    bp_path.write_text(bp)
