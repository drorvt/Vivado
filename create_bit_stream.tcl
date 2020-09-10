###################################################
### Must be run from the project's root directory
###################################################

# Open\Load the *.xpr file (i.e. project file)

open_project Electreon_on_Zync.xpr




# Launch the build to produce a *.bit file (bitstream)

launch_runs impl_1 -to_step write_bitstream -jobs 4
