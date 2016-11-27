#!/bin/bash
set -e

gem install package_cloud

BUILD_DIR=$1

package_cloud push Hypriot/Schatzkiste/debian/wheezy $BUILD_DIR/*.deb
package_cloud push Hypriot/Schatzkiste/debian/jessie $BUILD_DIR/*.deb
package_cloud push Hypriot/Schatzkiste/raspbian/wheezy $BUILD_DIR/*.deb
package_cloud push Hypriot/Schatzkiste/raspbian/jessie $BUILD_DIR/*.deb
