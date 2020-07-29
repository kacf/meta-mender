#
# Set the DISTRO_FEATURES variables for Mender.  This is done via a
# separate bbclass intentionally so that it can be conditionally
# enabled only when Mender is actually enabled to be built (ie
# mender-client-install is in MENDER_FEATURES_ENABLE.
#
# Doing the conditional check in the assignment of these variables
# causes parsing errors in some recipes due to the function
# mender_feature_is_enabled not being expanded until after parsing.
#

# MENDER_FEATURES_ENABLE and MENDER_FEATURES_DISABLE map to
# DISTRO_FEATURES_BACKFILL and DISTRO_FEATURES_BACKFILL_CONSIDERED,
# respectively.
DISTRO_FEATURES_BACKFILL_append = " ${MENDER_FEATURES_ENABLE}"
DISTRO_FEATURES_BACKFILL_CONSIDERED_append = " ${MENDER_FEATURES_DISABLE}"
