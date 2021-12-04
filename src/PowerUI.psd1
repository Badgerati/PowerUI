#
# Module manifest for module 'PowerUI'
#
# Generated by: Matthew Kelly (Badgerati)
#
# Generated on: 04/11/2021
#

@{
    # Script module or binary module file associated with this manifest.
    RootModule = 'PowerUI.psm1'

    # Version number of this module.
    ModuleVersion = '0.1.0'

    # ID used to uniquely identify this module
    GUID = 'f12afa43-81a1-4ee6-bf01-9a46af4aac0b'

    # Author of this module
    Author = 'Matthew Kelly (Badgerati)'

    # Copyright statement for this module
    Copyright = 'Copyright (c) 2021 Matthew Kelly (Badgerati), licensed under the MIT License.'

    # Description of the functionality provided by this module
    Description = 'PowerShell framework for WPF'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.0'

    # Assemblies that must be loaded prior to importing this module
    RequiredAssemblies = @(
        'PresentationFramework',
        'PresentationCore',
         'WindowsBase'
    )

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{
        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = @('powershell', 'wpf', 'windows', 'gui', 'framework', 'xaml')

            # A URL to the license for this module.
            LicenseUri = 'https://raw.githubusercontent.com/Badgerati/PowerUI/master/LICENSE.txt'

            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/Badgerati/PowerUI'

        }
    }
}