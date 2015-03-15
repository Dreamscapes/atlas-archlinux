# The Makefile
#
# Licensed under the BSD-3-Clause license
# For full copyright and license information, please see the LICENSE file
#
# @author       Robert Rossmann <rr.rossmann@me.com>
# @copyright    2015 Robert Rossmann
# @license      http://choosealicense.com/licenses/bsd-3-clause  BSD-3-Clause License

all:
	packer build -var-file=config.json packer.json
